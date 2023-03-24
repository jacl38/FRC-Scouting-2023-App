import 'package:flutter/material.dart';

class LabeledCard extends StatelessWidget {
	final bool outlined;
	final String label;
	final Widget child;
	const LabeledCard({super.key, this.outlined = false, this.label = "",required this.child});
	
	@override
	Widget build(BuildContext context) {
		return Card(
			elevation: 5,
			shadowColor: Colors.transparent,
			margin: EdgeInsets.fromLTRB(0, outlined ? 24 : 0, 0, 0),
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(12),
				side: outlined ? BorderSide(
					width: 4,
					color: Theme.of(context).colorScheme.background.withAlpha(128)
				) : BorderSide.none,
			),
			child: Stack(
				children: [
					Transform.translate(
						offset: Offset(16, outlined ? -22 : -8),
						child: Text(label)
					),
					Container(
						padding: const EdgeInsets.all(16),
						child: child,
					),
				],
			),
		);
	}
}