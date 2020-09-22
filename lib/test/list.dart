import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jahwa_mobile_working_center/util/common.dart';

import 'package:jahwa_mobile_working_center/util/globals.dart';
import 'package:jahwa_mobile_working_center/util/menu.dart';

class List extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {

  // Call When Form Init
  @override
  void initState() {
    super.initState();
    print("open List Page : " + DateTime.now().toString());
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
                child: Text('Just Text Container', style: TextStyle(color: Colors.white, fontSize: 20,)),
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
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => Menu()));
                          }
                      ),
                    ),
                    Container(
                      width: screenWidth - 100, // Index : 50, Exclude Index : 100
                      padding: EdgeInsets.all(10.0) ,
                      child: Text(
                        'Jahwa Mobile - List Page',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),
                      ),
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: FaIcon(FontAwesomeIcons.times),
                        color: Colors.white,
                        hoverColor: Colors.amber,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container( // Main Area
                color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
                width: screenWidth,
                alignment: Alignment.center,
                child : Column (
                  children: <Widget> [
                    Container(
                      width: screenWidth - 20,
                      padding: EdgeInsets.all(20.0) ,
                      alignment: Alignment.center,
                      child: Text(
                        'List Page',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, fontFamily: 'NanumBrush'),
                      ),
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
}