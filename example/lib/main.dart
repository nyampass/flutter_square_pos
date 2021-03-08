import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_square_pos/flutter_square_pos.dart';
import 'secret.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
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

  onPressPay(int amount, String currency) async {
    print('pressed pay');
    try {
      String result = await FlutterSquarePos.startTransaction(amount, currency);
      setState(() {
        _result = result;
      });
    } on PlatformException catch (e) {
      print(e);
      showDialog(
        context: this.context,
        child: AlertDialog(
          title: Text(e.code),
          content: Text(e.message),
          actions: [
            FlatButton(
              child: Text('close'),
              onPressed: () => Navigator.pop(context, false)
            )
          ],
        ),
      );
    } catch (e) {
      print(e);
      showDialog(
        context: this.context,
        child: AlertDialog(
          title: Text('Unexpected error'),
          content: Text(e.message),
          actions: [
            FlatButton(
              child: Text('close'),
              onPressed: () => Navigator.pop(context, false)
            )
          ],
        ),
      );
    }
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
            child: Text('Running on: $_platformVersion\nsquareApplicationId: $_applicationId\nresult: $_result'),
          ),
          Center(
            child: FlatButton(
              child: Text('500 JPY'),
              onPressed: () => onPressPay(500, 'JPY'),
            ),
          ),
          Center(
            child: FlatButton(
              child: Text('809 JPY'),
              onPressed: () => onPressPay(809, 'JPY'),
            ),
          ),
          Center(
            child: FlatButton(
              child: Text('5 USD'),
              onPressed: () => onPressPay(5, 'USD'),
            ),
          ),
        ],)
      ),
    );
  }
}
