import Flutter
import UIKit
import SquarePointOfSaleSDK

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
      guard let args = call.arguments as? Dictionary<String, Any> else {
        // TODO return error
        return
      }
      let applicationId = args["applicationId"] as? String
      SCCAPIRequest.setApplicationID(applicationId)
      result(applicationId)
    } else if call.method == "startTransaction" {
      guard let args = call.arguments as? Dictionary<String, Any> else {
        // TODO return error
        return
      }
      let callbackURL = args["callbackURL"] as? String
      let amount = args["callbackURL"] as? Int
      // do {
      //   let apiRequest =
      //     try SCCAPIRequest(
      //       callbackURL: callbackURL,
      //       amount: amount,
      //       userInfoString: nil,
      //       locationID: nil,
      //       notes: nil,
      //       customerID: nil,
      //       supportedTenderTypes: .all,
      //       clearsDefaultFees: false,
      //       returnsAutomaticallyAfterPayment: false,
      //       disablesKeyedInCardEntry: false,
      //       skipsReceipt: false
      //     )
      //   // Open Point of Sale to complete the payment.
      //   try SCCAPIConnection.perform(apiRequest)
      // } catch let error {
      //   // TODO return error
      //   result(error.localizedDescription)
      // }
      result("todo")
    } else {
      result("not handled")
    }
  }
}
