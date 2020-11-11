import '../constants.dart';

class SoilcreteProject {
  /* Data ------------------------------------------------------------------- */
  // user defined data from interface
  double _cementPerSoil = 1;
  double _waterPerCement = 1;
  double _strokeMultiplier = 2.365;
  double _maxDepth = kDefaultChartMaxDepth; // metres
  double _maxPressure = kDefaultPressureMaxDepth;
  String _columnName = "";
  String _projectName = "";
  String _projectOwner = "";
  String _projectContractor = "ซอยล์กรีตเทค จำกัด";
  int _samplingRate = 1000; // millisec

  DateTime _startRecordTime;
  DateTime _currentTimestamp;
  String _recordDuration = "0:00:00";

  bool _isPaused = false;
  bool _isRecord = false;
  bool _isStop = true;

  DateTime get currentTimestamp => _currentTimestamp;

  double get maxPressure => _maxPressure;
  set maxPressure(value) {
    if (value < 0)
      _maxPressure = 500;
    else
      _maxPressure = value;
  }

  double get cementPerSoil => _cementPerSoil;
  set cementPerSoil(value) {
    if (value < 0)
      _cementPerSoil = 0;
    else
      _cementPerSoil = value;
  }

  double get waterPerCement => _waterPerCement;
  set waterPerCement(value) {
    if (value < 0)
      _waterPerCement = 0;
    else
      _waterPerCement = value;
  }

  double get strokeMultiplier => _strokeMultiplier;
  set strokeMultiplier(value) {
    if (value < 0)
      _strokeMultiplier = 0;
    else
      _strokeMultiplier = value;
  }

  double get maxDepth => _maxDepth;
  set maxDepth(value) {
    if (value < 0)
      _maxDepth = 0;
    else
      _maxDepth = value;
  }

  String get columnName => _columnName;
  set columnName(givenName) {
    _columnName = givenName;
  }

  String get projectName => _projectName;
  set projectName(givenName) {
    _projectName = givenName;
  }

  String get projectOwner => _projectOwner;
  set projectOwner(givenName) {
    _projectOwner = givenName;
  }

  String get projectContractor => _projectContractor;
  set projectContractor(givenName) {
    _projectContractor = givenName;
  }

  int get samplingRate => _samplingRate;
  set samplingRate(value) {
    if (_samplingRate <= 0)
      _samplingRate = 1;
    else
      _samplingRate = value;
  }

  /* Util ------------------------------------------------------------------- */
  Map<String, dynamic> toMap() {
    /**
     * This function doesn't reflect all the properties of the SoilcreteProject Object
     */
    return {
      'projectName': _projectName,
      'projectOwner': _projectOwner,
      'projectContractor': _projectContractor,
      'cementPerSoil': _cementPerSoil,
      'waterPerCement': _waterPerCement,
      'strokeMultiplier': _strokeMultiplier,
      'maxDepth': _maxDepth,
      'maxPressure': _maxPressure,
      'samplingRate': _samplingRate
    };
  }

  /* Recorder --------------------------------------------------------------- */
  String get recordDuration {
    return _recordDuration;
  }

  bool get isPaused {
    return _isPaused;
  }

  bool get isRecord {
    return _isRecord;
  }

  bool get isStop {
    return _isStop;
  }

  startRecordTime() {
    if (_isRecord == false) {
      _startRecordTime = new DateTime.now();
      _isStop = false;
      _isRecord = true;
      _isPaused = false;
    }
  }

  recordTimer(DateTime currentTime) {
    if (_startRecordTime != null) {
      Duration diff = currentTime.difference(_startRecordTime);
      String duration = diff.toString().split('.')[0];
      if (_isPaused == false && _isStop == false) {
        _recordDuration = duration;
      }
    }
  }

  displayPause() {}
  pauseOrResume() {
    if (_isStop == false) _isPaused = !_isPaused;
  }

  reset() {
    _recordDuration = "0:00:00";
    _isStop = true;
    _isPaused = false;
    _isRecord = false;
    // reset to default value
    // _cementPerSoil = 1;
    // _waterPerCement = 1;
    // _strokeMultiplier = 1;
    // _maxDepth = 20; // metres
    // _maxPressure = 1000;
    // _columnName = "";
    // _projectName = "";
    // _projectOwner = "";
    // _projectContractor = "";
    // _samplingRate = 1000; // millisec
  }
}
