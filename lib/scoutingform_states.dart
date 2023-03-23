import 'dart:convert';
import 'dart:io';

import 'package:jsonize/jsonize.dart';
import 'package:scoutingapp/pref_util.dart';
import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

import 'package:xml/xml.dart';

// Future<void> saveSubmission(ScoutingFormData newData) async {
// 	final prefs = await SharedPreferences.getInstance();
	
// 	final existingSubmissionsString = prefs.getString("submissions") ?? "[]";

// 	final List<ScoutingFormData> existingSubmissions = jsonDecode(existingSubmissionsString) as List<ScoutingFormData>;
// 	existingSubmissions.add(newData);

// 	prefs.setString("submissions", jsonEncode(existingSubmissions));
// }

// Future<List<ScoutingFormData>> getSubmissions() async {
// 	final prefs = await SharedPreferences.getInstance();

// 	final submissionsString = prefs.getString("submissions") ?? "[]";
// 	final List<ScoutingFormData> submissions = jsonDecode(submissionsString) as List<ScoutingFormData>;
// 	print(submissionsString.runtimeType);
// 	return submissions;
// }

void clearSubmissions() {
	StorageUtil.writeString("submissions.json", "");
	PrefUtil.setValue("submissions", List<String>.empty(growable: true));
}

// List<ScoutingFormData> getSubmissions() {
// 	// final String dataString = PrefUtil.getValue("submissions", "") as String;
// 	final String dataString = StorageUtil.readString("submissions.json", "");
// 	if(dataString.isEmpty) {
// 		print("Data is empty, returning []");
// 		return List<ScoutingFormData>.empty(growable: true);
// 	}

// 	List<dynamic> encodedSubmissions = jsonDecode(dataString);

// 	print(encodedSubmissions[0]);

// 	final List<ScoutingFormData> submissions = encodedSubmissions.map((sub) => ScoutingFormData.fromJson(sub)).toList();

// 	// final List dynamicData = ScoutingFormData.fromJson(dataString);

// 	// dynamicData.forEach((sub) {
// 	// 	submissions.add(sub as ScoutingFormData);
// 	// });

// 	// final data = Jsonize.fromJson(dataString);
	
// 	// final data = Jsonize.fromJson(dataString) as List<ScoutingFormData>;
// 	return submissions;
// }

List<ScoutingFormData> getSubmissions() {
	final List<String> existingSubmissionStrings = PrefUtil.getValue("submissions", []) as List<String>;
	
	List<ScoutingFormData> existingSubmissions = [];

	existingSubmissionStrings.forEach((element) {
		existingSubmissions.add(ScoutingFormData.fromXml(XmlDocument.parse(element)));
	});
	return existingSubmissions;
}

void addSubmission(ScoutingFormData submission) {
	List<ScoutingFormData> currentSubmissions = getSubmissions();

	currentSubmissions.add(submission);
	List<String> newSubmissionsStrings = currentSubmissions.map((submission) => submission.toXml().toXmlString()).toList();
	PrefUtil.setValue("submissions", newSubmissionsStrings);
	print("Added submission: Match Number ${submission.matchNumber}");
}

// void saveSubmission(ScoutingFormData submission) {
// 	// final String existingDataString = PrefUtil.getValue("submissions", "") as String;
// 	final List<ScoutingFormData> existingData = getSubmissions();
// 	existingData.add(submission);
// 	final List<String> newDataStringList = [];
// 	existingData.forEach((element) { newDataStringList.add(existingData.toString()); });
// 	final String newData = jsonEncode(newDataStringList);
// 	// PrefUtil.setValue("submissions", jsonEncode(newData));
// 	File wroteFile = StorageUtil.writeString("submissions.json", newData);
// 	print("Wrote to ${wroteFile.path} ${wroteFile.statSync().size}");
// }

@JsonSerializable()
class TeamInfo {
	int id = 0;
	int teamNumber = 0;
	bool autoMobility = false;
	int autoCharge = 0;
	int endCharge = 0;
	String notes = "";

	TeamInfo({required this.id});

	XmlDocument toXml(int id) {
		final builder = XmlBuilder();
		builder.processing('xml', 'version="1.0"');
		builder.element("Team", nest: () {
			builder.attribute("id", id);
			builder.element("TeamNumber", nest: teamNumber);
			builder.element("AutoMobility", nest: autoMobility);
			builder.element("AutoCharge", nest: autoCharge);
			builder.element("EndCharge", nest: endCharge);
			builder.element("Notes", nest: () {
				builder.text(notes);
			});
		});
		return builder.buildDocument();
	}

