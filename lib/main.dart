import 'package:flutter/material.dart';
import 'package:jahwa_mobile_working_center/util/program_list.dart';

void main() {
  runApp(MainApp());
  print("open Main App : " + DateTime.now().toString());
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