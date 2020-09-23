import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';
import 'package:jahwa_mobile_working_center/util/globals.dart';
import 'package:jahwa_mobile_working_center/util/menu_list.dart';
import 'package:jahwa_mobile_working_center/util/program_list.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  List<BaseData> MenuList = List<BaseData>();

  void initState() {
    super.initState();
    menudata['Table'].forEach((value) {
      if(value != null) MenuList.add(MenuDataModel(id: value['id'].toString() ?? '', title: value['title'].toString() ?? '', parentId: value['parentId'].toString() ?? '', icon: value['icon'].toString() ?? '', url: value['url'].toString() ?? ''));
    });
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width * 0.7; // Screen Width
    screenHeight = MediaQuery.of(context).size.height; // Screen Height
    statusBarHeight = MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView (
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: screenWidth,
                padding: EdgeInsets.fromLTRB(40, 20, 30, 20),
                alignment: Alignment.bottomLeft,
                color: Color.fromARGB(0xFF, 0x42, 0x4E, 0x5E),
                child: Row(
                  children: <Widget> [
                    Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.white, width: 2, style: BorderStyle.solid,),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage('https://gw.jahwa.co.kr/Photo/' + session['Photo'],)),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      width: screenWidth - 200,
                      child: Text(
                        session['Name'] + '\n' + session['DeptName'] + ', ' + session['Position'],
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: 35,
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.signOutAlt, color: Colors.white),
                        iconSize: 25,
                        color: Colors.white,
                        onPressed: () {
                          removeUserSharedPreferences();
                          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container (
                padding: EdgeInsets.all(15),
                width: screenWidth,
                height: screenHeight - statusBarHeight - 110,
                color: Color.fromARGB(0xFF, 0x4B, 0x56, 0x68),
                child: DynamicTreeView(
                  width: screenWidth - 40,
                  data: MenuList,
                  config: Config(
                    parentTextStyle: TextStyle(color: Colors.white, fontSize: 13),
                    parentPaddingEdgeInsets: EdgeInsets.only(left: 20.0, top: 0.0, right: 0.0, bottom: 0.0,),
                    parentVisualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    childrenTextStyle: TextStyle(color: Colors.greenAccent, fontSize: 13),
                    childrenPaddingEdgeInsets: EdgeInsets.only(left: 20.0, top: 0.0, right: 0.0, bottom: 0.0,),
                    childrenVisualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    rootId: "Root",
                    iconSize: 13.0,
                    arrowIcon: FaIcon(FontAwesomeIcons.caretDown, color: Colors.white),
                    ),
                  onTap: (m) async {
                    print("onTap(ScreenOne) -> $m");
                    if(m['url'] != '') {
                      if (routes.containsKey(m['url'])) {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, m['url']);
                      }
                      else if(m['url'].contains('http')) {
                        var url = m['url'];
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      }
                      else showMessageBox(context, 'This Menu does not Exist.');
                    }
                    else print(m['id'] + ' : Folder');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}