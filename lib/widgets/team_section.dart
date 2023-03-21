import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoutingapp/scoutingform_states.dart';

import 'labeled_card.dart';

class TeamSection extends StatefulWidget {
	final int teamID;
	final ScoutingFormData formData;
	final Function updateFunction;
	const TeamSection({super.key, required this.teamID, required this.formData, required this.updateFunction})
		: assert(teamID == 1 || teamID == 2 || teamID == 3, "Team ID must be 1, 2, or 3");

	@override
	State<StatefulWidget> createState() => TeamSectionState();
}

class TeamSectionState extends State<TeamSection> {

	@override
	Widget build(BuildContext context) {
		TeamInfo team =
			widget.teamID == 1 ? widget.formData.team1Info :
			widget.teamID == 2 ? widget.formData.team2Info :
			widget.formData.team3Info;

		return LabeledCard(
			label: "Team ${team.teamNumber == 0 ? widget.teamID : team.teamNumber}",
			outlined: true,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					TextFormField(
						onChanged: (value) => { setState(() { team.teamNumber = int.tryParse(value) ?? 0; widget.updateFunction(); }) },
						keyboardType: TextInputType.number,
						inputFormatters: [ FilteringTextInputFormatter.digitsOnly ],
						decoration: const InputDecoration(
							prefixIcon: Icon(Icons.flag),
							label: Text("Team Number")
						),
					),

					const SizedBox(height: 24),

					const Text("Autonomous"),
					Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							Expanded(
								child: SegmentedButton(
									onSelectionChanged: (selection) {
										setState(() {
											team.autoCharge = selection.first;
											widget.updateFunction();
										});
									},
									selected: { team.autoCharge },
									segments: const [
										ButtonSegment(
											value: 0,
											icon: Icon(Icons.dangerous_outlined),
											label: Text("No Auto Charge")
										),
										ButtonSegment(
											value: 1,
											icon: Icon(Icons.indeterminate_check_box_sharp),
											label: Text("Auto Docked")
										),
										ButtonSegment(
											value: 2,
											icon: Icon(Icons.balance_rounded),
											label: Text("Auto Charged")
										)
									]
								),
							),
							SizedBox(
								width: 80,
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [
										Text(team.autoMobility ? "Mobility" : "No Mobility"),
										Switch(
											value: team.autoMobility,
											onChanged: (value) {
												setState(() {
													team.autoMobility = value;
													widget.updateFunction();
												});
											},
										)
									],
								)
							)
						],
					),

					const SizedBox(height: 36),

					const Text("Endgame"),
					const SizedBox(height: 12),
					SegmentedButton(
						onSelectionChanged: (selection) {
							setState(() {
								team.endCharge = selection.first;
								widget.updateFunction();
							});
						},
						selected: { team.endCharge },
						segments: const [
							ButtonSegment(
								value: 0,
								icon: Icon(Icons.dangerous_outlined),
								label: Text("No End Charge")
							),
							ButtonSegment(
								value: 1,
								icon: Icon(Icons.indeterminate_check_box_sharp),
								label: Text("End Docked")
							),
							ButtonSegment(
								value: 2,
								icon: Icon(Icons.balance_rounded),
								label: Text("End Charged")
							)
						]
					),

					const SizedBox(height: 24),

					TextFormField(
						onChanged: (value) => { team.notes = value },
						maxLines: null,
						keyboardType: TextInputType.multiline,
						decoration: const InputDecoration(
							prefixIcon: Icon(Icons.chat),
							label: Text("Notes")
						)
					)
				],
			)
		);
	}
}