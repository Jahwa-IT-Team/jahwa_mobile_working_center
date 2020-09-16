import 'package:flutter/material.dart';

import 'package:jahwa_mobile_working_center/check.dart';
import 'package:jahwa_mobile_working_center/login.dart';
import 'package:jahwa_mobile_working_center/index.dart';

import 'package:jahwa_mobile_working_center/mail/mail_list.dart';

import 'package:jahwa_mobile_working_center/test/main_page.dart';
import 'package:jahwa_mobile_working_center/test/test.dart';

final routes = {
  '/' : (BuildContext context) => Check(),
  '/Login' : (BuildContext context) => Login(),
  '/Index' : (BuildContext context) => Index(),

  '/MainPage' : (BuildContext context) => MainPage(),
  '/MailList' : (BuildContext context) => MailList(),
  '/Test' : (BuildContext context) => Test(),
};