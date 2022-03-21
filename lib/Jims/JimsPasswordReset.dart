import 'dart:async';
import 'dart:core';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';
import 'package:jahwa_mobile_working_center/util/globals.dart';

ProgressDialog pr; /// 0. Progress Dialog Declaration

class JimsPasswordReset extends StatefulWidget {
  @override
  _JimsPasswordResetState createState() => _JimsPasswordResetState();
}

class _JimsPasswordResetState extends State<JimsPasswordReset> {

  TextEditingController empcodeController = new TextEditingController(); /// Employee Number Data Controller
  TextEditingController nameController = new TextEditingController(); /// Name Data Controller
  TextEditingController passwordController = new TextEditingController(); /// Password Data Controller

  FocusNode empcodeFocusNode = FocusNode(); /// Employee Number Input Focus
  FocusNode nameFocusNode = FocusNode(); /// Name Input Focus
  FocusNode passwordFocusNode = FocusNode(); /// Password Input Focus

  void initState() {
    super.initState();
    print("open Admin Password Reset Page : " + DateTime.now().toString());
  }

  @override
  Widget build(BuildContext context) {

    pr = ProgressDialog( /// 1. Progress Dialog Setting
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
    );

    pr.style( /// 2. Progress Dialog Style
      message: translateText(context, 'Wait a Moment...'),
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
    );

    screenWidth = MediaQuery.of(context).size.width; /// Screen Width
    screenHeight = MediaQuery.of(context).size.height; /// Screen Height
    statusBarHeight = MediaQuery.of(context).padding.top; /// Status Bar Height

    var baseWidth = screenWidth * 0.65;
    if(baseWidth > 280) baseWidth = 280;

    return GestureDetector( /// Keyboard UnFocus시를 위해 onTap에 GestureDetector를 위치시킴
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) { currentFocus.unfocus(); }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0xFF, 0x34, 0x40, 0x4E),
          title: Text("Reset Password",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),
          ),
        ),
        body: SingleChildScrollView ( /// Scroll이 생기도록 하는 Object
            child: Container(
              height: screenHeight,
              width: screenWidth,
              color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
              child: Column(
                children: <Widget>[
                  Container( /// Jahwa Mark
                    width: screenWidth,
                    height: (screenHeight - statusBarHeight) * 0.15,
                    alignment: Alignment.center,
                    child: Text(translateText(context, 'Reset Password'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black,)),
                  ),
                  Container( /// Input Area
                    width: screenWidth,
                    alignment: Alignment.center,
                    child: Container(
                      width: baseWidth,
                      height: (screenHeight - statusBarHeight) * 0.85,
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget> [
                          TextField(
                            autofocus: false,
                            controller: empcodeController,
                            focusNode: empcodeFocusNode,
                            keyboardType: TextInputType.text,
                            onSubmitted: (String inputText) {
                              FocusScope.of(context).requestFocus(nameFocusNode);  /// Input Box에서 Enter 적용시 Password 입력 Box로 이동됨
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(const Radius.circular(10.0),),
                                borderSide: new BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              labelText: translateText(context, 'Employee Number'),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 16,),
                          TextField(
                            autofocus: false,
                            controller: nameController,
                            focusNode: nameFocusNode,
                            keyboardType: TextInputType.text,
                            onSubmitted: (String inputText) async {
                              await pr.show(); /// 3. Progress Dialog Show - Need Declaration, Setting, Style
                              checkEmployee(context, empcodeController, nameController, pr); /// 수동으로 로그인 프로세스를 실행시킴
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(const Radius.circular(10.0),),
                                borderSide: new BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              labelText: translateText(context, 'Name'),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 16,),
                          ButtonTheme(
                            minWidth: baseWidth,
                            height: 50.0,
                            child: RaisedButton(
                              child:Text(translateText(context, 'Check Employee'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white,)),
                              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                              splashColor: Colors.grey,
                              onPressed: () async {
                                await pr.show(); /// 3. Progress Dialog Show - Need Declaration, Setting, Style
                                checkEmployee(context, empcodeController, nameController, pr);
                              },
                            ),
                          ),
                          SizedBox(height: 40,),
                          TextField(
                            autofocus: false,
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            focusNode: passwordFocusNode,
                            onSubmitted: (String inputText) async {
                              await pr.show(); /// Progress Dialog Show - Need Declaration, Setting, Style
                              resetPassword(context, empcodeController, nameController, passwordController, pr); /// Input Box에서 Enter 적용시 바로 로그인 프로세스가 진행됨
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(const Radius.circular(10.0),),
                                borderSide: new BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              labelText: translateText(context, 'New Password'),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            textInputAction: TextInputAction.done,
                          ),
                          SizedBox(height: 16,),
                          ButtonTheme(
                            minWidth: baseWidth,
                            height: 50.0,
                            child: RaisedButton(
                              child:Text(translateText(context, 'Reset Password'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white,)),
                              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                              splashColor: Colors.grey,
                              onPressed: () async {
                                await pr.show(); /// 3. Progress Dialog Show - Need Declaration, Setting, Style
                                resetPassword(context, empcodeController, nameController, passwordController, pr); /// Input Box에서 Enter 적용시 바로 로그인 프로세스가 진행됨
                              },
                            ),
                          ),
                        ],
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

  /// Check Employee
  Future<void> checkEmployee(BuildContext context, TextEditingController empcodeController, TextEditingController nameController, ProgressDialog pr) async {

    pr.hide(); /// 4. Progress Dialog Close

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }

    var list;

    if(empcodeController.text.isEmpty && nameController.text.isEmpty) { showMessageBox(context, 'Alert', 'Employee Number and Name Not Exists !!!'); } /// Employee Number and Name Empty Check
    else {
      try {

        // Login API Url
        var url = 'https://jhapi.jahwa.co.kr/FindEmployee';

        // Send Parameter
        var data = {'EmpCode': empcodeController.text, 'Name' : nameController.text};

        return await http.post(Uri.parse(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) {
          if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ return false; }
          if(response.statusCode == 200){
            if(jsonDecode(response.body)['Table'].length != 0) {
              list = jsonDecode(response.body);

              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text('Select Employee ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black, )),
                    children: makeDialogItems(context, 'FindEmployee', list, "", empcodeController, nameController),
                  );
                },
              );

              FocusScope.of(context).requestFocus(passwordFocusNode);
            }
            else {
              showMessageBox(context, "Alert", "검색결과가 존재하지 않습니다.");
            }
          }
          else{ return false; }
        });
      }
      catch (e) {
        print("get Notiofy Error : " + e.toString());
        return false;
      }
    }
  }

  /// Reset Password Process
  Future<void> resetPassword(BuildContext context, TextEditingController empcodeController, TextEditingController nameController, TextEditingController passwordController, ProgressDialog pr) async {

    pr.hide(); /// 4. Progress Dialog Close

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }

    if(empcodeController.text.isEmpty || nameController.text.isEmpty) { showMessageBox(context, 'Alert', 'Employee Number or Name Not Exists !!!'); } /// Employee Number and Name Empty Check
    else {
      try {

        // Login API Url
        var url = 'https://jhapi.jahwa.co.kr/ResetPassword2';

        // Send Parameter
        var data = {'EmpCode': empcodeController.text, 'Name' : nameController.text, 'Password' : passwordController.text, 'EmpCode2': session['EmpCode'], 'Token' : session['Token']};

        return await http.post(Uri.parse(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) {
          if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ return false; }
          if(response.statusCode == 200) {
            showMessageBox(context, "", response.body.toString());
          }
          else{ return false; }
        });
      }
      catch (e) {
        print("reset Password Error : " + e.toString());
        return false;
      }
    }
  }
}