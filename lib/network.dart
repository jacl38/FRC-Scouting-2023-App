import 'package:requests/requests.dart';

Future<bool> submitMatch(List<String> submissions, String address) async {
	try {
		print("trying...");
		var r = await Requests.post(
			"http://$address/submit",
			body: {
				'submissions': submissions
			},
			bodyEncoding: RequestBodyEncoding.JSON);
		print("got");
		r.raiseForStatus();
		print("good");
		return true;
	} catch (e) {
		return false;
	}
}