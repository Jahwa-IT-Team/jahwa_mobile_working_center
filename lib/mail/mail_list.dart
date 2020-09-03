import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';

class MailList extends StatelessWidget {
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
                    width: MediaQuery.of(context).size.width - 100,
                    padding: EdgeInsets.all(10.0) ,
                    child: Text(
                      'Mail List Page',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: FaIcon(FontAwesomeIcons.times),
                      color: Colors.white,
                      hoverColor: Colors.amber,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container( // Main Area
              color: Colors.blueAccent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 74,
              alignment: Alignment.center,
              child : IconButton(
                  icon: FaIcon(FontAwesomeIcons.key),
                  iconSize: 100,
                  hoverColor: Colors.amber,
                  color: Colors.white,
                  onPressed: () { encrypt_text(context); }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

