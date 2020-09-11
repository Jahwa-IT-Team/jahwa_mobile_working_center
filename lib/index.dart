import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:jahwa_mobile_working_center/globals.dart';
import 'package:jahwa_mobile_working_center/util/common.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  // Call When Form Init
  @override
  void initState() {
    super.initState();
    print("open Index Page : " + DateTime.now().toString());
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width; // Screen Width
    screenHeight = MediaQuery.of(context).size.height; // Screen Height
    statusBarHeight = MediaQuery.of(context).padding.top;

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
              Container( // Menu Area - Menu List Button + Menu Name + Close Button -> Index has not Close Button
                height: 50,
                alignment: Alignment.centerLeft,
                width: screenWidth,
                color: Color.fromARGB(0xFF, 0x34, 0x40, 0x4E),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child : IconButton(
                          icon: FaIcon(FontAwesomeIcons.bars),
                          color: Colors.white,
                          onPressed: () { print("Index Page - Menu List !!!"); }
                      ),
                    ),
                    Container(
                      width: screenWidth - 100, // Index : 50, Exclude Index : 100
                      padding: EdgeInsets.all(10.0) ,
                      child: Text(
                        'Jahwa Mobile - Index Page : ' + session['Name'] + ' ' + session['Position'],
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 23,),
                      ),
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: FaIcon(FontAwesomeIcons.signOutAlt),
                        color: Colors.white,
                        hoverColor: Colors.amber,
                        onPressed: () {
                          removeUserSharedPreferences();
                          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container( // Main Area
                color: Color.fromARGB(0xFF, 0xE6, 0xE6, 0xE6),
                width: screenWidth,
                height: screenHeight - statusBarHeight - 50,
                alignment: Alignment.center,
                child: Container( // Content Area
                  //color: Colors.white,
                  width: screenWidth - 20,
                  height: screenHeight - statusBarHeight - 70,
                  alignment: Alignment.center,
                  child : Column (
                    children: <Widget> [
                      Container(
                        height: 50,
                      ),
                      IconButton(
                          icon: FaIcon(FontAwesomeIcons.solidFileAlt),
                          iconSize: 50,
                          hoverColor: Colors.amber,
                          color: Colors.blueAccent,
                          onPressed: () {
                            Navigator.pushNamed(context, '/MainPage');
                          }
                      ),
                      Container(
                        height: 50,
                      ),
                      IconButton(
                          icon: FaIcon(FontAwesomeIcons.mailBulk),
                          iconSize: 50,
                          hoverColor: Colors.amber,
                          color: Colors.blueAccent,
                          onPressed: () { Navigator.pushNamed(context, '/MailList'); }
                      ),
                      Container(
                        height: 50,
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