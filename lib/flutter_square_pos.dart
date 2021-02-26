import 'dart:async';

import 'package:flutter/services.dart';

class FlutterSquarePos {
  static const MethodChannel _channel =
      const MethodChannel('flutter_square_pos');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> setApplicationId(String applicationId) async {
    final String id =
        await _channel.invokeMethod('setApplicationId', {'applicationId': applicationId});
    return id;
  }
}
