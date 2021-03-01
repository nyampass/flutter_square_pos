package com.example.flutter_square_pos

import androidx.annotation.NonNull
import android.content.Context;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
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

/** FlutterSquarePosPlugin */
class FlutterSquarePosPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var activity: Activity
  private lateinit var posClient : PosClient
  private final var CHARGE_REQUEST_CODE: Int = 1

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
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

      val request: ChargeRequest = ChargeRequest.Builder(
              1,
              CurrencyCode.USD)
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
      result.success(null)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