	static TeamInfo fromXml(XmlElement xml) {
		XmlElement? root = xml.getElement("Team");

		String idString = root?.getAttribute("id") ?? "0";
		int id = int.parse(idString);

		TeamInfo info = TeamInfo(id: id);

		String teamNumberString = root?.getElement("TeamNumber")?.innerText ?? "0";
		int teamNumber = int.parse(teamNumberString);

		String autoMobilityString = root?.getElement("AutoMobility")?.innerText ?? "false";
		bool autoMobility = autoMobilityString != "false";

		String autoChargeString = root?.getElement("AutoCharge")?.innerText ?? "0";
		int autoCharge = int.parse(autoChargeString);

		String endChargeString = root?.getElement("EndCharge")?.innerText ?? "0";
		int endCharge = int.parse(endChargeString);

		String notes = root?.getElement("Notes")?.innerText ?? "";

		return info
			..teamNumber = teamNumber
			..autoCharge = autoCharge
			..autoMobility = autoMobility
			..endCharge = endCharge
			..notes = notes;
	}

	@override
	String toString() => toXml(id).toXmlString(pretty: true);

	// String toJson() => jsonEncode({
	// 	'teamNumber': teamNumber,
	// 	'autoMobility': autoMobility,
	// 	'autoCharge': autoCharge,
	// 	'endCharge': endCharge,
	// 	'notes': notes
	// });

	// static TeamInfo fromJson(Map<String, dynamic> json) {
	// 	return TeamInfo()
	// 		..teamNumber = json['teamNumber']
	// 		..autoMobility = json['autoMobility']
	// 		..autoCharge = json['autoCharge']
	// 		..endCharge = json['endCharge']
	// 		..notes = json['notes'];
	// }
}

@JsonSerializable()
class Score {
	int teamID = 0;
	int item = 0;
	bool auto = false;

	Score();

	XmlDocument toXml() {
		final builder = XmlBuilder();
		builder.processing('xml', 'version="1.0"');
		builder.element("Score", nest: () {
			builder.attribute("teamID", teamID);
			builder.element("Item", nest: item);
			builder.element("Auto", nest: auto);
		});
		return builder.buildDocument();
	}

	static Score fromXml(XmlElement xml) {
		XmlElement? root = xml.getElement("Score");
		
		String teamIDString = root?.getAttribute("teamID") ?? "0";
		int teamID = int.parse(teamIDString);

		String itemString = root?.getElement("Item")?.innerText ?? "0";
		int item = int.parse(itemString);

		String autoString = root?.getElement("Auto")?.innerText ?? "false";
		bool auto = autoString != "false";

		return Score()
			..teamID = teamID
			..item = item
			..auto = auto;
	}

	@override
	String toString() => toXml().toXmlString(pretty: true);

	// String toJson() => jsonEncode({
	// 	'teamID': teamID,
	// 	'item': item,
	// 	'auto': auto
	// });

	// static Score fromJson(Map<String, dynamic> json) {
	// 	return Score()
	// 		..teamID = json['teamID']
	// 		..item = json['item']
	// 		..auto = json['auto'];
	// }
}

class FormProblem {
	String title;
	String description;
	FormProblem({
		required this.title,
		required this.description
	});
}

class ScoutingFormData {
	int matchNumber = 0;
	String alliance = "none";
	
	TeamInfo team1Info = TeamInfo(id:1);
	TeamInfo team2Info = TeamInfo(id:2);
	TeamInfo team3Info = TeamInfo(id:3);

	Map<String, List<Score>> scoreGrid = {
		'low': [Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score()],
		'mid': [Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score()],
		'top': [Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score()]
	};

	String allianceWin = "none";

