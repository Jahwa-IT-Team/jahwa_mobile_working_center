import 'package:flutter/material.dart';

import 'package:jahwa_mobile_working_center/index.dart';
import 'package:jahwa_mobile_working_center/login.dart';
import 'package:jahwa_mobile_working_center/main_page.dart';
import 'package:jahwa_mobile_working_center/mail/mail_list.dart';

final routes = {
  '/' : (BuildContext context) => Index(),
  '/Index' : (BuildContext context) => Index(),
  '/MainPage' : (BuildContext context) => MainPage(),
  '/Login' : (BuildContext context) => Login(),
  '/MailList' : (BuildContext context) => MailList(),
};