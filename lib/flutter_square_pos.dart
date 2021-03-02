import 'dart:async';

import 'package:flutter/services.dart';

class FlutterSquarePos {
  static const MethodChannel _channel =
      const MethodChannel('flutter_square_pos');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> createClient(String applicationId) async {
    final String id =
        await _channel.invokeMethod('createClient', {'applicationId': applicationId});
    return id;
  }

  static Future<String> startTransaction(int amount, String currency) async {
    final String id =
        await _channel.invokeMethod('startTransaction', {
          "amount": amount,
          "currency": currency,
        });
    return id;
  }
}
