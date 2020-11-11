import 'package:flutter/material.dart';

import './name_text_field.dart';
import '../models/size_config.dart';
import '../constants.dart';

class ProjectInformation extends StatelessWidget {
  final bool isRecord;
  final bool isEditProjectInfo;
  final Function translateI18N;
  final Function onPressedEditButton;
  final Function onPressedCancelButton;
  final Function onPressedSubmitButton;

  Map<String, dynamic> tempProjectInfoInput;

  ProjectInformation({
    @required this.isRecord,
    @required this.isEditProjectInfo,
    @required this.translateI18N,
    @required this.onPressedEditButton,
    @required this.onPressedCancelButton,
    @required this.onPressedSubmitButton,
    @required this.tempProjectInfoInput,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.safeBlockVertical * 60,
      width: SizeConfig.safeBlockHorizontal * 50,
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.blockSizeVertical * 1.5,
        horizontal: SizeConfig.blockSizeHorizontal * 1.54,
      ),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translateI18N("project_information"),
                  style: kBoldTextStyle,
                ),
                Visibility(
                  visible: !isRecord,
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    tooltip: translateI18N("edit_project_information"),
                    onPressed: onPressedEditButton,
                  ),
                ),
              ],
            ),
            width: double.infinity,
            height: SizeConfig.blockSizeVertical * 6,
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 1.5,
          ),
          nameTextField(
              enabled: isEditProjectInfo,
              title: translateI18N("project_name") + " : ",
              unit: "",
              defaultValue: tempProjectInfoInput['projectName'],
              onChanged: (value) {
                tempProjectInfoInput['projectName'] = value;
              }),
          nameTextField(
              enabled: isEditProjectInfo,
              title: translateI18N("project_owner") + " : ",
              unit: "",
              defaultValue: tempProjectInfoInput['projectOwner'],
              onChanged: (value) {
                tempProjectInfoInput['projectOwner'] = value;
              }),
          nameTextField(
              enabled: isEditProjectInfo,
              title: translateI18N("project_contractor") + " : ",
              unit: "",
              defaultValue: tempProjectInfoInput['projectContractor'],
              onChanged: (value) {
                tempProjectInfoInput['projectContractor'] = value;
              }),
          nameTextField(
              enabled: isEditProjectInfo,
              title: translateI18N("column_name") + " : ",
              unit: "",
              defaultValue: tempProjectInfoInput['columnName'],
              onChanged: (value) {
                tempProjectInfoInput['columnName'] = value;
              }),
          // nameTextField(
          //     enabled: isEditProjectInfo,
          //     title: translateI18N("cement_per_soil") + " : ",
          //     unit: "",
          //     defaultValue: tempProjectInfoInput['cementPerSoil'].toString(),
          //     onChanged: (value) {
          //       tempProjectInfoInput['cementPerSoil'] = value;
          //     }),
          // nameTextField(
          //     enabled: isEditProjectInfo,
          //     title: translateI18N("water_per_cement") + " : ",
          //     unit: "",
          //     defaultValue: tempProjectInfoInput['waterPerCement'].toString(),
          //     onChanged: (value) {
          //       tempProjectInfoInput['waterPerCement'] = value;
          //     }),
          // nameTextField(
          //     enabled: isEditProjectInfo,
          //     title: translateI18N("chart_maxdepth") + " : ",
          //     unit: translateI18N("metre"),
          //     defaultValue: tempProjectInfoInput['maxDepth'].toString(),
          //     onChanged: (value) {
          //       tempProjectInfoInput['maxDepth'] = value;
          //     }),
          // nameTextField(
          //     enabled: isEditProjectInfo,
          //     title: translateI18N("sampling_rate") + " : ",
          //     unit: translateI18N("milliseconds"),
          //     defaultValue: tempProjectInfoInput['samplingRate'].toString(),
          //     onChanged: (value) {
          //       tempProjectInfoInput['samplingRate'] = value;
          //     }),
          Visibility(
            visible: isEditProjectInfo,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  child: Row(
                    children: [
                      Text(
                        translateI18N("cancel"),
                        style: kNormalTextStyle,
                      ),
                      Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 30.0,
                      ),
                    ],
                  ),
                  onPressed: onPressedCancelButton,
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 1,
                ),
                RaisedButton(
                  child: Row(
                    children: [
                      Text(
                        translateI18N("submit"),
                        style: kNormalTextStyle,
                      ),
                      Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 30.0,
                      ),
                    ],
                  ),
                  onPressed: onPressedSubmitButton,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
