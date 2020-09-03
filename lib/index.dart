import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Index extends StatelessWidget {

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
                      'Index Page',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  /*Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: FaIcon(FontAwesomeIcons.times),
                      color: Colors.white,
                      hoverColor: Colors.amber,
                      onPressed: () { print("Close This Page !!!"); }
                    ),
                  ),*/
                ],
              ),
            ),
            Container( // Main Area
              color: Colors.blueAccent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 74,
              alignment: Alignment.center,
              child : IconButton(
                  icon: FaIcon(FontAwesomeIcons.mailBulk),
                  iconSize: 100,
                  hoverColor: Colors.amber,
                  color: Colors.white,
                  onPressed: () { Navigator.pushNamed(context, '/MailList'); }
              ),
            ),
          ],
        ),
      ),
    );
  }
}