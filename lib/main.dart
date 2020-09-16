import 'package:flutter/material.dart';
import 'package:jahwa_mobile_working_center/util/program_list.dart';

void main() {
  print("open Main App : " + DateTime.now().toString());
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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