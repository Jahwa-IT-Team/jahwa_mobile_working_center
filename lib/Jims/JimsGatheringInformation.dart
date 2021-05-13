import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';


class JimsGatheringInformation extends StatefulWidget {
  @override
  _JimsGatheringInformationState createState() => _JimsGatheringInformationState();
}

class _JimsGatheringInformationState extends State<JimsGatheringInformation> {

  List<Card> cardList0 = new List<Card>();
  List<Card> cardList1 = new List<Card>();
  List<Card> cardList2 = new List<Card>();

  bool _isLoading = true;

  Future<void> makePageBody() async {

    try {

      // Login API Url
      var url = 'https://jhapi.jahwa.co.kr/JimsGatheringInformation';

      // Send Parameter
      var data = {};

      return await http.post(Uri.parse(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) async {
        //print("Result Version : ${response.body}, (${response.statusCode}) - " + DateTime.now().toString());
        if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ showMessageBox(context, 'Alert', 'Check Version Data Error !!!'); }
        else if(response.statusCode == 200){
          if(jsonDecode(response.body)['Table'].length == 0) {
            showMessageBox(context, 'Alert', 'Data does not Exists!!!');
          }
          else {
            cardList0.clear();
            jsonDecode(response.body)['Table'].forEach((element) {
              Widget card = Card(
                child: Row(
                  children: <Widget> [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          Text(element['MachineName'] + ' : ' + element['Comment'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),),
                          Text('Diff : ' + element['DiffSecond'].toString() + ' Sec, Service : ' + element['VService'] + ', Updater : ' + element['VUpdater'] + '', style: TextStyle(color: element['DiffSecond'] >= 120 ? Colors.redAccent : Colors.blueAccent, fontSize: 12,),),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              cardList0.add(card);
            });
            Widget card = Card(
              child: Row(
                children: <Widget> [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Text("CPU & Memory Gathering Limit Time is 120 Seconds.", style: TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold,),),
                      ],
                    ),
                  ),
                ],
              ),
            );
            cardList0.add(card);
            cardList1.clear();
            jsonDecode(response.body)['Table1'].forEach((element) {
              Widget card = Card(
                child: Row(
                  children: <Widget> [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          Text(element['MachineName'] + ' : ' + element['Comment'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),),
                          Text('Diff : ' + element['DiffMinute'].toString() + ' Min, Service : ' + element['VService'] + ', Updater : ' + element['VUpdater'] + '', style: TextStyle(color: element['DiffMinute'] >= 20 ? Colors.redAccent : Colors.blueAccent, fontSize: 12,),),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              cardList1.add(card);
            });
            card = Card(
              child: Row(
                children: <Widget> [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Text("DB & Disk Gathering Limit Time is 20 Minutes.", style: TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold,),),
                      ],
                    ),
                  ),
                ],
              ),
            );
            cardList1.add(card);
            cardList2.clear();
            jsonDecode(response.body)['Table2'].forEach((element) {
              Widget card = Card(
                child: Row(
                  children: <Widget> [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          Text(element['MachineName'] + ' : ' + element['Comment'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),),
                          Text('Diff : ' + element['DiffDay'].toString() + ' Day, Service : ' + element['VService'] + ', Updater : ' + element['VUpdater'] + '', style: TextStyle(color: element['DiffDay'] >= 2 ? Colors.redAccent : Colors.blueAccent, fontSize: 12,),),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              cardList2.add(card);
            });
            card = Card(
              child: Row(
                children: <Widget> [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Text("Server & Network Gathering Limit Time is 2 Days.", style: TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold,),),
                      ],
                    ),
                  ),
                ],
              ),
            );
            cardList2.add(card);
            setState(() {
              _isLoading = false;
            });
          }
        }
      });
    }
    catch (e) {
      showMessageBox(context, 'Alert', 'Preference Setting Error A : ' + e.toString());
    }
  }

  String _pageName = "CPU & Memory";

  // Call When Form Init
  @override
  void initState() {
    makePageBody();
    super.initState();
    print("open JimsGatheringInformation Page : " + DateTime.now().toString());
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
          title: Text("Gathering Time : " + _pageName,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),
          ),
        ),
        body: LoadingOverlay(
          isLoading: _isLoading,
          opacity: 0.5,
          color: Colors.grey,
          progressIndicator: CircularProgressIndicator(),
          child: new Swiper(
            itemBuilder: (BuildContext context,int index){
              if(index == 0) {
                return new RefreshIndicator(
                  onRefresh: makePageBody,
                  child: ListView(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: cardList0,
                    ).toList(),
                  ),
                );
              }
              else if(index == 1) {
                return new RefreshIndicator(
                  onRefresh: makePageBody,
                  child: ListView(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: cardList1,
                    ).toList(),
                  ),
                );
              }
              else if(index == 2) {
                return new RefreshIndicator(
                  onRefresh: makePageBody,
                  child: ListView(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: cardList2,
                    ).toList(),
                  ),
                );
              }
            },
            itemCount: 3,
            pagination: new SwiperPagination(
                builder: const DotSwiperPaginationBuilder(
                  size: 10.0, activeSize: 15.0, space: 5.0,
                  color: Colors.amberAccent, activeColor: Colors.blueAccent,
                )),
            ///control: new SwiperControl(),
            onIndexChanged: (int index) { // Change AppBar Title
              setState(() {
                if(index == 1) _pageName = "DB & Disk";
                else if(index == 2) _pageName = "System & Network";
                else _pageName = "CPU & Memory";
              });
            },
          ),
        ),
      ),
    );
  }
}

