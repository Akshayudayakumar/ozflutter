package com.example.ozone_erp

import android.telephony.SmsManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "sms_channel"

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSMS") {
                val phoneNumber = call.argument<String>("phone")
                val message = call.argument<String>("message")

                if (phoneNumber != null && message != null) {
                    sendSMS(phoneNumber, message)
                    result.success("SMS Sent")
                } else {
                    result.error("ERROR", "Invalid arguments", null)
                }
            }
        }
    }

    private fun sendSMS(phoneNumber: String, message: String) {
        try {
            val smsManager = SmsManager.getDefault()
            smsManager.sendTextMessage(phoneNumber, null, message, null, null)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
