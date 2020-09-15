import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jahwa_mobile_working_center/util/globals.dart';



// Encrypt Function
encrypt_text(BuildContext context) {
  print("exec encrypt_text");
  DateTime now = DateTime.now();
  String keydata = DateFormat('yyyyMMdd').format(now);
  keydata = keydata + keydata + keydata + keydata;

  final plainText = 'This is not Encrypt Text !!!';
  final key = encrypt.Key.fromUtf8(keydata);
  final iv = encrypt.IV.fromLength(16);

  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  final decrypted = encrypter.decrypt(encrypted, iv: iv);

  print(decrypted);
  print(encrypted.base64);

  //showMessageBox(context, decrypted);
  //showConfirmMessageBox(context, encrypted.base64);
  showSelectMessageBox(context, encrypted.base64, 'Button1♭Button2', '', '');
}

// Show Message Box Function
showMessageBox(BuildContext context, String message) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text(
      "Okay",
      style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,),
    ),
    onPressed: () { Navigator.of(context).pop(); },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text(translateText(context, message)),
    titleTextStyle: TextStyle(fontFamily: "Malgun", color: Colors.black, fontWeight: FontWeight.bold,),
    contentTextStyle: TextStyle(fontFamily: "Malgun", color: Colors.black,),
    actions: [ okButton, ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) { return alert; },
  );
}

// Show Confirm Message Box Function
showConfirmMessageBox(BuildContext context, String message, String div, String args) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(
      "Cancel",
      style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,),
    ),
    onPressed:  () {Navigator.of(context).pop();},
  );
  Widget continueButton = FlatButton(
    child: Text(
      "Continue",
      style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,),
    ),
    onPressed:  () {
      Navigator.of(context).pop();
      if(div == "") { // By div call each Function, args has many argument data Join by '♭', Level 2 Join by '♪', Level 3 Join by '♬'
        showMessageBox(context, "Test Message Box");
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Confirm"),
    content: Text(translateText(context, message)),
    titleTextStyle: TextStyle(fontFamily: "Malgun", color: Colors.black, fontWeight: FontWeight.bold,),
    contentTextStyle: TextStyle(fontFamily: "Malgun", color: Colors.black,),
    actions: [ cancelButton, continueButton, ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) { return alert; },
  );
}

// Show Select Message Box Function
showSelectMessageBox(BuildContext context, String message, String buttonname, String div, String args) {
  // set up the buttons
  Widget aButton = FlatButton(
    child: Text(buttonname.split('♭')[0]), // Button Name Join by '♭'
    onPressed:  () {
      Navigator.of(context).pop();
      if(div == "") { // By div call each Function, args has many argument data Join by '♭', Level 2 Join by '♪', Level 3 Join by '♬'
        showMessageBox(context, "Test Message Box");
      }
    },
  );
  Widget cancelButton = FlatButton(
    child: Text(
      "Cancel",
      style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,),
    ),
    onPressed:  () {Navigator.of(context).pop();},
  );
  Widget bButton = FlatButton(
    child: Text(
      buttonname.split('♭')[1],
      style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,),
    ), // Button Name Join by '♭'
    onPressed:  () {
      Navigator.of(context).pop();
      if(div == "") { // By div call each Function, args has many argument data Join by '♭', Level 2 Join by '♪', Level 3 Join by '♬'
        showMessageBox(context, "Test Message Box");
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text(translateText(context, message)),
    titleTextStyle: TextStyle(fontFamily: "Malgun", color: Colors.black, fontWeight: FontWeight.bold,),
    contentTextStyle: TextStyle(fontFamily: "Malgun", color: Colors.black,),
    actions: [
      aButton,
      cancelButton,
      bButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// Remove User SharedPreferences
Future<void> removeUserSharedPreferences() async {
  //print("exec removeUserSharedPreferences : " + DateTime.now().toString());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('DueDate');
}

// Change Language Function
Future<void> changeLanguage(BuildContext context, String langcode, String page) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("Language", langcode);

  if(await prefs.setString('LanguageData', await rootBundle.loadString("assets/lang/" + language + ".json"))){
    if((prefs.getString('LanguageData') ?? '') == '') languagedata = jsonDecode(await rootBundle.loadString("assets/lang/" + language + ".json"));
    else languagedata = jsonDecode(prefs.getString('LanguageData'));
    await Navigator.popAndPushNamed(context, page);
  }
}

String translateText(BuildContext context, String key) {
  String text = key;
  try{
    text = languagedata[key];
    if(text == null) text = key;
  }catch (e){
    print("translateText Error : " + e.toString());
  }
  return text;
}