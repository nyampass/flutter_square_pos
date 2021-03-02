import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_square_pos/flutter_square_pos.dart';
import 'secret.dart';

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
  String _result = 'None';

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
      applicationId = await FlutterSquarePos.createClient(squareApplicationId);
    } on PlatformException {
      applicationId = 'Failed to set application id.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _applicationId = applicationId;
    });
  }

  onPressPay(int amount) async {
    print('pressed pay');
    String result = await FlutterSquarePos.startTransaction(amount, 'JPY');
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return SimpleDialog(
    //       title: Text('hi'),
    //     );
    //   }
    // );
    setState(() {
      _result = result;
    });
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
            child: Text('Running on:\n$_platformVersion\n$_applicationId\n$_result'),
          ),
          Center(
            child: FlatButton(
              child: Text('500円'),
              onPressed: () => onPressPay(500),
            ),
          ),
          Center(
            child: FlatButton(
              child: Text('1000円'),
              onPressed: () => onPressPay(1000),
            ),
          ),
          Center(
            child: FlatButton(
              child: Text('809円'),
              onPressed: () => onPressPay(809),
            ),
          ),
        ],)
      ),
    );
  }
}
