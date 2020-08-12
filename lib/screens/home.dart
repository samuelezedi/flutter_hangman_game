
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [

            SizedBox(height: 50,),

            Text('HANGMAN',style: TextStyle(color: Colors.black,fontSize: 35),),
            SizedBox(height: 20,),
            Expanded(
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              child: RaisedButton(
                onPressed: (){
                  Navigator.pushNamed(context, 'gameScreen');
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                color: Colors.black,
                child: Text('Start Game',style: TextStyle(color: Colors.white),),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              child: RaisedButton(
                onPressed: (){
                  Navigator.pushNamed(context, 'scorePage');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                color: Colors.black,
                child: Text('High Scores',style: TextStyle(color: Colors.white),),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
