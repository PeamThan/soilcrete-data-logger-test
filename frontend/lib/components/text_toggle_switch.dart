import 'package:flutter/material.dart';
import '../models/size_config.dart';
import '../constants.dart';

Container textToggleSwitch({
  @required String title,
  @required String textLeft,
  @required String textRight,
  @required Function onPressed,
  @required List<bool> isSelected,
}) {
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
        ToggleButtons(
          children: <Widget>[
            Container(width: SizeConfig.blockSizeHorizontal * 7.7,
          child: Text(textLeft,style: kTextFieldStyle,
            textAlign: TextAlign.center,)),
            Container(width: SizeConfig.blockSizeHorizontal * 7.7,
          child: Text(textRight,style: kTextFieldStyle,
            textAlign: TextAlign.center,)),
          ],
          onPressed: onPressed,
          isSelected: isSelected,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    ),
  );
}
