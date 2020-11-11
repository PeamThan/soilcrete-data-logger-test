import 'package:flutter/material.dart';

import './data_container.dart';

class DataDisplayBar extends StatelessWidget {
  final double depth;
  final double pressure;
  final double drill;
  final double stroke;
  final double cementAmount;
  final double flowRate;
  
  final Function translateI18N;

  DataDisplayBar({
    @required this.depth,
    @required this.pressure,
    @required this.drill,
    @required this.stroke,
    @required this.cementAmount,
    @required this.flowRate,
    @required this.translateI18N,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          DataContainer(
            name: translateI18N("depth"),
            bgColor: Colors.white,
            textColor: Colors.black,
            data: depth.toStringAsFixed(2),
            unit: translateI18N("metre"),
          ),
          DataContainer(
            name: translateI18N("pressure"),
            bgColor: Colors.white,
            textColor: Colors.black,
            data: pressure.toStringAsFixed(2),
            unit: translateI18N("bar"),
          ),
          DataContainer(
            name: translateI18N("drill"),
            bgColor: Colors.white,
            textColor: Colors.black,
            data: drill.toStringAsFixed(2),
            unit: translateI18N("rpm"),
          ),
          DataContainer(
            name: translateI18N("stroke"),
            bgColor: Colors.white,
            textColor: Colors.black,
            data: stroke.toStringAsFixed(2),
            unit: translateI18N("rpm"),
          ),
          DataContainer(
            name: translateI18N("cement"),
            bgColor: Colors.white,
            textColor: Colors.black,
            data: cementAmount.toStringAsFixed(2),
            unit: translateI18N("kgs"),
          ),
          DataContainer(
            name: translateI18N("flow_rate"),
            bgColor: Colors.white,
            textColor: Colors.black,
            data: flowRate.toStringAsFixed(2),
            unit: translateI18N("lt_per_min"),
          ),
        ],
      ),
    );
  }
}
