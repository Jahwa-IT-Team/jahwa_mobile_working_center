import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jahwa_mobile_working_center/util/globals.dart';

// Encrypt Text Function
String encryptText(String methood, var data) {
  //print("exec encryptText");
  String returnData = '';
  String keydata = DateFormat('yyyyMMdd').format(DateTime.now());
  keydata = keydata + keydata + keydata + keydata;

  final key = encrypt.Key.fromUtf8(keydata);
  final iv = encrypt.IV.fromLength(16);

  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  if(methood == "Encrypt") returnData = encrypter.encrypt(data, iv: iv).base64;
  else returnData = encrypter.decrypt64(data, iv: iv);

  return returnData;
}

// Show Message Box Function
showMessageBox(BuildContext context, String message) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text(
      "Okay",
      style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,),
    ),
    onPressed: () {Navigator.of(context).pop();},
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

// Clear Session Function
clearSession() {
  //print("exec clearSession");
  try {
    session['EntCode'] =  '';
    session['EntName'] = '';
    session['DeptCode'] = '';
    session['DeptName'] = '';
    session['EmpCode'] = '';
    session['Name'] = '';
    session['RollPstn'] = '';
    session['Position'] = '';
    session['Role'] = '';
    session['Title'] = '';
    session['PayGrade'] = '';
    session['Level'] = '';
    session['Email'] = '';
    session['Photo'] = '';
    session['Auth'] = '0';
    session['EntGroup'] = '';
    session['OfficeTel'] = '';
    session['Mobile'] = '';
    session['DueDate'] = '';
  }
  catch (e) {
    print(e.toString());
  }
}

// Remove User SharedPreferences
Future<void> removeUserSharedPreferences() async {
  //print("exec removeUserSharedPreferences : " + DateTime.now().toString());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('DueDate');
}

// Change Language Function
Future<void> changeLanguage(BuildContext context, String code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("Language", code);

  if(await prefs.setString('LanguageData', await rootBundle.loadString("assets/lang/" + code + ".json"))){
    if((prefs.getString('LanguageData') ?? '') == '') languagedata = jsonDecode(await rootBundle.loadString("assets/lang/" + code + ".json"));
    else languagedata = jsonDecode(prefs.getString('LanguageData'));
    await Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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

List<SimpleDialogOption> makeDialogItems(BuildContext context, String div, var jsondata, String selectedvalue) {
  List<SimpleDialogOption> itemsList = [];
  var textStyle = const TextStyle(color: Colors.blueAccent);
  jsondata['Table'].forEach((element) {
    if(selectedvalue == element['Code'])textStyle = const TextStyle(color: Colors.blueAccent);
    else textStyle = const TextStyle(color: Colors.black);
    Widget simpleDialogOption = SimpleDialogOption(
      onPressed: () {
        selectedvalue = element['Code'];
        if(div == 'Language') changeLanguage(context, selectedvalue);
        else showMessageBox(context, selectedvalue);
      },
      child: Text(element['Name'], style: textStyle,),
    );
    itemsList.add(simpleDialogOption);
  });
  return itemsList;
}

List<DropdownMenuItem> makeDropdownMenuItem(BuildContext context, String div, var jsondata, String selectedvalue) {
  List<DropdownMenuItem> itemsList = [];
  var textStyle = const TextStyle(color: Colors.blueAccent);
  jsondata['Table'].forEach((element) {
    if(selectedvalue == element['Code'])textStyle = const TextStyle(color: Colors.blueAccent);
    else textStyle = const TextStyle(color: Colors.black);
    Widget dropdownMenuItem = DropdownMenuItem(
      child: Text(element['Name'], style:textStyle,),
      value: element['Code'],
    );
    itemsList.add(dropdownMenuItem);
  });
  return itemsList;
}

/// Notification - Start
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> showNotification(var title, var content) async {
  var rng = new Random();
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('Id', 'Name', 'Description', importance: Importance.max, priority: Priority.high, ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(rng.nextInt(1000), title, content, platformChannelSpecifics, payload: 'Notification'); // Id를 Random으로 생성하여 중복되지 않도록 처리하면 각 메시지가 별도로 나타난다.
}

setStatusMessage(BuildContext context) {
  var androidSetting = AndroidInitializationSettings('@mipmap/app_icon');
  var iosSetting = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(android: androidSetting, iOS: iosSetting);
  flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
    if (payload != null) {
      showDialog(
        context: context,
        builder: (_) {
          return new AlertDialog(
            title: Text("Notification Clicked !!!"),
            content: Text("Payload : $payload"),
          );
        },
      );
    }
  });
}
/// Notification - End