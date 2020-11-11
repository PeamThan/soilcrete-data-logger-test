import 'package:flutter/material.dart';
import './rounded_button.dart';

import '../models/size_config.dart';
import '../constants.dart';

class RecordTimeContainer extends StatelessWidget {
  final bool isEditProjectInfo;
  final bool isRecord;
  final bool isStop;
  final bool isPaused;
  final bool isMounted;

  final String recordDuration;

  final Function translateI18N;
  final Function onPressedStartButton;
  final Function onPressedPauseOrResumeButton;
  final Function onPressedStopButton;

  RecordTimeContainer({
    @required this.isEditProjectInfo,
    @required this.isRecord,
    @required this.isStop,
    @required this.isPaused,
    @required this.recordDuration,
    @required this.translateI18N,
    @required this.onPressedStartButton,
    @required this.onPressedPauseOrResumeButton,
    @required this.onPressedStopButton,
    @required this.isMounted,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        height: SizeConfig.blockSizeVertical * 18.28,
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  translateI18N("record_time") + ": ",
                  style: kBoldTextStyle,
                ),
                Text(
                  recordDuration,
                  style: kNormalTextStyle,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (!isRecord)
                  RoundedButton(
                    // cannot start record if the user is editing the Project Info
                    onPressed: onPressedStartButton,
                    // title: "start",
                    color: (isEditProjectInfo | !isMounted)
                        ? Colors.grey
                        : Colors.blue,
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                    ),
                  ),
                if (isRecord)
                  RoundedButton(
                    onPressed: onPressedPauseOrResumeButton,
                    // title: !_soilcreteData.isPaused ? "pause" : "resume",
                    color: !isStop
                        ? (!isPaused ? Colors.yellow.shade400 : Colors.green)
                        : Colors.grey,
                    icon: !isPaused
                        ? Icon(
                            Icons.pause,
                            color: Colors.black,
                          )
                        : Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                          ),
                  ),
                if (isRecord)
                  SizedBox(
                    width: SizeConfig.safeBlockHorizontal * 1.6,
                  ),
                if (isRecord)
                  RoundedButton(
                    onPressed: onPressedStopButton,
                    // title: "stop",
                    color: Colors.red,
                    icon: Icon(
                      Icons.stop,
                      color: Colors.black,
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
