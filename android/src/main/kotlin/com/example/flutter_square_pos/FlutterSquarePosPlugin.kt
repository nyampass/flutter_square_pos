package com.example.flutter_square_pos

import androidx.annotation.NonNull
import android.content.Context;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

import com.squareup.sdk.pos.PosClient
import com.squareup.sdk.pos.PosSdk
import com.squareup.sdk.pos.ChargeRequest
import com.squareup.sdk.pos.CurrencyCode

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent

class FlutterSquarePosPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, ActivityResultListener {
  private lateinit var channel : MethodChannel
  private lateinit var activity: Activity
  private lateinit var posClient : PosClient
  private final var CHARGE_REQUEST_CODE: Int = 1
  private var handlingResult : Result? = null

  override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?): Boolean {
    if (intent == null || requestCode != CHARGE_REQUEST_CODE) {
      // AlertDialogHelper.showDialog(this,
      //         "Error: unknown",
      //         "Square Point of Sale was uninstalled or stopped working")
      return false
    }

    if (resultCode == Activity.RESULT_OK) {
      val success = posClient.parseChargeSuccess(intent)
      handlingResult?.success(success.clientTransactionId)
    } else {
      val error = posClient.parseChargeError(intent)
      handlingResult?.success("error " + error.code + " " + error.debugDescription)
    }
    return true
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
    binding.addActivityResultListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_square_pos")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "createClient") {
      val applicationId = call.argument<String>("applicationId")
      if (!applicationId.isNullOrEmpty()) {
        posClient = PosSdk.createClient(activity, applicationId)
      }
      result.success(applicationId)
    } else if (call.method == "startTransaction") {
      val amount = call.argument<Int>("amount")
      val currency = call.argument<String>("currency")
      if (amount == null || currency.isNullOrEmpty()) {
        result.success("amount and currency is required")
        return
      }
      handlingResult = result
      val request: ChargeRequest = ChargeRequest.Builder(
              amount,
              CurrencyCode.valueOf(currency))
              .build()
      try {
        val intent: Intent = posClient.createChargeIntent(request)
        activity.startActivityForResult(intent, CHARGE_REQUEST_CODE)
      } catch (e: ActivityNotFoundException) {
        // AlertDialogHelper.showDialog(
        //         this,
        //         "Error",
        //         "Square Point of Sale is not installed"
        // )
        posClient.openPointOfSalePlayStoreListing()
      }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
