import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:package_info/package_info.dart';
import 'package:store_redirect/store_redirect.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';
import 'package:jahwa_mobile_working_center/util/globals.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {

  String _mobileNumber = '';
  List<SimCard> _simCard = <SimCard>[];

  /// Call When Form Init
  @override
  void initState() {
    super.initState();
    print("open Test Page : " + DateTime.now().toString());

    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
    });

    initMobileNumberState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    String mobileNumber = '';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      mobileNumber = await MobileNumber.mobileNumber;
      _simCard = await MobileNumber.getSimCards;
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _mobileNumber = mobileNumber;
    });
  }

  Widget fillCards() {
    List<Widget> widgets = _simCard
        .map((SimCard sim) => Text(
        'Sim Card Number: (${sim.countryPhonePrefix}) - ${sim.number}\nCarrier Name: ${sim.carrierName}\nCountry Iso: ${sim.countryIso}\nDisplay Name: ${sim.displayName}\nSim Slot Index: ${sim.slotIndex}\n\n'))
        .toList();
    return Column(children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( /// Keyboard UnFocus시를 위해 onTap에 GestureDetector를 위치시킴
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) { currentFocus.unfocus(); }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0xFF, 0x34, 0x40, 0x4E),
          title: Text('Jahwa Mobile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container( // Main Area
                color: Color.fromARGB(0xFF, 0xE6, 0xE6, 0xE6),
                width: screenWidth,
                height: screenHeight - statusBarHeight - appBarHeigight,
                alignment: Alignment.center,
                child: Container( // Content Area
                  width: screenWidth - 20,
                  height: screenHeight - statusBarHeight - appBarHeigight - 20,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.all(10.0) ,
                  child: Table(
                    children: [
                      TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                child: Column(
                                  children: <Widget> [
                                    IconButton(
                                        icon: FaIcon(FontAwesomeIcons.solidFile),
                                        iconSize: 50,
                                        color: Colors.blueAccent,
                                        onPressed: () { Navigator.pushNamed(context, '/StandardDesign'); }
                                    ),
                                    Text('Standard Design', style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget> [
                                    IconButton(
                                        icon: FaIcon(FontAwesomeIcons.solidFileAlt),
                                        iconSize: 50,
                                        color: Colors.blueAccent,
                                        onPressed: () { Navigator.pushNamed(context, '/FormWidget'); }
                                    ),
                                    Text('Form Widget', style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget> [
                                    IconButton(
                                      icon: FaIcon(FontAwesomeIcons.mailBulk),
                                      iconSize: 50,
                                      color: Colors.blueAccent,
                                      onPressed: () { Navigator.pushNamed(context, '/EmailGW'); },
                                    ),
                                    Text('GW Mail', style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                              ),
                            ),
                          ]
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.solidListAlt),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                    onPressed: () { Navigator.pushNamed(context, '/ListPage'); },
                                  ),
                                  Text('List Page', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.listAlt),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                    onPressed: () { Navigator.pushNamed(context, '/ListScroll'); },
                                  ),
                                  Text('List Scroll', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                      icon: FaIcon(FontAwesomeIcons.codeBranch),
                                      iconSize: 50,
                                      color: Colors.blueAccent,
                                      onPressed: () {
                                        PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
                                          String version = packageInfo.version;
                                          showMessageBox(context, 'Alert', 'Program Version : ' + version);
                                          print(version);
                                        });
                                      }
                                  ),
                                  Text('Version', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.bolt),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                    onPressed: () { showMessageBox(context, 'Alert', 'Action Test Button !!!'); },
                                  ),
                                  Text('Action Test', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.solidBell),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                    onPressed: () async { await showNotification('제목부문은 길게 안됨...', '내용부문도 길게 처리될까... 얼마나 길게 처리될까.. 여러분 테스트입니다. 그냥 살짝 무시하세요.. 더길게 써야 하나... 이것도 힘드네...'); },
                                  ),
                                  Text('Flutter Notify', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                      icon: FaIcon(FontAwesomeIcons.comments),
                                      iconSize: 50,
                                      color: Colors.blueAccent,
                                      onPressed: () { Navigator.pushNamed(context, '/Notice'); }
                                  ),
                                  Text('View Notify', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.solidBell),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                    onPressed: () async { await showNotification('Notification', 'Notification Test !!!'); },
                                  ),
                                  Text('Flutter Notify', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.playCircle),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                    onPressed: () async {
                                      var isRunning = await FlutterBackgroundService().isServiceRunning();
                                      if (!isRunning) {
                                        FlutterBackgroundService.initialize(onStart);
                                      }
                                    },
                                  ),
                                  Text('Start Notify', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.stopCircle),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                    onPressed: () async {
                                      var isRunning = await FlutterBackgroundService().isServiceRunning();
                                      if (isRunning) {
                                        FlutterBackgroundService().sendData(
                                          {"action": "stopService"},
                                        );
                                      }
                                    },
                                  ),
                                  Text('Stop Notify', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.googlePlay),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                    onPressed: () async {
                                      StoreRedirect.redirect(
                                          androidAppId: "kr.co.jahwa.jahwa_mobile_working_center"
                                      );
                                    },
                                  ),
                                  Text('Google Store', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.mobileAlt),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                    onPressed: () { showMessageBox(context, 'Alert', 'Action Test Button !!!'); },
                                  ),
                                  Text(_mobileNumber, style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget> [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.bolt),
                                    iconSize: 50,
                                    color: Colors.blueAccent,
                                    onPressed: () { showMessageBox(context, 'Alert', 'Action Test Button !!!'); },
                                  ),
                                  Text('Action Test', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ],
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