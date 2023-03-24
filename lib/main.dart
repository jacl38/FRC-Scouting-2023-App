import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:jsonize/jsonize.dart';
import 'package:path_provider/path_provider.dart';
import 'package:requests/requests.dart';
import 'package:scoutingapp/pages/picturepage.dart';
import 'package:scoutingapp/pages/submissionspage.dart';
import 'package:scoutingapp/pref_util.dart';
import 'package:scoutingapp/scoutingform_states.dart';
import 'package:scoutingapp/widgets/drawer_button.dart';
import 'package:scoutingapp/widgets/form_section.dart';
import 'package:scoutingapp/widgets/icon_section.dart';
import 'package:scoutingapp/widgets/labeled_card.dart';
import 'package:scoutingapp/widgets/score_grid.dart';
import 'package:scoutingapp/widgets/team_section.dart';
import 'package:xml/xml.dart';

import 'pages/settingspage.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	StorageUtil.init();
	PrefUtil.init();

	runApp(const ScoutingApp());
}

class ScoutingApp extends StatelessWidget {
	const ScoutingApp({super.key});

	@override
	Widget build(BuildContext context) {

		return MaterialApp(
			title: 'Team 237 Scouting',
			theme: ThemeData(
				colorScheme: const ColorScheme.dark(
					secondary: Color.fromRGBO(255, 224, 138, 1.0),
					primary: Color.fromRGBO(202, 138, 43, 1.0),
					surfaceTint: Color.fromRGBO(255, 255, 255, 1.0),
					background: Color.fromRGBO(28, 28, 28, 1.0),
					outline: Color.fromRGBO(255, 224, 138, 1.0)
				),
				useMaterial3: true
			),
			home: const ScoutingPage(),
		);
	}
}

class ScoutingPage extends StatefulWidget {
	const ScoutingPage({super.key});

	@override
	State<ScoutingPage> createState() => ScoutingPageState();
}

class ScoutingPageState extends State<ScoutingPage> {
	ScoutingFormData states = ScoutingFormData();

	int selectedTeamID = 0;

	Key key = UniqueKey();

	TeamSection? team1;
	TeamSection? team2;
	TeamSection? team3;

	void updateDataState(ScoutingFormData newData) {
		setState(() {
			states = newData;
		});
	}

