import 'package:flutter/material.dart';

import 'package:cron/cron.dart';
import 'package:intl/intl.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';
import 'package:jahwa_mobile_working_center/util/program_list.dart';

void main() {
  runApp(MainApp());

  /// Background Execution - Cron Package
  ///var cron = new Cron();
  ///cron.schedule(new Schedule.parse('*/10 * * * *'), () async {
    ///print(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()) + ' : Execution every 10 minutes');
    ///await showNotification('Notification', DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()) + ' : Notification Test !!!');
  ///});

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