import '../constants.dart';
import 'package:flutter/material.dart';
import '../models/size_config.dart';

Container nameTextField({
  @required String title,
  @required Function onChanged,
  bool enabled = true,
  String defaultValue,
  String unit,
}) {
  var _textFieldStyle = kTextFieldStyle;
  if (!enabled) _textFieldStyle = kTextFieldStyleDisabled;

  return Container(
    margin: EdgeInsets.symmetric(
      vertical: SizeConfig.blockSizeVertical * 0.3,
      horizontal: SizeConfig.blockSizeHorizontal * 1.56,
    ),
    height: SizeConfig.blockSizeVertical * 4,
    child: Row(
      children: <Widget>[
        Container(
          width: SizeConfig.blockSizeHorizontal * 16,
          child: Text(
            title,
            style: kTextFieldStyle,
          ),
        ),
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 15.62,
          child: TextField(
            enabled: enabled,
            controller: new TextEditingController.fromValue(
              new TextEditingValue(
                text: defaultValue,
                selection:
                    new TextSelection.collapsed(offset: defaultValue.length),
              ),
            ),
            style: _textFieldStyle,
            textAlign: TextAlign.right,
            onChanged: onChanged,
            decoration: kTextFieldEditProfileDecoration,
          ),
        ),
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 1,
        ),
                Container(
          width: SizeConfig.blockSizeHorizontal * 10,
          child: Text(
            unit,
            style: kTextFieldStyle,
          ),
        ),
      ],
    ),
  );
}
