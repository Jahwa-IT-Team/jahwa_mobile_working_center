import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jahwa_mobile_working_center/globals.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';
import 'package:jahwa_mobile_working_center/util/structures.dart';

ProgressDialog pr; // Progress Dialog Declaration

// Add User SharedPreferences
Future<void> addUserSharedPreferences(var user) async {
  //print("exec addUserSharedPreferences");
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
    prefs.setString('Language', language);
  }
  catch (e) {
    print(e.toString());
  }
}

// Check Login Info -> Move to Login Or Main Page : Index Page Use
Future<void> checkLogin(BuildContext context, String page) async {
  // Declare Shared Preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Setting Default Language : ko, en, vi, zh...
  if((prefs.getString('Language') ?? '') == '') prefs.setString('Language', language);
  else language = prefs.getString('Language') ?? '';

  // If passed Due Date go to Login Page
  if((prefs.getString('EmpCode') ?? '') == '' || (prefs.getString('DueDate') ?? '') != DateFormat('yyyy-MM-dd').format(DateTime.now())) removeUserSharedPreferences();
  else Navigator.pushNamedAndRemoveUntil(context, '/Index', (route) => false);
}

// Login Page Use
Future<void> loginCheck(BuildContext context, TextEditingController empcodeController, TextEditingController passwordController, ProgressDialog pr) async {
  //print("exec loginCheck : " + DateTime.now().toString());

  if(empcodeController.text.isEmpty) { // Employee Number Check
    pr.hide(); // Progress Dialog Close
    showMessageBox(context, "Employee Number Not Exists !!!");
  }
  else if(passwordController.text.isEmpty) { // Password Check
    pr.hide(); // Progress Dialog Close
    showMessageBox(context, "Password Not Exists !!!");
  }
  else if(!isPasswordCompliant(passwordController.text)) { // Password Check
    pr.hide(); // Progress Dialog Close
    showMessageBox(context, "Password invalid !!!");
  }
  else {
    // Login Process
    if(await signIn(empcodeController.text, passwordController.text)) {
      // Password 처리.....
      //prefs.setString('Password', passwordController.text); // Employee Save

      //print('SignIn Complete : ' + DateTime.now().toString());
      empcodeController.clear(); // Employee Number Clear
      passwordController.clear(); // Password Clear

      pr.hide(); // Progress Dialog Close

      // If Login Okay, Close Login Page And Move to Index Page
      Navigator.pushNamedAndRemoveUntil(context, '/Index', (route) => false);
    }
    else {
      pr.hide(); // Progress Dialog Close
      // When Fail Login Alert
      showMessageBox(context, "The login information is incorrect.");
    }
  }
}

// Password Validation Check
bool isPasswordCompliant(String password, [int minLength = 6, int maxLength = 21]) {
  //print("exec isPasswordCompliant : " + DateTime.now().toString());
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
  //print("exec signIn : " + DateTime.now().toString());
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

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // Progress - Not Used
  double percentage = 0.0;

  // TextField
  TextEditingController empcodeController = new TextEditingController(); // Employee Number Data Controller
  TextEditingController passwordController = new TextEditingController(); // Password Data Controller

  FocusNode empcodeFocusNode = FocusNode(); // Employee Input Number Focus
  FocusNode passwordFocusNode = FocusNode(); // Password Input Focus
  FocusNode loginFocusNode = FocusNode(); // Login Button Focus

  // Select Dialog - Language
  String ex1 = "Item 5";

  List <String> LanguageList = [
    'Korean',
    'Vietnamese',
    'Chinese',
    'English'
  ] ;

  void initState() {
    super.initState();
    print("open Login Page : " + DateTime.now().toString());
    checkLogin(context, '/Index');

    Map<String, dynamic> table = jsonDecode(languagelist);
    print(1);
    print(table);
    Map userMap = table['langlist'][0];
    print(2);
    print(userMap);
    var langlist = Language.fromJson(userMap);
    print(3);
    print(langlist.Lang);
  }

  @override
  Widget build(BuildContext context) {

    pr = ProgressDialog( // Progress Dialog Setting
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
    );

    pr.style( // Progress Dialog Style
      message: 'Wait a Moment...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    var width = MediaQuery.of(context).size.width; // Screen Width
    var height = MediaQuery.of(context).size.height; // Screen Height
    var statusBarHeight = MediaQuery.of(context).padding.top;

    var baseWidth = width * 0.65;
    if(baseWidth > 280) baseWidth = 280;

    return GestureDetector( // For Keyboard UnFocus
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView (
          child: Container(
            height: height,
            width: width,
            color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
            child: Column(
              children: <Widget>[
                SizedBox( height: statusBarHeight, ), // Status Bar
                Container( // Language
                  width: width,
                  height: (height - statusBarHeight) * 0.1,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0) ,
                  child: IconButton(
                      icon: FaIcon(FontAwesomeIcons.language),
                      iconSize: 30,
                      color: Colors.black,
                      onPressed: () {
                        SelectDialog.showModal<String>(
                          context,
                          label: "Select Language",
                          titleStyle: TextStyle(color: Colors.brown),
                          showSearchBox: false,
                          selectedValue: ex1,
                          backgroundColor: Colors.white,
                          items: LanguageList,
                          onChange: (String selected) {
                            setState(() {
                              ex1 = selected;
                              print(ex1);
                            });
                          },
                        );
                      }
                  ),
                ),
                Container( // Main Mark
                    width: width,
                    height: (height - statusBarHeight) * 0.4,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: baseWidth,
                      child: Image.asset("assets/image/jahwa.png"),
                    )
                ),
                Container( // Main Mark
                  width: width,
                  alignment: Alignment.center,
                  child: Container( // Input Area
                    width: baseWidth,
                    height: (height - statusBarHeight) * 0.3,
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget> [
                        TextField(
                          autofocus: false,
                          controller: empcodeController,
                          focusNode: empcodeFocusNode,
                          keyboardType: TextInputType.text,
                          onSubmitted: (String inputText) {
                            FocusScope.of(context).requestFocus(passwordFocusNode);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                              borderSide: new BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            labelText: 'Employee Number',
                            contentPadding: EdgeInsets.all(10),  // Added this
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 16,),
                        TextField(
                          obscureText: true,
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          focusNode: passwordFocusNode,
                          onSubmitted: (String inputText) async {
                            await pr.show(); // Progress Dialog Show - Need Declaration, Setting, Style
                            loginCheck(context, empcodeController, passwordController, pr);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                              borderSide: new BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            labelText: 'Password',
                            contentPadding: EdgeInsets.all(10),  // Added this
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: () {
                              showMessageBox(context, 'Are You Stupid ???'); // To be developed later.
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container( // Login Button
                  width: width,
                  height: (height - statusBarHeight) * 0.2,
                  alignment: Alignment.topCenter,
                  child: ButtonTheme(
                    minWidth: baseWidth,
                    height: 50.0,
                    child: RaisedButton(
                      focusNode: loginFocusNode,
                      child:Text('Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white,)),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                      onPressed: () async {
                        await pr.show();
                        loginCheck(context, empcodeController, passwordController, pr);
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}