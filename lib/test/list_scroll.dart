import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:jahwa_mobile_working_center/util/common.dart';
import 'package:jahwa_mobile_working_center/util/globals.dart';

class ListScroll extends StatefulWidget {
  @override
  _ListScrollState createState() => _ListScrollState();
}

class _ListScrollState extends State<ListScroll> {

  List<Card> cardList = new List<Card>();
  ScrollController _controller;

  int page = 1;

  makeScrollBody(String pageString) async {

    try {

      // Login API Url
      var url = 'https://jhapi.jahwa.co.kr/GWMail';

      // Send Parameter
      var data = {'page': pageString, 'pagerowcount' : '10', 'empcode' : 'K20604007'};

      return await http.post(Uri.encodeFull(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) async {
        //print("Result Version : ${response.body}, (${response.statusCode}) - " + DateTime.now().toString());
        if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ showMessageBox(context, 'Check Version Data Error !!!'); }
        else if(response.statusCode == 200){
          if(jsonDecode(response.body)['Table'].length == 0) {
            showMessageBox(context, 'Data does not Exists!!!');
          }
          else {
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
                          Text('Sender : ' + element['Name'] + ',   Send Time : ' + element['InsDate'] + ',   ', style: TextStyle(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.bold, ),),
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
            setState(() {
              ;
            });
          }
        }
      });
    }
    catch (e) {
      showMessageBox(context, 'Preference Setting Error A : ' + e.toString());
    }
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent && !_controller.position.outOfRange) {
      setState(() {
        //showMessageBox(context, "reach the bottom");
        page ++;
        makeScrollBody(page.toString());
      });
    }
    // Reach The Top : NonUse
    /*if (_controller.offset <= _controller.position.minScrollExtent && !_controller.position.outOfRange) {
      setState(() {
        showMessageBox(context, "reach the top");
      });
    }*/
  }

  // Call When Form Init
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    makeScrollBody(page.toString());
    super.initState();
    print("open Scroll List : " + DateTime.now().toString());
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
            'Scroll List Design',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),
          ),
        ),
        body: SingleChildScrollView(
          child: Column (
            children: <Widget> [
              Container (
                height: 50,
                width: screenWidth,
                alignment: Alignment.center,
                color: Color.fromARGB(0xFF, 0x4B, 0x56, 0x68),
                child :
                  Text('If scroll reached end of List View, Automatically receive 10 data.', style: TextStyle(color: Colors.white,),),
              ),
              Container( // Main Area
                color: Color.fromARGB(0xFF, 0xE6, 0xE6, 0xE6),
                width: screenWidth,
                height: screenHeight - statusBarHeight - appBarHeigight - 50,
                alignment: Alignment.center,
                child: ListView(
                  controller: _controller,
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: cardList,
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}