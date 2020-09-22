import 'package:flutter/material.dart';

import 'package:jahwa_mobile_working_center/check.dart';
import 'package:jahwa_mobile_working_center/login.dart';
import 'package:jahwa_mobile_working_center/index.dart';

import 'package:jahwa_mobile_working_center/mail/email_gw.dart';

import 'package:jahwa_mobile_working_center/test/design_page.dart';
import 'package:jahwa_mobile_working_center/test/form_widget.dart';
import 'package:jahwa_mobile_working_center/test/list.dart';
import 'package:jahwa_mobile_working_center/test/test.dart';

import 'package:jahwa_mobile_working_center/util/update.dart';

final routes = {
  '/' : (BuildContext context) => Check(),
  '/Update' : (BuildContext context) => Update(),
  '/Login' : (BuildContext context) => Login(),
  '/Index' : (BuildContext context) => Index(),

  '/EmailGW' : (BuildContext context) => EmailGW(),

  '/DesignPage' : (BuildContext context) => DesignPage(),
  '/FormWidget' : (BuildContext context) => FormWidget(),
  '/List' : (BuildContext context) => List(),
  '/Test' : (BuildContext context) => Test(),
};