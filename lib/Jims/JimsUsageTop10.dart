import 'package:flutter/material.dart';

import 'package:jahwa_mobile_working_center/util/globals.dart';

class JimsUsageTop10 extends StatefulWidget {
  @override
  _JimsUsageTop10State createState() => _JimsUsageTop10State();
}

class _JimsUsageTop10State extends State<JimsUsageTop10> {

  // Call When Form Init
  @override
  void initState() {
    super.initState();
    print("open JimsUsageTop10 Page : " + DateTime.now().toString());
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
            'Usage Top 10',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container( // Main Area
                color: Color.fromARGB(0xFF, 0xE6, 0xE6, 0xE6),
                width: screenWidth,
                height: screenHeight - statusBarHeight - 50,
                alignment: Alignment.center,
                child: Container( // Content Area
                  //color: Colors.white,
                  width: screenWidth - 20,
                  height: screenHeight - statusBarHeight - 70,
                  alignment: Alignment.center,
                  child : Column (
                    children: <Widget> [
                      Container(
                        width: screenWidth - 20,
                        height: screenHeight - statusBarHeight - 70,
                        alignment: Alignment.center,
                        child: Text(
                          'Usage Top 10',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, fontFamily: 'NanumBrush'),
                        ),
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
      ),
    );
  }
}