	List<FormProblem> validateProblems() {
		List<FormProblem> problems = [];

		if(matchNumber == 0) problems.add(FormProblem(title: "Match Number", description: "Please enter a number."));

		if(team1Info.teamNumber == 0) problems.add(FormProblem(title: "Team 1", description: "Please enter a number."));
		if(team2Info.teamNumber == 0) problems.add(FormProblem(title: "Team 2", description: "Please enter a number."));
		if(team3Info.teamNumber == 0) problems.add(FormProblem(title: "Team 3", description: "Please enter a number."));

		var teamNumbers = [team1Info, team2Info, team3Info].map((team) => team.teamNumber).where((tn) => tn != 0);

		if(teamNumbers.toSet().length != teamNumbers.where((tn) => tn != 0).length) problems.add(FormProblem(title: "Duplicate team numbers", description: "There are duplicate team numbers."));

		auto: {
			List<TeamInfo> dockedTeams = [team1Info, team2Info, team3Info].where((team) => team.autoCharge == 1).toList();
			List<TeamInfo> chargedTeams = [team1Info, team2Info, team3Info].where((team) => team.autoCharge == 2).toList();

			if(dockedTeams.isNotEmpty && chargedTeams.isNotEmpty) {
				String dockedTeamNumbers = "";
				if(dockedTeams.length == 1) {
					dockedTeamNumbers = "${dockedTeams.first.teamNumber == 0 ? "unset" : dockedTeams.first.teamNumber}";
				} else {
					dockedTeamNumbers = "${dockedTeams.first.teamNumber == 0 ? "unset" : dockedTeams.first.teamNumber} and ${dockedTeams.last.teamNumber == 0 ? "unset" : dockedTeams.last.teamNumber}";
				}

				String chargedTeamNumbers = "";
				if(chargedTeams.length == 1) {
					chargedTeamNumbers = "${chargedTeams.first.teamNumber == 0 ? "unset" : chargedTeams.first.teamNumber}";
				} else {
					chargedTeamNumbers = "${chargedTeams.first.teamNumber == 0 ? "unset" : chargedTeams.first.teamNumber} and ${chargedTeams.last.teamNumber == 0 ? "unset" : chargedTeams.last.teamNumber}";
				}

				problems.add(
					FormProblem(
						title: "Incorrect autonomous dock/charge data",
						description: "Team${dockedTeams.length > 1 ? "s" : ""} $dockedTeamNumbers ${dockedTeams.length > 1 ? "are" : "is"} docked, but Team${chargedTeams.length > 1 ? "s" : ""} $chargedTeamNumbers ${chargedTeams.length > 1 ? "are" : "is"} charging."
					)
				);
			}
		}

		end: {
			List<TeamInfo> dockedTeams = [team1Info, team2Info, team3Info].where((team) => team.endCharge == 1).toList();
			List<TeamInfo> chargedTeams = [team1Info, team2Info, team3Info].where((team) => team.endCharge == 2).toList();

			if(dockedTeams.isNotEmpty && chargedTeams.isNotEmpty) {
				String dockedTeamNumbers = "";
				if(dockedTeams.length == 1) {
					dockedTeamNumbers = "${dockedTeams.first.teamNumber == 0 ? "unset" : dockedTeams.first.teamNumber}";
				} else {
					dockedTeamNumbers = "${dockedTeams.first.teamNumber == 0 ? "unset" : dockedTeams.first.teamNumber} and ${dockedTeams.last.teamNumber == 0 ? "unset" : dockedTeams.last.teamNumber}";
				}

				String chargedTeamNumbers = "";
				if(chargedTeams.length == 1) {
					chargedTeamNumbers = "${chargedTeams.first.teamNumber == 0 ? "unset" : chargedTeams.first.teamNumber}";
				} else {
					chargedTeamNumbers = "${chargedTeams.first.teamNumber == 0 ? "unset" : chargedTeams.first.teamNumber} and ${chargedTeams.last.teamNumber == 0 ? "unset" : chargedTeams.last.teamNumber}";
				}

				problems.add(
					FormProblem(
						title: "Incorrect endgame dock/charge data",
						description: "Team${dockedTeams.length > 1 ? "s" : ""} $dockedTeamNumbers ${dockedTeams.length > 1 ? "are" : "is"} docked, but Team${chargedTeams.length > 1 ? "s" : ""} $chargedTeamNumbers ${chargedTeams.length > 1 ? "are" : "is"} charging."
					)
				);
			}
		}

		return problems;
	}

	// String toJson() => jsonEncode({
	// 	'matchNumber': matchNumber,
	// 	'blueAlliance': blueAlliance,
	// 	'team1': team1Info.toJson(),
	// 	'team2': team2Info.toJson(),
	// 	'team3': team3Info.toJson(),
	// 	'scoreGrid': {
	// 		'low': List.generate(9, (index) => scoreGrid['low']![index].toJson()),
	// 		'mid': List.generate(9, (index) => scoreGrid['mid']![index].toJson()),
	// 		'top': List.generate(9, (index) => scoreGrid['top']![index].toJson()),
	// 	},
	// 	'allianceWin': allianceWin,
	// });