	@override
	Widget build(BuildContext context) {

		team1 = TeamSection(teamID: 1, formData: states, updateFunction: () => updateDataState(states));
		team2 = TeamSection(teamID: 2, formData: states, updateFunction: () => updateDataState(states));
		team3 = TeamSection(teamID: 3, formData: states, updateFunction: () => updateDataState(states));

		return KeyedSubtree(
			key: key,
			child: 	Scaffold(
				extendBodyBehindAppBar: true,

				floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
				// bottomNavigationBar: BottomNavigationBar(
				// 	items: const [
				// 		BottomNavigationBarItem(
				// 			icon: Icon(Icons.call_to_action_outlined),
				// 			label: "Scouting Form"
				// 		),
				// 		BottomNavigationBarItem(
				// 			icon: Icon(Icons.bar_chart),
				// 			label: "Past submissions"
				// 		),
				// 		BottomNavigationBarItem(
				// 			icon: Icon(Icons.camera_alt),
				// 			label: "Pictures"
				// 		),
				// 	]
				// ),
				// bottomNavigationBar: BottomAppBar(
				// 	notchMargin: 5,
				// 	child: Row(
				// 		mainAxisAlignment: MainAxisAlignment.spaceAround,
				// 		children: [
				// 			// IconButton(onPressed: () => {}, icon: Icon(Icons.call_to_action_outlined)),
				// 			TextButton.icon(
				// 				icon: const Icon(Icons.call_to_action_outlined),
				// 				label: const Text("Scouting Form"),
				// 				onPressed: () => {},
				// 			),
				// 			TextButton.icon(
				// 				icon: const Icon(Icons.bar_chart),
				// 				label: const Text("Past submissions"),
				// 				onPressed: () => {},
				// 			),
				// 			TextButton.icon(
				// 				icon: const Icon(Icons.camera_alt),
				// 				label: const Text("Picture"),
				// 				onPressed: () => {},
				// 			),
				// 		]
				// 	),
				// ),

				drawer: Drawer(
					child: ListView(
						padding: EdgeInsets.zero,
						children: [
							DrawerHeader(
								decoration: BoxDecoration(
									color: Theme.of(context).colorScheme.primary,
									borderRadius: const BorderRadius.only(topRight: Radius.circular(16)),
								),
								child: Image.asset("assets/img/robot.png"),
							),
							Column(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								mainAxisSize: MainAxisSize.max,
								children: [
									Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											DrawerButton.from("View past submissions", Icons.bar_chart, () => {
												Navigator.push(context, MaterialPageRoute(builder: (context) => SubmissionsPage()))
											}),
											// DrawerButton.from("Take a picture", Icons.camera_alt, () => {
											// 	Navigator.push(context, MaterialPageRoute(builder: (context) => const PicturePage()))
											// }),
										],
									),
									const Divider(thickness: 0.25, endIndent: 16, indent: 16),
									DrawerButton.from("Settings", Icons.settings, () => {
										Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()))
									})
								],
							)
						],
					)
				),

				floatingActionButton: FloatingActionButton.extended(
					onPressed: () => showModalBottomSheet(
						isScrollControlled: true,
						context: context,
						builder: (context) {
							var problems = states.validateProblems();
							return Wrap(
								alignment: WrapAlignment.center,
								children: [
									const SizedBox(height: 24),
									Container(width: 48, height: 8, transform: Matrix4.translationValues(0, 8, 0), decoration: BoxDecoration(color: Colors.white.withAlpha(96), borderRadius: BorderRadius.circular(100))),
									const SizedBox(height: 12),
									Container(
										margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.stretch,
											children: [
												Text("Please check over your scouting data before submitting!"),
												const SizedBox(height: 8),
											] + problems.asMap().entries.map((problem) {
												return IconSection(
													child: Text(problem.value.description),
													icon: Icons.dangerous,
													header: problem.value.title,
													accentColor: Colors.red,
													margin: EdgeInsets.fromLTRB(0, 0, 0, 12)
												);
											}).toList()
											+ (problems.isEmpty ? [
												SizedBox(height: 16),
												FilledButton.icon(
													style: ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.all(16))),

													onPressed: () {
														addSubmission(states);
														Navigator.pop(context);
														setState(() {
															states = ScoutingFormData();
															selectedTeamID = 0;
															key = UniqueKey();
														});
														ScaffoldMessenger.of(context).showSnackBar(
															SnackBar(
																content: Row(
																	mainAxisAlignment: MainAxisAlignment.center,
																	children: const [
																		Icon(Icons.archive),
																		SizedBox(width: 8),
																		Text("Match submitted", style: TextStyle(color: Colors.white))
																	],
																),
																duration: const Duration(milliseconds: 1500),
																behavior: SnackBarBehavior.floating,
																padding: const EdgeInsets.all(16),
																backgroundColor: Colors.black,
															)
														);
													},

													icon: Icon(Icons.archive), label: Text("Submit")
												),
												SizedBox(height: 36)
											] : [])
										)
									)
								],
							);
						},
					),
					// onPressed: () { states.validateProblems().map((problem) => "${problem.title}: ${problem.description}").forEach((problem) => print(problem)); },
					label: const Text("Submit"),
					icon: const Icon(Icons.archive)
				),

				body: Center(
					child: CustomScrollView(
						slivers: [
							SliverAppBar(
								backgroundColor: Color.fromRGBO(202, 138, 43, 1),
								expandedHeight: 161,
								collapsedHeight: 80,
								flexibleSpace: Container(
									decoration: const BoxDecoration(
										gradient: LinearGradient(
											begin: Alignment.bottomLeft,
											end: Alignment.topRight,
											colors: [Color.fromRGBO(173, 103, 24, 1), Color.fromRGBO(202, 138, 43, 1)]
										)
									),
									child: const FlexibleSpaceBar(
										title: Text(
											"Team 237 Scouting",
											style: TextStyle(
												fontWeight: FontWeight.w500,
												shadows: [
													Shadow(offset: Offset(0.0, 2.0), blurRadius: 0.0, color: Color.fromRGBO(0, 0, 0, 0.5))
												]
											),
										)
									),
								),
							),
							SliverList(
								delegate: SliverChildBuilderDelegate(
									childCount: 1,
									(context, index) {
										return Column(
											crossAxisAlignment: CrossAxisAlignment.stretch,
											children: [
												const SizedBox(height: 12),
												FormSection(
													title: "Match Info",
													child: Column(
														crossAxisAlignment: CrossAxisAlignment.stretch,
														children: [
															Row( // Match Number and Alliance Color
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	Expanded(
																		flex: 36,
																		child: TextFormField(
																			onChanged: (value) => { states.matchNumber = int.tryParse(value) ?? 0 },
																			keyboardType: TextInputType.number,
																			inputFormatters: [ FilteringTextInputFormatter.digitsOnly ],
																			decoration: const InputDecoration(
																				prefixIcon: Icon(Icons.numbers),
																				label: Text("Match Number")
																			),
																		),
																	),
																	const Spacer(flex: 1),

																	Theme( // Red/Blue alliance switch
																		data: ThemeData(
																			colorScheme: Theme.of(context).colorScheme.copyWith(
																				outline: ([Colors.white30, Colors.red, Colors.blue])[(["none", "red", "blue"].indexOf(states.alliance))],
																				secondaryContainer: ([Colors.white30, Colors.red, Colors.blue])[(["none", "red", "blue"].indexOf(states.alliance))],
																				primary: ([Colors.white30, Colors.blue, Colors.red])[(["none", "red", "blue"].indexOf(states.alliance))]
																			)
																		),
																		child: Column(
																			children: [
																				const Text("Alliance"),
																				SegmentedButton(
																					selected: {["red", "blue"].indexOf(states.alliance)},
																					onSelectionChanged: (selection) {
																						setState(() {
																							states.alliance = selection.first == 1 ? "blue" : "red";
																						});
																					},
																					segments: const [
																						ButtonSegment(
																							value: 0,
																							icon: Icon(Icons.flag),
																							label: Text("Red")
																						),
																						ButtonSegment(
																							value: 1,
																							icon: Icon(Icons.flag),
																							label: Text("Blue")
																						),
																					],
																				)
																			]
																		)
																	),
																],
															),
															
															const SizedBox(height: 36),

															team1 ?? Text(""),

															const SizedBox(height: 24),

															team2 ?? Text(""),

															const SizedBox(height: 24),
															
															team3 ?? Text(""),
														],
													)
												),
												FormSection(
													title: "Scoring",
													child: Column(
														children: [
															ScoreGridTable(
																formData: states,
																updateFunction: () => updateDataState(states),
															),
															const SizedBox(height: 24),
															Column(
																children: const [
																	Icon(Icons.info_outline_rounded),
																	SizedBox(height: 12),
																	Text("Tap a team to select it for scoring"),
																	SizedBox(height: 12),
																	Text("Tap a score box to score for the selected team"),
																	SizedBox(height: 12),
																	Text("Long press a score box to mark it as autonomous (A)"),
																],
															),
															const SizedBox(height: 18),
															Divider(color: Theme.of(context).colorScheme.primary),
															const SizedBox(height: 18),
															SegmentedButton(
																style: ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.fromLTRB(16, 8, 16, 8))),
																selected: {["defeat", "tie", "victory"].indexOf(states.allianceWin)},
																onSelectionChanged: (selection) {
																	setState(() { states.allianceWin = (["defeat", "tie", "victory"])[selection.first]; });
																},
																segments: const [
																	ButtonSegment(
																		value: 0,
																		icon: Icon(Icons.thumb_down_rounded),
																		label: Text("Defeat")
																	),
																	ButtonSegment(
																		value: 1,
																		icon: Icon(Icons.thumbs_up_down_rounded),
																		label: Text("Tie")
																	),
																	ButtonSegment(
																		value: 2,
																		icon: Icon(Icons.thumb_up_rounded),
																		label: Text("Victory")
																	)
																],
															),
															const SizedBox(height: 12)
														],
													)
												)
											],
										);
									},
								),
							),
							const SliverPadding(padding: EdgeInsets.fromLTRB(0, 40, 0, 40))
						]
					)
				)
			)
		);
		
	}
}
