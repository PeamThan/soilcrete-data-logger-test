import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

// class ChartData {
//   double currChartMaxDepth;
//   double currChartMaxPressure;
//   double drillMaxDepth;
//   double drillCurrStDepth;
//   double drillBarWidth;
//   double currPressureBarWidth;
//   double fixedChartMaxDepth;

//   String wc;
//   Color pressureBarColor;

//   double drillLastStDepth = 0;
//   double lastPressureBarWidth = 0;
//   double minXpressureBarWidth = 0;
//   double maxXpressureBarWidth = 0;
//   double lastChartMaxDepth = 0;
//   double lastChartMaxPressure = 0;
//   double depthChangeThreshold = 1;
//   double pressureChangeThreshold = 2;

//   List<LineChartBarData> listLineChartData = [];
//   List<List> saveStList = [];

//   bool isPressureChage = false;
//   bool isUpdateDepthData = false;

//   ChartData(
//       {this.currChartMaxDepth,
//       this.currChartMaxPressure,
//       this.drillMaxDepth,
//       this.drillCurrStDepth,
//       this.drillBarWidth,
//       this.currPressureBarWidth,
//       this.wc,
//       this.pressureBarColor,
//       this.fixedChartMaxDepth});

// void _updateThreshold() {
//   if (currChartMaxDepth != lastChartMaxDepth) {
//     depthChangeThreshold =
//         double.parse((currChartMaxDepth / 50).toStringAsFixed(3));
//   }
//   if (currChartMaxPressure != lastChartMaxPressure) {
//     pressureChangeThreshold =
//         double.parse((currChartMaxPressure / 100).toStringAsFixed(3));
//     lastChartMaxPressure = currChartMaxPressure;
//   }
// }

// void _updatePressureBarWidth() {
//   double _pressureChange = double.parse(
//       (currPressureBarWidth - lastPressureBarWidth).toStringAsFixed(3));
//   if (_pressureChange.abs() >= pressureChangeThreshold) {
//     isPressureChage = true;
//     lastPressureBarWidth = currPressureBarWidth;
//     // Calculate a new lineChart minX and maxX
//     minXpressureBarWidth =
//         (currChartMaxPressure / 2 - currPressureBarWidth / 2);
//     maxXpressureBarWidth =
//         (currChartMaxPressure / 2 + currPressureBarWidth / 2);
//     // print("_updatePressureBarWidth : change pressure");
//   }
// }

// void _updatePressureBarColor() {
//   if (wc == "cement") {
//     pressureBarColor = kColorCement;
//   } else {
//     pressureBarColor = kColorWater;
//   }
// }

// void _addToSaveStList(
//   double _drillCurrStDepth,
//   double _drillLastStDepth,
//   double _minXpressureBarWidth,
//   double _maxXpressureBarWidth,
//   Color _pressureBarColor,
//   double _currChartMaxDepth,
// ) {
//   saveStList.add([
//     _drillCurrStDepth,
//     _drillLastStDepth,
//     _minXpressureBarWidth,
//     _maxXpressureBarWidth,
//     _pressureBarColor,
//     _currChartMaxDepth,
//   ]);
// }

// void _reloadChartFromSaveStList() {
//   int _saveStListLength = saveStList.length;
//   listLineChartData = [];
//   for (int i = 0; i < _saveStListLength; i++) {
//     _updateListLineChartData(
//       saveStList[i][0],
//       saveStList[i][1],
//       saveStList[i][2],
//       saveStList[i][3],
//       saveStList[i][4],
//       currChartMaxDepth,
//       depthChangeThreshold,
//     );
//   }
// }

// LineChartBarData _lineChartData(
//   double _drillCurrStDepth,
//   double _minXpressureBarWidth,
//   double _maxXpressureBarWidth,
//   Color _pressureBarColor,
//   double _currChartMaxDepth,
//   double _lineWidth,
//   double _depthChangeThreshold,
// ) {
//   return LineChartBarData(
//     spots: [
//       FlSpot(_minXpressureBarWidth,
//           _drillCurrStDepth * (fixedChartMaxDepth / _currChartMaxDepth)),
//       FlSpot(_maxXpressureBarWidth,
//           _drillCurrStDepth * (fixedChartMaxDepth / _currChartMaxDepth)),
//     ],
//     isCurved: false,
//     colors: [
//       _pressureBarColor,
//     ],
//     barWidth: (_depthChangeThreshold *
//             (fixedChartMaxDepth / currChartMaxDepth) *
//             kLineWidthChangeDepth) /
//         fixedChartMaxDepth,
//     isStrokeCapRound: false,
//     dotData: FlDotData(
//       show: false,
//     ),
//     belowBarData: BarAreaData(
//       show: false,
//     ),
//   );
// }

