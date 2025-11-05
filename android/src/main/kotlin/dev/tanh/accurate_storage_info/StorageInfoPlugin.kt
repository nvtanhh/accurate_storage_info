package dev.tanh.accurate_storage_info

import android.os.Environment
import android.os.StatFs
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** StorageInfoPlugin */
class StorageInfoPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dev.tanh/storage_info")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getTotalBytes" -> {
                val (total, _, _) = queryStorage()
                result.success(total)
            }
            "getAvailableBytes" -> {
                val (_, available, _) = queryStorage()
                result.success(available)
            }
            "getUsedBytes" -> {
                val (_, _, used) = queryStorage()
                result.success(used)
            }
            else -> result.notImplemented()
        }
    }

    private fun queryStorage(): Triple<Long, Long, Long> {
        val stat = StatFs(Environment.getDataDirectory().path)
        val total = stat.totalBytes
        val available = stat.availableBytes // do NOT use freeBytes
        val used = total - available
        return Triple(total, available, used)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
