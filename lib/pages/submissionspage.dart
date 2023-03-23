

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoutingapp/pref_util.dart';
import 'package:scoutingapp/scoutingform_states.dart';

// class SubmissionsPage extends StatefulWidget {
// 	const SubmissionsPage({super.key});
	
// 	 @override
// 	 State<StatefulWidget> createState() => SubmissionsPageState();
// }

// class SubmissionsPageState extends State<SubmissionsPage> {

// 	@override
// 	Widget build(BuildContext context) {
// 		return Scaffold(
// 			appBar: AppBar(title: const Text("Submissions")),

// 			body: Column(
// 				children: [
// 					Text("Submissions"),
// 					Text(jsonEncode(getSubmissions()))
// 				],
// 			)
// 		);
// 	}
// }

class SubmissionsPage extends StatelessWidget {
	const SubmissionsPage({super.key});

	@override
	Widget build(BuildContext context) {
		
		// final submissions = StorageUtil.readString("submissions.json", "[No data]");
		// print(submissions);
		// submissions.forEach((submission) => { print(submission) });
		// final submissions = getSubmissions()[0];

		return Scaffold(
			appBar: AppBar(title: const Text("Submissions")),

			body: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					const Text("Submissions"),
					OutlinedButton.icon(onPressed: () { clearSubmissions(); }, icon: Icon(Icons.dangerous), label: Text("Clear all submissions")),
					// Text(submissions as String),
					// OutlinedButton(
					// 	child: Text("test"),
					// 	onPressed: () {
					// 		PrefUtil.setValue("test", [new ScoutingFormData().toXml().toXmlString()]);
					// 		a = PrefUtil.getValue("test", []).toString();
					// 	}
					// ),
					OutlinedButton(
						onPressed: () {
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
									backgroundColor: Color.fromRGBO(0, 0, 0, 1.0),
								)
							);
						}, child: const Text("print")
					),
					Column(
						children: getSubmissions().map((submission) => Text("${submission.matchNumber}")).toList(),
					),
				],
			)
		);
	}
}