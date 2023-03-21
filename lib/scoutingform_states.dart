import 'dart:convert';

class TeamInfo {
	int teamNumber = 0;
	bool autoMobility = false;
	int autoCharge = 0;
	int endCharge = 0;
	String notes = "";

	Map toJSON() => {
		'teamNumber': teamNumber,
		'autoMobility': autoMobility,
		'autoCharge': autoCharge,
		'endCharge': endCharge,
		'notes': notes
	};
}

class Score {
	int teamID = 0;
	int item = 0;
	bool auto = false;

	Map toJSON() => {
		'teamID': teamID,
		'item': item,
		'auto': auto
	};
}

class ScoutingFormData {
	int matchNumber = 0;
	bool blueAlliance = false;
	
	TeamInfo team1Info = TeamInfo();
	TeamInfo team2Info = TeamInfo();
	TeamInfo team3Info = TeamInfo();

	Map<String, List<Score>> scoreGrid = {
		'low': [Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score()],
		'mid': [Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score()],
		'top': [Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score()]
	};

	String allianceWin = "none";

	Map toJson() => {
		'matchNumber': matchNumber,
		'blueAlliance': blueAlliance,
		'team1': team1Info.toJSON(),
		'team2': team2Info.toJSON(),
		'team3': team3Info.toJSON(),
		'scoreGrid': {
			// 'low': scoreGrid['low']?.map((score) => score.toJSON()),
			// 'mid': scoreGrid['mid']?.map((score) => score.toJSON()),
			// 'top': scoreGrid['top']?.map((score) => score.toJSON())
			'low': List.generate(9, (index) => scoreGrid['low']![index].toJSON()),
			'mid': List.generate(9, (index) => scoreGrid['mid']![index].toJSON()),
			'top': List.generate(9, (index) => scoreGrid['top']![index].toJSON()),
		},
		'allianceWin': allianceWin,
	};

	@override
	String toString() => jsonEncode(this);

	// GlobalKey matchNumber = GlobalKey(debugLabel: "Match Number");
	// GlobalKey allianceColor = GlobalKey(debugLabel: "Alliance Color");

	// GlobalKey team1Number = GlobalKey(debugLabel: "Team 1 Number");
	// GlobalKey team1AutoMobility = GlobalKey(debugLabel: "Team 1 Auto Mobility");
	// GlobalKey team1AutoCharge = GlobalKey(debugLabel: "Team 1 Auto Charge");
	// GlobalKey team1EndCharge = GlobalKey(debugLabel: "Team 1 End Charge");
	// GlobalKey team1Notes = GlobalKey(debugLabel: "Team 1 Notes");
	
	// GlobalKey team2Number = GlobalKey(debugLabel: "Team 2 Number");
	// GlobalKey team2AutoMobility = GlobalKey(debugLabel: "Team 2 Auto Mobility");
	// GlobalKey team2AutoCharge = GlobalKey(debugLabel: "Team 2 Auto Charge");
	// GlobalKey team2EndCharge = GlobalKey(debugLabel: "Team 2 End Charge");
	// GlobalKey team2Notes = GlobalKey(debugLabel: "Team 2 Notes");
	
	// GlobalKey team3Number = GlobalKey(debugLabel: "Team 3 Number");
	// GlobalKey team3AutoMobility = GlobalKey(debugLabel: "Team 3 Auto Mobility");
	// GlobalKey team3AutoCharge = GlobalKey(debugLabel: "Team 3 Auto Charge");
	// GlobalKey team3EndCharge = GlobalKey(debugLabel: "Team 3 End Charge");
	// GlobalKey team3Notes = GlobalKey(debugLabel: "Team 3 Notes");

	// GlobalKey allianceWin = GlobalKey(debugLabel: "Alliance Won");
}