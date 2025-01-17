import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_square_pos/flutter_square_pos.dart';
import './secret.dart';

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
  String _result = 'Unkown';

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

  onPressPay(
    int amount,
    String currency, {
    List<String> tenderTypes = const [],
    bool skipReceipt = false,
  }) async {
    try {
      Map<String, String> result = await FlutterSquarePos.startTransaction(
          amount, currency,
          tenderTypes: tenderTypes,
          callbackURL: squareCallbackURL,
          skipReceipt: skipReceipt);
      if (result.containsKey("errorCode")) {
        setState(() {
          _result = result["errorCode"];
        });
        showDialog(
          context: this.context,
          builder: (context) => AlertDialog(
            title: Text(result["errorCode"] ?? ""),
            content: Text(result["errorMessage"] ?? ""),
            actions: [
              TextButton(
                  child: Text('close'),
                  onPressed: () => Navigator.pop(context, false))
            ],
          ),
        );
      } else {
        setState(() {
          _result = result["clientTransactionId"];
        });
      }
    } catch (e) {
      print(e);
      showDialog(
        context: this.context,
        builder: (context) => AlertDialog(
          title: Text('Unexpected error'),
          content: Text(e.message),
          actions: [
            TextButton(
                child: Text('close'),
                onPressed: () => Navigator.pop(context, false))
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
          body: Column(
            children: [
              Center(
                child: Text(
                    'Running on: $_platformVersion\nsquareApplicationId: $_applicationId\nresult: $_result'),
              ),
              Center(
                child: TextButton(
                  child: Text('500 JPY'),
                  onPressed: () => onPressPay(500, 'JPY',
                      tenderTypes: ['CASH'], skipReceipt: true),
                ),
              ),
              Center(
                child: TextButton(
                  child: Text('809 JPY'),
                  onPressed: () => onPressPay(809, 'JPY',
                      tenderTypes: ['CARD', 'CARD_ON_FILE', 'CASH', 'OTHER']),
                ),
              ),
              Center(
                child: TextButton(
                  child: Text('1000 JPY'),
                  onPressed: () => onPressPay(1000, 'JPY'),
                ),
              ),
              Center(
                child: TextButton(
                  child: Text('5 USD'),
                  onPressed: () => onPressPay(5, 'USD'),
                ),
              ),
            ],
          )),
    );
  }
}
