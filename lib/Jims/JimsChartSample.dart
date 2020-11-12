import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jahwa_mobile_working_center/util/globals.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';

class JimsChartSample extends StatefulWidget {
  @override
  _JimsChartSampleState createState() => _JimsChartSampleState();
}

class _JimsChartSampleState extends State<JimsChartSample> {

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
      var data = {};

      return await http.post(Uri.encodeFull(url), body: json.encode(data), headers: {"Content-Type": "application/json"}).timeout(const Duration(seconds: 15)).then<bool>((http.Response response) async {
        print("Result Version : ${response.body}, (${response.statusCode}) - " + DateTime.now().toString());
        if(response.statusCode != 200 || response.body == null || response.body == "{}" ){ showMessageBox(context, 'Check Version Data Error !!!'); }
        else if(response.statusCode == 200){
          if(jsonDecode(response.body)['Table'].length == 0) {
            showMessageBox(context, 'Data does not Exists!!!');
          }
          else {
            jsonDecode(response.body)['Table'].forEach((element) {
              ChartSampleData chartSampleData = ChartSampleData(x: element['MachineName'].length > 7 ? element['MachineName'].substring(0, 5) + '..' : element['MachineName'], y: element['CPUUsage'], yValue: 100);
              chartList0.add(chartSampleData);
            });

            jsonDecode(response.body)['Table1'].forEach((element) {
              ChartSampleData chartSampleData = ChartSampleData(x: element['MachineName'].length > 7 ? element['MachineName'].substring(0, 5) + '..' : element['MachineName'], y: element['MemoryUsage']);
              chartList1.add(chartSampleData);
            });

            jsonDecode(response.body)['Table2'].forEach((element) {
              ChartSampleData chartSampleData = ChartSampleData(x: element['MachineName'].length > 7 ? element['MachineName'].substring(0, 5) + '..' : element['MachineName'] + '/' + element['DiskName'], y: element['DiskUsage']);
              chartList2.add(chartSampleData);
            });

            jsonDecode(response.body)['Table3'].forEach((element) {
              String mchaineName = element['MachineName'].length > 7 ? element['MachineName'].substring(0, 5) + '..' : element['MachineName'];
              String dbName = element['DBName'].length > 7 ? element['DBName'].substring(0, 5) + '..' : element['DBName'];
              ChartSampleData chartSampleData = ChartSampleData(x: mchaineName + '\n' + dbName, y: element['LogRate']);
              chartList3.add(chartSampleData);
              ;
            });

            jsonDecode(response.body)['Table4'].forEach((element) {
              String mchaineName = element['MachineName'].length > 7 ? element['MachineName'].substring(0, 5) + '..' : element['MachineName'];
              String dbName = element['DBName'].length > 7 ? element['DBName'].substring(0, 5) + '..' : element['DBName'];
              ChartSampleData chartSampleData = ChartSampleData(x: mchaineName + '\n' + dbName, y: element['DataSize']);
              chartList4.add(chartSampleData);
              ;
            });

            jsonDecode(response.body)['Table5'].forEach((element) {
              String mchaineName = element['MachineName'].length > 7 ? element['MachineName'].substring(0, 5) + '..' : element['MachineName'];
              String dbName = element['DBName'].length > 7 ? element['DBName'].substring(0, 5) + '..' : element['DBName'];
              ChartSampleData chartSampleData = ChartSampleData(x: mchaineName + '\n' + dbName, y: element['LogSize']);
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
      showMessageBox(context, 'Preference Setting Error A : ' + e.toString());
    }
  }

  String _pageName = "CPU Usage";

  /// Get default column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeries(int seq) {
    List<ChartSampleData> chartData = new List<ChartSampleData>();
    if(seq == 1) chartData = chartList1.toList();
    else if(seq == 2) chartData = chartList2.toList();
    else if(seq == 3) chartData = chartList3.toList();
    else if(seq == 4) chartData = chartList4.toList();
    else if(seq == 5) chartData = chartList5.toList();
    else chartData = chartList0.toList();

    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        name: 'CPU Usage',
        animationDuration: 500, /// animation이 그려지는 속도
        color: const Color.fromRGBO(75, 135, 185, 0.6), /// Column Color
        borderColor: const Color.fromRGBO(75, 135, 185, 1), /// Column Border Color
        borderWidth: 2, /// Column Border Width
        width: 0.6, /// Column의 두께, 1이 100%임
        spacing: 0.2, /// 여러개의 그래프일 경우 그래프간의 간격
        dataSource: chartData,
        markerSettings: MarkerSettings(isVisible: true), /// Value 위치에 dot 표시, true일 경우 tooltipBehavior가 작동하지 않음
        trackColor: const Color.fromRGBO(198, 201, 207, 1), /// 100%에 대한 전체 Column 색깔
        isTrackVisible: true, /// 100%에 대한 전체 Column 표시여부
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), /// Column에 Round 넣기
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.top, textStyle: const TextStyle(fontSize: 10)), /// Data Label Setting
      )
    ];
  }

  // Call When Form Init
  @override
  void initState() {
    makePageBody();
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
          title: Text("Top List : " + _pageName,
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
                  child: SfCartesianChart( /// Chart, https://flutter.syncfusion.com/ 참조
                    plotAreaBorderWidth: 0, /// Chart Outline Border Width
                    legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap), /// 범례
                    isTransposed: false, /// 방향 설정, true로 하는 경우 XY축이 바뀜
                    title: ChartTitle(text: 'CPU Usage Top 5', textStyle: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold,)), /// Chart Title
                    primaryXAxis: CategoryAxis( /// 형태에 따라 다양한 축설정 가능함
                      labelStyle: const TextStyle(color: Colors.black), /// X축 Label 형태
                      axisLine: AxisLine(width: 1, color: Colors.grey), /// X축 Line 형태
                      labelPosition: ChartDataLabelPosition.outside, /// X축 Label의 위치
                      majorTickLines: MajorTickLines(width: 0), /// X축 라인 표시선 두께, 의미 없음
                      majorGridLines: MajorGridLines(width: 0), /// X축 그리드 라인의 두께
                      title: AxisTitle(text: 'Server Name', textStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold,)), /// X축 Title
                    ),
                    primaryYAxis: NumericAxis( /// Y축 설정
                      axisLine: AxisLine(width: 1), /// Y축 라인의 두께
                      edgeLabelPlacement: EdgeLabelPlacement.shift, /// 최상단 및 최하단에 표시하는 Label의 위치를 조정하는 설정 shift의 경우 영역 내부로 약간의 이동을 해주는 기능
                      labelFormat: '{value}%', /// Y축 라벨 표시형태
                      numberFormat: NumberFormat.compact(), /// 숫자형 표기설정 - intl import 필요
                      majorTickLines: MajorTickLines(size: 0), /// Y축 라인 표시선 길이, 의미 없음
                      majorGridLines: MajorGridLines(width: 1), /// Y축 그리드 라인의 두께
                      labelStyle: const TextStyle(color: Colors.grey), /// Y축 Label 형태
                      isVisible: true,
                      minimum: 0,
                      maximum: 100,
                      interval: 10,
                      title: AxisTitle(text: 'CPU Usage', textStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold,)), // Y축 Title
                    ),
                    series: _getDefaultColumnSeries(0), /// Chart용 데이터
                    tooltipBehavior: TooltipBehavior( /// Click시 보여지는 ToolTip
                      enable: true,
                      header: 'CPU Usage',
                      format: 'point.x : point.y',
                      canShowMarker: true,
                    ),
                    trackballBehavior: TrackballBehavior( /// 화면상에서 드래그시 해당 영역에 포함되는 ToolTip
                        enable: true,
                        activationMode: ActivationMode.singleTap,
                        lineType: TrackballLineType.vertical,
                        tooltipSettings: InteractiveTooltip(format: 'point.x : point.y')),
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
                    plotAreaBorderWidth: 0,
                    ///title: ChartTitle(text: 'Population growth of various countries'),
                    primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0),),
                    primaryYAxis: NumericAxis(
                        axisLine: AxisLine(width: 0),
                        labelFormat: '{value}%',
                        majorTickLines: MajorTickLines(size: 0)),
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
                    plotAreaBorderWidth: 0,
                    ///title: ChartTitle(text: 'Population growth of various countries'),
                    primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0),),
                    primaryYAxis: NumericAxis(
                        axisLine: AxisLine(width: 0),
                        labelFormat: '{value}%',
                        majorTickLines: MajorTickLines(size: 0)),
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
                    plotAreaBorderWidth: 0,
                    ///title: ChartTitle(text: 'Population growth of various countries'),
                    primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0),),
                    primaryYAxis: NumericAxis(
                        axisLine: AxisLine(width: 0),
                        labelFormat: '{value}%',
                        majorTickLines: MajorTickLines(size: 0)),
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
                    plotAreaBorderWidth: 0,
                    ///title: ChartTitle(text: 'Population growth of various countries'),
                    primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0),),
                    primaryYAxis: NumericAxis(
                        axisLine: AxisLine(width: 0),
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
                    plotAreaBorderWidth: 0,
                    ///title: ChartTitle(text: 'Population growth of various countries'),
                    primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0),),
                    primaryYAxis: NumericAxis(
                        axisLine: AxisLine(width: 0),
                        labelFormat: '{value}Gb',
                        majorTickLines: MajorTickLines(size: 0)),
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
            ///control: new SwiperControl(),
            onIndexChanged: (int index) { // Change AppBar Title
              setState(() {
                if(index == 1) _pageName = "Memory Usage";
                else if(index == 2) _pageName = "Disk Usage";
                else if(index == 3) _pageName = "DB Log Rate";
                else if(index == 4) _pageName = "DB Data Usage";
                else if(index == 5) _pageName = "DB Log Usage";
                else _pageName = "CPU Usage";
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