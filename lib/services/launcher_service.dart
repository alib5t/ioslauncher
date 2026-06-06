import 'package:flutter/services.dart';

class LauncherService {
  static const MethodChannel _channel =
      MethodChannel("launcher_channel");

  /// 📱 Tüm uygulamaları getir
  static Future<List<dynamic>> getApps() async {
    final apps = await _channel.invokeMethod("getApps");
    return apps as List<dynamic>;
  }

  /// 🚀 Uygulama aç
  static Future<void> openApp(String package) async {
    await _channel.invokeMethod("openApp", {
      "package": package,
    });
  }
}