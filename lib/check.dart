import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';
import 'package:jahwa_mobile_working_center/util/globals.dart';

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}

class _CheckState extends State<Check> {

  // Call When Form Init
  @override
  void initState() {
    super.initState();
    print("open Check Page : " + DateTime.now().toString());
    Timer(Duration(seconds: 1), () {
      preferenceSetting(); // Make Session And Language Data, Check Login
    });  // Need Delete
  }

  ButtonState btnState = ButtonState.loading;

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width; // Screen Width
    screenHeight = MediaQuery.of(context).size.height; // Screen Height
    statusBarHeight = MediaQuery.of(context).padding.top;

    var baseWidth = screenWidth * 0.65;
    if(baseWidth > 280) baseWidth = 280;

    return GestureDetector( // For Keyboard UnFocus
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container( // Top Area
                height: statusBarHeight,
                width: screenWidth,
                color: Color.fromARGB(0xFF, 0x34, 0x40, 0x4E),
              ),
              SizedBox(
                height: 50,
              ),
              Container( // Main Mark
                  width: screenWidth,
                  height: (screenHeight - statusBarHeight) * 0.60,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: baseWidth,
                    child: Image.asset("assets/image/jahwa.png"),
                  )
              ),
              Container( // Main Area
                width: baseWidth,
                height: (screenHeight - statusBarHeight) * 0.35,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    buildCustomButton(),
                    SizedBox(height: 20,),
                    Text('Checking Update! Please Wait!!!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14, ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomButton() {
    var progressTextButton = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text("Update required!!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
        ButtonState.loading: Text("Checking Update!!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
        ButtonState.fail: Text("Failed. If you want to Reload, Click Here!!", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
        ButtonState.success: Text("The update was successful!!", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)
      },
      stateColors: {
        ButtonState.idle: Colors.grey.shade400,
        ButtonState.loading: Colors.blue.shade300,
        ButtonState.fail: Colors.red.shade300,
        ButtonState.success: Colors.green.shade400,
      },
      onPressed: () {
        if(btnState == ButtonState.fail) {
          btnState = ButtonState.loading;
          setState(() {});
          preferenceSetting();
        }
        else { setState(() {}); }
      },
      state: btnState,
      padding: EdgeInsets.all(8.0),
    );
    return progressTextButton;
  }

  // Version -> Language -> Session -> Menu

  // Make Session And Language Data
  Future<void> preferenceSetting() async {

    // 0. Declare Screent Size
    screenWidth = MediaQuery.of(context).size.width; // Screen Width
    screenHeight = MediaQuery.of(context).size.height; // Screen Height
    statusBarHeight = MediaQuery.of(context).padding.top; // Top Status Bar Height
    appBarHeigight = AppBar().preferredSize.height; // App Bar Height

    // 1. Version Check
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {

      String version = packageInfo.version;

      try {

        // Login API Url
        var url = 'https://jhapi.jahwa.co.kr/Version';

        // Send Parameter
        var data = {'VersionA': version.split('.')[0], 'VersionB' : version.split('.')[1], 'VersionC' : version.split('.')[2]};

        return await http.post(Uri.encodeFull(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) async {

          //print("Result Version : ${response.body}, (${response.statusCode}) - " + DateTime.now().toString());
          if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ showMessageBox(context, 'Alert', 'Check Version Data Error !!!'); }
          else if(response.statusCode == 200){

            if(jsonDecode(response.body)['Table'][0]['VersionA'].toString() == '0') {
              //print('Go Next Step!!!');

              SharedPreferences prefs = await SharedPreferences.getInstance();

              try{

                // 2. Language Check
                language = prefs.getString('Language') ?? ui.window.locale.languageCode;
                languagedata = jsonDecode(prefs.getString('LanguageData') ?? '{}');

                if(await prefs.setString('LanguageData', await rootBundle.loadString("assets/lang/" + language + ".json"))){
                  if((prefs.getString('LanguageData') ?? '') == '') languagedata = jsonDecode(await rootBundle.loadString("assets/lang/" + language + ".json"));
                  else languagedata = jsonDecode(prefs.getString('LanguageData'));
                }

                // 3. Session Check
                if(await checkLogin())
                {
                  btnState = ButtonState.success;
                  setState(() {});
                  Timer(Duration(seconds: 1), () {
                    Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);  // Direct Move to Login
                  });
                }
                else {
                  session['EntCode'] = prefs.getString('EntCode') ?? '';
                  session['EntName'] = prefs.getString('EntName') ?? '';
                  session['DeptCode'] = prefs.getString('DeptCode') ?? '';
                  session['DeptName'] = prefs.getString('DeptName') ?? '';
                  session['EmpCode'] = prefs.getString('EmpCode') ?? '';
                  session['Name'] = prefs.getString('Name') ?? '';
                  session['RollPstn'] = prefs.getString('RollPstn') ?? '';
                  session['Position'] = prefs.getString('Position') ?? '';
                  session['Role'] = prefs.getString('Role') ?? '';
                  session['Title'] = prefs.getString('Title') ?? '';
                  session['PayGrade'] = prefs.getString('PayGrade') ?? '';
                  session['Level'] = prefs.getString('Level') ?? '';
                  session['Email'] = prefs.getString('Email') ?? '';
                  session['Photo'] = prefs.getString('Photo') ?? '';
                  session['Auth'] = prefs.getInt('Auth').toString() ?? '0';
                  session['EntGroup'] = prefs.getString('EntGroup') ?? '';
                  session['OfficeTel'] = prefs.getString('OfficeTel') ?? '';
                  session['Mobile'] = prefs.getString('Mobile') ?? '';
                  session['DueDate'] = prefs.getString('DueDate') ?? '';

                  // 4. Menu Check
                  if(session['EmpCode'] != '') {
                    if(await getMenu()) {
                      btnState = ButtonState.success;
                      setState(() {});
                      // After Success Goto Index
                      Timer(Duration(seconds: 1), () {
                        Navigator.pushNamedAndRemoveUntil(context, '/Index', (route) => false);
                      });
                    }
                    else {
                      btnState = ButtonState.fail;
                      setState(() {});
                      showMessageBox(context, 'Alert', 'Preference Setting Error : getMenu Fail!!!');
                    }
                  }
                  else {
                    btnState = ButtonState.fail;
                    setState(() {});
                    showMessageBox(context, 'Alert', 'Preference Setting Error : Employee Number Not Exists!!!');
                  }
                }
              }
              catch (e){
                btnState = ButtonState.fail;
                setState(() {});
                showMessageBox(context, 'Alert', 'Preference Setting Error B : ' + e.toString());
              }
            }
            else {
              btnState = ButtonState.idle;
              setState(() {});
              Timer(Duration(seconds: 1), () {
                Navigator.pushNamedAndRemoveUntil(context, '/Update', (route) => false);  // Direct Move to Update
              });
            }
          }
        });
      }
      catch (e) {
        showMessageBox(context, 'Alert', 'Preference Setting Error A : ' + e.toString());
      }
    });
  }

  // Make Menu Data to menudata
  Future<bool> getMenu() async {
    //print("exec getMenu : " + DateTime.now().toString());
    //btnState = ButtonState.idle;
    //setState(() {});
    try {
      // Login API Url
      var url = 'https://jhapi.jahwa.co.kr/Menu';

      // Send Parameter
      var data = {'lang': session['Language'], 'category' : 'JHMobile', 'entgroup' : session['EntGroup'], 'entcode' : session['EntCode'], 'empcode' : session['EmpCode'], 'auth' : session['Auth']};

      return await http.post(Uri.encodeFull(url), body: json.encode(data), headers: {"Content-Type": "application/json"})
          .timeout(const Duration(seconds: 15))
          .then<bool>((http.Response response) {
        //print("Result getMenu : ${response.body}, (${response.statusCode}) - " + DateTime.now().toString());
        if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ return false; }
        if(response.statusCode == 200){
          menudata = jsonDecode(response.body);
          return true;
        }
        else{ return false; }
      });
    }
    catch (e) {
      print("getMenu Error : " + e.toString());
      return false;
    }
  }
}

// Check Login Info -> Move to Login Or Main Page : Index Page Use
Future<bool> checkLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // If passed Due Date go to Login Page
  if((prefs.getString('DueDate') ?? '') != DateFormat('yyyy-MM-dd').format(DateTime.now())) {
    clearSession();
    removeUserSharedPreferences();
    return true;
  }
  else{return false;}
}

