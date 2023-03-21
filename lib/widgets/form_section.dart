import 'package:flutter/material.dart';

import 'labeled_card.dart';

class FormSection extends StatelessWidget {
	final String title;
	final Widget child;
	const FormSection({super.key, required this.title, required this.child});

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: const EdgeInsets.all(8),
			child: LabeledCard(
				label: title,
				child: Form(autovalidateMode: AutovalidateMode.always, child: child,),
			)
		);
	}
}