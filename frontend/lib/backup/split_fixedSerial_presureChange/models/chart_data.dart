import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import './size_config.dart';

class ChartData {
  double currChartMaxDepth;
  double currChartMaxPressure;
  double drillMaxDepth;
  double drillCurrStDepth;
  double drillBarWidth;
  double currPressureBarWidth;
  String wc;
  Color pressureBarColor;

  double drillLastStDepth = 0;
  double lastPressureBarWidth = 0;
  double minXpressureBarWidth = 0;
  double maxXpressureBarWidth = 0;
  double lastChartMaxDepth = 0;

  List<LineChartBarData> listLineChartData = [];
  List<List> saveStList = [];

  bool isPressureChage = false;

  ChartData({
    this.currChartMaxDepth,
    this.currChartMaxPressure,
    this.drillMaxDepth,
    this.drillCurrStDepth,
    this.drillBarWidth,
    this.currPressureBarWidth,
    this.wc,
    this.pressureBarColor,
  });

  void _updatePressureBarColor() {
    if (wc == "cement") {
      pressureBarColor = kColorCement;
    } else {
      pressureBarColor = kColorWater;
    }
  }

  void _updatePressureBarWidth() {
    if (currPressureBarWidth != lastPressureBarWidth) {
      isPressureChage = true;
      lastPressureBarWidth = currPressureBarWidth;
      // Calculate a new linechart minX and maxX
      minXpressureBarWidth =
          (currChartMaxPressure / 2 - currPressureBarWidth / 2);
      maxXpressureBarWidth =
          (currChartMaxPressure / 2 + currPressureBarWidth / 2);
    }
    // print('isPressureChage = ' + isPressureChage.toString());
  }

  void _reLoadChartFromSaveStList() {
    int _saveStListLength = saveStList.length;
    listLineChartData = [];
    for (int i = 0; i < _saveStListLength; i++) {
      _updateListLineChartData(
          saveStList[i][0],
          saveStList[i][1],
          saveStList[i][2],
          saveStList[i][3],
          saveStList[i][4],
          currChartMaxDepth);
    }
  }

