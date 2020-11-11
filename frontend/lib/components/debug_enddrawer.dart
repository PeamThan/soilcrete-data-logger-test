import 'package:flutter/material.dart';

import './name_text_field.dart';
import './text_toggle_switch.dart';

import '../constants.dart';
import '../models/size_config.dart';

class DebugEndDrawer extends StatelessWidget {
  final Function translateI18N;
  final Function onPressedUpdateChartFromDebug;
  final Function onPressedUpdateChartFromSerial;
  final Function onPressedUpdateChartFromTestData;
  final Function onPressedResetChart;
  final Function onPressedToggleWC;
  final Function onPressedToggleDP;


  final List<bool> selectionsWC;
  final List<bool> selectionsDP;


  Map<String, dynamic> debugInput;
  Map<String, dynamic> testDataInput;

  DebugEndDrawer({
    @required this.translateI18N,
    @required this.onPressedUpdateChartFromDebug,
    @required this.onPressedUpdateChartFromSerial,
    @required this.onPressedUpdateChartFromTestData,
    @required this.onPressedResetChart,
    @required this.onPressedToggleWC,
    @required this.onPressedToggleDP,
    @required this.selectionsWC,
    @required this.selectionsDP,
    @required this.debugInput,
    @required this.testDataInput,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: SizeConfig.blockSizeHorizontal * 50, //39.06,
        child: Drawer(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: SizeConfig.blockSizeVertical * 6.71,
                color: Colors.blue,
                child: Center(
                    child: Text(
                  translateI18N("debug_window"),
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 1.56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockSizeVertical * 0.3,
                  horizontal: SizeConfig.blockSizeHorizontal * 1.56,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  translateI18N("debug_input"),
                  style: kBoldTextStyle,
                ),
              ),
              textToggleSwitch(
                title: translateI18N("water_or_cement") + " : ",
                onPressed: onPressedToggleWC,
                isSelected: selectionsWC,
                textLeft: translateI18N("water"),
                textRight: translateI18N("cement"),
              ),
              nameTextField(
                title: translateI18N("chart_maxpressure"),
                unit: translateI18N("bar"),
                defaultValue: debugInput['currChartMaxPressureValue'],
                onChanged: (value) {
                  debugInput['currChartMaxPressureValue'] = value.toString();
                },
              ),
              nameTextField(
                title: translateI18N("chart_maxdepth"),
                unit: translateI18N("metre"),
                defaultValue: debugInput['currChartMaxDepthValue'],
                onChanged: (value) {
                  debugInput['currChartMaxDepthValue'] = value.toString();
                },
              ),
              // nameTextField(
              //   title: translateI18N("water_or_cement"),
              //   unit: "",
              //   defaultValue: debugInput['wcValue'],
              //   onChanged: (value) {
              //     debugInput['wcValue'] = value.toString();
              //   },
              // ),
              nameTextField(
                title: translateI18N("pressure"),
                unit: translateI18N("bar"),
                defaultValue: debugInput['currPressureBarWidthValue'],
                onChanged: (value) {
                  debugInput['currPressureBarWidthValue'] = value.toString();
                },
              ),
              nameTextField(
                title: translateI18N("depth"),
                unit: translateI18N("metre"),
                defaultValue: debugInput['currDrillDepthValue'],
                onChanged: (value) {
                  debugInput['currDrillDepthValue'] = value.toString();
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockSizeVertical * 0.3,
                  horizontal: SizeConfig.blockSizeHorizontal * 1.56,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  translateI18N("testdata_input"),
                  style: kBoldTextStyle,
                ),
              ),
                            textToggleSwitch(
                title: translateI18N("test_mode") + " : ",
                onPressed: onPressedToggleDP,
                isSelected: selectionsDP,
                textLeft: translateI18N("depth"),
                textRight: translateI18N("pressure"),
              ),
              // nameTextField(
              //   title: translateI18N("test_mode"),
              //   unit: "",
              //   defaultValue: testDataInput['testMode'],
              //   onChanged: (value) {
              //     testDataInput['testMode'] = value.toString();
              //   },
              // ),
              nameTextField(
                title: translateI18N("chart_maxpressure"),
                unit: translateI18N("bar"),
                defaultValue: testDataInput['testDataChartMaxPressure'],
                onChanged: (value) {
                  testDataInput['testDataChartMaxPressure'] = value.toString();
                },
              ),
              nameTextField(
                title: translateI18N("chart_maxdepth"),
                unit: translateI18N("metre"),
                defaultValue: testDataInput['testDataChartMaxDepth'],
                onChanged: (value) {
                  testDataInput['testDataChartMaxDepth'] = value.toString();
                },
              ),
              nameTextField(
                title: translateI18N("maximum_drilled_depth"),
                unit: translateI18N("metre"),
                defaultValue: testDataInput['testDataDrillMaxDepth'],
                onChanged: (value) {
                  testDataInput['testDataDrillMaxDepth'] = value.toString();
                },
              ),
              nameTextField(
                title: translateI18N("test_interval_number"),
                unit: translateI18N("intervals"),
                defaultValue: testDataInput['testDataIntervalNum'],
                onChanged: (value) {
                  testDataInput['testDataIntervalNum'] = value.toString();
                },
              ),
              nameTextField(
                title: translateI18N("test_min_pressure"),
                unit: translateI18N("bar"),
                defaultValue: testDataInput['testDataMinPressure'],
                onChanged: (value) {
                  testDataInput['testDataMinPressure'] = value.toString();
                },
              ),
              nameTextField(
                title: translateI18N("test_max_pressure"),
                unit: translateI18N("bar"),
                defaultValue: testDataInput['testDataMaxPressure'],
                onChanged: (value) {
                  testDataInput['testDataMaxPressure'] = value.toString();
                },
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 19,
                child: RaisedButton(
                  onPressed: onPressedUpdateChartFromDebug,
                  child: Text(translateI18N("update_chart_from_debug")),
                  color: Colors.blue[50],
                  elevation: 3,
                ),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 19,
                child: RaisedButton(
                  onPressed: onPressedUpdateChartFromTestData,
                  child: Text(translateI18N("update_chart_from_test_data")),
                  color: Colors.blue[50],
                  elevation: 3,
                ),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 19,
                child: RaisedButton(
                  onPressed: onPressedUpdateChartFromSerial,
                  child: Text(translateI18N("update_chart_from_serial")),
                  color: Colors.blue[50],
                  elevation: 3,
                ),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 19,
                child: RaisedButton(
                  onPressed: onPressedResetChart,
                  child: Text(translateI18N("reset_chart")),
                  color: Colors.red[100],
                  elevation: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
