import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';
import 'package:jahwa_mobile_working_center/util/globals.dart';

// Server
var server = "KRAPPD";

class JimsIISRecycle extends StatefulWidget {
  @override
  _JimsIISRecycleState createState() => _JimsIISRecycleState();
}

class _JimsIISRecycleState extends State<JimsIISRecycle> {

  List<Card> cardList = new List<Card>();
  List<Text> textList = new List<Text>();

  List<DropdownMenuItem> itemsList = [];
  List<DropdownMenuItem> iisServerList = [];

  bool _isLoading = true;
  String _serverName = "KRAPPD";

  Future<void> makeDropdownItem(String strDiv, String strServer) async {
    try {

      // Login API Url
      var url = 'https://jhapi.jahwa.co.kr/SelectList';

      // Send Parameter
      var data = {'Div': strDiv, 'Data' : strServer, 'EmpCode' : session["EmpCode"], 'Token' : session['Token']};

      if(strDiv == "AppPoolServer") {
        iisServerList.clear();
      }
      return await http.post(Uri.parse(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) async {
        //print("Result Version : ${response.body}, (${response.statusCode}) - " + DateTime.now().toString());
        if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ showMessageBox(context, 'Alert', 'Server List Data Error !!!'); }
        else if(response.statusCode == 200){
          if(jsonDecode(response.body)['Table'].length == 0) {
            showMessageBox(context, 'Alert', 'Data does not Exists!!!');
          }
          else {
            jsonDecode(response.body)['Table'].forEach((element) {
              Widget dropdownMenuItem = DropdownMenuItem(
                child: Container ( padding: EdgeInsets.all(0.0), child: Text(element['Name'], style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),),),
                value: element['Code'],
              );
              if(strDiv == "AppPoolServer") iisServerList.add(dropdownMenuItem);
            });
            setState(() {
              _isLoading = false;
            });
          }
        }
      });
    }
    catch (e) {
      showMessageBox(context, 'Alert', 'Preference Setting Error A : ' + e.toString());
    }
  }

  Future<void> recycleIIS(String strServer) async {

    try {

      // Login API Url
      var url = 'https://jhapi.jahwa.co.kr/JimsIISRecycle';

      // Send Parameter
      var data = {'Server': strServer, 'EmpCode' : session["EmpCode"]};

      return await http.post(Uri.parse(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) async {
        //print("Result Version : ${response.body}, (${response.statusCode}) - " + DateTime.now().toString());
        if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ showMessageBox(context, 'Alert', 'Server Info. Data Error !!!'); }
        else if(response.statusCode == 200){
          if(jsonDecode(response.body)['Table'].length == 0) {
            showMessageBox(context, 'Alert', 'Data does not Exists!!!');
          }
          else {
            jsonDecode(response.body)['Table'].forEach((element) {
              if(element["Code"] == "OKAY") showMessageBox(context, 'Information', "Schedule registration is complete.\nIIS Recycle will run in less than a minute.");
              else showMessageBox(context, 'Alert', element["Code"]);
            });
          }
        }
      });
    }
    catch (e) {
      showMessageBox(context, 'Alert', 'Preference Setting Error A : ' + e.toString());
    }
  }

  // Call When Form Init
  @override
  void initState() {
    makeDropdownItem('AppPoolServer', '');
    //makePageBody();
    super.initState();
    print("open JimsIISRecycle Page : " + DateTime.now().toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // For Keyboard UnFocus
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0xFF, 0x34, 0x40, 0x4E),
          title: Text("IIS Recycle",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),
          ),
        ),
        body: LoadingOverlay(
          isLoading: _isLoading,
          opacity: 0.5,
          color: Colors.grey,
          progressIndicator: CircularProgressIndicator(),
          child:  SingleChildScrollView(
            child: Container( // Dropdown Button
              width: screenWidth,
              height: screenHeight,
              alignment: Alignment.center,
              //padding: EdgeInsets.only(left:20.0, top:0.0, right:0.0, bottom: 10.0) ,
              child:  Column(
                children: <Widget> [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 15.0),
                    child: DropdownButton(
                        value: server,
                        items: iisServerList,
                        onChanged: (value) {
                          setState(() {
                            _serverName = value;
                            server = value;
                          });
                        }
                    ),
                  ),
                  ///SizedBox(height: 10,),
                  Container( // Login Button
                    width: screenWidth,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15.0),
                    child: ButtonTheme(
                      minWidth: screenWidth,
                      height: 40.0,
                      child: RaisedButton(
                        child:Text(translateText(context, 'IIS Recycle'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white,)),
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                        splashColor: Colors.grey,
                        onPressed: () async {
                          await recycleIIS(server);
                        },
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}