// void _addToListLineChartData(
//   double _currentGraphDepth,
//   double _minXpressureBarWidth,
//   double _maxXpressureBarWidth,
//   Color _pressureBarColor,
//   double _currChartMaxDepth,
//   double _lineWidth,
//   double _depthChangeThreshold,
// ) {
//   listLineChartData.add(_lineChartData(
//     _currentGraphDepth,
//     _minXpressureBarWidth,
//     _maxXpressureBarWidth,
//     _pressureBarColor,
//     _currChartMaxDepth,
//     _lineWidth,
//     _depthChangeThreshold,
//   ));
// }

// void _updateListLineChartData(
//   double _drillCurrStDepth,
//   double _drillLastStDepth,
//   double _minXpressureBarWidth,
//   double _maxXpressureBarWidth,
//   Color _pressureBarColor,
//   double _currChartMaxDepth,
//   double _depthChangeThreshold,
// ) {
//   double _lineWidth;
//   double _currentGraphDepth;
//   double _stDepthDiff;
//   _stDepthDiff = double.parse(
//       (_drillCurrStDepth - _drillLastStDepth).toStringAsFixed(3));
//   int _numberOfLineChart;
//   // print("_stDepthDiff = "+_stDepthDiff.toString());
//   if (_stDepthDiff.abs() >= _depthChangeThreshold) {
//     if (_stDepthDiff > 0) {
//       //drill forward
//       _currentGraphDepth = _drillLastStDepth + (_depthChangeThreshold / 2);
//       // round up numberOfLine
//       _numberOfLineChart = (_stDepthDiff / (_depthChangeThreshold)).ceil();
//       for (var i = 0; i < _numberOfLineChart; i++) {
//         _addToListLineChartData(
//           _currentGraphDepth,
//           _minXpressureBarWidth,
//           _maxXpressureBarWidth,
//           _pressureBarColor,
//           _currChartMaxDepth,
//           _lineWidth,
//           _depthChangeThreshold,
//         );
//         _currentGraphDepth = _currentGraphDepth + (_depthChangeThreshold);
//       }
//       if (isUpdateDepthData == true) {
//         _addToSaveStList(
//           _drillCurrStDepth,
//           _drillLastStDepth,
//           _minXpressureBarWidth,
//           _maxXpressureBarWidth,
//           _pressureBarColor,
//           _currChartMaxDepth,
//         );
//       }
//       // print("_updateListLineChartData : _stDepthDiff > 0");
//     } else if (_stDepthDiff < 0) {
//       //drill backward
//       _currentGraphDepth = _drillLastStDepth - (_depthChangeThreshold / 2);
//       // round up numberOfLine
//       _numberOfLineChart = (-(_stDepthDiff) / (_depthChangeThreshold)).ceil();
//       for (var i = 0; i < _numberOfLineChart; i++) {
//         _addToListLineChartData(
//           _currentGraphDepth,
//           _minXpressureBarWidth,
//           _maxXpressureBarWidth,
//           _pressureBarColor,
//           _currChartMaxDepth,
//           _lineWidth,
//           _depthChangeThreshold,
//         );
//         _currentGraphDepth = _currentGraphDepth - (_depthChangeThreshold);
//       }
//       if (isUpdateDepthData == true) {
//         _addToSaveStList(
//           _drillCurrStDepth,
//           _drillLastStDepth,
//           _minXpressureBarWidth,
//           _maxXpressureBarWidth,
//           _pressureBarColor,
//           _currChartMaxDepth,
//         );
//       }
//     }
//     // print("_updateListLineChartData : _stDepthDiff < 0");
//   } else if (_stDepthDiff.abs() < _depthChangeThreshold  && (isPressureChage == true)) {
//     _reloadChartFromSaveStList();
//     _lineWidth = kLineWidthChangePressure;
//     _currentGraphDepth = _drillCurrStDepth;
//     listLineChartData.add(
//       _lineChartData(
//         _currentGraphDepth,
//         _minXpressureBarWidth,
//         _maxXpressureBarWidth,
//         _pressureBarColor,
//         _currChartMaxDepth,
//         _lineWidth,
//         _depthChangeThreshold,
//       ),
//     );
//     // print("_updateListLineChartData : _stDepthDiff =0 and change pressure");
//   }
// }

