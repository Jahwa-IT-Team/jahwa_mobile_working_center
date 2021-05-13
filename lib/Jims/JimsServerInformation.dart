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
var serverdata = {};
var serverlist = { "Table" : [ { "Code" : "KRAPPD", "Name" : "KRAPPD" }] };

class JimsServerInformation extends StatefulWidget {
  @override
  _JimsServerInformationState createState() => _JimsServerInformationState();
}

class _JimsServerInformationState extends State<JimsServerInformation> {

  List<Card> cardList = new List<Card>();
  List<Text> textList = new List<Text>();
  List<DropdownMenuItem> itemsList = [];

  bool _isLoading = true;
  String _serverName = "KRAPPD";

  Future<void> makeDropdownItem() async {
    try {

      // Login API Url
      var url = 'https://jhapi.jahwa.co.kr/SelectList';

      // Send Parameter
      var data = {'Div': 'Server', 'Data' : '', 'EmpCode' : ''};

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
                child: Container ( padding: EdgeInsets.all(0.0), child: Text(element['Name'], style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),),),
                value: element['Code'],
              );
              itemsList.add(dropdownMenuItem);
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

  Future<void> makePageBody() async {

    try {

      // Login API Url
      var url = 'https://jhapi.jahwa.co.kr/JimsServerInformation';

      // Send Parameter
      var data = {'Server': _serverName};

      return await http.post(Uri.parse(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) async {
        //print("Result Version : ${response.body}, (${response.statusCode}) - " + DateTime.now().toString());
        if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ showMessageBox(context, 'Alert', 'Server Info. Data Error !!!'); }
        else if(response.statusCode == 200){
          if(jsonDecode(response.body)['Table'].length == 0) {
            showMessageBox(context, 'Alert', 'Data does not Exists!!!');
          }
          else {
            cardList.clear();
            /// CPU & OS, Memory Information
            jsonDecode(response.body)['Table1'].forEach((element) {
              Widget card = Card(
                child: Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Text('CPU Info. : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),),
                      Text(' - ' + element['CPUInfo'], style: TextStyle(fontSize: 12,),),
                      Text('OS Info. : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),),
                      Text(' - ' + element['OSInfo'], style: TextStyle(fontSize: 12,),),
                      Text('Others Info. : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),),
                      Text(' - Total Memory : ' + element['MemoryTotalG'].toString() + ' Gbyte, Last Gather : ' + element['LastGather'], style: TextStyle(fontSize: 12,),),
                    ],
                  ),
                ),
              );
              cardList.add(card);
            });
            /// Network Information
            if(jsonDecode(response.body)['Table2'].length > 0) {
              textList.clear();
              textList.add(Text('Network Info. : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),));
              jsonDecode(response.body)['Table2'].forEach((element) {
                textList.add(Text(' - IP : ' + element['Ip'] + ', MAC : ' + element['MAC'], style: TextStyle(fontSize: 12,),));
              });
              Widget card = Card(
                child: Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: textList,
                    ).toList(),
                  ),
                ),
              );
              cardList.add(card);
            }
            /// DB Information
            if(jsonDecode(response.body)['Table3'].length > 0) {
              String ver = '';
              String lastGather = '';

              textList.clear();
              textList.add(Text('Database Info. : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),));
              jsonDecode(response.body)['Table3'].forEach((element) {
                textList.add(Text(' ' + element['DBName'] + ' - Data : ' + element['DataSize'].toString() + 'Gb, Log : ' + element['LogSize'].toString() + 'Gb, Log Rate : ' + element['LogRate'].toString() + '%', style: TextStyle(fontSize: 12,),));
                ver = element['DBVer'].toString();
                lastGather = element['LastGather'];
              });
              textList.add(Text(' - Ver : ' + ver + ', Last Gather : ' + lastGather, style: TextStyle(fontSize: 12,),));
              Widget card = Card(
                child: Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: textList,
                    ).toList(),
                  ),
                ),
              );
              cardList.add(card);
            }
            /// Disk Information
            if(jsonDecode(response.body)['Table4'].length > 0) {
              textList.clear();
              textList.add(Text('Disk Info. : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),));
              jsonDecode(response.body)['Table4'].forEach((element) {
                textList.add(Text(' ' + element['DiskName'] + ' Drive - Total : ' + element['DiskTotal'].toString() + 'Gb, UnUse : ' + element['DiskUnUse'].toString() + 'Gb, Usage : ' + element['DiskUsage'].toString() + '%', style: TextStyle(fontSize: 12,),));
              });
              Widget card = Card(
                child: Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: textList,
                    ).toList(),
                  ),
                ),
              );
              cardList.add(card);
            }
            /// Version Information
            jsonDecode(response.body)['Table5'].forEach((element) {
              Widget card = Card(
                child: Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Text('Service Version Info. : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),),
                      Text(' - Local : ' + element['VService'] + ', Server : ' + element['VerService'], style: TextStyle(fontSize: 12,),),
                      Text('Updater Version Info. : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),),
                      Text(' - Local : ' + element['VUpdater'] + ', Server : ' + element['VerUpdater'], style: TextStyle(fontSize: 12,),),
                    ],
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

  // Call When Form Init
  @override
  void initState() {
    makeDropdownItem();
    makePageBody();
    super.initState();
    print("open JimsServerInformation Page : " + DateTime.now().toString());
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
          title: Text("Server Info : " + _serverName,
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
              ///height: screenHeight,
              alignment: Alignment.topLeft,
              //padding: EdgeInsets.only(left:20.0, top:0.0, right:0.0, bottom: 10.0) ,
              child: Column(
                children: <Widget> [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 15.0),
                    child: DropdownButton(
                      value: server,
                      items: itemsList,
                      onChanged: (value) {
                        setState(() {
                          _serverName = value;
                          server = value;
                          makePageBody();
                        });
                      }
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
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}

