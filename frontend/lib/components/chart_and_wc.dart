import 'package:flutter/material.dart';

import './chart_scale.dart';
import '../models/size_config.dart';
import '../models/chart_data.dart';
import '../constants.dart';

class ChartAndWC extends StatelessWidget {
  final ChartData chartData;
  final Function translateI18N;
  ChartAndWC({
    @required this.chartData,
    @required this.translateI18N,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: SizeConfig.blockSizeVertical * 60,
          width: SizeConfig.blockSizeHorizontal * 50,
          child: Column(
            children: [
              Container(
                height: SizeConfig.blockSizeVertical * 11,
              ),
              ChartScale(
                currChartMaxDepth: chartData.currChartMaxDepth,
                currChartMaxPressure: chartData.currChartMaxPressure,
                drillMaxDepth: chartData.drillMaxDepth,
                currDrillDepth: chartData.currDrillDepth,
                drillBarWidth: chartData.drillBarWidth,
                listLineChartData: chartData.listLineChartData,
                drillColor: chartData.pressureBarColor,
                fixChartMaxDepth: chartData.fixedChartMaxDepth,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 1.56),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  translateI18N("maximum_drilled_depth") +
                      ' : ' +
                      chartData.drillMaxDepth.toStringAsFixed(2) +
                      ' ' +
                      translateI18N("metre"),
                  style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical * 2.15,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: SizeConfig.blockSizeHorizontal * kPositionDrillHeadStart,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 1.5),
            height: SizeConfig.blockSizeVertical * 12,
            width: kDrillBarWidth,
            color: chartData.pressureBarColor,
          ),
        ),
        Positioned(
          left: SizeConfig.blockSizeHorizontal * 2,
          child: Card(
            elevation: SizeConfig.blockSizeVertical * 1.20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            color: chartData.pressureBarColor,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 1.5),
              height: SizeConfig.blockSizeVertical * 7,
              width: SizeConfig.blockSizeHorizontal * 11,
              child: Center(
                  child: Text(
                chartData.wc == "cement"
                    ? translateI18N("cement")
                    : translateI18N("water"),
                style: kBoldTextStyle,
              )),
            ),
          ),
        ),
      ],
    );
  }
}
