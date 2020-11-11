import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/soilcrete_data.dart';
import 'package:frontend/models/soilcrete_project.dart';

class SoilcreteFileWriter {
  String _mountDrive = '/dev/sda1'; // set default to sda1
  bool _isMounted = false;
  String _projectPath;
  String _currentColumnFilePath;

  String get mountDrive => _mountDrive;
  set mountDrive(value) {
    if (value.runtimeType == 'String') _mountDrive = value;
  }

  bool get isMounted => _isMounted;

  /* Drive mounting --------------------------------------------------------- */
  Future<bool> mountUsbDrive() async {
    ProcessResult results =
        await Process.run('bash', ['mountUsbMassStorage', 'mount']);

    if (results.stdout.contains('OK')) {
      _isMounted = true;
      return true;
    } else
      return false;
  }

  Future<bool> unmountUsbDrive() async {
    ProcessResult results =
        await Process.run('bash', ['mountUsbMassStorage', 'umount']);

    if (results.stdout.contains('OK')) {
      _isMounted = false;
      return true;
    } else
      return false;
  }

  Future<void> initUsbMassStorage() async {
    bool mounted = false;

    // mount drive
    mounted = await mountUsbDrive();
    if (!mounted) {
      // cannot mount the drive -> Already mounted/ Drive doesn't existed
      print("Cannot mount USB drive, retrying...");

      // unmount
      mounted = await unmountUsbDrive();

      // re-mount
      mounted = await mountUsbDrive();

      if (!mounted) {
        // really cannot mount
        print("Cannot mount USB drive. Please check the USB connection.");

        return mounted;
      }
    }
    print("USB Drive mounted.");
    _isMounted = mounted;
  }

  /* File Writing ----------------------------------------------------------- */
  bool checkProjectDirExistence(String projectName) {
    String path = "/media/usb/" + projectName.trim().replaceAll(r' ', '-');

    if (FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound) {
      _currentColumnFilePath = path;
      return true;
    }
    return false;
  }

  bool checkProjectColumnExistence(String columnName, DateTime dt) {
    // date mainpulation
    String dateString = createDateString(dt);

    String path = '/media/usb/' +
        dateString +
        '_' +
        columnName.trim().replaceAll(r' ', '-') +
        '.csv';
    if (FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound) {
      return true;
    }
    return false;
  }

  Future<bool> createProjectDir(String projectName) async {
    final dirName = projectName.trim().replaceAll(r' ', '-');

    // use sudo command to create dir in the usb drive
    ProcessResult results =
        await Process.run('sudo', ['mkdir', '/media/usb/$dirName']);

    _projectPath = '/media/usb/$dirName';
    print("create proj dir: $_projectPath");

    if (results.stdout == '') {
      // update project file path
      _projectPath = '/media/usb/$dirName';
      print("successfully created project dir");
      return true; // successfully created dir
    } else {
      return false; // fail to create dir
    }
  }

  Future<bool> createColumnFile(
      SoilcreteProject soilcreteProject, DateTime projectDate) async {
    // Date String
    String dateString = createDateString(projectDate);

    // get file path
    // final fPath = '$_projectPath/' +
    final fPath = '/media/usb/' +
        dateString +
        '_' +
        soilcreteProject.columnName
            .trim()
            .replaceAll(r' ', '-')
            .replaceAll(r'_', '-') +
        '.csv';
    _currentColumnFilePath = fPath;

    // constants
    String constData = "# ";
    constData += soilcreteProject.columnName + ',';
    constData += soilcreteProject.cementPerSoil.toString() + ',';
    constData += soilcreteProject.waterPerCement.toString() + ',';
    constData += soilcreteProject.maxDepth.toString() + ',';
    constData += soilcreteProject.projectName + ',';
    constData += soilcreteProject.projectOwner + ',';
    constData += soilcreteProject.projectContractor + ',';
    constData += soilcreteProject.samplingRate.toString();

    // csv header: # column_name,
    String tableHeaderContent = '$constData\n'
        'date,time,depth,drill,pressure,stroke,wc,cementAmount,flowRate';

    final file = await new File(fPath).writeAsString(tableHeaderContent);

    print('created column fPath: ' + file.path);
    return true;
  }

  Future<bool> writeDataPoint(SoilcreteData soilcreteData) async {
    String content = '\n';

    DateTime dt = DateTime.now();
    // Time String Manipulation
    String yearStr = dt.year.toString();
    String monthStr = dt.month.toString().padLeft(2, '0');
    String dayStr = dt.day.toString().padLeft(2, '0');
    String hourStr = dt.hour.toString().padLeft(2, '0');
    String minStr = dt.minute.toString().padLeft(2, '0');
    String secStr = dt.second.toString().padLeft(2, '0');
    String millisecStr = dt.millisecond.toString();

    // Create content
    content += '$dayStr-$monthStr-$yearStr,'; // date
    content += '$hourStr:$minStr:$secStr.$millisecStr,'; // time
    content += soilcreteData.depth.toString() + ',';
    content += soilcreteData.drill.toString() + ',';
    content += soilcreteData.pressure.toString() + ',';
    content += soilcreteData.stroke.toString() + ',';
    content += soilcreteData.wc + ',';
    content += soilcreteData.cementAmount.toString() + ',';
    content += soilcreteData.flowRate.toString();

    final file = await File(_currentColumnFilePath)
        .writeAsString(content, mode: FileMode.append);
    print('writing file to $_currentColumnFilePath');

    return true;
  }

  /* Util ------------------------------------------------------------------- */
  void setVirtualDriveMount() {
    _isMounted = true;
  }

  String createDateString(DateTime dt) {
    String res;

    String yearStr = dt.year.toString();
    String monthStr = dt.month.toString().padLeft(2, '0');
    String dayStr = dt.day.toString().padLeft(2, '0');

    res = yearStr + monthStr + dayStr;

    return res;
  }
}
