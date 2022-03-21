import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jahwa_mobile_working_center/util/globals.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';

class JimsUsageTop extends StatefulWidget {
  @override
  _JimsUsageTopState createState() => _JimsUsageTopState();
}

class _JimsUsageTopState extends State<JimsUsageTop> {

  List<ChartSampleData> chartList0 = new List<ChartSampleData>();
  List<ChartSampleData> chartList1 = new List<ChartSampleData>();
  List<ChartSampleData> chartList2 = new List<ChartSampleData>();
  List<ChartSampleData> chartList3 = new List<ChartSampleData>();
  List<ChartSampleData> chartList4 = new List<ChartSampleData>();
  List<ChartSampleData> chartList5 = new List<ChartSampleData>();

  String strData = '';

  bool _isLoading = true;

  Future<void> makePageBody() async {
    try {

      // Login API Url
      var url = 'https://jhapi.jahwa.co.kr/JimsUsageTop';

      // Send Parameter
      var data = {'EmpCode': session['EmpCode'], 'Token' : session['Token']};

      return await http.post(Uri.parse(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) async {
        print("Result Version : ${response.body}, (${response.statusCode}) - " + DateTime.now().toString());
        if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ showMessageBox(context, 'Alert', 'Check Version Data Error !!!'); }
        else if(response.statusCode == 200){
          if(jsonDecode(response.body)['Table'].length == 0) {
            showMessageBox(context, 'Alert', 'Data does not Exists!!!');
          }
          else {
            jsonDecode(response.body)['Table'].forEach((element) {
              ChartSampleData chartSampleData = ChartSampleData(x: element['MachineName'].length > 7 ? element['MachineName'].substring(0, 5) + '..' : element['MachineName'], y: element['CPUUsage'], yValue: 90);
              chartList0.add(chartSampleData);
            });

            jsonDecode(response.body)['Table1'].forEach((element) {
              ChartSampleData chartSampleData = ChartSampleData(x: element['MachineName'].length > 7 ? element['MachineName'].substring(0, 5) + '..' : element['MachineName'], y: element['MemoryUsage'], yValue: 90);
              chartList1.add(chartSampleData);
            });

            jsonDecode(response.body)['Table2'].forEach((element) {
              ChartSampleData chartSampleData = ChartSampleData(x: element['MachineName'].length > 7 ? element['MachineName'].substring(0, 5) + '..' : element['MachineName'] + '/' + element['DiskName'], y: element['DiskUsage'], yValue: 90);
              chartList2.add(chartSampleData);
            });

            jsonDecode(response.body)['Table3'].forEach((element) {
              String mchaineName = element['MachineName'].length > 7 ? element['MachineName'].substring(0, 5) + '..' : element['MachineName'];
              String dbName = element['DBName'].length > 7 ? element['DBName'].substring(0, 5) + '..' : element['DBName'];
              ChartSampleData chartSampleData = ChartSampleData(x: mchaineName + '\n' + dbName, y: element['LogRate'], yValue: 100);
              chartList3.add(chartSampleData);
              ;
            });

            jsonDecode(response.body)['Table4'].forEach((element) {
              String mchaineName = element['MachineName'].length > 7 ? element['MachineName'].substring(0, 5) + '..' : element['MachineName'];
              String dbName = element['DBName'].length > 7 ? element['DBName'].substring(0, 5) + '..' : element['DBName'];
              ChartSampleData chartSampleData = ChartSampleData(x: mchaineName + '\n' + dbName, y: element['DataSize'], yValue: 100);
              chartList4.add(chartSampleData);
              ;
            });

            jsonDecode(response.body)['Table5'].forEach((element) {
              String mchaineName = element['MachineName'].length > 7 ? element['MachineName'].substring(0, 5) + '..' : element['MachineName'];
              String dbName = element['DBName'].length > 7 ? element['DBName'].substring(0, 5) + '..' : element['DBName'];
              ChartSampleData chartSampleData = ChartSampleData(x: mchaineName + '\n' + dbName, y: element['LogSize'], yValue: 5);
              chartList5.add(chartSampleData);
              ;
            });
            setState(() {
              _isLoading = false;
            });
          }
        }
      });
    }
    catch (e) {
      _isLoading = false;
      showMessageBox(context, 'Alert', 'Preference Setting Error A : ' + e.toString());
    }
  }

  String _pageName = "CPU Usage Top 5";

  /// Get default column series
  List<ChartSeries<ChartSampleData, String>> _getDefaultColumnSeries(int seq) {
    List<ChartSampleData> chartData = new List<ChartSampleData>();
    if(seq == 1) chartData = chartList1.toList();
    else if(seq == 2) chartData = chartList2.toList();
    else if(seq == 3) chartData = chartList3.toList();
    else if(seq == 4) chartData = chartList4.toList();
    else if(seq == 5) chartData = chartList5.toList();
    else chartData = chartList0.toList();

    return <ChartSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        color: const Color.fromRGBO(75, 135, 185, 0.6), /// Column Color
        borderColor: const Color.fromRGBO(75, 135, 185, 1), /// Column Border Color
        borderWidth: 2, /// Column Border Width
        width: 0.6, /// Column의 두께, 1이 100%임
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), /// Column에 Round 넣기
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.outer, textStyle: const TextStyle(fontSize: 10)), /// Data Label Setting
      ),
      LineSeries<ChartSampleData, String>(
          dataSource: chartData,
          width: 2,
          color: Colors.red, /// Column Color
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
      )
    ];
  }

  // Call When Form Init
  @override
  void initState() {
    makePageBody();
    super.initState();
    print("open JimsUsageTop Page : " + DateTime.now().toString());
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
          title: Text(_pageName,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),
          ),
        ),
        body: LoadingOverlay(
          isLoading: _isLoading,
          opacity: 0.5,
          color: Colors.grey,
          progressIndicator: CircularProgressIndicator(),
          child:new Swiper(
            itemBuilder: (BuildContext context,int index){
              if(index == 0) {
                return Container(
                  width: screenWidth,
                  height: screenHeight,
                  padding: EdgeInsets.only(top: 20.0, left:10.0, bottom: 30.0, right:10.0,),
                  alignment: Alignment.topCenter,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0),),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 100,
                      interval: 10,
                      labelFormat: '{value}%',
                    ),
                    series: _getDefaultColumnSeries(0),
                    tooltipBehavior: TooltipBehavior(enable: true, header: '', canShowMarker: false),
                  ),
                );
              }
              else if(index == 1) {
                return Container(
                  width: screenWidth,
                  height: screenHeight,
                  padding: EdgeInsets.only(top: 20.0, left:10.0, bottom: 30.0, right:10.0,),
                  alignment: Alignment.topCenter,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0),),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 100,
                      interval: 10,
                      labelFormat: '{value}%',
                    ),
                    series: _getDefaultColumnSeries(1),
                    tooltipBehavior: TooltipBehavior(enable: true, header: '', canShowMarker: false),
                  ),
                );
              }
              else if(index == 2) {
                return Container(
                  width: screenWidth,
                  height: screenHeight,
                  padding: EdgeInsets.only(top: 20.0, left:10.0, bottom: 30.0, right:10.0,),
                  alignment: Alignment.topCenter,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0),),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 100,
                      interval: 10,
                      labelFormat: '{value}%',
                    ),
                    series: _getDefaultColumnSeries(2),
                    tooltipBehavior: TooltipBehavior(enable: true, header: '', canShowMarker: false),
                  ),
                );
              }
              else if(index == 3) {
                return Container(
                  width: screenWidth,
                  height: screenHeight,
                  padding: EdgeInsets.only(top: 20.0, left:10.0, bottom: 30.0, right:10.0,),
                  alignment: Alignment.topCenter,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0),),
                    primaryYAxis: NumericAxis(
                      labelFormat: '{value}%',
                    ),
                    series: _getDefaultColumnSeries(3),
                    tooltipBehavior: TooltipBehavior(enable: true, header: '', canShowMarker: false),
                  ),
                );
              }
              else if(index == 4) {
                return Container(
                  width: screenWidth,
                  height: screenHeight,
                  padding: EdgeInsets.only(top: 20.0, left:10.0, bottom: 30.0, right:10.0,),
                  alignment: Alignment.topCenter,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0),),
                    primaryYAxis: NumericAxis(
                      labelFormat: '{value}Gb',
                      majorTickLines: MajorTickLines(size: 0)),
                    series: _getDefaultColumnSeries(4),
                    tooltipBehavior: TooltipBehavior(enable: true, header: '', canShowMarker: false),
                  ),
                );
              }
              else if(index == 5) {
                return Container(
                  width: screenWidth,
                  height: screenHeight,
                  padding: EdgeInsets.only(top: 20.0, left:10.0, bottom: 30.0, right:10.0,),
                  alignment: Alignment.topCenter,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0),),
                    primaryYAxis: NumericAxis(
                      labelFormat: '{value}Gb',
                    ),
                    series: _getDefaultColumnSeries(5),
                    tooltipBehavior: TooltipBehavior(enable: true, header: '', canShowMarker: false),
                  ),
                );
              }
            },
            itemCount: 6,
            pagination: new SwiperPagination(
                builder: const DotSwiperPaginationBuilder(
                  size: 10.0, activeSize: 15.0, space: 5.0,
                  color: Colors.amberAccent, activeColor: Colors.blueAccent,
                )),
            onIndexChanged: (int index) { // Change AppBar Title
              setState(() {
                if(index == 1) _pageName = "Memory Usage Top 5";
                else if(index == 2) _pageName = "Disk Usage Top 5";
                else if(index == 3) _pageName = "DB Log Rate Top 5";
                else if(index == 4) _pageName = "DB Data Usage Top 5";
                else if(index == 5) _pageName = "DB Log Usage Top 5";
                else _pageName = "CPU Usage Top 5";
              });
            },
          ),
        ),
      ),
    );
  }
}

///Chart sample data
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
        this.y,
        this.xValue,
        this.yValue,
        this.secondSeriesYValue,
        this.thirdSeriesYValue,
        this.pointColor,
        this.size,
        this.text,
        this.open,
        this.close,
        this.low,
        this.high,
        this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color pointColor;

  /// Holds size of the datapoint
  final num size;

  /// Holds datalabel/text value mapper of the datapoint
  final String text;

  /// Holds open value of the datapoint
  final num open;

  /// Holds close value of the datapoint
  final num close;

  /// Holds low value of the datapoint
  final num low;

  /// Holds high value of the datapoint
  final num high;

  /// Holds open value of the datapoint
  final num volume;
}