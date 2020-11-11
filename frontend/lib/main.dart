import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/models/soilcrete_file_writer.dart';
import 'package:frontend/models/string_validator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_is_emulator/flutter_is_emulator.dart';

import 'constants.dart';

import 'components/data_display_bar.dart';
import 'components/record_time_container.dart';
import 'components/project_information.dart';
import 'components/debug_enddrawer.dart';
import 'components/setting_enddrawer.dart';
import 'components/chart_and_wc.dart';
import 'components/drill_spinner.dart';
import 'components/date_and_time.dart';

import 'models/soilcrete_data.dart';
import 'models/size_config.dart';
import 'models/chart_data.dart';
import 'models/soilcrete_project.dart';

// Soilcrete File Writer
SoilcreteFileWriter writer = SoilcreteFileWriter();

void main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
        useCountryCode: false,
        fallbackFile: 'th',
        basePath: 'assets/i18n',
        forcedLocale: Locale('th')),
  );
  WidgetsFlutterBinding.ensureInitialized();

  // connect to usb drive
  try {
    await writer.initUsbMassStorage().timeout(Duration(seconds: 10));
  } catch (err) {
    print("ERROR! Cannot init USB Mass Storage");
    print(err);
  }

  if (writer.isMounted) {
    print("usb drive is mounted.");
  } else {
    print("cannot mount to usb drive.");
  }

  runApp(MyApp(flutterI18nDelegate));
}

class MyApp extends StatelessWidget {
  final FlutterI18nDelegate flutterI18nDelegate;

  MyApp(this.flutterI18nDelegate);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      theme: ThemeData(fontFamily: "Prompt"),
      home: MyHomePage(title: 'SoilCrete Tech Co.,Ltd.'),
      // showPerformanceOverlay: true,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // animation spin duration
  int _animationDuration = kDurationSlowestAnimation;
  int _lastAnimationDuration = 0;
  // bool _isAnimationPause = false;
  // language variable
  Locale currentLang = Locale("th");
  // time string
  DateTime currentTime = new DateTime.now();
  // use to update record duration in RecordTimeContainer
  String lastRecordDuration = "";
  // blink color changing flag
  bool _recordBlink = false;
  //emulator checking flag
  bool _isAnEmulator;
  // input source flag
  bool _isUpdateFromSerial = true;
  bool _isUpdateFromDebug = false;
  bool _isUpdateFromTestData = false;
  // CPU memory full flag
  bool _isListLineChartDataFull = false;
  // Setting or Debug endrawer flag
  bool _isSettingEndrawer = true;
  // Open dynamic chartmaxdepth
  bool _isEnableDynamicChartMaxDepth = true;
  List<bool> selectionsWC = [true, false];
  List<bool> selectionsDP = [true, false];
  List<bool> selectionsDynamic = [true, false];
  // build flag
  ValueNotifier<String> _timeString = ValueNotifier("");
  ValueNotifier<bool> _isBuildChart = ValueNotifier(false);
  ValueNotifier<bool> _isBuildDataDisplayBar = ValueNotifier(false);
  ValueNotifier<bool> _isBuildProjectInformation = ValueNotifier(false);
  ValueNotifier<bool> _isBuildRecordTimeContainer = ValueNotifier(false);
  ValueNotifier<bool> _isBuildRecordTimeBlink = ValueNotifier(false);
  ValueNotifier<bool> _isBuildEndDrawer = ValueNotifier(false);
  ValueNotifier<bool> _isBuildDrillSpinner = ValueNotifier(false);
  // testData
  int _testDataIndex = 0;
  List _testDataDepth = [];
  List _testDataPressure = [];
  List _testDataWC = [];
  Map<String, dynamic> _testDataInput = {
    // Store test data input
    "testMode": "depth",
    "testDataChartMaxDepth": kDefaultChartMaxDepth.toString(),
    "testDataChartMaxPressure": kDefaultPressureMaxDepth.toString(),
    "testDataDrillMaxDepth": "20",
    "testDataMinPressure": "190",
    "testDataMaxPressure": "210",
    "testDataIntervalNum": "50",
  };
  // open endrawer button
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> _debugInput = {
    // Store debug input
    "currDrillDepthValue": "15",
    "currChartMaxDepthValue": kDefaultChartMaxDepth.toString(),
    "currChartMaxPressureValue": kDefaultPressureMaxDepth.toString(),
    "currPressureBarWidthValue": "250",
    "wcValue": kDefaultWCvalue,
  };
  // project info
  SoilcreteData _soilcreteData = SoilcreteData();
  SoilcreteProject _soilcreteProject = SoilcreteProject();
  bool _isEditProjectInfo = false;
  Map<String, dynamic> _tempProjectInfoInput = {
    // Temporary store current project info
    "projectName": "",
    "projectOwner": "",
    "projectContractor": "ซอยล์กรีตเทค จำกัด",
    "columnName": "",
    "cementPerSoil": "",
    "waterPerCement": "",
    "strokeMultiplier": "",
    "maxDepth": "",
    "maxPreesure": "",
    "samplingRate": ""
  };
  // Chart
  ChartData _chartData = ChartData(
    currChartMaxDepth: kDefaultChartMaxDepth,
    currChartMaxPressure: kDefaultPressureMaxDepth,
    drillMaxDepth: 0,
    currDrillDepth: 0,
    currPressureBarWidth: 0,
    pressureBarColor: kColorWater,
    fixedChartMaxDepth: kDefaultFixedChartMaxDepth,
  );

