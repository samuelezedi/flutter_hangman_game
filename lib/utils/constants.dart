import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class Constants {

  static Future<List<String>> readWords() async {
    String fileText = await rootBundle.loadString('resource/word.txt');
    var words = fileText.split('\n');
    return words;
  }

  static String letters = "abcdefghijklmnopqrstuvwxyz";

  static String getWord(List<String> list) {
    var rnd = new Random();
    var max = (list.length-1);
    var r = 0 + rnd.nextInt(max - 0);
    return list[r];
  }

}