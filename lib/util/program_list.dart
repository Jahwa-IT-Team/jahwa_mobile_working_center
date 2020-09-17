import 'package:flutter/material.dart';

import 'package:jahwa_mobile_working_center/check.dart';
import 'package:jahwa_mobile_working_center/login.dart';
import 'package:jahwa_mobile_working_center/index.dart';

import 'package:jahwa_mobile_working_center/test/design_page.dart';
import 'package:jahwa_mobile_working_center/test/none_design_page.dart';
import 'package:jahwa_mobile_working_center/test/test.dart';

final routes = {
  '/' : (BuildContext context) => Check(),
  '/Login' : (BuildContext context) => Login(),
  '/Index' : (BuildContext context) => Index(),

  '/DesignPage' : (BuildContext context) => DesignPage(),
  '/NoneDesignPage' : (BuildContext context) => NoneDesignPage(),
  '/Test' : (BuildContext context) => Test(),
};