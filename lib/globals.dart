import 'dart:ui' as ui;

// Language
var language = ui.window.locale.languageCode; // Language
var languagedata = {};
var languagelist = { "LangList" : [ { "Lang" : "Korean", "LangCode" : "ko" }, { "Lang" : "Vietnamese", "LangCode" : "vi" }, { "Lang" : "Chinese", "LangCode" : "zh" }, { "Lang" : "English", "LangCode" : "en" } ] };

// Session
var session = {
  'EntCode' : '', 'EntName' : '',
  'DeptCode' : '', 'DeptName' : '',
  'EmpCode' : '', 'Name' : '',
  'RollPstn' : '', 'Position' : '',
  'Role' : '', 'Title' : '',
  'PayGrade' : '', 'Level' : '',
  'Email' : '', 'Photo' : '',
  'Auth' : "0", 'EntGroup' : '',
  'OfficeTel' : '', 'Mobile' : '',
  'DueDate' : ''
};

// Screen Size
var screenWidth = 100.0;
var screenHeight = 100.0;
var statusBarHeight = 24.0;