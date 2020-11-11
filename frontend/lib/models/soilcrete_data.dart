import 'dart:io';
import 'dart:convert';
import 'dart:core';

class SoilcreteData {
  /* Data ------------------------------------------------------------------- */
  // raw data from sensor
  double _depth = 0;
  double _drill = 0;
  double _pressure = 0;
  double _stroke = 0;
  String _wc = "water";

  // calculated data
  double _cementAmount = 0;
  double _flowRate = 0;

  // environment data
  DateTime _dt = DateTime.now();

  double get depth => _depth;
  double get drill => _drill;
  double get pressure => _pressure;
  double get stroke => _stroke;
  String get wc => _wc;
  double get cementAmount => _cementAmount;
  double get flowRate => _flowRate;
  DateTime get dt => _dt;

  /* USB Serial Caller ------------------------------------------------------ */
  void calculateFlowRate(double strokeMult) {
    _flowRate = _stroke * strokeMult;
  }

  void calculateCement(double waterPerCement, double flowRate) {
    double cementRate;
    DateTime now;
    Duration timeDifference;
    int timeDifferenceMilliseconds;
    double addedCement;

    cementRate = 3.1 / (waterPerCement * 3.1 + 1);

    // calculate time difference from the last time data was updated
    now = DateTime.now();
    timeDifference = now.difference(_dt);
    timeDifferenceMilliseconds = timeDifference.inMilliseconds;

    // calculate added cement
    addedCement = flowRate * cementRate * timeDifferenceMilliseconds / 60000;
    // print(timeDifferenceMilliseconds);

    // accumulate cement amount
    _cementAmount += addedCement;
  }

  void updateData(String jsonString, double strokeMult, double waterPerCement) {
    /**
     * @param jsonString: JSON String which is from the Serial
     */
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // update data from sensor
    _depth = double.parse(jsonData['depth']);
    _drill = double.parse(jsonData['drill']);
    _pressure = double.parse(jsonData['pressure']);
    _stroke = double.parse(jsonData['stroke']);
    _wc = jsonData['wc'];

    // calculate flow rate
    calculateFlowRate(strokeMult);

    // calculate cement when cement is applied
    if (_wc == "cement") calculateCement(waterPerCement, _flowRate);

    // update time
    _dt = DateTime.now();
  }

  Future<String> getSerialData(
      [String scriptPath = './reader.py',
      String pythonVersion = 'python3']) async {
    // Function to get data from USB Serial by calling a local python script
    ProcessResult res = await Process.run(pythonVersion, [scriptPath]);

    return res.stdout;
  }

  Future<void> printRawData() async {
    String rawString = await getSerialData();
    print(rawString);
  }
}
