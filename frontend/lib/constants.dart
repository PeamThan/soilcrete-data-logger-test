import 'package:flutter/material.dart';
import './models/size_config.dart';

var kTitleTextStyle = TextStyle(
  // fontSize: 30.0,
  fontSize: SizeConfig.blockSizeHorizontal * 2.34,
  fontWeight: FontWeight.w600,
);

var kTitleTextStyleRed = TextStyle(
  // fontSize: 30.0,
  fontSize: SizeConfig.blockSizeHorizontal * 2.34,
  fontWeight: FontWeight.w600,
  color: Colors.red
);

var kNormalTextStyle = TextStyle(
  // fontSize: 25.0,
  fontSize: SizeConfig.blockSizeHorizontal * 1.95,
  fontWeight: FontWeight.w400,
);

var kTextFieldStyle = TextStyle(
  // fontSize: 25.0,
  fontSize: SizeConfig.blockSizeHorizontal * 1.5,
  fontWeight: FontWeight.w400,
);

var kTextFieldStyleDisabled = TextStyle(
  // fontSize: 25.0,
  fontSize: SizeConfig.blockSizeHorizontal * 1.5,
  fontWeight: FontWeight.w400,
  color: Colors.grey,
);

var kBoldTextStyle = TextStyle(
  // fontSize: 25.0,
  fontSize: SizeConfig.blockSizeHorizontal * 1.95,
  fontWeight: FontWeight.bold,
);

var kDataTextStyle = TextStyle(
  // fontSize: 35.0,
  fontSize: SizeConfig.blockSizeHorizontal * 2.73,
  fontWeight: FontWeight.bold,
);

var kTextFieldEditProfileDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(
      vertical: SizeConfig.blockSizeVertical * 3,
      horizontal: SizeConfig.blockSizeHorizontal * 0.77),
  border: OutlineInputBorder(),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.grey, width: SizeConfig.blockSizeHorizontal * 0.078),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.grey, width: SizeConfig.blockSizeHorizontal * 0.156),
  ),
);

var kRecordContianer = BoxDecoration(
  color: Colors.grey,
  // borderRadius: BorderRadius.circular(20),
);

var kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(
        color: Colors.lightBlueAccent,
        width: SizeConfig.blockSizeHorizontal * 0.156),
  ),
);

var kTextStyle = TextStyle(
  // fontSize: 20.0,
  fontSize: SizeConfig.blockSizeHorizontal * 1.56,
  fontWeight: FontWeight.w700,
);

// chart_scale const
var kColorHorizontalLine = Colors.black87;

var kColorDrillWall = Colors.white;

var kStrokeWidthThinHorizontalLine = SizeConfig.blockSizeVertical * 0.097;

var kStrokeWidthThickHorizontalLine = SizeConfig.blockSizeVertical * 0.243;

var kBarChartRodDataBorderRadius = const BorderRadius.only();

var kBarChartSwapAnimationDuration = const Duration(milliseconds: 100);

// chart_data const
var kDefaultChartMaxDepth = 2.0;

var kDefaultPressureMaxDepth = 500.0;

/*Use to fixed ChartMaxDepth of line chartscale 
for O(1) linechart ploting*/
var kDefaultFixedChartMaxDepth = 10.0; 

var kDefaultWCvalue = "water";

var kColorWater = Colors.blue;

var kColorCement = Colors.grey;

var kDrillBarWidth = SizeConfig.blockSizeHorizontal * 2.37;

var kLineWidthChangeDepth = SizeConfig.blockSizeVertical * 46;//380;

var kLineWidthChangePressure = SizeConfig.blockSizeVertical * 0.6;//5.0;

// Animation const
var kUpdateAnimationDurationThreshold = 5;

var kMaxStroke = 180;

var kDurationSlowestAnimation  = 1000;

var kDurationFastestAnimation  = 100;

var kColorDrillSpinner1 = Colors.black;

var kColorDrillSpinner2 = Colors.orange;

var kPositionDrillSpinnerStart = 23.05;//24.05;//22.05;

var kPositionDrillComponentSpinnerHeight = 5;

var kPositionDrillComponentSpinnerWidth = 2.25;

var kPositionDrillHeadStart = 26.53;//27.55;//25.55;

// Refresh Button const
var kPositionWCstatusStart = 2;

// Refresh Button const
var kPositionRefreshButtonStart = 2;