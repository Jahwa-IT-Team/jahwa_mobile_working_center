import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jahwa_mobile_working_center/util/common.dart';

import 'package:jahwa_mobile_working_center/util/globals.dart';
import 'package:jahwa_mobile_working_center/util/menu.dart';

class NoneDesignPage extends StatefulWidget {
  @override
  _NoneDesignPageState createState() => _NoneDesignPageState();
}

class _NoneDesignPageState extends State<NoneDesignPage> {

  // Call When Form Init
  @override
  void initState() {
    print("open None Design Page : " + DateTime.now().toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width; // Screen Width
    screenHeight = MediaQuery.of(context).size.height; // Screen Height
    statusBarHeight = MediaQuery.of(context).padding.top;

    var languagename = '';

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
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => Menu()));
                          }
                      ),
                    ),
                    Container(
                      width: screenWidth - 100, // Index : 50, Exclude Index : 100
                      padding: EdgeInsets.all(10.0) ,
                      child: Text(
                        'Jahwa Mobile - None Design Page',
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
                height: screenHeight - statusBarHeight - 50,
                alignment: Alignment.center,
                child : Column (
                  children: <Widget> [
                    Container(
                      width: screenWidth - 20,
                      padding: EdgeInsets.all(20.0) ,
                      alignment: Alignment.center,
                      child: Text(
                        'None Design Page',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, fontFamily: 'NanumBrush'),
                      ),
                    ),
                    Container( // Language
                      width: screenWidth,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 50.0) ,
                      child: Row (
                        children: <Widget> [
                          IconButton(
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
                                    children: makeDialogItems(context, 'LanguageTest', languagelist, language, languagename),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(width: 20,),
                          Text('Click For Change Language'),
                        ],
                      ),
                    ),
                    Container( // Language
                      width: screenWidth,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 50.0) ,
                      child: Row (
                        children: <Widget> [
                          DropdownButton(
                          value: language,
                          items: makeDropdownMenuItem(context, 'LanguageTest', languagelist, language, languagename),
                          onChanged: (value) {
                            setState(() {
                              language = value;
                              showMessageBox(context, languagename);
                            });
                          }),
                          SizedBox(width: 20,),
                          Text('Click For Change Language'),
                        ],
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