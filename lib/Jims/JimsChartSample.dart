import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jahwa_mobile_working_center/util/globals.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:jahwa_mobile_working_center/util/common.dart';
/*
class JimsChartSample extends StatefulWidget {
  @override
  _JimsChartSampleState createState() => _JimsChartSampleState();
}

class _JimsChartSampleState extends State<JimsChartSample> {

  List<ChartSampleData> chartData = new List<ChartSampleData>();

  bool _isLoading = true;

  Future<void> makePageBody() async {
    try {

      // Login API Url
      var url = 'https://jhapi.jahwa.co.kr/JimsChartSample';

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
            chartData.clear();
            _server.clear();
            jsonDecode(response.body)['Table'].forEach((element) {
              ChartSampleData chartSampleData = ChartSampleData(x: element['MachineName'].length > 7 ? element['MachineName'].substring(0, 5) + '..' : element['MachineName'], y: element['CPUUsage'], secondSeriesYValue: element['MemoryUsage'], thirdSeriesYValue: element['DiskUsage']);
              chartData.add(chartSampleData);
              _server.add(Server(element['MachineName'], element['CPUUsage'], element['MemoryUsage'], element['DiskUsage']));
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

  String _pageName = "CPU Usage";

  /// Get Single Column series
  List<ColumnSeries<ChartSampleData, String>> _getSingleColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        name: 'CPU Usage',
        animationDuration: 500, /// animation이 그려지는 속도
        color: const Color.fromRGBO(75, 135, 185, 0.6), /// Column Color
        borderColor: const Color.fromRGBO(75, 135, 185, 1), /// Column Border Color
        borderWidth: 2, /// Column Border Width
        width: 0.6, /// Column의 두께, 1이 100%임
        spacing: 0.2, /// 여러개의 그래프일 경우 그래프간의 간격
        dataSource: chartData.toList(),
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

  /// Get default column series
  List<ColumnSeries<ChartSampleData, String>> _getMultiColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        name: 'CPU Usage',
        animationDuration: 500, /// animation이 그려지는 속도
        color: Colors.redAccent, /// Column Color
        borderColor: Colors.red, /// Column Border Color
        borderWidth: 2, /// Column Border Width
        width: 0.9, /// Column의 두께, 1이 100%임
        spacing: 0.2, /// 여러개의 그래프일 경우 그래프간의 간격
        dataSource: chartData.toList(),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.outer, textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)), /// Data Label Setting
      ),
      ColumnSeries<ChartSampleData, String>(
        name: 'Memory Usage',
        animationDuration: 500, /// animation이 그려지는 속도
        color: Colors.blueAccent, /// Column Color
        borderColor: Colors.blue, /// Column Border Color
        borderWidth: 2, /// Column Border Width
        width: 0.9, /// Column의 두께, 1이 100%임
        spacing: 0.2, /// 여러개의 그래프일 경우 그래프간의 간격
        dataSource: chartData.toList(),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.outer, textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)), /// Data Label Setting
      ),
      ColumnSeries<ChartSampleData, String>(
        name: 'C Drive Usage',
        animationDuration: 500, /// animation이 그려지는 속도
        color: Colors.greenAccent, /// Column Color
        borderColor: Colors.green, /// Column Border Color
        borderWidth: 2, /// Column Border Width
        width: 0.9, /// Column의 두께, 1이 100%임
        spacing: 0.2, /// 여러개의 그래프일 경우 그래프간의 간격
        dataSource: chartData.toList(),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.outer, textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)), /// Data Label Setting
      )
    ];
  }

  /// Get default column series
  List<LineSeries<ChartSampleData, String>> _getMultiLineSeries() {
    return <LineSeries<ChartSampleData, String>>[
      LineSeries<ChartSampleData, String>(
        name: 'CPU Usage',
        animationDuration: 1000, /// animation이 그려지는 속도
        color: Colors.redAccent, /// Line Color
        width: 3, /// Line의 두께
        dataSource: chartData.toList(),
        markerSettings: MarkerSettings(isVisible: true), /// Value 위치에 dot 표시, true일 경우 tooltipBehavior가 작동하지 않음
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.top, textStyle: const TextStyle(fontSize: 10)), /// Data Label Setting
      ),
      LineSeries<ChartSampleData, String>(
        name: 'Memory Usage',
        animationDuration: 1000, /// animation이 그려지는 속도
        color: Colors.blueAccent, /// Line Color
        width: 3, /// Line의 두께
        dataSource: chartData.toList(),
        markerSettings: MarkerSettings(isVisible: true), /// Value 위치에 dot 표시, true일 경우 tooltipBehavior가 작동하지 않음
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.top, textStyle: const TextStyle(fontSize: 10)), /// Data Label Setting
      ),
      LineSeries<ChartSampleData, String>(
        name: 'C Drive Usage',
        animationDuration: 1000, /// animation이 그려지는 속도
        color: Colors.green, /// Line Color
        width: 3, /// Line의 두께
        dataSource: chartData.toList(),
        markerSettings: MarkerSettings(isVisible: true), /// Value 위치에 dot 표시, true일 경우 tooltipBehavior가 작동하지 않음
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.top, textStyle: const TextStyle(fontSize: 10)), /// Data Label Setting
      )
    ];
  }

  /// Get default column series
  List<AreaSeries<ChartSampleData, String>> _getSingleAreaSeries() {
    return <AreaSeries<ChartSampleData, String>>[
      AreaSeries<ChartSampleData, String>(
        name: 'CPU Usage',
        animationDuration: 500, /// animation이 그려지는 속도
        color: const Color.fromRGBO(75, 135, 185, 0.6), /// Column Color
        borderColor: const Color.fromRGBO(75, 135, 185, 1), /// Column Border Color
        borderWidth: 2, /// Column Border Width
        dataSource: chartData.toList(),
        markerSettings: MarkerSettings(isVisible: true), /// Value 위치에 dot 표시, true일 경우 tooltipBehavior가 작동하지 않음
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
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
    print("open JimsChartSample Page : " + DateTime.now().toString());
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
          title: Text("Chart Sample", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),
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
                    legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap, position: LegendPosition.top), /// 범례
                    isTransposed: false, /// 방향 설정, true로 하는 경우 XY축이 바뀜
                    title: ChartTitle(text: 'Single Column Chart with Track', textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,)), /// Chart Title
                    primaryXAxis: CategoryAxis( /// 형태에 따라 다양한 축설정 가능함
                      labelStyle: const TextStyle(color: Colors.black), /// X축 Label 형태
                      axisLine: AxisLine(width: 1, color: Colors.grey), /// X축 Line 형태
                      labelPosition: ChartDataLabelPosition.outside, /// X축 Label의 위치
                      majorTickLines: MajorTickLines(width: 0), /// X축 라인 표시선 두께, 의미 없음
                      majorGridLines: MajorGridLines(width: 0), /// X축 그리드 라인의 두께
                      title: AxisTitle(text: 'X Axis Name', textStyle: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold,)), /// X축 Title
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
                      title: AxisTitle(text: 'Y Axis Name', textStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold,)), // Y축 Title
                    ),
                    series: _getSingleColumnSeries(), /// Chart용 데이터
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
                  child: SfCartesianChart( /// Chart, https://flutter.syncfusion.com/ 참조
                    plotAreaBorderWidth: 0, /// Chart Outline Border Width
                    legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap, position: LegendPosition.top), /// 범례
                    isTransposed: false, /// 방향 설정, true로 하는 경우 XY축이 바뀜
                    title: ChartTitle(text: 'Multi Column Chart', textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,)), /// Chart Title
                    primaryXAxis: CategoryAxis( /// 형태에 따라 다양한 축설정 가능함
                      labelStyle: const TextStyle(color: Colors.black), /// X축 Label 형태
                      axisLine: AxisLine(width: 1, color: Colors.grey), /// X축 Line 형태
                      labelPosition: ChartDataLabelPosition.outside, /// X축 Label의 위치
                      majorTickLines: MajorTickLines(width: 0), /// X축 라인 표시선 두께, 의미 없음
                      majorGridLines: MajorGridLines(width: 0), /// X축 그리드 라인의 두께
                      title: AxisTitle(text: 'X Axis Name', textStyle: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold,)), /// X축 Title
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
                      title: AxisTitle(text: 'Y Axis Name', textStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold,)), // Y축 Title
                    ),
                    series: _getMultiColumnSeries(), /// Chart용 데이터
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
              else if(index == 2) {
                return Container(
                  width: screenWidth,
                  height: screenHeight,
                  padding: EdgeInsets.only(top: 20.0, left:10.0, bottom: 30.0, right:10.0,),
                  alignment: Alignment.topCenter,
                  child: SfCartesianChart( /// Chart, https://flutter.syncfusion.com/ 참조
                    plotAreaBorderWidth: 0, /// Chart Outline Border Width
                    legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap, position: LegendPosition.top), /// 범례
                    isTransposed: false, /// 방향 설정, true로 하는 경우 XY축이 바뀜
                    title: ChartTitle(text: 'Multi Line Chart', textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,)), /// Chart Title
                    primaryXAxis: CategoryAxis( /// 형태에 따라 다양한 축설정 가능함
                      labelStyle: const TextStyle(color: Colors.black), /// X축 Label 형태
                      axisLine: AxisLine(width: 1, color: Colors.grey), /// X축 Line 형태
                      labelPosition: ChartDataLabelPosition.outside, /// X축 Label의 위치
                      majorTickLines: MajorTickLines(width: 0), /// X축 라인 표시선 두께, 의미 없음
                      majorGridLines: MajorGridLines(width: 0), /// X축 그리드 라인의 두께
                      title: AxisTitle(text: 'X Axis Name', textStyle: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold,)), /// X축 Title
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
                      title: AxisTitle(text: 'Y Axis Name', textStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold,)), // Y축 Title
                    ),
                    series: _getMultiLineSeries(), /// Chart용 데이터
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
              else if(index == 3) {
                return Container(
                  width: screenWidth,
                  height: screenHeight,
                  padding: EdgeInsets.only(top: 20.0, left:10.0, bottom: 30.0, right:10.0,),
                  alignment: Alignment.topCenter,
                  child: SfCartesianChart( /// Chart, https://flutter.syncfusion.com/ 참조
                    plotAreaBorderWidth: 0, /// Chart Outline Border Width
                    legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap, position: LegendPosition.top), /// 범례
                    isTransposed: false, /// 방향 설정, true로 하는 경우 XY축이 바뀜
                    title: ChartTitle(text: 'Single Area Chart', textStyle: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold,)), /// Chart Title
                    primaryXAxis: CategoryAxis( /// 형태에 따라 다양한 축설정 가능함
                      labelStyle: const TextStyle(color: Colors.black), /// X축 Label 형태
                      axisLine: AxisLine(width: 1, color: Colors.grey), /// X축 Line 형태
                      labelPosition: ChartDataLabelPosition.outside, /// X축 Label의 위치
                      majorTickLines: MajorTickLines(width: 0), /// X축 라인 표시선 두께, 의미 없음
                      majorGridLines: MajorGridLines(width: 0), /// X축 그리드 라인의 두께
                      title: AxisTitle(text: 'X Axis Name', textStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold,)), /// X축 Title
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
                      title: AxisTitle(text: 'Y Axis Name', textStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold,)), // Y축 Title
                    ),
                    series: _getSingleAreaSeries(), /// Chart용 데이터
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
              else if(index == 4) {
                return Container(
                  width: screenWidth,
                  height: screenHeight,
                  padding: EdgeInsets.only(top: 20.0, left:10.0, bottom: 30.0, right:10.0,),
                  alignment: Alignment.topCenter,
                  child: SfDataGrid(
                    source: _serverDataSource,
                    columnWidthMode: ColumnWidthMode.fill, /// Grid의 크기를 최대로
                    rowHeight: 50,
                    columns: [
                      GridTextColumn(columnName: 'MachineName', label: Text('Server')), /// width, padding, textAlignment, headerTextAlignment 설정 가능
                      GridTextColumn(columnName: 'CPUUsage', label: Text('CPU')),
                      GridTextColumn(columnName: 'MemoryUsage', label: Text('Memory')),
                      GridTextColumn(columnName: 'DiskUsage', label: Text('C Drive')),
                    ],
                  ),
                );
              }
            },
            itemCount: 5,
            pagination: new SwiperPagination(
                builder: const DotSwiperPaginationBuilder(
                  size: 10.0, activeSize: 15.0, space: 5.0,
                  color: Colors.amberAccent, activeColor: Colors.blueAccent,
                )),
            ///control: new SwiperControl(),
            onIndexChanged: (int index) { // Change AppBar Title
              setState(() {
                ;
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

class Server {
  Server(this.MachineName, this.CPUUsage, this.MemoryUsage, this.DiskUsage);
  final String MachineName;
  final num CPUUsage;
  final num MemoryUsage;
  final num DiskUsage;
}

final List<Server> _server = <Server>[];

final ServerDataSource _serverDataSource = ServerDataSource();

class ServerDataSource extends DataGridSource<Server> {
  @override
  List<Server> get dataSource => _server;

  @override
  getValue(Server server, String columnName) {
    switch (columnName) {
      case 'MachineName':
        return server.MachineName;
        break;
      case 'CPUUsage':
        return server.CPUUsage;
        break;
      case 'MemoryUsage':
        return server.MemoryUsage;
        break;
      case 'DiskUsage':
        return server.DiskUsage;
        break;
      default:
        return ' ';
        break;
    }
  }
}
*/