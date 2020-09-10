import 'package:flutter/material.dart';

import 'package:jahwa_mobile_working_center/index.dart';
import 'package:jahwa_mobile_working_center/login.dart';

import 'package:jahwa_mobile_working_center/test.dart';

import 'package:jahwa_mobile_working_center/main_page.dart';
import 'package:jahwa_mobile_working_center/mail/mail_list.dart';

final routes = {
  '/' : (BuildContext context) => Login(),
  '/Index' : (BuildContext context) => Index(),
  '/Login' : (BuildContext context) => Login(),
  '/Test' : (BuildContext context) => Test(),

  '/MainPage' : (BuildContext context) => MainPage(),
  '/MailList' : (BuildContext context) => MailList(),
};