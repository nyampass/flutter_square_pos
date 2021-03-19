import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:uni_links/uni_links.dart';
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

  static Future startTransaction(int amount, String currency,
      {List<String> tenderTypes = const [], String callbackURL = null}) async {
    String strTenderTypes =
        tenderTypes.length > 0 ? jsonEncode(tenderTypes) : null;
    final String invokeResult =
        await _channel.invokeMethod('startTransaction', <String, dynamic>{
      "amount": amount,
      "currency": currency,
      "tenderTypes": strTenderTypes,
      "callbackURL": callbackURL,
    });
    if (invokeResult != null || !Platform.isIOS) {
      invokeResult;
    } else {
      Uri uri = await getUriLinksStream().first;
      Map<String, dynamic> baseParams = uri.queryParameters;
      Map<String, dynamic> params = json.decode(baseParams["data"]);
      if (params.containsKey("error_code")) {
        throw Exception(params["error_code"]);
      } else if (params.containsKey("transaction_id")) {
        return params["transaction_id"];
      } else {
        return "unknown: " + params.toString();
      }
    }
  }
}
