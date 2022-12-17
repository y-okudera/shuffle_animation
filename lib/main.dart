import 'package:flutter/material.dart';
import 'package:shuffle_animation/presentation/anim/card_shuffle_animation/card_shuffle_animation_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Card shuffle animation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CardShuffleAnimation(
            cardWidth: MediaQuery.of(context).size.shortestSide / 2,
            onTapCardAfterAnimation: (index) {
              debugPrint('onTapCardAfterAnimation index:$index');
            },
            child: Image.asset(
              'assets/images/card.png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
