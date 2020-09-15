import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:jahwa_mobile_working_center/util/globals.dart';
import 'package:jahwa_mobile_working_center/util/menulist.dart';

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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView (
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width:MediaQuery.of(context).size.width,
                //height: 120,
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
                      width: MediaQuery.of(context).size.width - 190,
                      child: Text(
                        session['Name'] + '\n' + session['DeptName'] + ', ' + session['Position'],
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: 30,
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.times, color: Colors.white),
                        iconSize: 30,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container (
                padding: EdgeInsets.all(20),
                width:MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 130,
                color: Color.fromARGB(0xFF, 0x4B, 0x56, 0x68),
                child: DynamicTreeView(
                  data: MenuList,
                  config: Config(
                    parentTextStyle: TextStyle(color: Colors.white,),
                    parentPaddingEdgeInsets: EdgeInsets.only(left: 30, top: 0, bottom: 0),
                    rootId: "Root",
                    childrenTextStyle: TextStyle(color: Colors.blueAccent,),
                    childrenPaddingEdgeInsets: EdgeInsets.only(left: 30, top: 0, bottom: 0),
                    arrowIcon: FaIcon(FontAwesomeIcons.caretDown, color: Colors.white,),
                    ),
                  onTap: (m) {
                    print("onTap(ScreenOne) -> $m");
                    if(m['url'] != "") {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, m['url']);
                    }
                    else print('Folder');
                  },
                  width: MediaQuery.of(context).size.width - 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}