import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';
import 'package:jahwa_mobile_working_center/util/globals.dart';
import 'package:jahwa_mobile_working_center/util/menu.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  /// Call When Form Init
  @override
  void initState() {
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async { await showNotification(message['notification']['title'], message['notification']['body']); },
      onLaunch: (Map<String, dynamic> message) async { await showNotification('onLaunch', message['notification']['body']); },
      onResume: (Map<String, dynamic> message) async { await showNotification('onResume', message['notification']['body']); },
    );
    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
    ///_firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) { print("Settings registered: $settings"); });
    ///_firebaseMessaging.getToken().then((String token) { assert(token != null); setState(() { _homeScreenText = "Push Messaging token: $token"; }); print(_homeScreenText); });

    print("open Index Page : " + DateTime.now().toString());
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
          title: Text('Jahwa Mobile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),),
        ),
        drawer: Container(
          width: screenWidth * 0.9,
          child: Menu(), /// Menu.dart 화면 호출
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container( // Main Area
                color: Color.fromARGB(0xFF, 0xE6, 0xE6, 0xE6),
                width: screenWidth,
                height: screenHeight - statusBarHeight - appBarHeigight,
                alignment: Alignment.center,
                child: Container( // Content Area
                  width: screenWidth - 20,
                  height: screenHeight - statusBarHeight - appBarHeigight - 20,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.all(10.0) ,
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                      icon: FaIcon(FontAwesomeIcons.codeBranch),
                                      iconSize: 50,
                                      color: Colors.blueAccent,
                                      onPressed: () {
                                        PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
                                          String version = packageInfo.version;
                                          showMessageBox(context, 'Alert', 'Program Version : ' + version);
                                          print(version);
                                        });
                                      }
                                  ),
                                  Text('Version', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.solidFileAlt),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                    onPressed: () { Navigator.pushNamed(context, '/FormWidget'); }
                                  ),
                                  Text('Form Widget', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.comments),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                      onPressed: () { Navigator.pushNamed(context, '/Notice'); }
                                  ),
                                  Text('View Notify', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.bolt),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                    onPressed: () async { showMessageBox(context, 'Alert', 'Action Test Button !!!');},
                                  ),
                                  Text('Action Test', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.bolt),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                    onPressed: () async { showMessageBox(context, 'Alert', 'Action Test Button !!!'); },
                                  ),
                                  Text('Action Test', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.bolt),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                    onPressed: () async { showMessageBox(context, 'Alert', 'Action Test Button !!!'); },
                                  ),
                                  Text('Action Test', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  decoration: BoxDecoration( // Container Box Design
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
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
