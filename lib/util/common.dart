import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

encrypt_text(BuildContext context) {
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

  //showDialogOne(context, decrypted);
  //showDialogTwo(context, encrypted.base64);
  showDialogThree(context, encrypted.base64);
}

showDialogOne(BuildContext context, String strData) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () { Navigator.of(context).pop(); },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text(strData),
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

showDialogTwo(BuildContext context, String strData) {

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {Navigator.of(context).pop();},
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed:  () {Navigator.of(context).pop();},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Confirm"),
    content: Text(strData),
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

showDialogThree(BuildContext context, String strData) {

  // set up the buttons
  Widget remindButton = FlatButton(
    child: Text("Remind me later"),
    onPressed:  () {Navigator.of(context).pop();},
  );
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {Navigator.of(context).pop();},
  );
  Widget launchButton = FlatButton(
    child: Text("Launch missile"),
    onPressed:  () {Navigator.of(context).pop();},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text(strData),
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