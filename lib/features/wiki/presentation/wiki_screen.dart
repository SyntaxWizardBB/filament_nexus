import 'package:filament_nexus/features/wiki/presentation/widgets/wiki_list.dart';
import 'package:flutter/material.dart';

class WikiScreen extends StatelessWidget {
	const WikiScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Wiki'),
			),
			body: WikiList(),
		);
	}
}

