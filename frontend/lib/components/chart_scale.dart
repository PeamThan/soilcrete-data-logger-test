import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../constants.dart';
import '../models/size_config.dart';
import 'dart:math';

class ChartScale extends StatelessWidget {
  final double fixChartMaxDepth;
  final double currChartMaxDepth;
  final double currChartMaxPressure;
  final double drillMaxDepth;
  final double currDrillDepth;
  final double drillBarWidth;
  final List<LineChartBarData> listLineChartData;
  final Color drillColor;

  ChartScale(
      {@required this.currChartMaxDepth,
      @required this.currChartMaxPressure,
      @required this.drillMaxDepth,
      @required this.currDrillDepth,
      @required this.drillBarWidth,
      @required this.listLineChartData,
      @required this.drillColor,
      @required this.fixChartMaxDepth});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical * 45,
      // width: SizeConfig.blockSizeHorizontal * 50,
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.blockSizeVertical * 1,),
          // horizontal: SizeConfig.blockSizeHorizontal * 1.5),
      child: Transform.rotate(
        angle: pi,
        child: Stack(
          children: [
            LineChart(
              LineChartData(
                  lineTouchData: LineTouchData(
                    enabled: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: SideTitles(
                      showTitles: false,
                    ),
                    bottomTitles: SideTitles(
                      showTitles: false,
                    ),
                    leftTitles: SideTitles(
                      showTitles: false,
                    ),
                    rightTitles: SideTitles(
                      showTitles: true,
                      textStyle: TextStyle(
                          color: Colors.transparent,
                          fontSize: SizeConfig.blockSizeHorizontal * 1.2),
                      rotateAngle: 180,
                      getTitles: (double value) {
                        return (value * (currChartMaxDepth / fixChartMaxDepth))
                            .toString();
                      },
                      interval: fixChartMaxDepth / 4,
                      margin: SizeConfig.blockSizeHorizontal * 0.3,
                      reservedSize: SizeConfig.blockSizeHorizontal * 5,//3.13,
                    ),
                  ),
                  gridData: FlGridData(
                    show: false,
                    horizontalInterval: 0.001,
                    checkToShowHorizontalLine: (value) {
                      value = double.parse((value).toStringAsFixed(3));
                      if (value % (fixChartMaxDepth / 8) == 0) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    getDrawingHorizontalLine: (value) {
                      value = double.parse((value).toStringAsFixed(3));
                      if (value % (fixChartMaxDepth / 4) == 0) {
                        return FlLine(
                          color: kColorHorizontalLine,
                          strokeWidth: kStrokeWidthThickHorizontalLine,
                        );
                      } else {
                        return FlLine(
                          color: kColorHorizontalLine,
                          strokeWidth: kStrokeWidthThinHorizontalLine,
                        );
                      }
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.transparent,
                        width: SizeConfig.blockSizeVertical * 0.24,
                      ),
                      left: BorderSide(
                        color: Colors.transparent,
                      ),
                      right: BorderSide(
                        color: Colors.transparent,
                      ),
                      top: BorderSide(
                        color: Colors.transparent,
                        width: SizeConfig.blockSizeVertical * 0.24,
                      ),
                    ),
                  ),
                  minX: 0,
                  maxX: currChartMaxPressure,
                  maxY: fixChartMaxDepth,
                  minY: 0,
                  lineBarsData: listLineChartData),
            ),
            BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  enabled: false,
                ),
                alignment: BarChartAlignment.center,
                minY: 0,
                maxY: fixChartMaxDepth,
                groupsSpace: 0,
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: SideTitles(
                    showTitles: false,
                  ),
                  bottomTitles: SideTitles(
                    showTitles: false,
                  ),
                  leftTitles: SideTitles(
                    showTitles: false,
                  ),
                  rightTitles: SideTitles(
                    showTitles: true,
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.blockSizeHorizontal * 1.2),
                    rotateAngle: 180,
                    getTitles: (double value) {
                      return (value * (currChartMaxDepth / fixChartMaxDepth))
                          .toString();
                    },
                    interval: fixChartMaxDepth / 4,
                    margin: SizeConfig.blockSizeHorizontal * 0.3,
                    reservedSize: SizeConfig.blockSizeHorizontal * 5,//3.13,
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 0.001,
                  checkToShowHorizontalLine: (value) {
                    value = double.parse((value).toStringAsFixed(3));
                    if (value % (fixChartMaxDepth / 8) == 0) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  getDrawingHorizontalLine: (value) {
                    value = double.parse((value).toStringAsFixed(3));
                    if (value % (fixChartMaxDepth / 4) == 0) {
                      return FlLine(
                        color: kColorHorizontalLine,
                        strokeWidth: kStrokeWidthThickHorizontalLine,
                      );
                    } else {
                      return FlLine(
                        color: kColorHorizontalLine,
                        strokeWidth: kStrokeWidthThinHorizontalLine,
                      );
                    }
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: SizeConfig.blockSizeVertical * 0.24,
                    ),
                    left: BorderSide(
                      color: Colors.transparent,
                    ),
                    right: BorderSide(
                      color: Colors.transparent,
                    ),
                    top: BorderSide(
                      color: Colors.black,
                      width: SizeConfig.blockSizeVertical * 0.24,
                    ),
                  ),
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barsSpace: 0,
                    barRods: [
                      BarChartRodData(
                        color: kColorDrillWall,
                        y: drillMaxDepth *
                            (fixChartMaxDepth / currChartMaxDepth),
                        width: SizeConfig.blockSizeHorizontal * 0.39,
                        borderRadius: kBarChartRodDataBorderRadius,
                      ),
                      BarChartRodData(
                        color: Colors.black,
                        y: drillMaxDepth *
                            (fixChartMaxDepth / currChartMaxDepth),
                        width: drillBarWidth,
                        borderRadius: kBarChartRodDataBorderRadius,
                        rodStackItems: [
                          BarChartRodStackItem(
                              0,
                              currDrillDepth *
                                  (fixChartMaxDepth / currChartMaxDepth),
                              drillColor),
                        ],
                      ),
                      BarChartRodData(
                        color: kColorDrillWall,
                        y: drillMaxDepth *
                            (fixChartMaxDepth / currChartMaxDepth),
                        width: SizeConfig.blockSizeHorizontal * 0.39,
                        borderRadius: kBarChartRodDataBorderRadius,
                      ),
                    ],
                  ),
                ],
              ),
              swapAnimationDuration: kBarChartSwapAnimationDuration,
            ),
          ],
        ),
      ),
    );
  }
}
