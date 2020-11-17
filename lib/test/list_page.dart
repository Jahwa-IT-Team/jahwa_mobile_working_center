import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:jahwa_mobile_working_center/util/common.dart';
import 'package:jahwa_mobile_working_center/util/globals.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  List<Card> cardList = new List<Card>();
  List<ButtonTheme> buttonList = new List<ButtonTheme>();
  int page = 1;

  makePageBody(String pageString) async {

    int totalCount = 0;
    int totalPage = 1;
    int page = int.parse(pageString);

    cardList.clear();
    buttonList.clear();

    try {

      // Login API Url
      var url = 'https://jhapi.jahwa.co.kr/GWMail';

      // Send Parameter
      var data = {'page': pageString, 'pagerowcount' : '10', 'empcode' : 'K20604007'};

      return await http.post(Uri.encodeFull(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) async {
        //print("Result Version : ${response.body}, (${response.statusCode}) - " + DateTime.now().toString());
        if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ showMessageBox(context, 'Alert', 'Check Version Data Error !!!'); }
        else if(response.statusCode == 200){
          jsonDecode(response.body)['Table'].forEach((element) {
            Widget card = Card(
              child: Row(
                children: <Widget> [
                  Container(
                    width: screenWidth * 0.1,
                    alignment: Alignment.center,
                    child: Text(element['Num'].toString(), style: TextStyle(fontSize: 25,),),
                  ),
                  Container(
                    width: screenWidth * 0.75,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Text(element['Subject'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                        SizedBox(height: 10, ),
                        Html(
                          data : element['Contents'],
                          style: {
                            "body" : Style(padding: EdgeInsets.all(0), margin: EdgeInsets.all(0),),
                          },
                        ),
                        SizedBox(height: 10, ),
                        Text('Sender : ' + element['Name'] + ', Sent : ' + element['InsDate'] + '', style: TextStyle(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.bold, ),),
                        SizedBox(height: 10, ),
                        Text('Receiver : ' + element['ToAddress'], style: TextStyle(color: Colors.green.shade400, fontSize: 14, fontWeight: FontWeight.bold, ),),
                      ],
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.1,
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget> [
                        FaIcon(FontAwesomeIcons.paperclip, color: Colors.blueAccent, size: 25,),
                        Text(element['Cnt'].toString(), style: TextStyle(color: Colors.blueAccent, fontSize: 25, fontWeight: FontWeight.bold, ),),
                      ],
                    ),
                  ),
                ],
              ),
            );
            cardList.add(card);
          });

          totalCount = jsonDecode(response.body)['Table1'][0]['TotalCount'];
          totalPage = 5;//(totalCount / 10).ceil();

          // Move to First
          Widget buttonTheme = ButtonTheme(
            minWidth: 0,
            height: 30.0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              child: RaisedButton(
                child:FaIcon(FontAwesomeIcons.angleDoubleLeft, color: Colors.white, size: 16,),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                splashColor: Colors.grey,
                onPressed: () async {
                  makePageBody('1');
                },
              ),
            ),
          );
          buttonList.add(buttonTheme);

          // Move to Page - 2, If Exists
          if(page >= 3) {
            buttonTheme = ButtonTheme(
              minWidth: 0,
              height: 30.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: RaisedButton(
                  child: FaIcon(FontAwesomeIcons.angleLeft, color: Colors.white, size: 16,),
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                  splashColor: Colors.grey,
                  onPressed: () async {
                    makePageBody((page - 2).toString());
                  },
                ),
              ),
            );
            buttonList.add(buttonTheme);
          }

          // From To Calculate
          int frPage = 1;
          int toPage = totalPage;

          if(page - 1 > 1) frPage = page - 1;
          if(page + 1 < totalPage) toPage = page + 1;
          if(toPage < 3 && totalPage > 2) toPage = 3;

          // Page Number
          for (int i = frPage; i <= toPage; i++) {
            buttonTheme = ButtonTheme(
              minWidth: 0,
              height: 30.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: RaisedButton(
                  child:Text(translateText(context, i.toString()), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white,)),
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                  splashColor: Colors.grey,
                  onPressed: () async {
                    makePageBody(i.toString());
                  },
                ),
              ),
            );
            buttonList.add(buttonTheme);
          }

          // Move to Page + 2, If Exists
          if(totalPage > toPage) {
            buttonTheme = ButtonTheme(
              minWidth: 0,
              height: 30.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: RaisedButton(
                  child: FaIcon(FontAwesomeIcons.angleRight, color: Colors.white, size: 16,),
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                  splashColor: Colors.grey,
                  onPressed: () async {
                    makePageBody((page + 2).toString());
                  },
                ),
              ),
            );
            buttonList.add(buttonTheme);
          }

          // Move to Last
          buttonTheme = ButtonTheme(
            minWidth: 0,
            height: 30.0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              child: RaisedButton(
                child: FaIcon(FontAwesomeIcons.angleDoubleRight, color: Colors.white, size: 16,),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                splashColor: Colors.grey,
                onPressed: () async {
                  makePageBody(totalPage.toString());
                },
              ),
            ),
          );
          buttonList.add(buttonTheme);

          setState(() {});
        }
      });
    }
    catch (e) {
      showMessageBox(context, 'Alert', 'makePageBody Error : ' + e.toString());
    }
  }

  // Call When Form Init
  @override
  void initState() {
    makePageBody(page.toString());
    super.initState();
    print("open Page List : " + DateTime.now().toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // For Keyboard UnFocus
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0xFF, 0x34, 0x40, 0x4E),
          title: Text(
            'Page List Design',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),
          ),
        ),
        body: SingleChildScrollView(
          child: Column (
            children: <Widget> [
              Container( // Main Area
                color: Color.fromARGB(0xFF, 0xE6, 0xE6, 0xE6),
                width: screenWidth,
                height: screenHeight - statusBarHeight - appBarHeigight - 50,
                alignment: Alignment.center,
                child: ListView(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: cardList,
                  ).toList(),
                ),
              ),
              Container (
                height: 50,
                width: screenWidth,
                alignment: Alignment.center,
                color: Color.fromARGB(0xFF, 0x4B, 0x56, 0x68),
                child : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  //padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Row(
                    children: buttonList.toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}