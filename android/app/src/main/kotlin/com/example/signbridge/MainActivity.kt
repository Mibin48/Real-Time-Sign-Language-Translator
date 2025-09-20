package com.example.signbridge

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "signbridge/landmarks"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initialize" -> {
                    // TODO: Initialize MediaPipe Hands here
                    result.success(true)
                }
                "processFrame" -> {
                    // val width = call.argument<Int>("width") ?: 0
                    // val height = call.argument<Int>("height") ?: 0
                    // val pixelFormat = call.argument<String>("pixelFormat")
                    // val buffer = call.argument<ByteArray>("buffer")
                    // TODO: Run MediaPipe Hands and return landmarks
                    val response: Map<String, Any> = mapOf(
                        "left" to emptyList<Map<String, Float>>(),
                        "right" to emptyList<Map<String, Float>>()
                    )
                    result.success(response)
                }
                "dispose" -> {
                    // TODO: Cleanup MediaPipe resources
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
