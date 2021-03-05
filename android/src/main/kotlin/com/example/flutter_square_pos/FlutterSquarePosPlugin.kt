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
      return false
    }

    if (resultCode == Activity.RESULT_OK) {
      val success = posClient.parseChargeSuccess(intent)
      handlingResult?.success(success.clientTransactionId)
    } else {
      val error = posClient.parseChargeError(intent)
      handlingResult?.error(error.code.toString(), error.debugDescription, null)
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
      val tenderTypes = call.argument<List<String>>("tenderTypes")
      try {
        handlingResult = result
        val currencyCode = CurrencyCode.valueOf(currency)
        val builder = ChargeRequest.Builder(
                amount,
                currencyCode)
        if (tenderTypes != null) {
          var tenderTypeCodes: Array<ChargeRequest.TenderType> = emptyArray();
          for (type in tenderTypes) {
            tenderTypeCodes += ChargeRequest.TenderType.valueOf(type)
          }
          builder.restrictTendersTo(tenderTypeCodes.toTypedArray());
        }
        val intent: Intent = posClient.createChargeIntent(builder.build())
        activity.startActivityForResult(intent, CHARGE_REQUEST_CODE)
      } catch (e: ActivityNotFoundException) {
        result.error("activity not found", e.message, null)
        handlingResult = null
      } catch (e: IllegalArgumentException) {
        result.error("invalid string for currency", e.message, null)
        handlingResult = null
      }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
