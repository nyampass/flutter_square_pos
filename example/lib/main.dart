import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_square_pos/flutter_square_pos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _applicationId = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterSquarePos.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    String applicationId;
    try {
      applicationId = await FlutterSquarePos.createClient("testId");
    } on PlatformException {
      applicationId = 'Failed to set application id.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _applicationId = applicationId;
    });
  }

  onPressPay() {
    print('pressed pay');
    FlutterSquarePos.startTransaction();
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return SimpleDialog(
    //       title: Text('hi'),
    //     );
    //   }
    // );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(children: [
          Center(
            child: Text('Running on:\n$_platformVersion\n$_applicationId\n'),
          ),
          Center(
            child: FlatButton(
              child: Text('pay'),
              onPressed: onPressPay,
            ),
          )
        ],)
      ),
    );
  }
}
