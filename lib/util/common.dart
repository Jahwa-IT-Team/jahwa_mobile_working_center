import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  print("exec showDialogOne");
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
  print("exec showDialogTwo");
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
  print("exec showDialogThree");
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
Future<void> insSharedPreferences(var user) async {
  print("exec insSharedPreferences");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('EntCode', user.EntCode);
  await prefs.setString('EntName', user.EntName);
  await prefs.setString('DeptCode', user.DeptCode);
  await prefs.setString('DeptName', user.DeptName);
  await prefs.setString('EmpCode', user.EmpCode);
  await prefs.setString('Name', user.Name);
  await prefs.setString('RollPstn', user.RollPstn);
  await prefs.setString('Position', user.Position);
  await prefs.setString('Role', user.Role);
  await prefs.setString('Title', user.Title);
  await prefs.setString('PayGrade', user.PayGrade);
  await prefs.setString('Level', user.Level);
  await prefs.setString('Email', user.Email);
  await prefs.setString('Photo', user.Photo);
  await prefs.setInt('Auth', user.Auth);
  await prefs.setString('EntGroup', user.EntGroup);
  await prefs.setString('OfficeTel', user.OfficeTel);
  await prefs.setString('Mobile', user.Mobile);
  await prefs.setString('DueDate', DateFormat('yyyy-MM-dd').format(DateTime.now()));
}

// Insert SharedPreferences
Future<void> delSharedPreferences() async {
  print("exec delSharedPreferences");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

// Check Login Info -> Move to Login Or Main Page : Index Page Use
Future<void> checkLogin(BuildContext context, String page) async {
  print("exec checkLogin");
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var empcode = await prefs.getString('EmpCode') ?? '';
  var duedate = await prefs.getString('DueDate') ?? '';

  // Valid Date Check Add - If Out of Time, Delete SharedPreferences Data
  if(empcode != '' && duedate == '') {
    duedate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString('DueDate', DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  print("checkLogin - EmpCode : " + empcode);
  print("checkLogin - DueDate : " + duedate);

  // If passed Due Date go to Login Page
  if(duedate != DateFormat('yyyy-MM-dd').format(DateTime.now())) {
    delSharedPreferences();
    Navigator.pushNamed(context, '/Login');
  }

  // If Employee Number does not Exists go to Login Page
  if(empcode == '') { _navigateAndDisplaySelection(context); }
  else { Navigator.pushNamedAndRemoveUntil(context, page, (route) => false); }
}

_navigateAndDisplaySelection(BuildContext context) async { // Open Window For Receive Data
  print("Index Page Check Start : ");
  final result = await Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);
  //showDialogOne(context, "$result");
  print("Index Page Check End : " + result);

  if(result == "Login Okay") Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);
  else Navigator.pushNamedAndRemoveUntil(context, '/MainPage', (route) => false);
}

// Login Page Use
Future<void> loginCheck(BuildContext context, TextEditingController empcodeController, TextEditingController passwordController) async {
  print("exec loginCheck");
  final prefs = await SharedPreferences.getInstance();

  if(empcodeController.text.isEmpty) { // Employee Number Check
    showDialogOne(context, "Employee Not Exists !!!");
  }
  else if(!isPasswordCompliant(passwordController.text)) { // Password Check
    showDialogOne(context, "Password invalid !!!");
  }
  else {
    // Login Process
    var data = await signIn(empcodeController.text, passwordController.text);
    print(data);
    if(data) {
      //prefs.setString('Password', passwordController.text); // Employee Save

      empcodeController.clear(); // Employee Number Clear
      passwordController.clear(); // Password Clear

      // If Login Okay to move Main Page
      Navigator.pop(context, 'Login Okay');
      //Navigator.pushNamed(context, '/MainPage');
    }
    else {
      // When Fail Login Alert
      showDialogOne(context, "The login information is incorrect.");
    }
  }
}

// Password Validation Check
bool isPasswordCompliant(String password, [int minLength = 6, int maxLength = 21]) {
  print("exec isPasswordCompliant");
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
  print("exec signIn");
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
      print("Result SignIn : ${response.body}, (${response.statusCode})");
      if(response.statusCode != 200 || response.body == null || response.body == "{}" ){
        return false;
      }
      if(response.statusCode == 200){
        Map<String, dynamic> table = jsonDecode(response.body);
        Map userMap = table['Table'][0];
        var user = User.fromJson(userMap);
        insSharedPreferences(user);
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