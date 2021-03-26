# flutter_square_pos

A flutter plugin to use square POS(point of sale) api.

## Setup

### Android

Change minSdkVersino to 23.

## Run example app

Create your own example/lib/secret.dart to put square application id before run app.
```
cp example/lib/secret.dart.exampele example/lib/secret.dart
```

Then you can run example app.
```
cd example
flutter run
```

## References

- [POS-apo Build on Android](https://developer.squareup.com/docs/pos-api/build-on-android)
- [POS-api Build on iOS](https://developer.squareup.com/docs/pos-api/build-on-ios)
- [SquarePointOfSaleSDK-iOS](https://github.com/square/SquarePointOfSaleSDK-iOS)
- [Type of expression is ambiguous using Square code](https://stackoverflow.com/questions/46533607/type-of-expression-is-ambiguous-using-square-code)
- [Writing custom platform-specific code](https://flutter.dev/docs/development/platform-integration/platform-channels)
- [plug-in package](https://flutter.dev/developing-packages/)
- [pos android fingerprint](https://developer.squareup.com/docs/pos-api/cookbook/find-your-android-fingerprint)
- [matix-io/react-native-square-pos](https://github.com/matix-io/react-native-square-pos)
