import 'package:flutter/material.dart';

import 'package:cron/cron.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:intl/intl.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';
import 'package:jahwa_mobile_working_center/util/program_list.dart';

void main() {

  /// Flutter Background Service
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService.initialize(onStart); /// onStart Fuinction은 common.dart에 설정됨

  runApp(MainApp());

  /// Background Execution - Cron Package, 정기적으로 필요한 메세지를 생성하여 알림을 처리할 예정
  ///var cron = new Cron();
  ///cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
    ///print(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()) + ' : Execution every 1 minutes');
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
        fontFamily: 'Malgun', /// Custom Font 사용, pubspec.yaml에 정의된 Font
      ),
      routes: routes, /// program_list.dart에 정의된 주소를 기반으로 이동을 진행함
    );
  }
}