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

  static Future<Map<String, String>> startTransaction(
    int amount,
    String currency, {
    List<String> tenderTypes = const [],
    String callbackURL = null,
    bool skipReceipt = false,
  }) async {
    String strTenderTypes =
        tenderTypes.length > 0 ? jsonEncode(tenderTypes) : null;
    String invokeResult;
    try {
      invokeResult =
          await _channel.invokeMethod('startTransaction', <String, dynamic>{
        "amount": amount,
        "currency": currency,
        "tenderTypes": strTenderTypes,
        "callbackURL": callbackURL,
        "skipReceipt": skipReceipt,
      });
    } on PlatformException catch (e) {
      print("platform exception");
      print(e);
      return {"errorCode": e.code, "errorMessage": e.message};
    } catch (e) {
      return {"errorMessage": e.toString()};
    }
    if (invokeResult != null || !Platform.isIOS) {
      return {"clientTransactionId": invokeResult};
    } else {
      Uri uri = await getUriLinksStream().first;
      Map<String, dynamic> baseParams = uri.queryParameters;
      Map<String, dynamic> params = json.decode(baseParams["data"]);
      if (params.containsKey("error_code")) {
        return {"errorCode": params["error_code"]};
      } else if (params.containsKey("client_transaction_id")) {
        return {"clientTransactionId": params["client_transaction_id"]};
      } else {
        return {"errorMessage": "unknown: " + params.toString()};
      }
    }
  }
}
