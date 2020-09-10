import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:jahwa_mobile_working_center/util/structures.dart';

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

// Insert SharedPreferences
Future<void> addUserSharedPreferences(var user) async {
  print("exec insSharedPreferences");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    prefs.setString('EntCode', user.EntCode);
    prefs.setString('EntName', user.EntName);
    prefs.setString('DeptCode', user.DeptCode);
    prefs.setString('DeptName', user.DeptName);
    prefs.setString('EmpCode', user.EmpCode);
    prefs.setString('Name', user.Name);
    prefs.setString('RollPstn', user.RollPstn);
    prefs.setString('Position', user.Position);
    prefs.setString('Role', user.Role);
    prefs.setString('Title', user.Title);
    prefs.setString('PayGrade', user.PayGrade);
    prefs.setString('Level', user.Level);
    prefs.setString('Email', user.Email);
    prefs.setString('Photo', user.Photo);
    prefs.setInt('Auth', user.Auth);
    prefs.setString('EntGroup', user.EntGroup);
    prefs.setString('OfficeTel', user.OfficeTel);
    prefs.setString('Mobile', user.Mobile);
    prefs.setString('DueDate', DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }
  catch (e) {
    print(e.toString());
  }
}

// Insert SharedPreferences
Future<void> removeUserSharedPreferences() async {
  //print("exec delSharedPreferences : " + DateTime.now().toString());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('EmpCode');
  prefs.remove('DueDate');
}

// Check Login Info -> Move to Login Or Main Page : Index Page Use
Future<void> checkLogin(BuildContext context, String page) async {
  //print("exec checkLogin : " + DateTime.now().toString());
  SharedPreferences prefs = await SharedPreferences.getInstance();

  //print("checkLogin 1-1 - EmpCode : " + (prefs.getString('EmpCode') ?? '') + " - "  + DateTime.now().toString());
  //print("checkLogin 1-2 - DueDate : " + (prefs.getString('DueDate') ?? '') + " - " + DateTime.now().toString());

  // If passed Due Date go to Login Page
  if((prefs.getString('EmpCode') ?? '') == '' || (prefs.getString('DueDate') ?? '') != DateFormat('yyyy-MM-dd').format(DateTime.now())) {
    //print('checkLogin 2-1 - EmpCode Is NULL : ' + DateTime.now().toString());
    //print('checkLogin 2-2 - Due Date Not Correct : ' + DateTime.now().toString());
    removeUserSharedPreferences();
  }
  else {
      //print("checkLogin 3-1 - EmpCode : " + (prefs.getString('EmpCode') ?? '') + " - "  + DateTime.now().toString());
      //print("checkLogin 3-2 - DueDate : " + (prefs.getString('DueDate') ?? '') + " - " + DateTime.now().toString());
      //Navigator.pushNamed(context, '/Index');
      Navigator.pushNamedAndRemoveUntil(context, '/Index', (route) => false);
  }
}

// Login Page Use
Future<void> loginCheck(BuildContext context, TextEditingController empcodeController, TextEditingController passwordController, ProgressDialog pr) async {
  print("exec loginCheck : " + DateTime.now().toString());

  if(empcodeController.text.isEmpty) { // Employee Number Check
    pr.hide();
    showDialogOne(context, "Employee Number Not Exists !!!");
  }
  else if(passwordController.text.isEmpty) { // Password Check
    pr.hide();
    showDialogOne(context, "Password Not Exists !!!");
  }
  else if(!isPasswordCompliant(passwordController.text)) { // Password Check
    pr.hide();
    showDialogOne(context, "Password invalid !!!");
  }
  else {
    // Login Process
    if(await signIn(empcodeController.text, passwordController.text)) {
      // Password 처리.....
      //prefs.setString('Password', passwordController.text); // Employee Save

      print('SignIn Complete : ' + DateTime.now().toString());
      empcodeController.clear(); // Employee Number Clear
      passwordController.clear(); // Password Clear

      pr.hide();

      // If Login Okay, Close Login Page And Move to Index Page
      Navigator.pushNamedAndRemoveUntil(context, '/Index', (route) => false);
    }
    else {
      pr.hide();
      // When Fail Login Alert
      showDialogOne(context, "The login information is incorrect.");
    }
  }
}

// Password Validation Check
bool isPasswordCompliant(String password, [int minLength = 6, int maxLength = 21]) {
  print("exec isPasswordCompliant : " + DateTime.now().toString());
  if (password == null || password.isEmpty) { return false; }

  bool hasUppercase = password.contains(new RegExp(r'[A-Z]')); // Upper Case Character Check
  bool hasLowercase = password.contains(new RegExp(r'[a-z]')); // Lower Case Character Check
  bool hasDigits = password.contains(new RegExp(r'[0-9]')); // Number Check
  bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*()?_~]')); // Special Character Check
  bool hasMinLength = password.length > minLength; // Min Over 6
  bool hasMaxLength = password.length < maxLength; // Max Under 21

  return hasDigits & (hasUppercase || hasLowercase) & hasSpecialCharacters & hasMinLength & hasMaxLength;
}

// Login Process
Future<bool> signIn(String email, String password) async {
  print("exec signIn : " + DateTime.now().toString());
  try {
    // Login API Url
    var url = 'https://jhapi.jahwa.co.kr/Login';

    // Send Parameter
    var data = {'id': email, 'password' : password};

    return await http.post(
        Uri.encodeFull(url),
        body: json.encode(data),
        headers: {"Content-Type": "application/json"}
    ).timeout(
        const Duration(seconds: 15)
    ).then<bool>((http.Response response) {
      //print("Result SignIn : ${response.body}, (${response.statusCode}) - " + DateTime.now().toString());
      if(response.statusCode != 200 || response.body == null || response.body == "{}" ){
        return false;
      }
      if(response.statusCode == 200){
        Map<String, dynamic> table = jsonDecode(response.body);
        Map userMap = table['Table'][0];
        var user = User.fromJson(userMap);
        //print("Pre addUserSharedPreferences : " + DateTime.now().toString());
        addUserSharedPreferences(user);
        //print("After addUserSharedPreferences : " + DateTime.now().toString());
        return true;
      }else{
        return false;
      }
    });
  } catch (e) {
    print(e.toString());
    return false;
  }
}