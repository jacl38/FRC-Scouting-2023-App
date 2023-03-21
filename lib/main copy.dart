// import 'dart:io';

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';

// void main() {
// 	runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
// 	const MyApp({super.key});

// 	@override
// 	Widget build(BuildContext context) {
// 		return MaterialApp(
// 		title: 'Team 237 Scouting',
// 		theme: ThemeData(
// 			colorScheme: ColorScheme.dark(secondary: Color.fromRGBO(255, 224, 138, 1.0), primary: Color.fromRGBO(202, 138, 43, 1.0)),
// 			useMaterial3: true,
// 			primarySwatch: Colors.blue,
// 		),
// 		home: const MyHomePage(title: 'Team 237 Scouting'),
// 		);
// 	}
// }

// class MyHomePage extends StatefulWidget {
// 	const MyHomePage({super.key, required this.title});

// 	final String title;

// 	@override
// 	State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
// 	int _counter = 0;

// 	void _incrementCounter() {
// 		setState(() {
// 			_counter++;
// 		});
// 	}

// 	@override
// 	Widget build(BuildContext context) {
// 		return Scaffold(
// 			drawer: Drawer(
// 				child: ListView(
// 					padding: EdgeInsets.zero,
// 					children: [
// 						DrawerHeader(
// 							decoration: BoxDecoration(
// 								color: Theme.of(context).colorScheme.primary
// 							),
// 							child: Image.asset("assets/img/robot.png")
// 						),
// 						ListTile(
// 							leading: const Icon(Icons.bar_chart),
// 							title: const Text("View past submissions"),
// 							onTap: () => {},
// 						),
// 						ListTile(
// 							leading: const Icon(Icons.send_to_mobile),
// 							title: const Text("Upload submissions"),
// 							onTap: () => {},
// 						),
// 						ListTile(
// 							leading: const Icon(Icons.settings),
// 							title: const Text("Settings"),
// 							onTap: () => {},
// 						),
// 					],
// 				)
// 			),

// 			appBar: AppBar(
// 				title: Text(widget.title),
// 			),

// 			body: Center(
// 				child: Column(
// 					children: <Widget>[
// 						const Text('You have pushed the button this many times:'),
// 						Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
// 						FilledButton(onPressed: () => { print("yeet") }, child: Text("a")),
// 					],

// 				),
// 			),
// 		);
// 	}
// }
