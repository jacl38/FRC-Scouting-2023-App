import 'package:flutter/material.dart';

class Settings {
	static String serverAddress = "";
}

class SettingsPage extends StatelessWidget {
	const SettingsPage({super.key});
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text("Settings")),

			body: ListView(
				padding: const EdgeInsets.all(8),
				children: [
					ListTile(title: Text("Administration")),
					TextField(
						controller: TextEditingController()..text = Settings.serverAddress,
						onChanged: (value) {
							Settings.serverAddress = value;
						},
						decoration: const InputDecoration(
							border: OutlineInputBorder(),
							prefixIcon: Icon(Icons.computer),
							label: Text("Server address"),
						),
					)
				],
			)
		);
	}
}