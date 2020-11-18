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
import 'package:jahwa_mobile_working_center/util/structures.dart';

ProgressDialog pr; /// Progress Dialog Declaration

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController empcodeController = new TextEditingController(); /// Employee Number Data Controller
  TextEditingController passwordController = new TextEditingController(); /// Password Data Controller

  FocusNode empcodeFocusNode = FocusNode(); /// Employee Input Number Focus
  FocusNode passwordFocusNode = FocusNode(); /// Password Input Focus
  FocusNode loginFocusNode = FocusNode(); /// Login Button Focus

  void initState() {
    super.initState();
    print("open Login Page : " + DateTime.now().toString());
    setEmpCodeController(empcodeController); /// 세션을 이용한 사번 자동 세팅
  }

  @override
  Widget build(BuildContext context) {

    pr = ProgressDialog( /// Progress Dialog Setting
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
    );

    pr.style( /// Progress Dialog Style
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
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView ( /// Scroll이 생기도록 하는 Object
          child: Container(
            height: screenHeight,
            width: screenWidth,
            color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
            child: Column(
              children: <Widget>[
                SizedBox( height: statusBarHeight, ), /// Status Bar
                Container( /// Language Select
                  width: screenWidth,
                  height: (screenHeight - statusBarHeight) * 0.1,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0) ,
                  child: IconButton(
                      icon: FaIcon(FontAwesomeIcons.language),
                      iconSize: 40,
                      color: Colors.blueAccent,
                      onPressed: () {
                        return showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: const Text('Select Language ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black, )),
                              children: makeDialogItems(context, 'Language', languagelist, language),
                            );
                          },
                        );
                      }
                  ),
                ),
                Container( // Main Mark
                    width: screenWidth,
                    height: (screenHeight - statusBarHeight) * 0.35,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: baseWidth,
                      child: Image.asset("assets/image/jahwa.png"),
                    )
                ),
                Container( /// Jahwa Mark
                  width: screenWidth,
                  alignment: Alignment.center,
                  child: Container( /// Input Area
                    width: baseWidth,
                    height: (screenHeight - statusBarHeight) * 0.35,
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
                            labelText: translateText(context, 'Employee Number'),
                            contentPadding: EdgeInsets.all(10),
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
                            await pr.show(); /// Progress Dialog Show - Need Declaration, Setting, Style
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
                            labelText: translateText(context, 'Password'),
                            contentPadding: EdgeInsets.all(10),
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: () {
                              showMessageBox(context, 'Alert', 'Are You Stupid ???'); /// To be developed later.
                            },
                            child: Text(
                              translateText(context, 'Forgot Password?'),
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14, ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container( // Login Button
                  width: screenWidth,
                  height: (screenHeight - statusBarHeight) * 0.2,
                  alignment: Alignment.topCenter,
                  child: ButtonTheme(
                    minWidth: baseWidth,
                    height: 50.0,
                    child: RaisedButton(
                      focusNode: loginFocusNode,
                      child:Text(translateText(context, 'Login'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white,)),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                      splashColor: Colors.grey,
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

  /// Add User SharedPreferences
  Future<void> addPasswordSharedPreferences(var password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try { prefs.setString('Password', encryptText('Encrypt', password)); }
    catch (e) { print(e.toString()); }
  }

  /// Add User SharedPreferences
  Future<void> addUserSharedPreferences(var user) async {
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

      session['EntCode'] =  user.EntCode;
      session['EntName'] = user.EntName;
      session['DeptCode'] = user.DeptCode;
      session['DeptName'] = user.DeptName;
      session['EmpCode'] = user.EmpCode;
      session['Name'] = user.Name;
      session['RollPstn'] = user.RollPstn;
      session['Position'] = user.Position;
      session['Role'] = user.Role;
      session['Title'] = user.Title;
      session['PayGrade'] = user.PayGrade;
      session['Level'] = user.Level;
      session['Email'] = user.Email;
      session['Photo'] = user.Photo;
      session['Auth'] = user.Auth.toString();
      session['EntGroup'] = user.EntGroup;
      session['OfficeTel'] = user.OfficeTel;
      session['Mobile'] = user.Mobile;
      session['DueDate'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    catch (e) {
      print(e.toString());
    }
  }

  /// Password Validation Check
  bool isPasswordCompliant(String password, [int minLength = 6, int maxLength = 21]) {
    if (password == null || password.isEmpty) { return false; } /// Password Null Check
    bool hasUppercase = password.contains(new RegExp(r'[A-Z]')); /// Upper Case Character Check
    bool hasLowercase = password.contains(new RegExp(r'[a-z]')); /// Lower Case Character Check
    bool hasDigits = password.contains(new RegExp(r'[0-9]')); /// Number Check
    bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*()?_~.,]')); /// Special Character Check
    bool hasMinLength = password.length > minLength; /// Min Over 6
    bool hasMaxLength = password.length < maxLength; /// Max Under 21

    return hasDigits & (hasUppercase || hasLowercase) & hasSpecialCharacters & hasMinLength & hasMaxLength;
  }

  /// Login Process
  Future<void> loginCheck(BuildContext context, TextEditingController empcodeController, TextEditingController passwordController, ProgressDialog pr) async {

    pr.hide(); /// Progress Dialog Close

    if(empcodeController.text.isEmpty) { showMessageBox(context, 'Alert', 'Employee Number Not Exists !!!'); } /// Employee Number Empty Check
    else if(passwordController.text.isEmpty) { showMessageBox(context, 'Alert', 'Password Not Exists !!!'); } /// Password Empty Check
    else if(!isPasswordCompliant(passwordController.text)) { showMessageBox(context, 'Alert', 'Password invalid !!!'); } /// Password Validation Check
    else {
      if(await signIn(empcodeController.text, passwordController.text)) {
        empcodeController.clear(); /// Employee Number Clear
        passwordController.clear(); /// Password Clear
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); /// 로그인 성공시 Check 페이지로 이동
      }
      else { showMessageBox(context, 'Alert', 'The login information is incorrect.'); } /// Login 실패 메시지
    }
  }

  /// 세션을 이용한 사번 자동 세팅
  Future<void> setEmpCodeController(TextEditingController empcodeController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    empcodeController.text = (prefs.getString('EmpCode') ?? '');
  }

  /// Login Check Process
  Future<bool> signIn(String email, String password) async {
    try {

      var url = 'https://jhapi.jahwa.co.kr/Login';  /// API Url
      var data = {'id': email, 'password' : password}; /// Send Parameter

      return await http.post(Uri.encodeFull(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) {
        if(response.statusCode != 200 || response.body == null || response.body == "{}" ) { return false; }
        if(response.statusCode == 200){
          Map<String, dynamic> table = jsonDecode(response.body);
          Map userMap = table['Table'][0];
          var user = User.fromJson(userMap);
          addUserSharedPreferences(user); /// 사용자 정보 세션 생성
          addPasswordSharedPreferences(password); /// 비밀번호 관련 세션 생성
          return true;
        }
        else { return false; }
      });
    } catch (e) {
      print("signIn Error : " + e.toString());
      return false;
    }
  }
}