import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jahwa_mobile_working_center/util/common.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView (
          child: Column(
            children: <Widget>[
              Container( // Top Area
                height: 24,
                width: width,
                color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
              ),
              Container( // Language
                color: Colors.white,
                width: width,
                height: (height - 24) * 0.1,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.0) ,
                child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.language),
                    iconSize: 30,
                    color: Colors.black,
                    onPressed: () { Navigator.pushNamed(context, '/MailList'); }
                ),
              ),
              Container( // Main Mark
                  color: Colors.white,
                  width: width,
                  height: (height - 24) * 0.4,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width:width * 0.65,
                    child: Image.asset("assets/image/jahwa.png"),
                  )
              ),
              Container( // Input Area
                color: Colors.white,
                width: width * 0.65,
                height: (height - 24) * 0.3,
                alignment: Alignment.center,
                child: Column(
                  children: <Widget> [
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Employee Number',
                        contentPadding: EdgeInsets.all(10),  // Added this
                      ),
                    ),
                    SizedBox(height: 16,),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        contentPadding: EdgeInsets.all(10),  // Added this
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () {
                          showDialogOne(context, 'Reset Password');
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container( // Login Button
                color: Colors.white,
                width: width,
                height: (height - 24) * 0.2,
                alignment: Alignment.topCenter,
                child: ButtonTheme(
                  minWidth: width * 0.65,
                  height: 50.0,
                  child: RaisedButton(
                    child:Text('Login', style: TextStyle(fontSize: 24, color: Colors.white,)),
                    onPressed: () {
                      showDialogOne(context, 'Login');
                      Navigator.pushNamed(context, '/MainPage');
                    },
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