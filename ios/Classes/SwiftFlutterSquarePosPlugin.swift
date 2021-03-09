import Flutter
import UIKit

public class SwiftFlutterSquarePosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_square_pos", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterSquarePosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "getPlatformVersion" {
      result("iOS " + UIDevice.current.systemVersion)
    } else if call.method == "createClient" {
      result("test result for createClient")
      // guard let args = call.arguments else {
      //   return
      // }
      // let applicationId = call.arguments["applicationId"] as? String
      // result(applicationId)
    } else if call.method == "startTransaction" {
      result("todo")
      // TODO
    } else {
      result("not handled")
    }
  }
}
