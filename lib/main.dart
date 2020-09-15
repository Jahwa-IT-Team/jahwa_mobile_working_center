import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/sqlite3.dart' as Sqlite3;

import 'package:jahwa_mobile_working_center/util/globals.dart';
import 'package:jahwa_mobile_working_center/util/program_list.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    SQLiteProcess();
    preferenceSetting(); // Make Session And Language Data
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("open Main App : " + DateTime.now().toString());
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

// Make Session And Language Data
Future<bool> preferenceSetting() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try{
    session['EntCode'] = prefs.getString('EntCode') ?? '';
    session['EntName'] = prefs.getString('EntName') ?? '';
    session['DeptCode'] = prefs.getString('DeptCode') ?? '';
    session['DeptName'] = prefs.getString('DeptName') ?? '';
    session['EmpCode'] = prefs.getString('EmpCode') ?? '';
    session['Name'] = prefs.getString('Name') ?? '';
    session['RollPstn'] = prefs.getString('RollPstn') ?? '';
    session['Position'] = prefs.getString('Position') ?? '';
    session['Role'] = prefs.getString('Role') ?? '';
    session['Title'] = prefs.getString('Title') ?? '';
    session['PayGrade'] = prefs.getString('PayGrade') ?? '';
    session['Level'] = prefs.getString('Level') ?? '';
    session['Email'] = prefs.getString('Email') ?? '';
    session['Photo'] = prefs.getString('Photo') ?? '';
    session['Auth'] = prefs.getInt('Auth').toString() ?? '0';
    session['EntGroup'] = prefs.getString('EntGroup') ?? '';
    session['OfficeTel'] = prefs.getString('OfficeTel') ?? '';
    session['Mobile'] = prefs.getString('Mobile') ?? '';
    session['DueDate'] = prefs.getString('DueDate') ?? '';

    language = prefs.getString('Language') ?? ui.window.locale.languageCode;
    languagedata = jsonDecode(prefs.getString('LanguageData') ?? '{}');

    if(await prefs.setString('LanguageData', await rootBundle.loadString("assets/lang/" + language + ".json"))){
      if((prefs.getString('LanguageData') ?? '') == '') languagedata = jsonDecode(await rootBundle.loadString("assets/lang/" + language + ".json"));
      else languagedata = jsonDecode(prefs.getString('LanguageData'));
    }

    if(session['EmpCode'] != '') getMenu(); // Make Menu Data to menudata
    return true;
  }
  catch (e){
    print("preferenceSetting Error : " + e.toString());
    return false;
  }
}

// Make Menu Data to menudata
Future<bool> getMenu() async {
  //print("exec getMenu : " + DateTime.now().toString());
  try {
    // Login API Url
    var url = 'https://jhapi.jahwa.co.kr/Menu';

    // Send Parameter
    var data = {'lang': session['Language'], 'category' : 'JHMobile', 'entgroup' : session['EntGroup'], 'entcode' : session['EntCode'], 'empcode' : session['EmpCode'], 'auth' : session['Auth']};

    return await http.post(Uri.encodeFull(url), body: json.encode(data), headers: {"Content-Type": "application/json"})
      .timeout(const Duration(seconds: 15))
      .then<bool>((http.Response response) {
        //print("Result getMenu : ${response.body}, (${response.statusCode}) - " + DateTime.now().toString());
        if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ return false; }
        if(response.statusCode == 200){
          menudata = jsonDecode(response.body);
          return true;
        }
        else{ return false; }
      }
    );
  }
  catch (e) {
    print("getMenu Error : " + e.toString());
    return false;
  }
}

void SQLiteProcess() {

  print('Using sqlite3 ${Sqlite3.sqlite3.version}');

  final db = Sqlite3.sqlite3.openInMemory();

  // Create a table and insert some data
  db.execute('''
    CREATE TABLE artists (
      id INTEGER NOT NULL PRIMARY KEY,
      name TEXT NOT NULL
    );
  ''');

  // Prepare a statement to run it multiple times:
  final stmt = db.prepare('INSERT INTO artists (name) VALUES (?)');
  stmt
    ..execute(['The Beatles'])
    ..execute(['Led Zeppelin'])
    ..execute(['The Who'])
    ..execute(['Nirvana']);

  // Dispose a statement when you don't need it anymore to clean up resources.
  stmt.dispose();

  // You can run select statements with PreparedStatement.select, or directly
  // on the database:
  final Sqlite3.ResultSet resultSet =
  db.select('SELECT * FROM artists WHERE name LIKE ?', ['The %']);

  // You can iterate on the result set in multiple ways to retrieve Row objects
  // one by one.
  resultSet.forEach((element) {
    print(element);
  });
  for (final Sqlite3.Row row in resultSet) {
    print('Artist[id: ${row['id']}, name: ${row['name']}]');
  }

  // Register a custom function we can invoke from sql:
  db.createFunction(
    functionName: 'dart_version',
    argumentCount: const Sqlite3.AllowedArgumentCount(0),
    function: (args) => Platform.version,
  );
  print(db.select('SELECT dart_version()'));

  // Don't forget to dispose the database to avoid memory leaks
  db.dispose();
}