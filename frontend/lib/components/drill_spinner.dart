import 'package:flutter/material.dart';
import '../models/size_config.dart';
import '../constants.dart';

class DrillSpinner extends StatefulWidget {
  final int duration;
  // final bool isAnimationPause;

  DrillSpinner({
    Key key,
    this.duration,
  }) : super(key: key);

  @override
  _DrillSpinnerState createState() => _DrillSpinnerState();
}

class _DrillSpinnerState extends State<DrillSpinner>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  bool _isAnimationChangeColor = true;
  double _kPositionDrillSpinnerStart = 0;
  var _isBuildanimation = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    // // init animation controller
    _animationController = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    );

    //   // // init animation controller
    // _animationController = AnimationController(
    //   duration: Duration(milliseconds: 1000),
    //   vsync: this,
    // );

    // init animation
    // change color of drillspinner after animation finish then repeat animation
    _animation = _animationController
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          // print("completed");
          _isAnimationChangeColor = !_isAnimationChangeColor;
          _isBuildanimation.value = !_isBuildanimation.value;
          _animationController.reset();
        } else if (state == AnimationStatus.dismissed) {
          // print("dismissed");
          _isBuildanimation.value = !_isBuildanimation.value;
          _animationController.forward();
        }
      });
    _animationController.forward();
  }

  @override
  void didUpdateWidget(DrillSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationController.duration = Duration(milliseconds: widget.duration);
    // print("_animationController.duration = " + _animationController.duration.toString());
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: SizeConfig.blockSizeVertical *
              kPositionDrillComponentSpinnerHeight,
          width: SizeConfig.blockSizeHorizontal *
              4 *
              kPositionDrillComponentSpinnerWidth,
        ),
        ValueListenableBuilder(
          valueListenable: _isBuildanimation,
          builder: (_, value, __) => Positioned(
            left: SizeConfig.blockSizeHorizontal * _kPositionDrillSpinnerStart,
            child: Container(
              height: SizeConfig.blockSizeVertical *
                  kPositionDrillComponentSpinnerHeight,
              width: SizeConfig.blockSizeHorizontal *
                  (kPositionDrillComponentSpinnerWidth),
              color: _isAnimationChangeColor == true
                  ? kColorDrillSpinner1
                  : kColorDrillSpinner2,
              child: Row(
                children: [
                  buildSizeTransitionWidget(
                    controller: _animationController,
                    widget: Container(
                      height: SizeConfig.blockSizeVertical *
                          kPositionDrillComponentSpinnerHeight,
                      width: SizeConfig.blockSizeHorizontal *
                          kPositionDrillComponentSpinnerWidth,
                      color: _isAnimationChangeColor == true
                          ? kColorDrillSpinner2
                          : kColorDrillSpinner1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _isBuildanimation,
          builder: (_, value, __) => Positioned(
            left: SizeConfig.blockSizeHorizontal *
                (_kPositionDrillSpinnerStart +
                    kPositionDrillComponentSpinnerWidth),
            child: Container(
              height: SizeConfig.blockSizeVertical *
                  kPositionDrillComponentSpinnerHeight,
              width: SizeConfig.blockSizeHorizontal *
                  kPositionDrillComponentSpinnerWidth,
              color: _isAnimationChangeColor == true
                  ? kColorDrillSpinner2
                  : kColorDrillSpinner1,
              child: Row(
                children: [
                  buildSizeTransitionWidget(
                    controller: _animationController,
                    widget: Container(
                      height: SizeConfig.blockSizeVertical *
                          kPositionDrillComponentSpinnerHeight,
                      width: SizeConfig.blockSizeHorizontal *
                          kPositionDrillComponentSpinnerWidth,
                      color: _isAnimationChangeColor == true
                          ? kColorDrillSpinner1
                          : kColorDrillSpinner2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _isBuildanimation,
          builder: (_, value, __) => Positioned(
            left: SizeConfig.blockSizeHorizontal *
                (_kPositionDrillSpinnerStart +
                    2 * kPositionDrillComponentSpinnerWidth),
            child: Container(
              height: SizeConfig.blockSizeVertical *
                  kPositionDrillComponentSpinnerHeight,
              width: SizeConfig.blockSizeHorizontal *
                  kPositionDrillComponentSpinnerWidth,
              color: _isAnimationChangeColor == true
                  ? kColorDrillSpinner1
                  : kColorDrillSpinner2,
              child: Row(
                children: [
                  buildSizeTransitionWidget(
                    controller: _animationController,
                    widget: Container(
                      height: SizeConfig.blockSizeVertical *
                          kPositionDrillComponentSpinnerHeight,
                      width: SizeConfig.blockSizeHorizontal *
                          kPositionDrillComponentSpinnerWidth,
                      color: _isAnimationChangeColor == true
                          ? kColorDrillSpinner2
                          : kColorDrillSpinner1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _isBuildanimation,
          builder: (_, value, __) => Positioned(
            left: SizeConfig.blockSizeHorizontal *
                (_kPositionDrillSpinnerStart +
                    3 * kPositionDrillComponentSpinnerWidth),
            child: Container(
              height: SizeConfig.blockSizeVertical *
                  kPositionDrillComponentSpinnerHeight,
              width: SizeConfig.blockSizeHorizontal *
                  kPositionDrillComponentSpinnerWidth,
              color: _isAnimationChangeColor == true
                  ? kColorDrillSpinner2
                  : kColorDrillSpinner1,
              child: Row(
                children: [
                  buildSizeTransitionWidget(
                    controller: _animationController,
                    widget: Container(
                      height: SizeConfig.blockSizeVertical *
                          kPositionDrillComponentSpinnerHeight,
                      width: SizeConfig.blockSizeHorizontal *
                          kPositionDrillComponentSpinnerWidth,
                      color: _isAnimationChangeColor == true
                          ? kColorDrillSpinner1
                          : kColorDrillSpinner2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSizeTransitionWidget(
      {AnimationController controller, Widget widget}) {
    return AnimatedBuilder(
        animation: controller,
        child: widget,
        builder: (context, child) {
          return SizeTransition(
              axis: Axis.horizontal,
              axisAlignment: 1,
              sizeFactor: _animation,
              child: child);
        });
  }
}
