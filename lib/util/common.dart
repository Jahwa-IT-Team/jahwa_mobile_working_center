import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jahwa_mobile_working_center/util/globals.dart';

/// Change Language Function
Future<void> changeLanguage(BuildContext context, String code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("Language", code);

  if(await prefs.setString('LanguageData', await rootBundle.loadString("assets/lang/" + code + ".json"))){
    if((prefs.getString('LanguageData') ?? '') == '') languagedata = jsonDecode(await rootBundle.loadString("assets/lang/" + code + ".json"));
    else languagedata = jsonDecode(prefs.getString('LanguageData'));
    await Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}

/// Clear Session Function
clearSession() {
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
  catch (e) { print(e.toString()); }
}

/// Encrypt Text Function
String encryptText(String methood, var data) {
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

/// Select Dialog용 아이템 생성 Function
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
        else showMessageBox(context, 'Alert', selectedvalue);
      },
      child: Text(element['Name'], style: textStyle,),
    );
    itemsList.add(simpleDialogOption);
  });
  return itemsList;
}

/// Dropdown용 아이템 생성 Function
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

/// Notification, iOS는 아직 세팅되지 않음
Future<void> showNotification(var title, var content) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var rng = new Random();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);

  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('Id', 'Name', 'Description', importance: Importance.max, priority: Priority.high, ticker: 'ticker', enableLights: true, color: const Color.fromARGB(255, 0, 255, 0), ledColor: const Color.fromARGB(255, 255, 255, 255), ledOnMs: 1000, ledOffMs: 500);
  const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(rng.nextInt(1000000), title, content, platformChannelSpecifics, payload: 'Notification'); // Id를 Random으로 생성하여 중복되지 않도록 처리하면 각 메시지가 별도로 나타난다.
}

Future selectNotification(String payload) async {
  print('notification payload: $payload');
}

Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
  print('notification payload: $payload');
}

/// Awesome Notification, iOS는 아직 세팅되지 않음
Future<void> showAwesomeNotification(var title, var content) async {
  var rng = new Random();
  AwesomeNotifications().initialize(
      'resource://drawable/app_icon',
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic',
            defaultColor: Color(0x00FF00),
            ledColor: Colors.white
        )
      ]
  );
  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: rng.nextInt(1000),
          channelKey: 'basic_channel',
          title: title,
          body: content
      )
  );
}

/// Remove User SharedPreferences
Future<void> removeUserSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('DueDate');
}

/// Show Confirm Message Box Function
showConfirmMessageBox(BuildContext context, String message, String div, String args) {
  /// set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel", style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,),),
    onPressed:  () {Navigator.of(context).pop();},
  );
  Widget continueButton = FlatButton(
    child: Text("Continue", style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,),
    ),
    onPressed:  () {
      Navigator.of(context).pop();
      /// By div call each Function, args has many argument data Join by '♭', Level 2 Join by '♪', Level 3 Join by '♬'
      /// String으로 Function Name을 호출하는 방법을 몰라 현재로서는 각개별로 생성 필요
      if(div == "") { showMessageBox(context, 'Alert', "Test Message Box"); }
    },
  );

  /// set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Confirm"),
    content: Text(translateText(context, message)),
    titleTextStyle: TextStyle(fontFamily: "Malgun", color: Colors.black, fontWeight: FontWeight.bold,),
    contentTextStyle: TextStyle(fontFamily: "Malgun", color: Colors.black,),
    actions: [ cancelButton, continueButton, ],
  );

  /// show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) { return alert; },
  );
}

/// Show Message Box Function
showMessageBox(BuildContext context, String title, String message) {
  /// set up the button
  Widget okButton = FlatButton(
    child: Text("Okay", style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,), ),
    onPressed: () {Navigator.of(context).pop();},
  );

  /// set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(translateText(context, message)),
    titleTextStyle: TextStyle(fontFamily: "Malgun", color: Colors.black, fontWeight: FontWeight.bold,),
    contentTextStyle: TextStyle(fontFamily: "Malgun", color: Colors.black,),
    actions: [ okButton, ],
  );

  /// show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) { return alert; },
  );
}

/// Show Select Message Box Function
showSelectMessageBox(BuildContext context, String message, String buttonname, String div, String args) {
  /// set up the buttons
  Widget aButton = FlatButton(
    child: Text(buttonname.split('♭')[0]), // Button Name Join by '♭'
    onPressed:  () {
      Navigator.of(context).pop();
      /// By div call each Function, args has many argument data Join by '♭', Level 2 Join by '♪', Level 3 Join by '♬'
      /// String으로 Function Name을 호출하는 방법을 몰라 현재로서는 각개별로 생성 필요
      if(div == "") { showMessageBox(context, 'Alert', "Test Message Box"); }
    },
  );
  Widget cancelButton = FlatButton(
    child: Text("Cancel", style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,),),
    onPressed:  () {Navigator.of(context).pop();},
  );
  Widget bButton = FlatButton(
    child: Text(buttonname.split('♭')[1], style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,),), /// Button Name Join by '♭'
    onPressed:  () {
      Navigator.of(context).pop();
      /// By div call each Function, args has many argument data Join by '♭', Level 2 Join by '♪', Level 3 Join by '♬'
      /// String으로 Function Name을 호출하는 방법을 몰라 현재로서는 각개별로 생성 필요
      if(div == "") { showMessageBox(context, 'Alert', "Test Message Box"); }
    },
  );

  /// set up the AlertDialog
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

  /// show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) { return alert; },
  );
}

/// DD 번역 Function
String translateText(BuildContext context, String key) {
  String text = key;
  try {
    text = languagedata[key];
    if(text == null) text = key;
  }
  catch (e) {
    print("translateText Error : " + e.toString());
  }
  return text;
}