
import 'package:flutter/material.dart';
import 'package:flutter_hangman_game/utils/constants.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  String hangMan = "3";
  int lives = 5;
  int highScore = 0;
  String hint = "";
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

  initWord() async {

    if(visibleList.length>0||wrongWordList.length>0){refresh();}

    var word = Constants.getWord(await Constants.readWords()).trim();
    print(word);
    setState(() {
      currentWord = word;
      currentWordList = word.split("");
      actualWordList = word.split("").toSet().toList();
      keyboardLetters = Constants.letters.split("");
    });
  }

  refresh() {
    setState(() {
      hangMan = "3";
      hint = "";
      currentWord = '';
      currentWordList = [];
      actualWordList = [];
      visibleList = [];
      wrongWordList = [];
      hangManLevel = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Lives: $lives'),
                Text('Scores: $highScore'),
                IconButton(
                  onPressed: (){
                    print('hint');
                  },
                  icon: Icon(Icons.lightbulb_outline,color: Colors.black,),
                )
              ],
            ),
            Image.asset('assets/images/$hangMan.jpg'),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: currentWordList.map((letter) {
                return Container(
                  width: 20,
                  child: Center(
                    child: Column(
                        children: [
                          Text(visibleList.contains(letter) ? letter : " ",style: TextStyle(fontSize: 25),),

                          Text('_',style: TextStyle(height: 0,fontSize: 25),)
                        ],
                      ),

                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 10,),
            Flexible(
              child: GridView.count(
                crossAxisCount: 8,children: keyboardLetters.map((letter) {
                  return GestureDetector(
                    onTap: (){
                      if(!visibleList.contains(letter)) {
                        validateLetter(letter);
                      } else {
                        showFalseLetterAdded(letter);
                      }
                    },
                    child: Container(
                      width: 30,
                      height:30,
                      margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      decoration:BoxDecoration(
                        borderRadius:  BorderRadius.circular(5),
                        color: visibleList.contains(letter) ? Colors.grey[300] : wrongWordList.contains(letter) ? Colors.red : Colors.white,
                        border: Border.all(color: Colors.black)
                      ),
                      child: Center(
                        child: Text(letter.toUpperCase(),style: TextStyle(color: Colors.black),),
                      ),
                    ),
                  );
              }).toList(),),
            )
          ],
        ),
      ),
    );
  }

  validateLetter(String letter) {
    if(visibleList.length != actualWordList.length) {
      if (currentWordList.contains(letter)) {
        setState(() {
          visibleList.add(letter);
        });
        print(visibleList.length == currentWordList.length);
        if(visibleList.length == actualWordList.length){
          initWord();
          addScore();
        }
      } else {
        showFalseLetterAdded(letter);
      }
    } else {
      //do nothing
    }
  }

  showFalseLetterAdded(String letter) {

    if(lives != 0) {
      if (wrongWordList.length >= 6) {
        // game over
        setState(() {
          lives -= 1;
        });

        if(lives == 0){
          showGameOver();
        } else {


          addBodyPart(number: 10);

          Future.delayed(Duration(seconds: 1)).then((value) {

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

  addScore() {
    setState(() {
      highScore += 1;
    });
  }

  showGameOver() {
    print('game over');
  }

  addBodyPart({int number}) {
    if(number == null) {
      setState(() {
        hangMan = (int.parse(hangMan) + 1).toString();
      });
    } else{
      setState(() {
        hangMan = (number).toString();
      });
    }
  }
}
