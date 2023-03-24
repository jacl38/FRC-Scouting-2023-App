

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoutingapp/pages/submissionspage.dart';
import 'package:scoutingapp/scoutingform_states.dart';
import 'package:scoutingapp/widgets/score_grid.dart';

class SubmissionPreview extends StatefulWidget {
	final ScoutingFormData formData;
	final SubmissionsPage submissionsPage;
	final Function addFunction;
	final Function removeFunction;
	bool selected = false;
	SubmissionPreview({
		super.key,
		required this.formData,
		required this.submissionsPage,
		required this.addFunction,
		required this.removeFunction
	});

	@override
	State<StatefulWidget> createState() => SubmissionPreviewState();
}

class SubmissionPreviewState extends State<SubmissionPreview> {
	bool expanded = false;

	final DateFormat dateFormatter = DateFormat("EEEE', 'MM/dd/yyyy' at'").add_jm();

	ButtonSegment teamButtonSegment(int teamID) {
		TeamInfo teamInfo = TeamInfo(id: teamID);

		if(teamID == 1) teamInfo = widget.formData.team1Info;
		if(teamID == 2) teamInfo = widget.formData.team2Info;
		if(teamID == 3) teamInfo = widget.formData.team3Info;
		if(![1, 2, 3].contains(teamID)) return ButtonSegment(value: 1);

		return ButtonSegment(
			value: teamID,
			// icon: const Icon(Icons.flag_circle),
			label: Wrap(
				direction: Axis.horizontal,
				children: [
					Wrap(
						direction: Axis.vertical,
						children: [
							const SizedBox(height: 3),
							const Icon(Icons.flag_circle),
							const SizedBox(height: 5),
							Icon(teamInfo.autoMobility ? Icons.check_box_rounded : Icons.check_box_outline_blank),
							const SizedBox(height: 2),
							Icon(teamInfo.autoCharge == 0 ? Icons.check_box_outline_blank : (teamInfo.autoCharge == 1 ? Icons.indeterminate_check_box_rounded : Icons.check_box_rounded)),
							const SizedBox(height: 2),
							Icon(teamInfo.endCharge == 0 ? Icons.check_box_outline_blank : (teamInfo.endCharge == 1 ? Icons.indeterminate_check_box_rounded : Icons.check_box_rounded)),
						],
					),
					SizedBox(width: 2),
					Wrap(
						direction: Axis.vertical,
						children: [
							Text("Team ${teamInfo.teamNumber}", style: TextStyle(fontSize: 18)),
							const Text("Mobility"),
							const Text("Auto Charge"),
							const Text("End Charge"),
						],
					),
				],
			)
		);
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			margin: EdgeInsets.fromLTRB(0, 6, 0, 6),

			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					Material(
						borderRadius: BorderRadius.circular(24),
						color: widget.selected ? Colors.red.withAlpha(64) : Colors.white10,
						child: InkWell(
							borderRadius: BorderRadius.circular(24),
							onTap: () {
								setState(() {
									expanded = !expanded;
								});
							},
							onLongPress: () {
								setState(() {
									widget.selected = !widget.selected;
									if(widget.selected) widget.addFunction(widget);
									if(!widget.selected) widget.removeFunction(widget);
								});
							},
							child: SizedBox(
								height: 64,
								child: Container(
									padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
									child: Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											Row(
												mainAxisAlignment: MainAxisAlignment.spaceBetween,
												children: [
													if(widget.selected) Icon(Icons.dangerous),
													if(widget.selected) const SizedBox(width: 8),
													Text("Match ${widget.formData.matchNumber}"),
													const SizedBox(width: 16),
													Text(dateFormatter.format(widget.formData.dateTime), style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white38),)
												],
											),
											Icon(expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded)
										],
									)
								)
							),
						),
					),
					AnimatedContainer(
						duration: const Duration(milliseconds: 300),
						curve: Curves.decelerate,
						clipBehavior: Clip.antiAlias,
						decoration: BoxDecoration(),
						padding: EdgeInsets.all(16),
						constraints: BoxConstraints.tight(Size.fromHeight(expanded ? 480 : 0)),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								Row(
									children: [
										Container( // Red/Blue Alliance chip
											clipBehavior: Clip.antiAlias,
											decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.white12),
											child: Row(
												mainAxisSize: MainAxisSize.min,
												children: [
													Container(
														padding: EdgeInsets.fromLTRB(10, 8, 8, 8),
														decoration: BoxDecoration(
															gradient: LinearGradient(
																colors: widget.formData.alliance == "blue" ? [Colors.blue[700] as Color, Colors.cyan] : [Colors.pink[800] as Color, Colors.red],
																begin: Alignment.bottomLeft,
																end: Alignment.topRight,
																stops: [0, 1]
															)
														),
														child: Text(widget.formData.alliance == "blue" ? "Blue" : "Red"),
													),
													Container(
														padding: const EdgeInsets.fromLTRB(6, 8, 8, 8),
														child: const Text("Alliance"),
													),
												],
											),
										),
										const SizedBox(width: 8),
										const Text("Victory", style: TextStyle(fontSize: 18))
									],
								),
								const SizedBox(height: 8),
								SegmentedButton(
									emptySelectionAllowed: true,
									selected: const {},
									style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
									segments: [
										teamButtonSegment(1),
										teamButtonSegment(2),
										teamButtonSegment(3),
									],
								),
								const SizedBox(height: 8),
								ScoreGridTable(
									showSwitcher: false,
									formData: widget.formData,
									updateFunction: () {}
								)
							],
						),
					)
				],
			)
		);
	}
}