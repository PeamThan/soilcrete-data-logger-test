import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/size_config.dart';

class DataContainer extends StatelessWidget {
  DataContainer(
      {this.bgColor,
      this.textColor,
      @required this.name,
      @required  this.data,
      @required  this.unit,
      this.onPressed});
   Color bgColor = Colors.white;
   Color textColor = Colors.black;
  final String name;
  final String data;
  final String unit;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: SizeConfig.blockSizeHorizontal * 11.72,
        height: SizeConfig.blockSizeVertical * 18.28,
        margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1, horizontal: SizeConfig.blockSizeHorizontal * 0.77),
        padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1, horizontal: SizeConfig.blockSizeHorizontal * 0.77),
        decoration: BoxDecoration(
          color: bgColor,
        ),
        child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: onPressed,
          child: Column(
            children: <Widget>[
              Container(
                height: SizeConfig.blockSizeVertical * 4.88,
                child: Text(
                  name,
                  style: kNormalTextStyle.copyWith(color: textColor),
                ),
              ),
              Container(
                height: SizeConfig.blockSizeVertical * 6.09,
                child: Text(
                  data,
                  style: kDataTextStyle.copyWith(color: textColor),
                ),
              ),
              Container(
                height: SizeConfig.blockSizeVertical * 4.88,
                child: Text(
                  unit,
                  style: kNormalTextStyle.copyWith(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
