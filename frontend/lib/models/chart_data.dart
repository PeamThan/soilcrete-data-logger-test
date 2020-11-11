import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ChartData {
  double currChartMaxDepth;
  double currChartMaxPressure;
  double drillMaxDepth;
  double currDrillDepth;
  double drillBarWidth;
  double currPressureBarWidth;
  double fixedChartMaxDepth;

  String wc;
  Color pressureBarColor;

  double lastDrillDepth = 0;
  double lastPressureBarWidth = 0;
  double lastChartMaxDepth = 0;
  double lastChartMaxPressure = 0;

  double minXpressureBarWidth = 0;
  double maxXpressureBarWidth = 0;

  double depthChangeThreshold = 1;
  double pressureChangeThreshold = 2;

  List<LineChartBarData> listLineChartData = [];
  List<List> saveStList = [];

  bool _isUpdateChartMaxDepth = false;
  bool _isUpdatePressureBarWidth = false;
  bool _isUpdateDrillDepth = false;
  bool _isUpdateChartMaxPressure = false;

  ChartData(
      {this.currChartMaxDepth,
      this.currChartMaxPressure,
      this.drillMaxDepth,
      this.currDrillDepth,
      this.drillBarWidth,
      this.currPressureBarWidth,
      this.wc,
      this.pressureBarColor,
      this.fixedChartMaxDepth});

/* Check for update value function------------------------------------------------------------- */
  void _checkIsUpdateChartMaxDepth() {
    if (currChartMaxDepth != lastChartMaxDepth) {
      _isUpdateChartMaxDepth = true;
    } else {
      _isUpdateChartMaxDepth = false;
    }
  }

  void _checkIsUpdateChartMaxPressure() {
    if (currChartMaxPressure != lastChartMaxPressure) {
      _isUpdateChartMaxPressure = true;
    } else {
      _isUpdateChartMaxPressure = false;
    }
  }

  void _checkIsUpdateDrillDepth() {
    double _depthChange =
        double.parse((currDrillDepth - lastDrillDepth).toStringAsFixed(3));
    if (_depthChange.abs() >= depthChangeThreshold) {
      _isUpdateDrillDepth = true;
    } else {
      _isUpdateDrillDepth = false;
    }
  }

  void _checkIsUpdatePressureBarWidth() {
    double _pressureChange = double.parse(
        (currPressureBarWidth - lastPressureBarWidth).toStringAsFixed(3));
    if (_pressureChange.abs() >= pressureChangeThreshold) {
      _isUpdatePressureBarWidth = true;
    } else {
      _isUpdatePressureBarWidth = false;
    }
  }

/* Update value function------------------------------------------------------------------- */
  void _updateChartMaxDepth() {
    if (_isUpdateChartMaxDepth == true) {
      lastChartMaxDepth = currChartMaxDepth;
    }
  }

  void _updateLastPressureBarWidth() {
    if (_isUpdatePressureBarWidth == true) {
      lastPressureBarWidth = currPressureBarWidth;
    }
  }

  void _updateLastDrillDepth() {
    if (_isUpdateDrillDepth == true) {
      lastDrillDepth = currDrillDepth;
    }
  }

  void _updateDepthChangeThreshold() {
    if (_isUpdateChartMaxDepth == true) {
      depthChangeThreshold =
          double.parse((currChartMaxDepth / 50).toStringAsFixed(3));
    }
  }

  void _updatePressureChangeThreshold() {
    if (_isUpdateChartMaxDepth == true) {
      pressureChangeThreshold =
          double.parse((currChartMaxPressure / 50).toStringAsFixed(3));
    }
  }

  void _updateDrillMaxDepth() {
    if (drillMaxDepth <= currDrillDepth) {
      drillMaxDepth = currDrillDepth;
    }
  }

  void _updatePressureBarColor() {
    if (wc == "cement") {
      pressureBarColor = kColorCement;
    } else {
      pressureBarColor = kColorWater;
    }
  }

  void _updatePressureBarWidth() {
    if (_isUpdatePressureBarWidth == true) {
      lastPressureBarWidth = currPressureBarWidth;
      // Calculate a new lineChart minX and maxX
      minXpressureBarWidth =
          (currChartMaxPressure / 2 - currPressureBarWidth / 2);
      maxXpressureBarWidth =
          (currChartMaxPressure / 2 + currPressureBarWidth / 2);
      // print("_updatePressureBarWidth : change pressure");
    }
  }

/* Clear update flag------------------------------------------------------------------- */
  void _clearUpdateFlag() {
    _isUpdatePressureBarWidth = false;
    _isUpdateChartMaxDepth = false;
    _isUpdateChartMaxPressure = false;
    _isUpdateDrillDepth = false;
  }

/* LineChartData class------------------------------------------------------------------- */
// data for one line chart plot
  LineChartBarData _lineChartData(
    double _currDrillDepth,
    double _minXpressureBarWidth,
    double _maxXpressureBarWidth,
    Color _pressureBarColor,
    double _currChartMaxDepth,
    double _depthChangeThreshold,
  ) {
    return LineChartBarData(
      spots: [
        FlSpot(_minXpressureBarWidth,
            _currDrillDepth * (fixedChartMaxDepth / _currChartMaxDepth)),
        FlSpot(_maxXpressureBarWidth,
            _currDrillDepth * (fixedChartMaxDepth / _currChartMaxDepth)),
      ],
      isCurved: false,
      colors: [
        _pressureBarColor,
      ],
      barWidth: (_depthChangeThreshold *
              (fixedChartMaxDepth / currChartMaxDepth) *
              kLineWidthChangeDepth) /
          fixedChartMaxDepth,
      isStrokeCapRound: false,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
  }

/* Update listLineChartData function------------------------------------------------------------------- */
  void _saveChartData() {
    saveStList.add([
      currDrillDepth,
      lastDrillDepth,
      minXpressureBarWidth,
      maxXpressureBarWidth,
      pressureBarColor,
      currChartMaxDepth,
    ]);
  }

  void _reloadOldChartData() {
    // Clear current chart data
    listLineChartData = [];
    // create private variable for reload old chart data
    double _currDrillDepth;
    double _lastDrillDepth;
    double _minXpressureBarWidth;
    double _maxXpressureBarWidth;
    Color _pressureBarColor;
    double _currentGraphDepth;
    double _stDepthDiff;
    int _numberOfLineChart;

    for (int i = 0; i < saveStList.length; i++) {
      _currDrillDepth = saveStList[i][0];
      _lastDrillDepth = saveStList[i][1];
      _minXpressureBarWidth = saveStList[i][2];
      _maxXpressureBarWidth = saveStList[i][3];
      _pressureBarColor = saveStList[i][4];

      _stDepthDiff =
          double.parse((_currDrillDepth - _lastDrillDepth).toStringAsFixed(3));

      if (_stDepthDiff > 0) {
        //drill forward
        _currentGraphDepth = _lastDrillDepth + (depthChangeThreshold / 2);
        // round up numberOfLine
        _numberOfLineChart = (_stDepthDiff / (depthChangeThreshold)).ceil();
        for (var i = 0; i < _numberOfLineChart; i++) {
          listLineChartData.add(_lineChartData(
            _currentGraphDepth,
            _minXpressureBarWidth,
            _maxXpressureBarWidth,
            _pressureBarColor,
            currChartMaxDepth,
            depthChangeThreshold,
          ));
          _currentGraphDepth = _currentGraphDepth + (depthChangeThreshold);
        }
      } else if (_stDepthDiff < 0) {
        //drill backward
        _currentGraphDepth = _lastDrillDepth - (depthChangeThreshold / 2);
        // round up numberOfLine
        _numberOfLineChart = (-(_stDepthDiff) / (depthChangeThreshold)).ceil();
        for (var i = 0; i < _numberOfLineChart; i++) {
          listLineChartData.add(_lineChartData(
            _currentGraphDepth,
            _minXpressureBarWidth,
            _maxXpressureBarWidth,
            _pressureBarColor,
            currChartMaxDepth,
            depthChangeThreshold,
          ));
          _currentGraphDepth = _currentGraphDepth - (depthChangeThreshold);
        }
      }
    }
  }

  void _addNewDepthChangeLine() {
    double _currentGraphDepth;
    int _numberOfLineChart;
    double _stDepthDiff =
        double.parse((currDrillDepth - lastDrillDepth).toStringAsFixed(3));
    if (_stDepthDiff > 0) {
      //drill forward
      _currentGraphDepth = lastDrillDepth + (depthChangeThreshold / 2);
      // round up numberOfLine
      _numberOfLineChart = (_stDepthDiff / (depthChangeThreshold)).ceil();
      for (var i = 0; i < _numberOfLineChart; i++) {
        listLineChartData.add(_lineChartData(
          _currentGraphDepth,
          minXpressureBarWidth,
          maxXpressureBarWidth,
          pressureBarColor,
          currChartMaxDepth,
          depthChangeThreshold,
        ));
        _currentGraphDepth = _currentGraphDepth + (depthChangeThreshold);
      }
      _saveChartData();
    } else if (_stDepthDiff < 0) {
      //drill backward
      _currentGraphDepth = lastDrillDepth - (depthChangeThreshold / 2);
      // round up numberOfLine
      _numberOfLineChart = (-(_stDepthDiff) / (depthChangeThreshold)).ceil();
      for (var i = 0; i < _numberOfLineChart; i++) {
        listLineChartData.add(_lineChartData(
          _currentGraphDepth,
          minXpressureBarWidth,
          maxXpressureBarWidth,
          pressureBarColor,
          currChartMaxDepth,
          depthChangeThreshold,
        ));
        _currentGraphDepth = _currentGraphDepth - (depthChangeThreshold);
      }
      _saveChartData();
    }
  }

  void _addNewPressureChangeLine() {
    listLineChartData.add(
      _lineChartData(
        currDrillDepth,
        minXpressureBarWidth,
        maxXpressureBarWidth,
        pressureBarColor,
        currChartMaxDepth,
        depthChangeThreshold,
      ),
    );
  }

  void _addNewLineChart() {
    if (_isUpdateDrillDepth == true) {
      // reload from saveStList to remove PressureChangeLine
      _reloadOldChartData();
      _addNewDepthChangeLine();
      lastDrillDepth = currDrillDepth;
    } else {
      if (_isUpdatePressureBarWidth == true) {
        // reload from saveStList to remove PressureChangeLine
        _reloadOldChartData();
        // plot new PressureChangeLine
        _addNewPressureChangeLine();
      }
    }
  }

  void _updateLineChartData() {
    // check scaling chart from chartmaxdepth
    if (_isUpdateChartMaxDepth == true) {
      if (saveStList.length > 0) {
        // Load old chart data to scale old data with new ChartMaxDepth
        // before add new line
        _reloadOldChartData();
      }
      _addNewLineChart();
      _updateChartMaxDepth();
    } else {
      _addNewLineChart();
    }
  }

  void updateChart() {
    // check for chart scale update value
    _checkIsUpdateChartMaxDepth();
    _updateDepthChangeThreshold();
    _checkIsUpdateChartMaxPressure();
    _updatePressureChangeThreshold();

    // check for serial data update value
    _checkIsUpdateDrillDepth();
    _checkIsUpdatePressureBarWidth();

    // update linechart and barchart data from above value
    _updateDrillMaxDepth();
    _updatePressureBarWidth();
    _updatePressureBarColor();
    _updateLineChartData();

    // update laststate data and clear update flag
    _updateLastPressureBarWidth();
    _updateLastDrillDepth();
    _clearUpdateFlag();
    // print("listLineChartData.length = " + listLineChartData.length.toString());
  }

  void resetChart() {
    currChartMaxDepth = kDefaultChartMaxDepth;
    drillMaxDepth = 0;
    currDrillDepth = 0;
    lastDrillDepth = 0;
    drillBarWidth = kDrillBarWidth;
    currPressureBarWidth = 0;
    lastPressureBarWidth = 0;
    listLineChartData = [];
    wc = kDefaultWCvalue;
    pressureBarColor = kColorWater;
    saveStList = [];
  }
}