  LineChartBarData _lineChartData(
    double _drillCurrStDepth,
    double _minXpressureBarWidth,
    double _maxXpressureBarWidth,
    Color _pressureBarColor,
    double _currChartMaxDepth,
    double _lineWidth,
  ) {
    return LineChartBarData(
      spots: [
        FlSpot(_minXpressureBarWidth, _drillCurrStDepth - 0.5),
        FlSpot(_maxXpressureBarWidth, _drillCurrStDepth - 0.5),
      ],
      isCurved: false,
      colors: [
        _pressureBarColor,
      ],
      //47.5 = 1 depth in 0-8 , 380 = 1 depth in 0-1
      //barWidth: 380 / _currChartMaxDepth,
      // barWidth: SizeConfig.blockSizeVertical * 44 / _currChartMaxDepth,
      barWidth: _lineWidth,
      isStrokeCapRound: false,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
  }

  // Forward and backward version
  void _updateListLineChartData(
    double _drillCurrStDepth,
    double _drillLastStDepth,
    double _minXpressureBarWidth,
    double _maxXpressureBarWidth,
    Color _pressureBarColor,
    double _currChartMaxDepth,
  ) {
    double _lineWidth;
    double _currentGraphDepth;
    double _stDepthDiff = _drillCurrStDepth - _drillLastStDepth;
    int _numberOfLineChart;

    if (_stDepthDiff > 0) {
      //drill forward
      _lineWidth = kLineWidthChangeDepth / _currChartMaxDepth;
      _currentGraphDepth = _drillCurrStDepth;
      _numberOfLineChart = (_stDepthDiff ~/ 0.5) - 1;
      for (var i = 0; i < _numberOfLineChart; i++) {
        listLineChartData.add(_lineChartData(
          _currentGraphDepth,
          _minXpressureBarWidth,
          _maxXpressureBarWidth,
          _pressureBarColor,
          _currChartMaxDepth,
          _lineWidth,
        ));
        _currentGraphDepth = _currentGraphDepth - 0.5;
      }
      saveStList.add([
        _drillCurrStDepth,
        _drillLastStDepth,
        _minXpressureBarWidth,
        _maxXpressureBarWidth,
        _pressureBarColor,
        _currChartMaxDepth,
      ]);
    } else if (_stDepthDiff < 0) {
      //drill backward
      _lineWidth = kLineWidthChangeDepth / _currChartMaxDepth;
      _currentGraphDepth = _drillLastStDepth;
      _numberOfLineChart = (-(_stDepthDiff) ~/ 0.5) - 1;
      for (var i = 0; i < _numberOfLineChart; i++) {
        listLineChartData.add(_lineChartData(
          _currentGraphDepth,
          _minXpressureBarWidth,
          _maxXpressureBarWidth,
          _pressureBarColor,
          _currChartMaxDepth,
          _lineWidth,
        ));
        _currentGraphDepth = _currentGraphDepth - 0.5;
      }
      saveStList.add([
        _drillCurrStDepth,
        _drillLastStDepth,
        _minXpressureBarWidth,
        _maxXpressureBarWidth,
        _pressureBarColor,
        _currChartMaxDepth,
      ]);
    } else if (_stDepthDiff == 0 && (isPressureChage == true)) {
      _reLoadChartFromSaveStList();
      _lineWidth = kLineWidthChangePressure;
      _currentGraphDepth = _drillCurrStDepth + 0.5;
      listLineChartData.add(_lineChartData(
        _currentGraphDepth,
        _minXpressureBarWidth,
        _maxXpressureBarWidth,
        _pressureBarColor,
        _currChartMaxDepth,
        _lineWidth,
      ));
    }
  }

  void _updateDrillMaxDepth() {
    if (drillMaxDepth <= drillCurrStDepth) {
      drillMaxDepth = drillCurrStDepth;
    } else {
      drillMaxDepth = drillMaxDepth;
    }
  }

  void _updateDrillLastStDepth() {
    if (drillCurrStDepth != drillLastStDepth) {
      _updateDrillMaxDepth();
      _updateListLineChartData(
          drillCurrStDepth,
          drillLastStDepth,
          minXpressureBarWidth,
          maxXpressureBarWidth,
          pressureBarColor,
          currChartMaxDepth);
      drillLastStDepth = drillCurrStDepth;
    } else {
      _updateListLineChartData(
          drillCurrStDepth,
          drillLastStDepth,
          minXpressureBarWidth,
          maxXpressureBarWidth,
          pressureBarColor,
          currChartMaxDepth);
    }
  }

  void _updateChartMaxDepth() {
    int _saveStListLength = saveStList.length;
    // currChartMaxDepth has been change
    if (currChartMaxDepth != lastChartMaxDepth) {
      // Chart has changed stage bafore
      // Scale old chart before add new line chart
      // Case : User enter new currChartMaxDepth and drillCurrStDepth but old chart has been rendered
      if (_saveStListLength > 0) {
        _reLoadChartFromSaveStList();
        _updateDrillLastStDepth();
      } else {
        // currChartMaxDepth has been change but chart hasn't changed stage bafore
        // Case : User change currChartMaxDepth from default value before plot graph
        _updateDrillLastStDepth();
      }
      // Update lastChartMaxDepth
      lastChartMaxDepth = currChartMaxDepth;
    } else {
      // currChartMaxDepth hasn't been change
      // Case : User enter new drillCurrStDepth with default currChartMaxDepth
      _updateDrillLastStDepth();
    }
  }

  void updateChart() {
    _updatePressureBarColor();
    _updatePressureBarWidth();
    _updateChartMaxDepth();
    // reset isPressureChange flag
    isPressureChage = false;
  }

  void reset() {
    currChartMaxDepth = 20;
    drillMaxDepth = 0;
    drillCurrStDepth = 0;
    drillLastStDepth = 0;
    drillBarWidth = 30;
    currPressureBarWidth = 0;
    lastPressureBarWidth = 0;
    listLineChartData = [];
    wc = "water";
    saveStList = [];
    isPressureChage = false;
  }
}
