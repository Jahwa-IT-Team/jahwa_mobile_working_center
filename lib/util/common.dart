import 'dart:async';
import 'dart:core';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    child: Text("Okay"),
    onPressed: () { Navigator.of(context).pop(); },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text(message),
    actions: [
      okButton,
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

// Show Confirm Message Box Function
showConfirmMessageBox(BuildContext context, String message, String div, String args) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {Navigator.of(context).pop();},
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
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
    content: Text(message),
    actions: [
      cancelButton,
      continueButton,
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

// Show Select Message Box Function
showSelectMessageBox(BuildContext context, String message, String buttonname, String div, String args) {
  // set up the buttons
  Widget remindButton = FlatButton(
    child: Text(buttonname.split('♭')[0]), // Button Name Join by '♭'
    onPressed:  () {
      Navigator.of(context).pop();
      if(div == "") { // By div call each Function, args has many argument data Join by '♭', Level 2 Join by '♪', Level 3 Join by '♬'
        showMessageBox(context, "Test Message Box");
      }
    },
  );
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {Navigator.of(context).pop();},
  );
  Widget launchButton = FlatButton(
    child: Text(buttonname.split('♭')[1]), // Button Name Join by '♭'
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
    content: Text(message),
    actions: [
      remindButton,
      cancelButton,
      launchButton,
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
  prefs.remove('EmpCode');
  prefs.remove('DueDate');
}