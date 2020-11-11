import 'package:flutter/material.dart';
import '../models/size_config.dart';

class DateAndTime extends StatelessWidget {

String timeString;

DateAndTime({@required this.timeString});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 1.56,
          vertical: SizeConfig.blockSizeVertical * 2,
        ),
        child: Text(
          timeString,
          textAlign: TextAlign.center,
          // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.blockSizeHorizontal * 1.95),
        ),
      ),
    );
  }
}

// // Listen change with stateful
//   void _getTime() {
//     final DateTime now = DateTime.now();
//     final String formattedDateTime =
//     DateFormat('MM/dd/yyyy hh:mm:ss').format(now);
//     // setState(() {
//     _timeString.value = formattedDateTime;
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: SizeConfig.blockSizeHorizontal * 1.56,
//           vertical: SizeConfig.blockSizeVertical * 2.43,
//         ),
//         child:ValueListenableBuilder(valueListenable: _timeString,
//         builder: (_, value, __) => Text(
//           value,
//           textAlign: TextAlign.center,
//           // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
//           style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: SizeConfig.blockSizeHorizontal * 1.95),
//         ),),
//       ),
//     );
//   }
// }