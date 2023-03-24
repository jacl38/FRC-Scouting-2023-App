import 'package:scoutingapp/pref_util.dart';

import 'package:xml/xml.dart';


void clearSubmissions() {
	StorageUtil.writeString("submissions.json", "");
	PrefUtil.setValue("submissions", List<String>.empty(growable: true));
}

void deleteSubmission(ScoutingFormData submission) {
	final oldSubmissions = getSubmissions();

	print(oldSubmissions.length);
	oldSubmissions.remove(oldSubmissions.firstWhere((s) => s.equals(submission)));
	print(oldSubmissions.length);
	
	List<String> newSubmissionsStrings = oldSubmissions.map((submission) => submission.toXml().toXmlString()).toList();
	PrefUtil.setValue("submissions", newSubmissionsStrings);
} 

List<ScoutingFormData> getSubmissions() {
	final prefValue = PrefUtil.getValue("submissions", []);
	List<String> existingSubmissionStrings = [];
	if(prefValue.runtimeType == List<dynamic>) {
		existingSubmissionStrings = List<String>.empty(growable: true);
	} else {
		existingSubmissionStrings = prefValue as List<String>;
	}

	List<ScoutingFormData> existingSubmissions = [];

	existingSubmissionStrings.forEach((element) {
		existingSubmissions.add(ScoutingFormData.fromXml(XmlDocument.parse(element)));
	});
	return existingSubmissions;
}

void addSubmission(ScoutingFormData submission) {
	List<ScoutingFormData> currentSubmissions = getSubmissions();

	currentSubmissions.add(submission..dateTime = DateTime.now());
	List<String> newSubmissionsStrings = currentSubmissions.map((submission) => submission.toXml().toXmlString()).toList();
	PrefUtil.setValue("submissions", newSubmissionsStrings);
	print("Added submission: Match Number ${submission.matchNumber}");
}

class TeamInfo {
	int id = 0;
	int teamNumber = 0;
	bool autoMobility = false;
	int autoCharge = 0;
	int endCharge = 0;
	String notes = "";

	TeamInfo({required this.id});

	bool equals(TeamInfo other) {
		return id == other.id
			&& teamNumber == other.teamNumber
			&& autoMobility == other.autoMobility
			&& autoCharge == other.autoCharge
			&& endCharge == other.endCharge
			&& notes == other.notes;
	}

