import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../models/size_config.dart';

onAlertNotification({context, title, onChanged, defaultValue,onPressed}) {
  Alert(
    content: TextField(
            controller: new TextEditingController.fromValue(
                new TextEditingValue(
                    text: defaultValue,
                    selection: new TextSelection.collapsed(
                        offset: defaultValue.length))),
            style: kNormalTextStyle,
            textAlign: TextAlign.right,
            onChanged: onChanged,
            decoration: kTextFieldEditProfileDecoration,
            keyboardType: TextInputType.number,
            
          ),
    context: context,
    title: title,
    buttons: [
        DialogButton(
          child: Text(
            "Enter",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: onPressed,
          width: SizeConfig.blockSizeHorizontal * 9.375,
        )
      ],
  ).show();
}