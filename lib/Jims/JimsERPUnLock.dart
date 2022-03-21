import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';
import 'package:jahwa_mobile_working_center/util/globals.dart';

class JimsERPUnLock extends StatefulWidget {
  @override
  _JimsERPUnLockState createState() => _JimsERPUnLockState();
}

class _JimsERPUnLockState extends State<JimsERPUnLock> {

  TextEditingController searchController = new TextEditingController(); /// Employee Number Data Controller
  FocusNode searchFocusNode = FocusNode(); /// Employee Number Input Focus

  List<Card> cardList = new List<Card>();
  List<Text> textList = new List<Text>();

  bool _isLoading = true;

  /// Call When Form Init
  @override
  void initState() {
    super.initState();
    print("open ERP UnLock Page : " + DateTime.now().toString());
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector( /// Keyboard UnFocus시를 위해 onTap에 GestureDetector를 위치시킴
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) { currentFocus.unfocus(); }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0xFF, 0x34, 0x40, 0x4E),
          title: Text('ERP UnLock', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container( // Main Area
                color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
                width: screenWidth,
                height: 50,
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Container( // Main Area
                      color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
                      width: screenWidth * 0.05,
                      alignment: Alignment.center,
                    ),
                    Container( // Main Area
                        color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
                        width: screenWidth * 0.63,
                        height: 40,
                        alignment: Alignment.center,
                        child: TextField(
                          autofocus: true,
                          controller: searchController,
                          keyboardType: TextInputType.text,
                          focusNode: searchFocusNode,
                          onSubmitted: (String inputText) async {
                            FocusScope.of(context).unfocus();
                            await makePageBody();
                          },
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                            contentPadding: EdgeInsets.only(bottom:10,),
                            labelText: translateText(context, 'Employee Number or Name'),
                          ),
                          textInputAction: TextInputAction.done,
                        )
                    ),
                    Container( // Main Area
                        color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
                        width: screenWidth * 0.32,
                        alignment: Alignment.center,
                        child: ButtonTheme(
                          ///minWidth: 100,
                          child: RaisedButton(
                            child:Text(translateText(context, 'Search'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white,)),
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                            splashColor: Colors.grey,
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              await makePageBody();
                            },
                          ),
                        )
                    ),
                  ],
                ),
              ),
              RefreshIndicator(
                onRefresh: makePageBody,
                child: Column(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: cardList,
                  ).toList(),
                ),
              ),
              /*Container( // Main Area
                color: Color.fromARGB(0xFF, 0xE6, 0xE6, 0xE6),
                width: screenWidth,
                height: (screenHeight - statusBarHeight - appBarHeigight) - 50,
                alignment: Alignment.center,
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePageBody() async {

    try {

      // Login API Url
      var url = 'https://jhapi.jahwa.co.kr/FindEmployee';

      // Send Parameter
      var data = {'EmpCode': searchController.text, 'Name' : searchController.text, 'EmpCode2': session['EmpCode'], 'Token' : session['Token']};

      return await http.post(Uri.parse(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) async {
        //print("Result Version : ${response.body}, (${response.statusCode}) - " + DateTime.now().toString());
        if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ showMessageBox(context, 'Alert', 'Server Info. Data Error !!!'); }
        else if(response.statusCode == 200){
          if(jsonDecode(response.body)['Table'].length == 0) {
            showMessageBox(context, 'Alert', 'Data does not Exists!!!');
          }
          else {
            cardList.clear();
            jsonDecode(response.body)['Table'].forEach((element) {
              Widget card = Card(
                child: new InkWell(
                  onTap: () async {
                    await showInformation(context, element['Code']);
                  },
                  child: Container(
                    width: screenWidth,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Text(element['Name'] + ' ' + element['Position'].toString() + ' (' + element['DeptName'] + ' ' + element['Title'] + ')', style: TextStyle(fontSize: 16,),),
                      ],
                    ),
                  ),
                ),
              );
              cardList.add(card);
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

  /// Show Message Box Function
  showInformation(BuildContext context, String code) async {

    try {

      var photo = "";

      // Login API Url
      var url = 'https://jhapi.jahwa.co.kr/EmpInformation';

      // Send Parameter
      var data = {'EmpCode': code, 'EmpCode2': session['EmpCode'], 'Token' : session['Token']};

      return await http.post(Uri.parse(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) async {
        if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ showMessageBox(context, 'Alert', 'Server Info. Data Error !!!'); }
        else if(response.statusCode == 200){
          if(jsonDecode(response.body)['Table'].length == 0) {
            showMessageBox(context, 'Alert', 'Data does not Exists!!!');
          }
          else {
            jsonDecode(response.body)['Table'].forEach((element) {
              /// set up the button
              Widget okButton = FlatButton(
                child: Text("Okay", style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,), ),
                onPressed: () {Navigator.of(context).pop();},
              );

              if(element['Photo'] == "") photo = 'https://gw.jahwa.co.kr/Common/Image/pics.gif';
              else photo = 'https://gw.jahwa.co.kr/Photo/' + element['Photo'];

              /// set up the AlertDialog
              AlertDialog alert = AlertDialog(
                title: Text(element['DeptName'] + ' ' + element['Name'] + ' ' + element['Position'] + ' (' + element['Title'] + ')', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,)),
                content: new SingleChildScrollView(
                  padding: EdgeInsets.all(0),
                  child: new ListBody(
                    children: <Widget>[
                      SizedBox(height: 16,),
                      Container(
                        width: 200.0,
                        height: 200.0,
                        decoration: BoxDecoration(
                          border: Border.all(color:Colors.white, width: 2, style: BorderStyle.solid,),
                          image: DecorationImage(
                              image: NetworkImage(photo,)),
                        ),
                      ),
                      SizedBox(height: 16,),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 30,
                        child: FlatButton(
                          onPressed: () => launch("tel://" + element['OfficeTel']),
                          child: Text('사번 : ' + element['EmpCode'], style: TextStyle(fontSize: 14,)),
                          padding: EdgeInsets.only(left: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                contentPadding: EdgeInsets.all(0),
                titleTextStyle: TextStyle(fontFamily: "Malgun", color: Colors.black, fontWeight: FontWeight.bold,),
                contentTextStyle: TextStyle(fontFamily: "Malgun", color: Colors.black,),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        unlockERP(context, element['EmpCode']);
                        /// Navigator.of(context).pop();
                      },
                      child: Text('UnLock', style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent, fontWeight: FontWeight.bold,)),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close', style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,)),
                  ),
                ],
              );

              /// show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) { return alert; },
              );
            });
          }
        }
      });
    }
    catch (e) {
      showMessageBox(context, 'Alert', 'Preference Setting Error A : ' + e.toString());
    }
  }

  /// Show Message Box Function
  unlockERP(BuildContext context, String code) async {

    try {

      var photo = "";

      // Login API Url
      var url = 'https://jhapi.jahwa.co.kr/JimsERPUnLock';

      // Send Parameter
      var data = {'EmpCode': code, 'EmpCode2': session['EmpCode'], 'Token' : session['Token']};

      return await http.post(Uri.parse(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) async {
        if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ showMessageBox(context, 'Alert', 'ERP UnLock Error !!!'); }
        else if(response.statusCode == 200){
          if(jsonDecode(response.body)['Table'].length == 0) {
            showMessageBox(context, 'Alert', 'Data does not Exists!!!');
          }
          else {
            jsonDecode(response.body)['Table'].forEach((element) {
              /// set up the button
              Widget okButton = FlatButton(
                child: Text("Okay", style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,), ),
                onPressed: () {Navigator.of(context).pop();},
              );

              var Message = 'OKAY';
              if(element['Code'] == 'OKAY') Message = 'UnLock Completed';
              else Message = element['Code'];

              /// set up the AlertDialog
              AlertDialog alert = AlertDialog(
                content: new SingleChildScrollView(
                  padding: EdgeInsets.all(30),
                  child: new ListBody(
                    children: <Widget>[
                      Text(Message, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,)),
                    ],
                  ),
                ),
                contentPadding: EdgeInsets.all(0),
                titleTextStyle: TextStyle(fontFamily: "Malgun", color: Colors.black, fontWeight: FontWeight.bold,),
                contentTextStyle: TextStyle(fontFamily: "Malgun", color: Colors.black,),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close', style: TextStyle(fontFamily: "Malgun", color: Colors.blueAccent,)),
                  ),
                ],
              );

              /// show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) { return alert; },
              );
            });
          }
        }
      });
    }
    catch (e) {
      showMessageBox(context, 'Alert', 'ERP UnLock Error : ' + e.toString());
    }
  }
}