	XmlDocument toXml() {
		final builder = XmlBuilder();
		builder.processing("xml", 'version="1.0"');
		builder.element("MatchData", nest: () {
			builder.attribute("matchNumber", matchNumber);
			builder.element("Alliance", nest: alliance);
			builder.xml(team1Info.toXml(1).rootElement.toXmlString());
			builder.xml(team2Info.toXml(2).rootElement.toXmlString());
			builder.xml(team3Info.toXml(3).rootElement.toXmlString());
			builder.element("ScoreGrid", nest: () {
				builder.element("Top", nest: () {
					scoreGrid['top']?.forEach((score) {
						builder.xml(score.toXml().rootElement.toXmlString());
					});
				});
				builder.element("Mid", nest: () {
					scoreGrid['mid']?.forEach((score) {
						builder.xml(score.toXml().rootElement.toXmlString());
					});
				});
				builder.element("Low", nest: () {
					scoreGrid['low']?.forEach((score) {
						builder.xml(score.toXml().rootElement.toXmlString());
					});
				});
			});
			builder.element("AllianceWin", nest: () { builder.text(allianceWin); });
		});
		return builder.buildDocument();
	}

	static ScoutingFormData fromXml(XmlDocument xml) {
		XmlElement? root = xml.getElement("MatchData");
		
		String matchNumberString = root?.getAttribute("matchNumber") ?? "0";
		int matchNumber = int.parse(matchNumberString);

		String alliance = root?.getElement("Alliance")?.innerText ?? "none";

		List<XmlElement> teams = root?.findAllElements("Team").toList() ?? [];
		if(teams.isEmpty) print("Error: No teams found in xml\n${xml.toXmlString(pretty: true)}");

		TeamInfo team1 = TeamInfo.fromXml(teams.firstWhere((team) => team.getAttribute("id") == "1"));
		TeamInfo team2 = TeamInfo.fromXml(teams.firstWhere((team) => team.getAttribute("id") == "2"));
		TeamInfo team3 = TeamInfo.fromXml(teams.firstWhere((team) => team.getAttribute("id") == "3"));

		XmlElement? scoreGridElement = root?.getElement("ScoreGrid");

		XmlElement? topRow = scoreGridElement?.getElement("Top");
		XmlElement? midRow = scoreGridElement?.getElement("Mid");
		XmlElement? lowRow = scoreGridElement?.getElement("Low");

		List<Score> topScores = topRow?.childElements.map((e) => Score.fromXml(e)).toList() ?? List.filled(9, Score());
		List<Score> midScores = midRow?.childElements.map((e) => Score.fromXml(e)).toList() ?? List.filled(9, Score());
		List<Score> lowScores = lowRow?.childElements.map((e) => Score.fromXml(e)).toList() ?? List.filled(9, Score());

		Map<String, List<Score>> scoreGrid = {
			'top': topScores,
			'mid': midScores,
			'low': lowScores
		};

		String allianceWin = root?.getElement("AllianceWin")?.innerText ?? "none";

		return ScoutingFormData()
			..matchNumber = matchNumber
			..alliance = alliance
			..team1Info = team1
			..team2Info = team2
			..team3Info = team3
			..scoreGrid = scoreGrid
			..allianceWin = allianceWin;
	}