	XmlDocument toXml(int id) {
		final builder = XmlBuilder();
		builder.processing('xml', 'version="1.0"');
		builder.element("Team", nest: () {
			builder.element("ID", nest: id);
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

	static TeamInfo fromXml(XmlElement root) {

		String idString = root.getElement("ID")?.innerText ?? "0";
		int id = int.parse(idString);

		TeamInfo info = TeamInfo(id: id);

		String teamNumberString = root.getElement("TeamNumber")?.innerText ?? "0";
		int teamNumber = int.parse(teamNumberString);

		String autoMobilityString = root.getElement("AutoMobility")?.innerText ?? "false";
		bool autoMobility = autoMobilityString != "false";

		String autoChargeString = root.getElement("AutoCharge")?.innerText ?? "0";
		int autoCharge = int.parse(autoChargeString);

		String endChargeString = root.getElement("EndCharge")?.innerText ?? "0";
		int endCharge = int.parse(endChargeString);

		String notes = root.getElement("Notes")?.innerText ?? "";

		return info
			..teamNumber = teamNumber
			..autoCharge = autoCharge
			..autoMobility = autoMobility
			..endCharge = endCharge
			..notes = notes;
	}

	@override
	String toString() => toXml(id).toXmlString(pretty: true);
}

class Score {
	int teamID = 0;
	int item = 0;
	bool auto = false;

	Score();

	bool equals(Score other) {
		return teamID == other.teamID
			&& item == other.item
			&& auto == other.auto;
	}

	XmlDocument toXml() {
		final builder = XmlBuilder();
		builder.processing('xml', 'version="1.0"');
		builder.element("Score", nest: () {
			builder.element("TeamID", nest: teamID);
			builder.element("Item", nest: item);
			builder.element("Auto", nest: auto);
		});
		return builder.buildDocument();
	}

	static Score fromXml(XmlElement root) {
		
		String teamIDString = root.getElement("TeamID")?.innerText ?? "0";
		int teamID = int.parse(teamIDString);

		String itemString = root.getElement("Item")?.innerText ?? "0";
		int item = int.parse(itemString);

		String autoString = root.getElement("Auto")?.innerText ?? "false";
		bool auto = autoString != "false";

		return Score()
			..teamID = teamID
			..item = item
			..auto = auto;
	}

	@override
	String toString() => toXml().toXmlString(pretty: true);
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
	DateTime dateTime = DateTime.now();
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

	bool scoreGridEquals(Map<String, List<Score>> other) {
		for(int i = 0; i < 9; i++) {
			if(!scoreGrid['low']![i].equals(other['low']![i])) return false;
			if(!scoreGrid['mid']![i].equals(other['mid']![i])) return false;
			if(!scoreGrid['top']![i].equals(other['top']![i])) return false;
		}
		return true;
	}

	String allianceWin = "none";

	bool equals(ScoutingFormData other) {
		return dateTime == other.dateTime
			&& matchNumber == other.matchNumber
			&& alliance == other.alliance
			&& allianceWin == other.allianceWin
			&& team1Info.equals(other.team1Info)
			&& team2Info.equals(other.team2Info)
			&& team3Info.equals(other.team3Info)
			&& scoreGridEquals(scoreGrid);
	}

	List<FormProblem> validateProblems() {
		List<FormProblem> problems = [];

		if(matchNumber == 0) problems.add(FormProblem(title: "Match Number", description: "Please enter a number."));

		if(alliance == "none") problems.add(FormProblem(title: "No Alliance Color", description: "Please select an alliance color."));

		if(team1Info.teamNumber == 0) problems.add(FormProblem(title: "Team 1", description: "Please enter a number."));
		if(team2Info.teamNumber == 0) problems.add(FormProblem(title: "Team 2", description: "Please enter a number."));
		if(team3Info.teamNumber == 0) problems.add(FormProblem(title: "Team 3", description: "Please enter a number."));

		var teamNumbers = [team1Info, team2Info, team3Info].map((team) => team.teamNumber).where((tn) => tn != 0);

		if(teamNumbers.toSet().length != teamNumbers.where((tn) => tn != 0).length) problems.add(FormProblem(title: "Duplicate team numbers", description: "There are duplicate team numbers."));

		if(allianceWin == "none") problems.add(FormProblem(title: "No Result", description: "Please select whether the alliance won, lost, or tied."));

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

	XmlDocument toXml() {
		final builder = XmlBuilder();
		builder.processing("xml", 'version="1.0"');
		builder.element("MatchData", nest: () {
			builder.attribute("matchNumber", matchNumber);
			builder.attribute("timestamp", dateTime.millisecondsSinceEpoch);
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

		String dateTimeString = root?.getAttribute("timestamp") ?? "0";
		int dateTime = int.parse(dateTimeString);

		String alliance = root?.getElement("Alliance")?.innerText ?? "none";

		List<XmlElement> teams = root?.findAllElements("Team").toList() ?? [];
		if(teams.isEmpty) print("Error: No teams found in xml\n${xml.toXmlString(pretty: true)}");

		// final a = teams;
		// print(teams.firstWhere((element) => element.getElement("ID")?.innerText == "1"));

		TeamInfo team1 = TeamInfo.fromXml(teams.firstWhere((team) => team.getElement("ID")?.innerText == "1"));
		TeamInfo team2 = TeamInfo.fromXml(teams.firstWhere((team) => team.getElement("ID")?.innerText == "2"));
		TeamInfo team3 = TeamInfo.fromXml(teams.firstWhere((team) => team.getElement("ID")?.innerText == "3"));

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
			..dateTime = DateTime.fromMillisecondsSinceEpoch(dateTime)
			..alliance = alliance
			..team1Info = team1
			..team2Info = team2
			..team3Info = team3
			..scoreGrid = scoreGrid
			..allianceWin = allianceWin;
	}

	@override
	String toString() => toXml().toXmlString(pretty: true);

	ScoutingFormData();
}