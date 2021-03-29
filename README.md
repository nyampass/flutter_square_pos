# flutter_square_pos

A flutter plugin to use square POS(point of sale) api.

Square supports sdk of POS for [Andoid](https://github.com/square/point-of-sale-android-sdk) and [iOS](https://github.com/square/SquarePointOfSaleSDK-iOS) but not supported for flutter.
This library bundles them for flutter.

## Setup

### Common

#### Installation

Add `flutter_square_pos` to `depencency` in `pubspec.yaml` of your project.

```yaml
depencendies:
  flutter_square_pos: ^1.0.0
```

#### Define applicationId of square on code of your app

Get Application ID from [developper dashboard](https://developer.squareup.com/apps) and define it on your app.

For example on `main.dart`.

```dart
var squareApplicationId = 'sq0idp-sEIatSPRxB2uxxxxxxx';
```

### Android

#### Register Android app info to square account

[Fingerprint](https://developer.squareup.com/docs/pos-api/cookbook/find-your-android-fingerprint) and package name are required.

[Andorid | Register your application](https://developer.squareup.com/docs/pos-api/build-on-android#step-2-register-your-application)


#### Change minSdkVersino for uni_links.

This plugin uses uni_links for iOS but Android also need to support it.
To build it, set `minSdkVersion` as 23 in `android/build.gradle` of your project.

```gradle
android {
    defaultConfig {
        minSdkVersion 23 // required to set
    }
}
```

### iOS

#### Activate url scheme

[iOS | Add your URL schemes](https://developer.squareup.com/docs/pos-api/build-on-ios#step-4-add-your-url-schemes)

#### Register iOS app info to square account

Bunde id and URL scheme are required.

[iOS | Register your application](https://developer.squareup.com/docs/pos-api/build-on-ios#step-2-register-your-application)

#### Define url schema in dart code

For example on `main.dart`.

```dart
var squareCallbackURL = 'your-ios-url-scheme://';
```

## Usage

### Import
```dart
import 'package:flutter_square_pos/flutter_square_pos.dart';
```

### createClient

Call `createClient` once.

This sample calls createClient on initState.

```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterSquarePos.createClient(squareApplicationId)
  }
}
```

### startTransaction

By calling startTransaction, you can get client_transaction_id or error information.

```dart
Map<String, String> result = await FlutterSquarePos.startTransaction(
    amount, 809,
    tenderTypes: ['CARD', 'CARD_ON_FILE', 'CASH', 'OTHER'])
    callbackURL: squareCallbackURL, // Required for iOS
    skipReceipt: true); // skipReceipt support only for iOS
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
```

## License

MIT

## References

- [POS-apo Build on Android](https://developer.squareup.com/docs/pos-api/build-on-android)
- [Point of Sale Android SDK](https://github.com/square/point-of-sale-android-sdk)
- [POS-api Build on iOS](https://developer.squareup.com/docs/pos-api/build-on-ios)
- [SquarePointOfSaleSDK-iOS](https://github.com/square/SquarePointOfSaleSDK-iOS)
- [Type of expression is ambiguous using Square code](https://stackoverflow.com/questions/46533607/type-of-expression-is-ambiguous-using-square-code)
- [Writing custom platform-specific code](https://flutter.dev/docs/development/platform-integration/platform-channels)
- [plug-in package](https://flutter.dev/developing-packages/)
- [pos android fingerprint](https://developer.squareup.com/docs/pos-api/cookbook/find-your-android-fingerprint)
- [matix-io/react-native-square-pos](https://github.com/matix-io/react-native-square-pos)
