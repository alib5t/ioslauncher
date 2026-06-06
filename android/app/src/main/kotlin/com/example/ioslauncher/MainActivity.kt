package com.example.myapplication

import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "launcher_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                val pm = packageManager

                when (call.method) {

                    "getApps" -> {
                        val apps = pm.getInstalledApplications(PackageManager.GET_META_DATA)

                        val list = apps.filter {
                            pm.getLaunchIntentForPackage(it.packageName) != null
                        }.map {
                            mapOf(
                                "label" to pm.getApplicationLabel(it).toString(),
                                "package" to it.packageName
                            )
                        }

                        result.success(list)
                    }

                    "openApp" -> {
                        val pkg = call.argument<String>("package")
                        val intent = pm.getLaunchIntentForPackage(pkg!!)
                        startActivity(intent)
                        result.success(true)
                    }
                }
            }
    }
}