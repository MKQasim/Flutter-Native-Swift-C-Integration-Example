package com.example.flutter_test_app
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class MainActivity : FlutterActivity() {
    private val batteryChannel = "battery_channel"
    private val galleryChannel = "gallery_channel"
    private val googleMapChannel = "googleMap_Channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, batteryChannel)
            .setMethodCallHandler { call: MethodCall, result: Result ->
                if (call.method == "getBatteryLevel") {
                    val batteryLevel = getBatteryLevel()
                    result.success(batteryLevel)
                } else {
                    result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, galleryChannel)
            .setMethodCallHandler { call: MethodCall, result: Result ->
                when (call.method) {
                    "openGallery" -> {
                        openGallery(result)
                    }
                    "openCamera" -> {
                        openGallery(result)
                    }
                    "recordVideo" -> {
                        recordVideo(result)
                    } else -> {
                        result.notImplemented()
                    }
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, googleMapChannel)
            .setMethodCallHandler { call: MethodCall, result: Result ->
                if (call.method == "openGoogleMap") {
                    val data = call.arguments as Map<String, String>
                    openGoogleMap(data, result)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun getBatteryLevel(): Int {
        // Implement your logic to get the battery level here
        return -1
    }

    private fun openGallery(result: Result) {
        // Implement your logic to open the gallery here
        // Pass the appropriate result to the Flutter side using result.success() or result.error()
    }

    private fun recordVideo(result: Result) {
        // Implement your logic to record a video here
        // Pass the appropriate result to the Flutter side using result.success() or result.error()
    }

    private fun openGoogleMap(data: Map<String, String>, result: Result) {
        // Implement your logic to open Google Maps here using the data provided
        // Pass the appropriate result to the Flutter side using result.success() or result.error()
    }
}
