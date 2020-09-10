import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';

ProgressDialog pr; // Progress Use

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  double percentage = 0.0;

  TextEditingController empcodeController = new TextEditingController(); // Employee Number Data Controller
  TextEditingController passwordController = new TextEditingController(); // Password Data Controller

  FocusNode empcodeFocusNode = FocusNode(); // Employee Input Number Focus
  FocusNode passwordFocusNode = FocusNode(); // Password Input Focus
  FocusNode loginFocusNode = FocusNode(); // Login Button Focus

  void initState() {
    super.initState();
    print("open Login Page : " + DateTime.now().toString());
    checkLogin(context, '/Index');
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      //textDirection: TextDirection.LTR,
      isDismissible: true,
    );

    pr.style(
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

    return GestureDetector( // For Keyboard UnFocus
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView (
          child: Column(
            children: <Widget>[
              Container( // Top Area
                height: 24,
                width: width,
                color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
              ),
              Container( // Language
                color: Colors.white,
                width: width,
                height: (height - 24) * 0.1,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.0) ,
                child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.language),
                    iconSize: 30,
                    color: Colors.black,
                    onPressed: () { Navigator.pushNamedAndRemoveUntil(context, '/MailList', (route) => false); }
                ),
              ),
              Container( // Main Mark
                  color: Colors.white,
                  width: width,
                  height: (height - 24) * 0.4,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width:width * 0.65,
                    child: Image.asset("assets/image/jahwa.png"),
                  )
              ),
              Container( // Main Mark
                color: Colors.white,
                width: width,
                alignment: Alignment.center,
                child: Container( // Input Area
                  color: Colors.white,
                  width: width * 0.65,
                  height: (height - 24) * 0.3,
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
                          border: OutlineInputBorder(),
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
                          await pr.show();
                          print("ID : ${empcodeController.text}, Password : ${passwordController.text}");
                          loginCheck(context, empcodeController, passwordController, pr);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          contentPadding: EdgeInsets.all(10),  // Added this
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          onPressed: () async {
                            //await pr.show();
                            //Timer(Duration(seconds: 5), () async {
                            //print("ID : ${empcodeController.text}, Password : ${passwordController.text}");
                            //loginCheck(context, empcodeController, passwordController, pr);
                            //await pr.hide();
                            //});
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container( // Login Button
                color: Colors.white,
                width: width,
                height: (height - 24) * 0.2,
                alignment: Alignment.topCenter,
                child: ButtonTheme(
                  minWidth: width * 0.65,
                  height: 50.0,
                  child: RaisedButton(
                    focusNode: loginFocusNode,
                    child:Text('Login', style: TextStyle(fontSize: 24, color: Colors.white,)),
                    onPressed: () async {
                      await pr.show();
                      //Timer(Duration(seconds: 5), () async {
                      print("ID : ${empcodeController.text}, Password : ${passwordController.text}");
                      loginCheck(context, empcodeController, passwordController, pr);
                      //await pr.hide();
                      //});
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}