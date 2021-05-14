import 'package:flutter/material.dart';

import 'package:jahwa_mobile_working_center/check.dart';
import 'package:jahwa_mobile_working_center/login.dart';
import 'package:jahwa_mobile_working_center/notice.dart';
import 'package:jahwa_mobile_working_center/index.dart';

import 'package:jahwa_mobile_working_center/Jims/JimsPasswordReset.dart';
import 'package:jahwa_mobile_working_center/Jims/JimsEmployeeInfo.dart';
import 'package:jahwa_mobile_working_center/Jims/JimsGatheringInformation.dart';
import 'package:jahwa_mobile_working_center/Jims/JimsServerInformation.dart';
import 'package:jahwa_mobile_working_center/Jims/JimsUsageTop.dart';
import 'package:jahwa_mobile_working_center/Jims/JimsAppPoolRecycle.dart';
import 'package:jahwa_mobile_working_center/Jims/JimsChartSample.dart';

import 'package:jahwa_mobile_working_center/mail/email_gw.dart';

import 'package:jahwa_mobile_working_center/test/design_page.dart';
import 'package:jahwa_mobile_working_center/test/form_widget.dart';
import 'package:jahwa_mobile_working_center/test/list_page.dart';
import 'package:jahwa_mobile_working_center/test/list_scroll.dart';
import 'package:jahwa_mobile_working_center/test/test.dart';

import 'package:jahwa_mobile_working_center/util/update.dart';
import 'package:jahwa_mobile_working_center/util/check_employee.dart';
import 'package:jahwa_mobile_working_center/util/reset_password.dart';
import 'package:jahwa_mobile_working_center/util/reset_password_question.dart';
import 'package:jahwa_mobile_working_center/util/reset_password_mobile.dart';

final routes = {
  /// Basic Program
  '/' : (BuildContext context) => Check(), /// 기본으로 main -> check -> update, login or index page로 이동
  '/Update' : (BuildContext context) => Update(), /// Android Update Apk Download Page로 이동, IOS 미지원
  '/Login' : (BuildContext context) => Login(),
  '/Notice' : (BuildContext context) => Notice(),
  '/Index' : (BuildContext context) => Index(), /// 기본 Page -> 설계 필요

  '/CheckEmployee' : (BuildContext context) => CheckEmployee(), /// 사원확인
  '/ResetPassword' : (BuildContext context) => ResetPassword(), /// 비밀번호 초기화 관리자용
  '/ResetPasswordQuestion' : (BuildContext context) => ResetPasswordQuestion(), /// 비밀번호 초기화 질문답변 인증용
  '/ResetPasswordMobile' : (BuildContext context) => ResetPasswordMobile(), /// 비밀번호 초기화 휴대폰 인증용

  /// Email
  '/EmailGW' : (BuildContext context) => EmailGW(),

  /// JIMS
  '/JimsPasswordReset' : (BuildContext context) => JimsPasswordReset(),
  '/JimsEmployeeInfo' : (BuildContext context) => JimsEmployeeInfo(),
  '/JimsGatheringInformation' : (BuildContext context) => JimsGatheringInformation(),
  '/JimsServerInformation' : (BuildContext context) => JimsServerInformation(),
  '/JimsUsageTop' : (BuildContext context) => JimsUsageTop(),
  '/JimsAppPoolRecycle' : (BuildContext context) => JimsAppPoolRecycle(),
  '/JimsChartSample' : (BuildContext context) => JimsChartSample(),

  /// Sample
  '/StandardDesign' : (BuildContext context) => StandardDesign(),
  '/FormWidget' : (BuildContext context) => FormWidget(),
  '/ListPage' : (BuildContext context) => ListPage(),
  '/ListScroll' : (BuildContext context) => ListScroll(),
  '/Test' : (BuildContext context) => Test(),
};