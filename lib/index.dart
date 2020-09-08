import 'package:flutter/material.dart';
import 'package:jahwa_mobile_working_center/util/common.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("open Index Page");
    checkLogin(context, '/MainPage'); // Check Login Info -> Move to Login Or Main Page

    return Scaffold(
      body: Container(),
    );
  }
}