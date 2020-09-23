import 'package:flutter/material.dart';

import 'package:jahwa_mobile_working_center/util/globals.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {

  // Call When Form Init
  @override
  void initState() {
    super.initState();
    print("open Test Page : " + DateTime.now().toString());
  }

  // Text Field
  TextEditingController empcodeController = new TextEditingController(); // Employee Number Data Controller
  FocusNode empcodeFocusNode = new FocusNode(); // Employee Input Number Focus

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0xFF, 0x34, 0x40, 0x4E),
        title: Text(
          'Test Page',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),
        ),
      ),
      body: SingleChildScrollView (
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
          child: TextField(
            autofocus: false,
            controller: empcodeController,
            focusNode: empcodeFocusNode,
            keyboardType: TextInputType.text,
            onSubmitted: (String inputText) {
              //FocusScope.of(context).requestFocus(passwordFocusNode);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Employee Number',
              contentPadding: EdgeInsets.all(10),  // Added this
            ),
            textInputAction: TextInputAction.next,
          ),
        ),
      ),
    );
  }
}