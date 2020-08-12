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
        child: FutureBuilder<List<String>>(
          future: getAllScores(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              if(snapshot.data.isEmpty){
                return Text('No score has been recorded',style: TextStyle(fontSize: 20,color: Colors.black));
              } else{
                return ListView(
                  children: snapshot.data.map((value){
                    return Text(value,style: TextStyle(fontSize: 20,color: Colors.black));
                  }).toList()
                );
              }
            } else{
              return CircularProgressIndicator();
            }
          }
        )
      ),
    );
  }
}
