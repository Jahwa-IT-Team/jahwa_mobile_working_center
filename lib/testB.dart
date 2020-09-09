import 'package:flutter/material.dart';

class TestB extends StatefulWidget {
  @override
  _TestBState createState() => _TestBState();
}

class _TestBState extends State<TestB> {

  TextEditingController empcodeController = new TextEditingController(); // Employee Number Data Controller
  FocusNode empcodeFocusNode = new FocusNode(); // Employee Input Number Focus

  @override
  Widget build(BuildContext context) {
    print("open Test A : " + DateTime.now().toString());
    return Scaffold(
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