// void _updateDrillMaxDepth() {
//   if (drillMaxDepth <= drillCurrStDepth) {
//     drillMaxDepth = drillCurrStDepth;
//   } else {
//     drillMaxDepth = drillMaxDepth;
//   }
// }

// void _updateChartFromDrillDepth() {
//   double _depthChange =
//       double.parse((drillCurrStDepth - drillLastStDepth).toStringAsFixed(3));
//   if (_depthChange.abs() >= depthChangeThreshold) {
//     isUpdateDepthData = true;
//     _updateDrillMaxDepth();
//     _updateListLineChartData(
//       drillCurrStDepth,
//       drillLastStDepth,
//       minXpressureBarWidth,
//       maxXpressureBarWidth,
//       pressureBarColor,
//       currChartMaxDepth,
//       depthChangeThreshold,
//     );
//     drillLastStDepth = drillCurrStDepth;
//     // print("_updateChartFromDrillDepth : change depth");
//   } else {
//     isUpdateDepthData = false;
//     _updateListLineChartData(
//       drillCurrStDepth,
//       drillLastStDepth,
//       minXpressureBarWidth,
//       maxXpressureBarWidth,
//       pressureBarColor,
//       currChartMaxDepth,
//       depthChangeThreshold,
//     );
//     // print("_updateChartFromDrillDepth : not change depth");
//   }
// }

// void _updateChartData() {
//   int _saveStListLength = saveStList.length;
//   // currChartMaxDepth has been change
//   if (currChartMaxDepth != lastChartMaxDepth) {
//     // Chart has changed stage before
//     // Scale old chart before add new line chart
//     // Case : User enter new currChartMaxDepth and drillCurrStDepth but old chart has been rendered
//     if (_saveStListLength > 0) {
//       _reloadChartFromSaveStList();
//       _updateChartFromDrillDepth();
//     } else {
//       // currChartMaxDepth has been change but chart hasn't changed stage bafore
//       // Case : User change currChartMaxDepth from default value before plot graph
//       _updateChartFromDrillDepth();
//     }
//     // Update lastChartMaxDepth
//     lastChartMaxDepth = currChartMaxDepth;
//   } else {
//     // currChartMaxDepth hasn't been change
//     // Case : User enter new drillCurrStDepth with default currChartMaxDepth
//     _updateChartFromDrillDepth();
//   }
// }

// void updateChart() {
//   // print("drillLastStDepth = " + drillLastStDepth.toString());
//   // print("lastPressureBarWidth = " + lastPressureBarWidth.toString());
//   _updateThreshold();
//   _updatePressureBarColor();
//   _updatePressureBarWidth();
//   _updateChartData();
//   // reset isPressureChange flag
//   isPressureChage = false;
//   // reset isUpdateDepthData flag
//   isUpdateDepthData = false;
//   print("saveStList.length = " + saveStList.length.toString());
//   print("listLineChartData.length = " + listLineChartData.length.toString());
//   print("drillCurrStDepth = " + drillCurrStDepth.toString());
//   print("currPressureBarWidth = " + currPressureBarWidth.toString());
// }

//   void reset() {
//     currChartMaxDepth = 2;
//     drillMaxDepth = 0;
//     currDrillDepth = 0;
//     drillLastStDepth = 0;
//     drillBarWidth = kDrillBarWidth;
//     currPressureBarWidth = 0;
//     lastPressureBarWidth = 0;
//     listLineChartData = [];
//     wc = "water";
//     pressureBarColor = kColorWater;
//     saveStList = [];
//     isPressureChage = false;
//   }
// }

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

/* Update listLineChartData function */
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
      _reloadOldChartData();
      _addNewDepthChangeLine();
      lastDrillDepth = currDrillDepth;
    } else {
      if (_isUpdatePressureBarWidth == true) {
        _reloadOldChartData();
        _addNewPressureChangeLine();
      }
    }
  }

  void _updateLineChartData() {
    // check scaling chart from chartmaxdepth
    if (_isUpdateChartMaxDepth == true) {
      if (saveStList.length > 0) {
        // Load old chart data before add new line
        _reloadOldChartData();
      }
      _addNewLineChart();
      lastChartMaxDepth = currChartMaxDepth;
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
