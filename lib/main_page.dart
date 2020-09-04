import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container( // Top Area
              height: 24,
              width: MediaQuery.of(context).size.width,
              color: Color.fromARGB(0xFF, 0x34, 0x40, 0x4E),
            ),
            Container( // Menu Area - Menu List Button + Menu Name + Close Button -> Index has not Close Button
              height: 50,
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              color: Color.fromARGB(0xFF, 0x34, 0x40, 0x4E),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child : IconButton(
                        icon: FaIcon(FontAwesomeIcons.bars),
                        color: Colors.white,
                        onPressed: () { print("Menu List !!!"); }
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 50, // Index를 제외한 경우는 100을 차감
                    padding: EdgeInsets.all(10.0) ,
                    child: Text(
                      'Jahwa Mobile Work Center',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Container( // Main Area
              color: Color.fromARGB(0xFF, 0xE6, 0xE6, 0xE6),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 74,
              alignment: Alignment.center,
              child: Container( // Content Area
                //color: Colors.white,
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height - 94,
                alignment: Alignment.center,
                child : Column (
                  children: <Widget> [
                    IconButton(
                        icon: FaIcon(FontAwesomeIcons.signInAlt),
                        iconSize: 100,
                        hoverColor: Colors.amber,
                        color: Colors.blueAccent,
                        onPressed: () { Navigator.pushNamed(context, '/Login'); }
                    ),
                    Container(
                      height: 50,
                    ),
                    IconButton(
                        icon: FaIcon(FontAwesomeIcons.mailBulk),
                        iconSize: 100,
                        hoverColor: Colors.amber,
                        color: Colors.blueAccent,
                        onPressed: () { Navigator.pushNamed(context, '/MailList'); }
                    ),
                    Container(
                      height: 50,
                    ),
                  ],
                ),
                decoration: BoxDecoration( // Container Box Design
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}