import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class FlutterSquarePos {
  static const MethodChannel _channel =
      const MethodChannel('flutter_square_pos');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> createClient(String applicationId) async {
    final String id = await _channel.invokeMethod('createClient', {
      'applicationId': applicationId,
    });
    return id;
  }

  static Future startTransaction(int amount, String currency, {List<String> tenderTypes =  const []}) async {
    String strTenderTypes = tenderTypes.length > 0 ? jsonEncode(tenderTypes) : null;
    return await _channel.invokeMethod('startTransaction', <String, dynamic>{
      "amount": amount,
      "currency": currency,
      "tenderTypes": strTenderTypes,
    });
  }
}
