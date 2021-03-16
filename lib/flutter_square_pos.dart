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
    print("invokeResult");
    print(invokeResult);
    if (invokeResult != null || !Platform.isIOS) {
      invokeResult;
    } else {
      String strResult = "";
      StreamSubscription sub = getUriLinksStream().listen((Uri uri) {
        print("received uri");
        print(uri);
        // TODO parse uri
        strResult = uri.toString();
        return strResult;
      }, onError: (err) {});
      // await sub.asFuture();
      // Future.wait([f]);
      // sub.cancel();
      // TODO listen stream once
      print("strResult");
      print(strResult);
      return strResult;
    }
  }
}
