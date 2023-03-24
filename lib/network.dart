import 'package:requests/requests.dart';

void submitMatch(List<String> submissions, String address) async {
	var r = await Requests.post(
		"http://$address/submit",
		body: {
			'submissions': submissions
		},
		bodyEncoding: RequestBodyEncoding.JSON);
	r.raiseForStatus();
}