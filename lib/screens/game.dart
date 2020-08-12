import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hangman_game/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String hangMan = "3";
  int lives = 5;
  int highScore = 0;
  List<String> hint = [];
  bool hintAccess = true;
  String currentWord = '';
  List<String> currentWordList = [];
  List<String> actualWordList = [];
  List<String> visibleList = [];
  List<String> wrongWordList = [];
  List<String> keyboardLetters = [];
  int hangManLevel = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initWord();
  }

  void initWord() async {
    if (visibleList.length > 0 || wrongWordList.length > 0) {
      refresh();
    }

    var word = Constants.getWord(await Constants.readWords()).trim();
    print(word);
    setState(() {
      currentWord = word;
      currentWordList = word.split("");
      actualWordList = word.split("").toSet().toList();
      keyboardLetters = Constants.letters.split("");
    });
  }

  void refresh() {
    setState(() {
      hangMan = "3";
      hint = [];
      currentWord = '';
      currentWordList = [];
      actualWordList = [];
      visibleList = [];
      wrongWordList = [];
      hangManLevel = 0;
      hintAccess = true;
    });
  }

  showHint() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 5,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[500]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.yellowAccent,
                    size: 50,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Hint',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  hintAccess
                      ? Container()
                      : Text('You ran out of hints for the word'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: currentWordList.map((letter) {
                      return GestureDetector(
                        onTap: () {
                          int divisor = (actualWordList.length / 2).round();
                          print(divisor);
                          if (hint.length < divisor) {
                            setState(() {
                              hint.add(letter);
                            });
                          } else {
                            setState(() {
                              hintAccess = false;
                            });
                          }
                        },
                        child: Container(
                          width: 30,
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  hint.contains(letter) ? letter : " ",
                                  style: TextStyle(fontSize: 35),
                                ),
                                Text(
                                  '_',
                                  style: TextStyle(height: 0, fontSize: 35),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tap missing letters to get hint, you are only allowed certain number of letter so pick wisely.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  exitDialog() {
    showDialog(
        context: context,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to exit the game?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'No',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: Colors.black,
                      onPressed: () {
                        recordHighScore();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          //TODO show confirmation dialog
          exitDialog();
          return Future.value(false);
        },
        child: Scaffold(
          body: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Lives: $lives',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Scores: $highScore',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        print('hint');
                        showHint();
                      },
                      icon: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Image.asset('assets/images/$hangMan.jpg'),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: currentWordList.map((letter) {
                    return Container(
                      width: 20,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              visibleList.contains(letter) ? letter : " ",
                              style: TextStyle(fontSize: 25),
                            ),
                            Text(
                              '_',
                              style: TextStyle(height: 0, fontSize: 25),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: GridView.count(
                    crossAxisCount: 8,
                    children: keyboardLetters.map((letter) {
                      return GestureDetector(
                        onTap: () {
                          if (!visibleList.contains(letter)) {
                            validateLetter(letter);
                          } else {
                            showFalseLetterAdded(letter);
                          }
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: visibleList.contains(letter)
                                  ? Colors.grey[300]
                                  : wrongWordList.contains(letter)
                                      ? Colors.red
                                      : Colors.white,
                              border: Border.all(color: Colors.black)),
                          child: Center(
                            child: Text(
                              letter.toUpperCase(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void validateLetter(String letter) {
    if (visibleList.length != actualWordList.length) {
      if (currentWordList.contains(letter)) {
        setState(() {
          visibleList.add(letter);
        });
        print(visibleList.length == currentWordList.length);
        if (visibleList.length == actualWordList.length) {
          showCorrectWordDialog(failed: true);
          Future.delayed(Duration(seconds: 3)).then((value) {
            initWord();
            addScore();
          });
        }
      } else {
        showFalseLetterAdded(letter);
      }
    } else {
      //do nothing
    }
  }

  void showFalseLetterAdded(String letter) {
    if (lives != 0) {
      if (wrongWordList.length >= 6) {
        // game over

        setState(() {
          lives -= 1;
        });
        if (lives == 0) {
          showCorrectWordDialog(failed: true);
          Future.delayed(Duration(seconds: 3)).then((value) {
            Navigator.pop(context);
            showGameOver();
          });
        } else {
          addBodyPart(number: 10);
          showCorrectWordDialog(failed: true);
          Future.delayed(Duration(seconds: 3)).then((value) {
            Navigator.pop(context);
            initWord();
          });
        }
      } else {
        setState(() {
          wrongWordList.add(letter);
          addBodyPart();
        });
      }
    } else {
      showGameOver();
    }
  }

  void addScore() {
    setState(() {
      highScore += 1;
    });
  }

  showCorrectWordDialog({bool failed = false}) {
    showDialog(context: context,
      barrierDismissible: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
       child: Padding(
         padding: const EdgeInsets.all(10.0),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Text(failed ? 'The correct word is...' : 'You got it!',style: TextStyle(color: Colors.black54,fontSize: 16),),
             SizedBox(height: 20,),
             Text(currentWord,style: TextStyle(color: Colors.green,fontSize: 18, fontWeight: FontWeight.bold),),
             SizedBox(height: 20,),
           ],
         ),
       ),
      )
    );
  }

  void showGameOver() {
    //TODO this should show game over dialog
    print('game over');
    recordHighScore();
    initWord();
    showDialog(
        context: context,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: 50,
                ),
                Text(
                  'GAME OVER!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )
              ],
            ),
          ),
        ));
  }

  void recordHighScore() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    if (local.getStringList('highScore') == null) {
      List<String> scores = [];
      scores.add(highScore.toString());
      local.setStringList('highScore', scores);
    } else {
      List<String> scores = local.getStringList('highScore');
      scores.add(highScore.toString());
      local.setStringList('highScore', scores);
    }
  }

  void addBodyPart({int number}) {
    if (number == null) {
      setState(() {
        hangMan = (int.parse(hangMan) + 1).toString();
      });
    } else {
      setState(() {
        hangMan = (number).toString();
      });
    }
  }
}
