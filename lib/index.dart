import 'package:flutter/material.dart';
import 'package:jahwa_mobile_working_center/util/common.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    print("open Index Page : " + DateTime.now().toString());

    return Scaffold(
      body: SingleChildScrollView (
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
        ),
      ),
    );
  }
}