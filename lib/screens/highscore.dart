import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ScoreScreen extends StatelessWidget {

  Future<List<String>> getAllScores() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    if(local.getStringList('highScore') == null){
      return [];
    } else {
      return local.getStringList('highScore');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40,),
            Text('High Scores',style: TextStyle(fontSize: 30),),
            SizedBox(height: 20,),
            FutureBuilder<List<String>>(
              future: getAllScores(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  if(snapshot.data.isEmpty){
                    return Text('No score has been recorded',style: TextStyle(fontSize: 20,color: Colors.black));
                  } else{
                    return Expanded(
                      child: ListView(

                        children: snapshot.data.map((value){
                          return Text("- $value -", textAlign: TextAlign.center,style: TextStyle(fontSize: 25,color: Colors.black));
                        }).toList()
                      ),
                    );
                  }
                } else{
                  return CircularProgressIndicator();
                }
              }
            ),
          ],
        )
      ),
    );
  }
}
