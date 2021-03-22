import Flutter
import UIKit
import SquarePointOfSaleSDK

public class SwiftFlutterSquarePosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_square_pos", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterSquarePosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  // private var handlingResult: FlutterResult?
  // public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
  //   guard let sourceApplication = options[.sourceApplication] as? String,
  //     sourceApplication.hasPrefix("com.squareup.square") else {
  //     return false
  //   }
  //   if (handlingResult == nil) {
  //     return false
  //   }
  //   do {
  //     let response = try SCCAPIResponse(responseURL: url)
  //     if let error = response.error {
  //       // Handle a failed request.
  //       // print(error.localizedDescription)
  //       handlingResult!(error.localizedDescription)
  //     } else {
  //       handlingResult!("success")
  //     }
  //   } catch let error as NSError {
  //     // Handle unexpected errors.
  //     // print(error.localizedDescription)
  //     handlingResult!(error.localizedDescription)
  //   }
  //   handlingResult = nil
  //   return true
  // }

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
      let currency = args["currency"] as? String
      let amount = args["amount"] as? Int
      let skipsReceipt = (args["skipReceipt"] as? Bool) ?? false
      let strJsonTenderTypes = args["tenderTypes"] as? String
      if callbackURL == nil {
        result("callbackURL is required")
        return
      }
      do {
        var tenderTypes: SCCAPIRequestTenderTypes? = nil
        if (strJsonTenderTypes != nil) {
          let jsonData = Data(strJsonTenderTypes!.utf8)
          let strTypes = try JSONDecoder().decode([String].self, from: jsonData)
          for strType in strTypes {
            var type: SCCAPIRequestTenderTypes? = nil
            if (strType == "CASH") {
              type = SCCAPIRequestTenderTypes.cash
            } else if (strType == "CARD") {
              type = SCCAPIRequestTenderTypes.card
            } else if (strType == "CARD_ON_FILE") {
              type = SCCAPIRequestTenderTypes.cardOnFile
            } else if (strType == "SQUARE_GIFT_CARD") {
              type = SCCAPIRequestTenderTypes.squareGiftCard
            } else if (strType == "OTHER") {
              type = SCCAPIRequestTenderTypes.other
            } else {
              // TODO raise error
            }
            if (tenderTypes == nil) {
              tenderTypes = type
            } else {
              tenderTypes!.formSymmetricDifference(type!)
            }
          }
        }
        if (tenderTypes == nil) {
          tenderTypes = SCCAPIRequestTenderTypes.all
        }
        let money = try SCCMoney(amountCents: amount!, currencyCode: currency!)
        let url = URL(string: callbackURL!)!
        let apiRequest =
          try SCCAPIRequest(
            callbackURL: url,
            amount: money,
            userInfoString: nil,
            locationID: nil,
            notes: nil,
            customerID: nil,
            supportedTenderTypes: tenderTypes!,
            clearsDefaultFees: false,
            returnsAutomaticallyAfterPayment: false,
            disablesKeyedInCardEntry: false,
            skipsReceipt: skipsReceipt
          )
        // Open Point of Sale to complete the payment.
        try SCCAPIConnection.perform(apiRequest)
        // handlingResult = result
        result(nil)
      } catch let error {
        // TODO return error
        result(error.localizedDescription)
      }
    } else {
      result("not handled")
    }
  }
}
