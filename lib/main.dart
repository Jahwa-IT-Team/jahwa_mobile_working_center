import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:jahwa_mobile_working_center/globals.dart';
import 'package:jahwa_mobile_working_center/program_list.dart';
import 'package:jahwa_mobile_working_center/util/common.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    preferenceSetting();
  }

  @override
  Widget build(BuildContext context) {
    print("open Main App : " + DateTime.now().toString());
    return MaterialApp(
      title: 'Jahwa Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'NanumPen',
      ),
      routes: routes,
    );
  }
}


