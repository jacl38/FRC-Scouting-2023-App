import 'package:flutter/material.dart';

class IconSection extends StatelessWidget {
	final IconData icon;
	final String header;
	final Widget child;
	final EdgeInsets margin;
	Color accentColor = Colors.white;
	IconSection({
		super.key,
		required this.child,
		required this.icon,
		required this.header,
		this.accentColor = Colors.white,
		this.margin = EdgeInsets.zero
	});

	@override
	Widget build(BuildContext context) {
		return Container(
			decoration: BoxDecoration(
				gradient: new LinearGradient(
					colors: [accentColor, Colors.white.withAlpha(32)],
					stops: [0.02, 0.02]
				),
				borderRadius: BorderRadius.circular(12),
			),
			padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
			margin: margin,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Row(
						children: [
							Icon(icon, color: accentColor),
							SizedBox(width: 4),
							Text(header, style: TextStyle(fontSize: 24))
						],
					),
					child
				],
			)
		);
	}
}