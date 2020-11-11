import 'package:flutter/material.dart';

import '../models/size_config.dart';

import './name_text_field.dart';
import './text_toggle_switch.dart';

import '../constants.dart';

class SettingEndDrawer extends StatelessWidget {
  final Function translateI18N;
  final bool isEnableDynamicChartMaxDepth;
  final bool isRecord;
  final List<bool> selectionsDynamic;
  final Function onPressedConfirmButton;
  final Function onPressedToggleDynamic;

  Map<String, dynamic> tempProjectInfoInput;

  SettingEndDrawer({
    @required this.translateI18N,
    @required this.isEnableDynamicChartMaxDepth,
    @required this.isRecord,
    @required this.selectionsDynamic,
    @required this.onPressedConfirmButton,
    @required this.onPressedToggleDynamic,
    @required this.tempProjectInfoInput,
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
                  translateI18N("setting_window"),
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
                  translateI18N("setting_input"),
                  style: kBoldTextStyle,
                ),
              ),
              textToggleSwitch(
                title: translateI18N("dynamic_chart_mode") + " : ",
                onPressed: onPressedToggleDynamic,
                isSelected: selectionsDynamic,
                textLeft: translateI18N("on"),
                textRight: translateI18N("off"),
              ),
              nameTextField(
                  enabled: !isRecord && !isEnableDynamicChartMaxDepth,
                  title: translateI18N("cement_per_soil") + " : ",
                  unit: "",
                  defaultValue:
                      tempProjectInfoInput['cementPerSoil'].toString(),
                  onChanged: (value) {
                    tempProjectInfoInput['cementPerSoil'] = value;
                  }),
              nameTextField(
                  enabled: !isRecord && !isEnableDynamicChartMaxDepth,
                  title: translateI18N("water_per_cement") + " : ",
                  unit: "",
                  defaultValue:
                      tempProjectInfoInput['waterPerCement'].toString(),
                  onChanged: (value) {
                    tempProjectInfoInput['waterPerCement'] = value;
                  }),
              nameTextField(
                  enabled: !isRecord && !isEnableDynamicChartMaxDepth,
                  title: translateI18N("chart_maxpressure") + " : ",
                  unit: translateI18N("bar"),
                  defaultValue: tempProjectInfoInput['maxPressure'].toString(),
                  onChanged: (value) {
                    tempProjectInfoInput['maxPressure'] = value;
                  }),
              nameTextField(
                  enabled:!isRecord && !isEnableDynamicChartMaxDepth,
                  title: translateI18N("chart_maxdepth") + " : ",
                  unit: translateI18N("metre"),
                  defaultValue: tempProjectInfoInput['maxDepth'].toString(),
                  onChanged: (value) {
                    tempProjectInfoInput['maxDepth'] = value;
                  }),
              // nameTextField(
              //     enabled: !isRecord,
              //     title: translateI18N("sampling_rate") + " : ",
              //     unit: translateI18N("milliseconds"),
              //     defaultValue: tempProjectInfoInput['samplingRate'].toString(),
              //     onChanged: (value) {
              //       tempProjectInfoInput['samplingRate'] = value;
              //     }),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 19,
                child: RaisedButton(
                  onPressed: onPressedConfirmButton,
                  child: Text(translateI18N("confirm_setting")),
                  color: Colors.blue[50],
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
