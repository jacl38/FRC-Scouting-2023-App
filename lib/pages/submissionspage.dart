import 'package:flutter/material.dart';
import 'package:scoutingapp/main.dart';
import 'package:scoutingapp/network.dart';
import 'package:scoutingapp/pages/settingspage.dart';
import 'package:scoutingapp/scoutingform_states.dart';
import 'package:scoutingapp/widgets/submission_preview.dart';

class SubmissionsPage extends StatefulWidget {
	const SubmissionsPage({super.key});

	@override
	State<StatefulWidget> createState() => SubmissionsPageState();
}

class SubmissionsPageState extends State<SubmissionsPage> {
	List<SubmissionPreview> previews = [];

	void addSubmission(SubmissionPreview preview) {
		previews.add(preview);
	}
	void removeSubmission(SubmissionPreview preview) {
		previews.remove(preview);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text("Submissions")),

			floatingActionButton: FloatingActionButton.extended(
				onPressed: () {
					List<SubmissionPreview> selectedSubmissions = previews.where((submission) => submission.selected).toList();
					if(selectedSubmissions.isNotEmpty) {
						showDialog(
							context: context,
							builder: (context) {
								return AlertDialog(
									title: Text("Delete ${selectedSubmissions.length} submissions?"),
									actions: [
										TextButton(
											child: Text("Cancel"),
											onPressed: () { Navigator.of(context).pop(); },
										),
										TextButton(
											child: Text("Delete", style: TextStyle(color: Colors.red)),
											onPressed: () {
												for (var submission in selectedSubmissions) {
													deleteSubmission(submission.formData);
													Navigator.of(context).pop();
													Navigator.of(context).pop();
													Navigator.push(context, MaterialPageRoute(builder: (context) => SubmissionsPage()));
												}
											},
										),
									],
								);
							},
						);
					}
				},
				label: Text("Delete selected"),
				icon: Icon(Icons.dangerous),
				backgroundColor: Colors.red,
			),

			body: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					// OutlinedButton.icon(onPressed: () { clearSubmissions(); }, icon: Icon(Icons.dangerous), label: Text("Clear all submissions")),
					
					Container(
						padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
						child: Wrap(
							alignment: WrapAlignment.center,
							children: getSubmissions().isEmpty ? const [
								Icon(Icons.cancel_rounded),
								SizedBox(width: 16),
								Text("No submissions", style: TextStyle(fontSize: 18)),
							] : [
								FilledButton.icon(
									icon: const Icon(Icons.send_to_mobile),
									label: const Text("Upload Submissions"),
									style: const ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.all(12))),
									onPressed: () {
										submitMatch(getSubmissions().map((formData) => formData.toXml().toXmlString()).toList(), Settings.serverAddress);
										// showDialog(
										// 	builder: (BuildContext context) {
										// 		return const AlertDialog(
										// 			title: Text("Upload Result"),
										// 			content: Text("Submissions were uploaded successfully.")
										// 		);
										// 	},
										// 	context: context
										// );
									},
								),
							]
						)
					),

					Expanded(
						child: Container(
							padding: EdgeInsets.all(16),
							child: ListView(
								children: getSubmissions().map((submission) {
									SubmissionPreview newSubmissionPreview = SubmissionPreview(
										formData: submission,
										submissionsPage: widget,
										addFunction: addSubmission,
										removeFunction: removeSubmission);
									// widget.selected.add(newSubmissionPreview.formData.dateTime);
									return ListTile(title: newSubmissionPreview);
								}).toList()
							)
						)
					),
				],
			)
		);
	}
}