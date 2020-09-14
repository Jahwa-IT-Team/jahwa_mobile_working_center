import 'package:flutter/material.dart';

import 'package:dynamic_treeview/dynamic_treeview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';
import 'package:jahwa_mobile_working_center/globals.dart';
import 'package:jahwa_mobile_working_center/util/structures.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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
                padding: EdgeInsets.fromLTRB(40, 20, 20, 40),
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
                          image: NetworkImage('https://gw.jahwa.co.kr/Photo/KRERP/K20604007.JPG',)),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        //color: Colors.redAccent,
                      ),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      session['Name'] + '\n' + session['DeptName'] + ', ' + session['Position'],
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25,),
                    ),
                  ],
                ),
              ),
              Container (
                padding: EdgeInsets.all(20),
                width:MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 150,
                color: Color.fromARGB(0xFF, 0x4B, 0x56, 0x68),
                child: DynamicTreeView(
                  data: getData(),
                  config: Config(
                    parentTextStyle: TextStyle(color: Colors.white, fontSize: 25, ),
                    parentPaddingEdgeInsets: EdgeInsets.only(left: 30, top: 0, bottom: 0),
                    rootId: "1",
                    childrenTextStyle: TextStyle(color: Colors.blueAccent, fontSize: 25, ),
                    childrenPaddingEdgeInsets: EdgeInsets.only(left: 30, top: 0, bottom: 0),
                    arrowIcon: FaIcon(FontAwesomeIcons.caretDown, color: Colors.white,),
                    ),
                  onTap: (m) {
                    print("onTap(ScreenOne) -> $m");
                    if(_getChildrenFromParent(getData(), m['id']).length == 0) showMessageBox(context, 'Exec Program : ' + m['id'] + ' / ' + m['title']);
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

List<BaseData> _getChildrenFromParent(List data, String parentId) {
  return data
      .where((data) => data.getParentId() == parentId.toString())
      .toList();
}

List<BaseData> getData() {
  return [
    MenuDataModel(
      id: 1,
      name: 'Root',
      parentId: -1,
      extras: {'key': 'extradata1'},
    ),
    MenuDataModel(
      id: 2,
      name: 'Men',
      parentId: 1,
      extras: {'key': 'extradata2'},
    ),
    MenuDataModel(
      id: 3,
      name: 'Shorts',
      parentId: 2,
      extras: {'key': 'extradata3'},
    ),
    MenuDataModel(
      id: 4,
      name: 'Shoes',
      parentId: 2,
      extras: {'key': 'extradata4'},
    ),
    MenuDataModel(
      id: 5,
      name: 'Women',
      parentId: 1,
      extras: {'key': 'extradata5'},
    ),
    MenuDataModel(
      id: 6,
      name: 'Shoes',
      parentId: 5,
      extras: {'key': 'extradata6'},
    ),
    MenuDataModel(
      id: 7,
      name: 'Shorts',
      parentId: 5,
      extras: {'key': 'extradata7'},
    ),
    MenuDataModel(
      id: 8,
      name: 'Tops',
      parentId: 5,
      extras: {'key': 'extradata8'},
    ),
    MenuDataModel(
      id: 9,
      name: 'Electronics',
      parentId: 1,
      extras: {'key': 'extradata9'},
    ),
    MenuDataModel(
      id: 10,
      name: 'Phones',
      parentId: 9,
      extras: {'key': 'extradata10'},
    ),
    MenuDataModel(
      id: 11,
      name: 'Tvs',
      parentId: 9,
      extras: {'key': 'extradata11'},
    ),
    MenuDataModel(
      id: 12,
      name: 'Laptops',
      parentId: 9,
      extras: {'key': 'extradata12'},
    ),
    MenuDataModel(
      id: 13,
      name: 'Nike shooes',
      parentId: 4,
      extras: {'key': 'extradata13'},
    ),
    MenuDataModel(
      id: 14,
      name: 'puma shoes',
      parentId: 4,
      extras: {'key': 'extradata14'},
    ),
    MenuDataModel(
      id: 15,
      name: 'puma shoes 1',
      parentId: 14,
      extras: {'key': 'extradata15'},
    ),
    MenuDataModel(
      id: 16,
      name: 'puma shoes 2',
      parentId: 14,
      extras: {'key': 'extradata16'},
    ),
    MenuDataModel(
      id: 17,
      name: 'puma shoes 3',
      parentId: 14,
      extras: {'key': 'extradata17'},
    ),
  ];
}