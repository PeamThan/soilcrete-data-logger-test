import '../constants.dart';
import 'package:flutter/material.dart';
import '../models/size_config.dart';

Padding bottomSheetTextField({
  @required String title,
  @required Function onChanged,
  String defaultValue,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 2.43, horizontal: SizeConfig.blockSizeHorizontal * 3.12),
    child: Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              child: Container(
                width: SizeConfig.blockSizeHorizontal * 11.71,
                child: Text(
                  title,
                  style: kTextStyle,
                ),
              ),
              alignment: Alignment.bottomLeft,
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 1.21,
          width: SizeConfig.blockSizeHorizontal * 1.56,
        ),
        Container(
          width: SizeConfig.blockSizeHorizontal * 15.62,
          child: TextFormField(
            initialValue: defaultValue,
            // child: TextField(
            //   controller: TextEditingController()..text = defaultValue,
            onChanged: onChanged,
            decoration: kTextFieldEditProfileDecoration.copyWith(),
          ),
        ),
      ],
    )),
  );
}