	String toJson() => jsonEncode({
		'matchNumber': matchNumber,
		'alliance': alliance,
		'team1': {
			'teamNumber': team1Info.teamNumber,
			'autoMobility': team1Info.autoMobility,
			'autoCharge': team1Info.autoCharge,
			'endCharge': team1Info.endCharge,
			'notes': team1Info.notes
		},
		'team2': {
			'teamNumber': team2Info.teamNumber,
			'autoMobility': team2Info.autoMobility,
			'autoCharge': team2Info.autoCharge,
			'endCharge': team2Info.endCharge,
			'notes': team2Info.notes
		},
		'team3': {
			'teamNumber': team3Info.teamNumber,
			'autoMobility': team3Info.autoMobility,
			'autoCharge': team3Info.autoCharge,
			'endCharge': team3Info.endCharge,
			'notes': team3Info.notes
		},
		'scoreGrid': {
			'low': [
				{
					'teamID': scoreGrid['low']![0].teamID,
					'item': scoreGrid['low']![0].item,
					'auto': scoreGrid['low']![0].auto
				},
				{
					'teamID': scoreGrid['low']![1].teamID,
					'item': scoreGrid['low']![1].item,
					'auto': scoreGrid['low']![1].auto
				},
				{
					'teamID': scoreGrid['low']![2].teamID,
					'item': scoreGrid['low']![2].item,
					'auto': scoreGrid['low']![2].auto
				},
				{
					'teamID': scoreGrid['low']![3].teamID,
					'item': scoreGrid['low']![3].item,
					'auto': scoreGrid['low']![3].auto
				},
				{
					'teamID': scoreGrid['low']![4].teamID,
					'item': scoreGrid['low']![4].item,
					'auto': scoreGrid['low']![4].auto
				},
				{
					'teamID': scoreGrid['low']![5].teamID,
					'item': scoreGrid['low']![5].item,
					'auto': scoreGrid['low']![5].auto
				},
				{
					'teamID': scoreGrid['low']![6].teamID,
					'item': scoreGrid['low']![6].item,
					'auto': scoreGrid['low']![6].auto
				},
				{
					'teamID': scoreGrid['low']![7].teamID,
					'item': scoreGrid['low']![7].item,
					'auto': scoreGrid['low']![7].auto
				},
				{
					'teamID': scoreGrid['low']![8].teamID,
					'item': scoreGrid['low']![8].item,
					'auto': scoreGrid['low']![8].auto
				},
			],
			'mid': [
				{
					'teamID': scoreGrid['mid']![0].teamID,
					'item': scoreGrid['mid']![0].item,
					'auto': scoreGrid['mid']![0].auto
				},
				{
					'teamID': scoreGrid['mid']![1].teamID,
					'item': scoreGrid['mid']![1].item,
					'auto': scoreGrid['mid']![1].auto
				},
				{
					'teamID': scoreGrid['mid']![2].teamID,
					'item': scoreGrid['mid']![2].item,
					'auto': scoreGrid['mid']![2].auto
				},
				{
					'teamID': scoreGrid['mid']![3].teamID,
					'item': scoreGrid['mid']![3].item,
					'auto': scoreGrid['mid']![3].auto
				},
				{
					'teamID': scoreGrid['mid']![4].teamID,
					'item': scoreGrid['mid']![4].item,
					'auto': scoreGrid['mid']![4].auto
				},
				{
					'teamID': scoreGrid['mid']![5].teamID,
					'item': scoreGrid['mid']![5].item,
					'auto': scoreGrid['mid']![5].auto
				},
				{
					'teamID': scoreGrid['mid']![6].teamID,
					'item': scoreGrid['mid']![6].item,
					'auto': scoreGrid['mid']![6].auto
				},
				{
					'teamID': scoreGrid['mid']![7].teamID,
					'item': scoreGrid['mid']![7].item,
					'auto': scoreGrid['mid']![7].auto
				},
				{
					'teamID': scoreGrid['mid']![8].teamID,
					'item': scoreGrid['mid']![8].item,
					'auto': scoreGrid['mid']![8].auto
				},
			],
			'top': [
				{
					'teamID': scoreGrid['top']![0].teamID,
					'item': scoreGrid['top']![0].item,
					'auto': scoreGrid['top']![0].auto
				},
				{
					'teamID': scoreGrid['top']![1].teamID,
					'item': scoreGrid['top']![1].item,
					'auto': scoreGrid['top']![1].auto
				},
				{
					'teamID': scoreGrid['top']![2].teamID,
					'item': scoreGrid['top']![2].item,
					'auto': scoreGrid['top']![2].auto
				},
				{
					'teamID': scoreGrid['top']![3].teamID,
					'item': scoreGrid['top']![3].item,
					'auto': scoreGrid['top']![3].auto
				},
				{
					'teamID': scoreGrid['top']![4].teamID,
					'item': scoreGrid['top']![4].item,
					'auto': scoreGrid['top']![4].auto
				},
				{
					'teamID': scoreGrid['top']![5].teamID,
					'item': scoreGrid['top']![5].item,
					'auto': scoreGrid['top']![5].auto
				},
				{
					'teamID': scoreGrid['top']![6].teamID,
					'item': scoreGrid['top']![6].item,
					'auto': scoreGrid['top']![6].auto
				},
				{
					'teamID': scoreGrid['top']![7].teamID,
					'item': scoreGrid['top']![7].item,
					'auto': scoreGrid['top']![7].auto
				},
				{
					'teamID': scoreGrid['top']![8].teamID,
					'item': scoreGrid['top']![8].item,
					'auto': scoreGrid['top']![8].auto
				},
			],
		},
		'allianceWin': allianceWin
	});

	// static ScoutingFormData fromJson(Map<String, dynamic> json) {
	// 	return ScoutingFormData()
	// 		..matchNumber = json['matchNumber']
	// 		..blueAlliance = json['blueAlliance']
	// 		..team1Info = TeamInfo.fromJson(json['team1'])
	// 		..team2Info = TeamInfo.fromJson(json['team2'])
	// 		..team3Info = TeamInfo.fromJson(json['team3'])
	// 		..scoreGrid = (json['scoreGrid'] as Map<String, dynamic>).map((key, value) {
	// 			return MapEntry(key, ((value as List).map((s) => Score.fromJson(s))).toList());
	// 		})
	// 		..allianceWin = json['allianceWin'];
	// }

	@override
	String toString() => toJson();

	ScoutingFormData();
}