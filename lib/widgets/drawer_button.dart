import 'package:flutter/material.dart';

class DrawerButton {
	static TextButton from(String label, IconData icon, Function() onPressed) {
		return TextButton.icon(
			style: TextButton.styleFrom(alignment: Alignment.centerLeft, padding: const EdgeInsets.all(16)),
			icon: Icon(icon),
			label: Text(label),
			onPressed: onPressed,
		);
	}
}