import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:jahwa_mobile_working_center/globals.dart';
import 'package:jahwa_mobile_working_center/program_list.dart';

void main() {
  language = ui.window.locale.languageCode;
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("open Main App : " + DateTime.now().toString());
    return MaterialApp(
      title: 'Jahwa Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Malgun',
      ),
      routes: routes,
    );
  }
}


