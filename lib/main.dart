import 'package:flutter/material.dart';
import 'package:flutter_hangman_game/screens/game.dart';
import 'package:flutter_hangman_game/screens/highscore.dart';
import 'package:flutter_hangman_game/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HangMan',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: 'homePage',
      debugShowCheckedModeBanner: false,
      routes: {
        'homePage': (context) => HomeScreen(),
        'scorePage': (context) => ScoreScreen(),
        'gameScreen': (context) => GameScreen()
      },
    );
  }
}
