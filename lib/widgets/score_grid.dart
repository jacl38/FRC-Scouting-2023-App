import 'package:flutter/material.dart';
import 'package:scoutingapp/scoutingform_states.dart';

class ScoreGridTable extends StatefulWidget {
	final ScoutingFormData formData;
	final Function updateFunction;
	const ScoreGridTable({super.key, required this.formData, required this.updateFunction});

	@override
	State<StatefulWidget> createState() => ScoreGridTableState();
}

class ScoreGridTableState extends State<ScoreGridTable> {
	List<String> rows = ["top", "mid", "low"];
	int selectedTeamID = 0;

	@override
	Widget build(BuildContext context) {

		var grid = widget.formData.scoreGrid;
		var teamNumbers = [
			widget.formData.team1Info.teamNumber,
			widget.formData.team2Info.teamNumber,
			widget.formData.team3Info.teamNumber,
		];

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				SegmentedButton( // Team selector
					showSelectedIcon: false,
					selected: {selectedTeamID},
					onSelectionChanged: (selection) {
						setState(() {
							selectedTeamID = selection.first;
							widget.updateFunction();
						});
					},
					segments: [
						ButtonSegment(
							value: 1,
							enabled: widget.formData.team1Info.teamNumber != 0,
							icon: const Icon(Icons.adjust),
							label: Text("${widget.formData.team1Info.teamNumber}")
						),
						ButtonSegment(
							value: 2,
							enabled: widget.formData.team2Info.teamNumber != 0,
							icon: const Icon(Icons.adjust),
							label: Text("${widget.formData.team2Info.teamNumber}")
						),
						ButtonSegment(
							value: 3,
							enabled: widget.formData.team3Info.teamNumber != 0,
							icon: const Icon(Icons.adjust),
							label: Text("${widget.formData.team3Info.teamNumber}")
						)
					]
				),

				const SizedBox(height: 12),

				Container(
					clipBehavior: Clip.antiAliasWithSaveLayer,
					decoration: BoxDecoration(
						borderRadius: BorderRadius.circular(28),
					),	
					child: Table(
						border: TableBorder.all(width: 10, color: Color.fromRGBO(42, 42, 42, 1), borderRadius: BorderRadius.circular(24)),
						children: List.generate(rows.length, (rowIndex) {
							String row = rows[rowIndex];
							return TableRow(
								children: List.generate(9, (column) {

									Score score = grid[row]![column];
									String scoreType = (column % 3 - 1).abs() == 0 ? "cube" : "cone";
									if(row == "low") scoreType = "conecube";

									return Container(
										// margin: EdgeInsets.all(4),
										decoration: BoxDecoration(
											color: scoreType == "cone" ? Colors.yellow.shade200 : (scoreType == "cube" ? Colors.purple.shade200 : null),
											gradient: scoreType == "conecube" ? LinearGradient(
												begin: Alignment.bottomRight,
												end: Alignment.topLeft,
												colors: [ Colors.yellow.shade200, Colors.purple.shade200 ],
												stops: const [0.495, 0.505]
											) : null
										),
										child: InkWell(
											onTap: () {
												setState(() {
													if(selectedTeamID == 0) return;
													if(score.teamID != selectedTeamID && score.item != 0) {
														score.teamID = 0;
														score.item = 0;
														score.auto = false;
														return;
													}
													score.teamID = selectedTeamID;
													score.item = (score.item + 1) % 3;
													if(score.item == 0) {
														score.teamID = 0;
														score.auto = false;
													}
													widget.updateFunction();
												});
											},
											onLongPress: () {
												setState(() {
													if(score.teamID != 0) score.auto = !score.auto;
													widget.updateFunction();
												});
											},
											child: Stack(
												alignment: Alignment.center,
												children: [
													Image.asset("assets/img/blank.png"),
													AspectRatio(
														aspectRatio: 1,
														child: FractionallySizedBox(
															widthFactor: 0.5, heightFactor: 0.5,
															child: score.item.abs() == 1? Image.asset("assets/img/cone.png", color: Colors.amber)
																: score.item.abs() == 2? Image.asset("assets/img/cube.png", color: Colors.deepPurple[700])
																: Image.asset("assets/img/blank.png"),
														),
													),
													
													Text(
														"${score.teamID == 0 ? "" : teamNumbers[score.teamID - 1]}\n${score.auto ? "(A)" : ""}",
														textAlign: TextAlign.center,
														style: const TextStyle(
															fontWeight: FontWeight.w500,
															fontSize: 18,
															shadows: [
																Shadow(offset: Offset(0.0, 1.0), blurRadius: 0.0, color: Color.fromRGBO(0, 0, 0, 0.5))
															]
														)
													)
												],
											)
										)
									);
								})
							);
						}),
					)
				),
			],
		);
		
	}
}