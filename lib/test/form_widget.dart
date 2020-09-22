import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jahwa_mobile_working_center/util/common.dart';

import 'package:jahwa_mobile_working_center/util/globals.dart';
import 'package:jahwa_mobile_working_center/util/menu.dart';

class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {

  // Call When Form Init
  @override
  void initState() {
    super.initState();
    print("open Form Widget Page : " + DateTime.now().toString());
  }

  // Check Box
  bool _isKorenChecked = false;
  bool _isVietnameseChecked = false;

  // Radio Button
  String _groupValue = 'ko';

  // TextField
  TextEditingController empcodeController = new TextEditingController(); // Employee Number Data Controller
  TextEditingController passwordController = new TextEditingController(); // Password Data Controller
  FocusNode empcodeFocusNode = FocusNode(); // Employee Input Number Focus
  FocusNode passwordFocusNode = FocusNode(); // Password Input Focus
  FocusNode loginFocusNode = FocusNode(); // Login Button Focus

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
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => Menu()));
                          }
                      ),
                    ),
                    Container(
                      width: screenWidth - 100, // Index : 50, Exclude Index : 100
                      padding: EdgeInsets.all(10.0) ,
                      child: Text(
                        'Jahwa Mobile - Form Widget Page',
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
                        'Form Widget Page',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, fontFamily: 'NanumBrush'),
                      ),
                    ),
                    Container( // Icon Button And Simple Dialog
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
                                    children: makeDialogItems(context, 'Language', languagelist, language),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(width: 20,),
                          Text(' : Icon Button And Simple Dialog'),
                        ],
                      ),
                    ),
                    Container( // Dropdown Button
                      width: screenWidth,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 50.0) ,
                      child: Row (
                        children: <Widget> [
                          DropdownButton(
                          value: language,
                          items: makeDropdownMenuItem(context, 'LanguageTest', languagelist, language),
                          onChanged: (value) {
                            setState(() {
                              print(value);
                              language = value;
                              showMessageBox(context, value);
                            });
                          }),
                          SizedBox(width: 20,),
                          Text(': Dropdown Button'),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container( // Check Box
                      width: screenWidth,
                      height: 30,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 50.0, right: 50.0, ) ,
                      child: Text(translateText(context, 'Check Box'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16,),),
                    ),
                    Container( // Language
                      width: screenWidth,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 50.0, right: 50.0, ) ,
                      child: Column(
                        children: <Widget> [
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                            child: CheckboxListTile(
                              title: const Text('Korean'),
                              subtitle: const Text('Korean Check Box'),
                              secondary: const FaIcon(FontAwesomeIcons.language),
                              activeColor: Colors.blueAccent,
                              checkColor: Colors.white,
                              selected: _isKorenChecked,
                              value: _isKorenChecked,
                              onChanged: (bool value) {
                                setState(() {
                                  _isKorenChecked = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                            child: CheckboxListTile(
                              title: const Text('Vietnamese'),
                              subtitle: const Text('Vietnamese Check Box'),
                              secondary: const FaIcon(FontAwesomeIcons.language),
                              activeColor: Colors.blueAccent,
                              checkColor: Colors.white,
                              selected: _isVietnameseChecked,
                              value: _isVietnameseChecked,
                              onChanged: (bool value) {
                                setState(() {
                                  _isVietnameseChecked = value;
                                });
                              },
                            ),
                          ),
                        ]
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container( // Radio Button
                      width: screenWidth,
                      height: 30,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 50.0, right: 50.0, ) ,
                      child: Text(translateText(context, 'Radio Button'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16,),),
                    ),
                    Container( // Radio Button
                      width: screenWidth,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 50.0) ,
                      child: Column(
                        children: <Widget> [
                          RadioListTile(
                            title: Text('Korean', style: _groupValue == 'ko' ? TextStyle(color:Colors.blueAccent) : TextStyle(color:Colors.black)),
                            value: 'ko',
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value;
                                showMessageBox(context, value);
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text('Vietnamese', style: _groupValue == 'vi' ? TextStyle(color:Colors.blueAccent) : TextStyle(color:Colors.black)),
                            value: 'vi',
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value;
                                showMessageBox(context, value);
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text('Chinese', style: _groupValue == 'zh' ? TextStyle(color:Colors.blueAccent) : TextStyle(color:Colors.black)),
                            value: 'zh',
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value;
                                showMessageBox(context, value);
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text('English', style: _groupValue == 'en' ? TextStyle(color:Colors.blueAccent) : TextStyle(color:Colors.black)),
                            value: 'en',
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value;
                                showMessageBox(context, value);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container( // Text Filed
                      width: screenWidth,
                      height: 30,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 50.0, right: 50.0, ) ,
                      child: Text(translateText(context, 'Text Filed'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16,),),
                    ),
                    Container( // Text Filed
                      width: screenWidth,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 50.0) ,
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
                              contentPadding: EdgeInsets.all(10),  // Added this
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
                              showMessageBox(context, 'Submit Clicked on Password!!');
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
                              contentPadding: EdgeInsets.all(10),  // Added this
                            ),
                            textInputAction: TextInputAction.done,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container( // Button
                      width: screenWidth,
                      height: 30,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 50.0, right: 50.0, ) ,
                      child: Text(translateText(context, 'Button'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16,),),
                    ),
                    Container( // Button
                      width: screenWidth,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 50.0) ,
                      child: Column(
                        children: <Widget> [
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 50.0,
                            child: FlatButton(
                              onPressed: () {
                                showMessageBox(context, 'Flat Button Clicked!!!'); // To be developed later.
                              },
                              child: Text(
                                translateText(context, 'Flat Button'),
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14, ),
                              ),
                            ),
                          ),
                          Container( // Login Button
                            width: screenWidth,
                            alignment: Alignment.topCenter,
                            child: ButtonTheme(
                              minWidth: screenWidth,
                              height: 50.0,
                              child: RaisedButton(
                                focusNode: loginFocusNode,
                                child:Text(translateText(context, 'Raised Button'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white,)),
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                splashColor: Colors.grey,
                                onPressed: () async {
                                  showMessageBox(context, 'Raised Button Clicked!!!');
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 50,),
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