  @override
  void initState() {
    // detect using emulator or not
    // _detectEmulator();
    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    // get default Project information
    loadProjectInfo();

    // get default Setting information
    loadSetting();

    // set recorder blink duration
    Timer.periodic(Duration(milliseconds: 1000), (Timer t2) => _blinkRecord());

    // set data sampling rate
    _soilcreteProject.samplingRate = 1000;
    Timer.periodic(Duration(milliseconds: _soilcreteProject.samplingRate),
        (Timer t) => _initFunc());

    super.initState();

    // Fail drive mounting alert
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // writer.setVirtualDriveMount();
      print("Mounting status: " + writer.isMounted.toString());
      if (!writer.isMounted) {
        _showErrDialog(_translateI18N("warning"),
            _translateI18N("fail_drive_mounting_alert"));
      }
    });
  }

  void _initFunc() async {
    /* This function triggers every <defined> ms */
    currentLang = FlutterI18n.currentLocale(context);
    _soilcreteProject.recordTimer(DateTime.now());
    _getTime();

    /* Collect Data from Sensor */
    try {
      // get data from serial
      String _soilcreteDataJsonString = await _soilcreteData
          .getSerialData()
          .timeout(Duration(milliseconds: 2000));

      // update soilcrete data
      _soilcreteData.updateData(_soilcreteDataJsonString,
          _soilcreteProject.strokeMultiplier, _soilcreteProject.waterPerCement);
      _updateAnimationDuration();
      // print("_animationDuration" + _animationDuration.toString());
      // build DataDisplayBar by change this flag
      _buildDataDisplayBar();
      if (_isUpdateFromSerial == true) {
        _updateChartDataFromSerialInput();
      }
    } catch (err) {
      print("Flutter cannot communicate with Serial.");
      print(err);
    }

    // write data point to file
    if (_soilcreteProject.isRecord &&
        !_soilcreteProject.isPaused &&
        writer.isMounted) {
      await writer.writeDataPoint(_soilcreteData);
    }

    /*Loop update ChartData with Data from testData*/
    if (_isUpdateFromTestData == true) {
      if (_testDataIndex <
          (2 * int.parse(_testDataInput["testDataIntervalNum"]))) {
        _updateChartDataFromTestData();
        _testDataIndex += 1;
        print("Current data number is " + _testDataIndex.toString());
      } else {
        /* down and up test version */
        _resetTestDataInput();
        /* loop test version */
        // _testDataIndex = 0;
      }
    }

    /*Rebuild Record time container when record time has change*/
    if (_soilcreteProject.isRecord == true &&
        _soilcreteProject.isPaused == false) {
      if (_soilcreteProject.recordDuration != lastRecordDuration) {
        // rebuild RecordTimeContainer
        _buildRecordTimeContainer();
        // rebuild Blink Icon
        _buildRecordTimeBlink();
        lastRecordDuration = _soilcreteProject.recordDuration;
      }
    } else {
      lastRecordDuration = "";
    }
  }

  Future<bool> _loadData() async {
    SizeConfig().init(context);
    _chartData.drillBarWidth = kDrillBarWidth;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // fixed value for debug
    _isAnEmulator = true;
    return FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Container(child: Text(widget.title)),
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 31.25,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: ValueListenableBuilder(
                          valueListenable: _isBuildRecordTimeBlink,
                          builder: (_, value, __) => Icon(
                            Icons.fiber_manual_record,
                            color:
                                _recordBlink == true ? Colors.red : Colors.blue,
                            size: SizeConfig.safeBlockHorizontal * 2.34,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  // open debug drawer button
                  if (_isAnEmulator == true)
                    IconButton(
                      onPressed: () {
                        _isSettingEndrawer = false;
                        _openEndDrawer();
                      },
                      tooltip: _translateI18N("debug_window"),
                      icon: Icon(Icons.bug_report),
                      iconSize: 30,
                    ),

                  // open setting drawer button
                  IconButton(
                    onPressed: () {
                      _isSettingEndrawer = true;
                      _openEndDrawer();
                    },
                    tooltip: _translateI18N("setting_window"),
                    icon: Icon(Icons.settings),
                    iconSize: 30,
                  ),
                  // action button
                  if (currentLang.languageCode == "th")
                    FlatButton(
                      child: Container(
                        child: Text("EN"),
                      ),
                      onPressed: () {
                        setState(() {
                          _changeLanguage('en');
                        });
                      },
                    ),
                  if (currentLang.languageCode == "en")
                    FlatButton(
                      child: Container(
                        child: Text("ไทย"),
                      ),
                      onPressed: () {
                        setState(() {
                          _changeLanguage('th');
                        });
                      },
                    ),
                ],
              ),
              body: SafeArea(
                child: ListView(
                  children: <Widget>[
                    /* Date and time Panel ------------------------------------------ */
                    ValueListenableBuilder(
                      valueListenable: _timeString,
                      builder: (_, value, __) => DateAndTime(
                        timeString: value,
                      ),
                    ),
                    Container(
                      height: SizeConfig.blockSizeVertical * 60,
                      child: Row(
                        children: [
                          /* Left Graph and animation Panel ------------------------- */
                          Stack(
                            children: [
                              ValueListenableBuilder(
                                valueListenable: _isBuildChart,
                                builder: (_, value, __) => ChartAndWC(
                                  chartData: _chartData,
                                  translateI18N: _translateI18N,
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable: _isBuildDrillSpinner,
                                builder: (_, value, __) => Positioned(
                                  top: SizeConfig.blockSizeVertical * 5,
                                  left: SizeConfig.blockSizeHorizontal *
                                      kPositionDrillSpinnerStart,
                                  child: DrillSpinner(
                                    duration: _animationDuration,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: SizeConfig.blockSizeVertical * 2.5,
                                right: SizeConfig.blockSizeHorizontal *
                                    kPositionRefreshButtonStart,
                                child: IconButton(
                                  onPressed: () {
                                    confirmDialog(
                                        context,
                                        _translateI18N("warning"),
                                        _translateI18N("reset_chart_alert"),
                                        _confirmResetChart);
                                  },
                                  tooltip: _translateI18N("reset_chart"),
                                  icon: Icon(Icons.refresh),
                                  iconSize: 30,
                                ),
                              ),
                            ],
                          ),
                          /* Right Constants Panel ---------------------------------- */
                          ValueListenableBuilder(
                            valueListenable: _isBuildProjectInformation,
                            builder: (_, value, __) => ProjectInformation(
                              isRecord: _soilcreteProject.isRecord,
                              isEditProjectInfo: _isEditProjectInfo,
                              translateI18N: _translateI18N,
                              onPressedEditButton: () {
                                // click edit icon to edit project info
                                _isEditProjectInfo = true;
                                // load current project info into a temp var
                                loadProjectInfo();
                              },
                              onPressedCancelButton: () {
                                _isEditProjectInfo = false;
                                loadProjectInfo();
                              },
                              onPressedSubmitButton: () {
                                _isEditProjectInfo = false;
                                try {
                                  // validate project info
                                  if (Validator.hasSpecialChar(
                                          _tempProjectInfoInput[
                                              'projectName']) |
                                      Validator.hasSpecialChar(
                                          _tempProjectInfoInput[
                                              'columnName'])) {
                                    _showErrDialog(
                                      _translateI18N("invalid_name"),
                                      _translateI18N("invalid_name_alert"),
                                    );
                                    loadProjectInfo();
                                  } else {
                                    saveProjectInfo();

                                    // rebuild RecordTimeContainer
                                    _buildRecordTimeContainer();
                                  }
                                } catch (err) {
                                  if (err.runtimeType == FormatException) {
                                    _showErrDialog("Invalid Input!",
                                        "Please enter only decimal value.");
                                  } else {
                                    _showErrDialog(
                                        "Error!", "Unknown error occurred.");
                                  }
                                  loadProjectInfo();
                                  print(err);
                                }
                              },
                              tempProjectInfoInput: _tempProjectInfoInput,
                            ),
                          ),
                        ],
                      ),
                    ),
                    /* Bottom DataDisplayBar and RecordTimeContainer ---------------- */
                    Row(
                      children: <Widget>[
                        ValueListenableBuilder(
                          valueListenable: _isBuildDataDisplayBar,
                          builder: (_, value, __) => DataDisplayBar(
                            depth: _soilcreteData.depth,
                            pressure: _soilcreteData.pressure,
                            drill: _soilcreteData.drill,
                            stroke: _soilcreteData.stroke,
                            cementAmount: _soilcreteData.cementAmount,
                            flowRate: _soilcreteData.flowRate,
                            translateI18N: _translateI18N,
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _isBuildRecordTimeContainer,
                          builder: (_, value, __) => RecordTimeContainer(
                            isMounted: writer.isMounted,
                            isEditProjectInfo: _isEditProjectInfo,
                            isRecord: _soilcreteProject.isRecord,
                            isStop: _soilcreteProject.isStop,
                            isPaused: _soilcreteProject.isPaused,
                            recordDuration: _soilcreteProject.recordDuration,
                            translateI18N: _translateI18N,
                            onPressedStartButton: (_isEditProjectInfo |
                                    !writer.isMounted)
                                ? () {
                                    _showErrDialog(
                                        _translateI18N("warning"),
                                        _translateI18N(
                                            "fail_drive_mounting_alert"));
                                  }
                                : () async {
                                    if (_tempProjectInfoInput['projectName'] !=
                                            "" &&
                                        _tempProjectInfoInput['columnName'] !=
                                            "") {
                                      // check for project directory existence
                                      if (writer.checkProjectColumnExistence(
                                          _soilcreteProject.columnName,
                                          DateTime.now())) {
                                        print("Column file existed.");

                                        recordConfirmDialog(
                                          context,
                                          _translateI18N("warning"),
                                          _translateI18N(
                                              "choose_append_overwrite_alert"),
                                          _confirmRecord,
                                        );

                                        _buildProjectInformation();
                                      } else {
                                        // create column file

                                        try {
                                          await writer.createColumnFile(
                                              _soilcreteProject,
                                              DateTime.now());

                                          _soilcreteProject.startRecordTime();

                                          // rebuild RecordTimeContainer
                                          _buildRecordTimeContainer();
                                          _buildProjectInformation();
                                        } catch (err) {
                                          _showErrDialog(
                                              _translateI18N("error"),
                                              _translateI18N(
                                                  "invalid_column_name_alert"));
                                        }
                                      }
                                    } else {
                                      _showErrDialog(
                                        _translateI18N("empty_feild"),
                                        _translateI18N("empty_feild_alert"),
                                      );
                                    }
                                  },
                            onPressedPauseOrResumeButton: () {
                              _soilcreteProject.pauseOrResume();
                              _recordBlink = false;
                              // rebuild RecordTimeContainer
                              _buildRecordTimeContainer();
                              // rebuild RecordTimeBlink
                              _buildRecordTimeBlink();
                            },
                            onPressedStopButton: () {
                              _soilcreteProject.reset();
                              loadProjectInfo();
                              _chartData.resetChart();
                              // rebuild chart
                              _buildChart();
                              // rebuild RecordTimeContainer
                              _buildRecordTimeContainer();
                              _recordBlink = false;
                              // rebuild RecordTimeBlink
                              _buildRecordTimeBlink();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              endDrawer: ValueListenableBuilder(
                valueListenable: _isBuildEndDrawer,
                builder: (_, value, __) => _isSettingEndrawer == true
                    ? SettingEndDrawer(
                        isEnableDynamicChartMaxDepth:
                            _isEnableDynamicChartMaxDepth,
                        isRecord: _soilcreteProject.isRecord,
                        translateI18N: _translateI18N,
                        onPressedToggleDynamic: (int index) {
                          if (index == 0) {
                            selectionsDynamic[0] = true;
                            selectionsDynamic[1] = false;
                            _isEnableDynamicChartMaxDepth = true;
                          } else {
                            selectionsDynamic[0] = false;
                            selectionsDynamic[1] = true;
                            _isEnableDynamicChartMaxDepth = false;
                          }
                          _buildEndDrawer();
                        },
                        selectionsDynamic: selectionsDynamic,
                        onPressedConfirmButton: () {
                          saveSetting();
                          _updateChartDataFromSettingInput();
                        },
                        tempProjectInfoInput: _tempProjectInfoInput,
                      )
                    : DebugEndDrawer(
                        onPressedToggleWC: (int index) {
                          if (index == 0) {
                            selectionsWC[0] = true;
                            selectionsWC[1] = false;
                            _debugInput['wcValue'] = "water";
                          } else {
                            selectionsWC[0] = false;
                            selectionsWC[1] = true;
                            _debugInput['wcValue'] = "cement";
                          }
                          _buildEndDrawer();
                        },
                        selectionsWC: selectionsWC,
                        onPressedToggleDP: (int index) {
                          if (index == 0) {
                            selectionsDP[0] = true;
                            selectionsDP[1] = false;
                            _testDataInput['testMode'] = "depth";
                          } else {
                            selectionsDP[0] = false;
                            selectionsDP[1] = true;
                            _testDataInput['testMode'] = "pressure";
                          }
                          _buildEndDrawer();
                        },
                        selectionsDP: selectionsDP,
                        translateI18N: _translateI18N,
                        onPressedUpdateChartFromDebug:
                            _updateChartDataFromDebugInput,
                        onPressedUpdateChartFromSerial:
                            _updateChartDataFromSerialInput,
                        onPressedUpdateChartFromTestData:
                            _updateChartDataFromTestData,
                        onPressedResetChart: () {
                          _isUpdateFromSerial = false;
                          _resetDebugInput();
                          _resetTestDataInput();
                          _resetSelectionWCList();
                          _resetSelectionDPList();
                          _chartData.resetChart();
                          // rebuild chart
                          _buildChart();
                          // rebuild Blink Icon
                          _buildEndDrawer();
                        },
                        debugInput: _debugInput,
                        testDataInput: _testDataInput,
                      ),
              ),
              // Disable opening the end drawer with a swipe gesture.
              endDrawerEnableOpenDragGesture: false,
            );
          }
        });
  }

  void _buildChart() {
    _isBuildChart.value = !_isBuildChart.value;
  }

  void _buildDataDisplayBar() {
    _isBuildDataDisplayBar.value = !_isBuildDataDisplayBar.value;
  }

  void _buildProjectInformation() {
    _isBuildProjectInformation.value = !_isBuildProjectInformation.value;
  }

  void _buildRecordTimeContainer() {
    _isBuildRecordTimeContainer.value = !_isBuildRecordTimeContainer.value;
  }

  void _buildRecordTimeBlink() {
    _isBuildRecordTimeBlink.value = !_isBuildRecordTimeBlink.value;
  }

  void _buildEndDrawer() {
    _isBuildEndDrawer.value = !_isBuildEndDrawer.value;
  }

  void _buildDrillSpinner() {
    _isBuildDrillSpinner.value = !_isBuildDrillSpinner.value;
  }

  void _blinkRecord() {
    if (_soilcreteProject.isRecord && !_soilcreteProject.isPaused) {
      _recordBlink = !_recordBlink;
    } else {
      _recordBlink = false;
    }
  }

  _confirmRecord(BuildContext context, int confirmation) async {
    switch (confirmation) {
      case 0: // append
        {
          print("Continuing writing file...");

          _soilcreteProject.startRecordTime();
          _buildProjectInformation();
        }
        break;

      case 1: // overwrite
        {
          print("Overwriting begins. Creating column file...");

          // create column file
          await writer.createColumnFile(_soilcreteProject, DateTime.now());
          _soilcreteProject.startRecordTime();
          _buildProjectInformation();
        }
        break;

      default: // cancel
        {
          print("Record is canceled.");
        }
        break;
    }

    Navigator.pop(context);
  }

  _confirmResetChart(BuildContext context, bool confirmation) async {
    if (confirmation) {
      print("Reset Chart data...");
      _chartData.resetChart();
      _buildChart();
      _isListLineChartDataFull = false;
    } else {
      print("Chart data is not reset.");
      _isListLineChartDataFull = false;
    }

    Navigator.pop(context);
  }

  _confirmOverwrite(BuildContext context, bool confirmation) async {
    if (confirmation) {
      // create column file
      await writer.createColumnFile(_soilcreteProject, DateTime.now());
      _soilcreteProject.startRecordTime();
      _buildProjectInformation();
    } else {
      print("record is canceled");
    }

    // double pop the dialogs
    Navigator.pop(context);
    Navigator.pop(context);
  }

  _confirmOverwriteDialog() {
    confirmDialog(context, _translateI18N("warning"),
        _translateI18N("column_already_exist_alert"), _confirmOverwrite);
  }

  recordConfirmDialog(
      BuildContext context, String title, String msg, Function confirm) {
    // set up the buttons
    Widget cancelButton = RaisedButton(
      child: Row(
        children: [
          Text(
            _translateI18N("cancel"),
            style: kNormalTextStyle,
          ),
          Icon(
            Icons.cancel,
            color: Colors.red,
            size: 30.0,
          ),
        ],
      ),
      onPressed: () async {
        await confirm(context, 2);
      },
    );
    Widget overwriteButton = RaisedButton(
      child: Row(
        children: [
          Text(
            _translateI18N("overwrite"),
            style: kNormalTextStyle,
          ),
          Icon(
            Icons.error,
            color: Colors.orange,
            size: 30.0,
          ),
        ],
      ),
      onPressed: () async {
        // await confirm(context, 1);
        await _confirmOverwriteDialog();
      },
    );
    Widget continueButton = RaisedButton(
      child: Row(
        children: [
          Text(
            _translateI18N("continue"),
            style: kNormalTextStyle,
          ),
          Icon(
            Icons.check,
            color: Colors.green,
            size: 30.0,
          ),
        ],
      ),
      onPressed: () async {
        await confirm(context, 0);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        title,
        style: kTitleTextStyleRed,
      ),
      content: Text(
        msg,
        style: kNormalTextStyle,
      ),
      actions: [
        cancelButton,
        overwriteButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  confirmDialog(
      BuildContext context, String title, String msg, Function conifirm) {
    // set up the buttons
    Widget cancelButton = RaisedButton(
      child: Row(
        children: [
          Text(
            _translateI18N("cancel"),
            style: kNormalTextStyle,
          ),
          Icon(
            Icons.cancel,
            color: Colors.red,
            size: 30.0,
          ),
        ],
      ),
      onPressed: () async {
        await conifirm(context, false);
      },
    );
    Widget continueButton = RaisedButton(
      child: Row(
        children: [
          Text(
            _translateI18N("continue"),
            style: kNormalTextStyle,
          ),
          Icon(
            Icons.check,
            color: Colors.green,
            size: 30.0,
          ),
        ],
      ),
      onPressed: () async {
        await conifirm(context, true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        title,
        style: kTitleTextStyleRed,
      ),
      content: Text(
        msg,
        style: kNormalTextStyle,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _showErrDialog(String errTitle, String errMsg) async {
    /**
     * @description Shows an error dialog box provided title and message
     * @param errTitle<String>: Error Title
     * @param errMsg<String>: Error Message
     */
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                errTitle,
                style: kTitleTextStyleRed,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  errMsg,
                  style: kNormalTextStyle,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Row(
                children: [
                  Text(
                    _translateI18N("ok"),
                    style: kNormalTextStyle,
                  ),
                  Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 30.0,
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  void loadProjectInfo() {
    /**
     * Load project info into a temporary variable for display
     * tempProjInfo <-- load -- soilcreteProject
     */
    _tempProjectInfoInput['projectName'] = _soilcreteProject.projectName;
    _tempProjectInfoInput['projectOwner'] = _soilcreteProject.projectOwner;
    _tempProjectInfoInput['projectContractor'] =
        _soilcreteProject.projectContractor;
    _tempProjectInfoInput['columnName'] = _soilcreteProject.columnName;

    // rebuild ProjectInformation
    _buildProjectInformation();
  }

  void saveProjectInfo() {
    /**
     * Save project info into the original before submit
     * soilcreteProject <-- load -- tempProjInfo
     */
    _soilcreteProject.projectName = _tempProjectInfoInput['projectName'];
    _soilcreteProject.projectOwner = _tempProjectInfoInput['projectOwner'];
    _soilcreteProject.projectContractor =
        _tempProjectInfoInput['projectContractor'];
    _soilcreteProject.columnName = _tempProjectInfoInput['columnName'];

    // Refresh data after save
    loadProjectInfo();
  }

  void loadSetting() {
    _tempProjectInfoInput['cementPerSoil'] =
        _soilcreteProject.cementPerSoil.toString();
    _tempProjectInfoInput['waterPerCement'] =
        _soilcreteProject.waterPerCement.toString();
    _tempProjectInfoInput['strokeMultiplier'] =
        _soilcreteProject.strokeMultiplier.toString();
    _tempProjectInfoInput['maxPressure'] =
        _soilcreteProject.maxPressure.toString();
    _tempProjectInfoInput['maxDepth'] = _soilcreteProject.maxDepth.toString();
    _tempProjectInfoInput['samplingRate'] =
        _soilcreteProject.samplingRate.toString();

    _buildEndDrawer();
  }

  void saveSetting() {
    _soilcreteProject.cementPerSoil =
        roundDouble(double.parse(_tempProjectInfoInput['cementPerSoil']), 2);
    print(_soilcreteProject.cementPerSoil);
    _soilcreteProject.waterPerCement =
        double.parse(_tempProjectInfoInput['waterPerCement']);
    _soilcreteProject.strokeMultiplier =
        double.parse(_tempProjectInfoInput['strokeMultiplier']);
    _soilcreteProject.maxDepth =
        double.parse(_tempProjectInfoInput['maxDepth']);
    _soilcreteProject.maxPressure =
        double.parse(_tempProjectInfoInput['maxPressure']);
    _soilcreteProject.samplingRate =
        int.parse(_tempProjectInfoInput['samplingRate']);

    loadSetting();
  }

  void _checkLengthListLinechartData() {
    if (_chartData.listLineChartData.length > 2000) {
      _isListLineChartDataFull = true;
      confirmDialog(
        context,
        _translateI18N("warning"),
        _translateI18N("cpu_memory_full_alert"),
        _confirmResetChart,
      );
    }
  }

  void _updateChartDataFromSettingInput() {
    _chartData.currChartMaxDepth = _soilcreteProject.maxDepth;
    _chartData.currChartMaxPressure = _soilcreteProject.maxPressure;
    //rebuild chart
    _buildChart();
  }

  void _updateChartDataFromSerialInput() {
    // stage change from Debug to Serial input
    // clear chart from Debug input
    if (_isUpdateFromSerial == false) {
      _isUpdateFromSerial = true;
      _isUpdateFromTestData = false;
      _isUpdateFromDebug = false;
      _chartData.resetChart();
    }
    if (_isListLineChartDataFull == false) {
      // check length of listLineChart is over 2000 entry or not
      _checkLengthListLinechartData();
      // update chartData
      _chartData.currDrillDepth = _soilcreteData.depth;
      _chartData.currPressureBarWidth = _soilcreteData.pressure;
      _chartData.wc = _soilcreteData.wc;
      // Check Open dynamic chart flag
      _dynamicChartMaxDepth();
      // Update Chart data
      _chartData.updateChart();
      //rebuild chart
      _buildChart();
    }
  }

  void _updateChartDataFromDebugInput() {
    // change stage from Serial to Debug input
    // clear chart from Serial input
    if (_isUpdateFromDebug == false) {
      _isUpdateFromDebug = true;
      _isUpdateFromSerial = false;
      _isUpdateFromTestData = false;
      _chartData.resetChart();
    }
    if (_isListLineChartDataFull == false) {
      // check length of listLineChart is over 2000 entry or not
      _checkLengthListLinechartData();
      // update chartData
      _chartData.currChartMaxPressure =
          double.parse(_debugInput['currChartMaxPressureValue']);
      _chartData.currChartMaxDepth =
          double.parse(_debugInput['currChartMaxDepthValue']);
      _chartData.currPressureBarWidth =
          double.parse(_debugInput['currPressureBarWidthValue']);
      _chartData.currDrillDepth =
          double.parse(_debugInput['currDrillDepthValue']);
      _chartData.wc = _debugInput['wcValue'];
      _chartData.wc = _debugInput['wcValue'];
      // Check Open dynamic chart flag
      _dynamicChartMaxDepth();
      // Update Chart data
      _chartData.updateChart();
      //rebuild chart
      _buildChart();
    }
  }

  void _createDepthTestData() {
    double _currDepth = 0;
    double _intervalDepth =
        double.parse(_testDataInput["testDataDrillMaxDepth"]) /
            double.parse(_testDataInput["testDataIntervalNum"]);
    double _minPressure = double.parse(_testDataInput["testDataMinPressure"]);
    int _intervalNum = int.parse(_testDataInput["testDataIntervalNum"]);
    int _presureRange = int.parse(_testDataInput["testDataMaxPressure"]) -
        int.parse(_testDataInput["testDataMinPressure"]);
    Random _random = new Random();
    int _randomMax;
    double _randomDouble;
    for (int i = 0; i < (_intervalNum * 2); i++) {
      if (i < _intervalNum) {
        _currDepth += _intervalDepth;
        _testDataWC.add("water");
      } else {
        _currDepth -= _intervalDepth;
        _testDataWC.add("cement");
      }
      _randomMax = _random.nextInt(_presureRange);
      _randomDouble = _random.nextDouble() * _randomMax;
      _testDataDepth.add(_currDepth);
      _testDataPressure.add(_minPressure + _randomDouble);
    }
  }

  void _createPressureTestData() {
    double _currDepth =
        double.parse(_testDataInput["testDataDrillMaxDepth"]) / 2;
    double _minPressure = double.parse(_testDataInput["testDataMinPressure"]);
    int _intervalNum = int.parse(_testDataInput["testDataIntervalNum"]);
    int _presureRange = int.parse(_testDataInput["testDataMaxPressure"]) -
        int.parse(_testDataInput["testDataMinPressure"]);
    Random _random = new Random();
    int _randomMax;
    double _randomDouble;
    for (int i = 0; i < (_intervalNum * 2); i++) {
      if (i % 2 == 0) {
        _testDataWC.add("water");
      } else {
        _testDataWC.add("cement");
      }
      _randomMax = _random.nextInt(_presureRange);
      _randomDouble = _random.nextDouble() * _randomMax;
      _testDataDepth.add(_currDepth);
      _testDataPressure.add(_minPressure + _randomDouble);
    }
  }

  void _updateChartDataFromTestData() {
    if (_isUpdateFromTestData == false) {
      if (_testDataInput['testMode'] == 'depth') {
        _createDepthTestData();
      } else if (_testDataInput['testMode'] == 'pressure') {
        _createPressureTestData();
      }
      _isUpdateFromTestData = true;
      _isUpdateFromDebug = false;
      _isUpdateFromSerial = false;
      _chartData.resetChart();
    }

    if (_isListLineChartDataFull == false) {
      _checkLengthListLinechartData();
      _chartData.currChartMaxPressure =
          double.parse(_testDataInput["testDataChartMaxPressure"]);
      // _chartData.currChartMaxDepth =
      //     double.parse(_testDataInput["testDataChartMaxDepth"]);
      _chartData.currDrillDepth = _testDataDepth[_testDataIndex];
      _chartData.currPressureBarWidth = _testDataPressure[_testDataIndex];
      _chartData.wc = _testDataWC[_testDataIndex];
      // check Open dynamic chart flag
      _dynamicChartMaxDepth();
      // update Chart data
      _chartData.updateChart();
      // rebuild chart
      _buildChart();
    }
  }

  void _dynamicChartMaxDepth() {
    if (_isEnableDynamicChartMaxDepth == true) {
      if (_chartData.currDrillDepth >= _chartData.drillMaxDepth) {
        if (_chartData.currDrillDepth > _chartData.currChartMaxDepth) {
          if (_chartData.currDrillDepth % 2 == 0) {
            _chartData.currChartMaxDepth = _chartData.currDrillDepth + 2;
          } else {
            _chartData.currChartMaxDepth =
                ((_chartData.currDrillDepth ~/ 2) * 2 + 2).toDouble();
          }
        } else if (_chartData.currDrillDepth >=
            (0.8 * _chartData.currChartMaxDepth)) {
          _chartData.currChartMaxDepth = _chartData.currChartMaxDepth + 2;
        }
      }
    } else {
      if (_chartData.drillMaxDepth > _chartData.currChartMaxDepth) {
        if (_chartData.drillMaxDepth % 2 == 0) {
          _chartData.currChartMaxDepth = _chartData.drillMaxDepth + 2;
        } else {
          _chartData.currChartMaxDepth =
              ((_chartData.drillMaxDepth ~/ 2) * 2 + 2).toDouble();
        }
      } else if (_chartData.drillMaxDepth >=
          (0.8 * _chartData.currChartMaxDepth)) {
        _chartData.currChartMaxDepth = _chartData.currChartMaxDepth + 2;
      }
    }
  }

  void _resetDebugInput() {
    _isUpdateFromDebug = false;
    _debugInput["currDrillDepthValue"] = "15";
    _debugInput["currChartMaxPressureValue"] =
        kDefaultPressureMaxDepth.toString();
    _debugInput["currChartMaxDepthValue"] = kDefaultChartMaxDepth.toString();
    _debugInput["currPressureBarWidthValue"] = "500";
    _debugInput["wcValue"] = kDefaultWCvalue;
  }

  void _resetTestDataInput() {
    _isUpdateFromTestData = false;
    _testDataIndex = 0;
    _testDataDepth = [];
    _testDataPressure = [];
    _testDataWC = [];
    _testDataInput["testMode"] = "depth";
    // _testDataInput["testDataChartMaxDepth"] = "5";
    // _testDataInput["testDataDrillMaxDepth"] = "20";
    // _testDataInput["testDataMinPressure"] = "190";
    // _testDataInput["testDataMaxPressure"] = "210";
    // _testDataInput["testDataIntervalNum"] = "50";
  }

  void _resetSelectionWCList() {
    selectionsWC = [true, false];
  }

  void _resetSelectionDPList() {
    selectionsDP = [true, false];
  }

  void _updateAnimationDuration() {
    if (_soilcreteData.stroke < kMaxStroke && _soilcreteData.stroke > 0) {
      _animationDuration =
          ((-(kDurationSlowestAnimation - kDurationFastestAnimation) /
                      kMaxStroke *
                      _soilcreteData.stroke) +
                  (kDurationSlowestAnimation + kDurationFastestAnimation))
              .round();
    } else if (_soilcreteData.stroke == 0) {
      // slowest animation when stroke = 0
      _animationDuration = kDurationSlowestAnimation;
    } else {
      // max speed animation when stroke > kMaxStroke
      _animationDuration = kDurationFastestAnimation;
    }

    if ((_animationDuration - _lastAnimationDuration).abs() >=
        kUpdateAnimationDurationThreshold) {
      _buildDrillSpinner();
      _lastAnimationDuration = _animationDuration;
    }
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  void _detectEmulator() async {
    _isAnEmulator = await FlutterIsEmulator.isDeviceAnEmulatorOrASimulator;
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime =
        // DateFormat('MM/dd/yyyy hh:mm:ss').format(now);
        DateFormat.yMd().add_Hms().format(now);
    _timeString.value = formattedDateTime;
  }

  void _changeLanguage(language) async {
    currentLang = Locale(language);
    await FlutterI18n.refresh(context, currentLang);
    setState(() {});
  }

  String _translateI18N(title) {
    return FlutterI18n.translate(context, title);
  }
}
