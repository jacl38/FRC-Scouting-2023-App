import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PicturePage extends StatelessWidget {
	const PicturePage({super.key});

	@override
	Widget build(BuildContext context) {

		return Scaffold(
			appBar: AppBar(title: Text("Pictures")),

			body: FilledButton(
				onPressed: () => {
				},
				child: Text("button"),
			)
		);
	}
}