import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/size_config.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.title, this.color, @required this.onPressed, this.icon});

  final Color color;
  final String title;
  final Function onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1.17),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: SizeConfig.blockSizeHorizontal * 6,
          height: SizeConfig.blockSizeVertical * 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              if (title != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                      // vertical: SizeConfig.blockSizeVertical * 1.46,
                      // horizontal: SizeConfig.blockSizeHorizontal * 0.93),
                      vertical: SizeConfig.blockSizeVertical * 0,
                      horizontal: SizeConfig.blockSizeHorizontal * 0),
                  child: Text(
                    title,
                    style: kTextStyle,
                  ),
                ),
              icon != null ? icon : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
