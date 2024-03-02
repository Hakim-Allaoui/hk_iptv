import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Tools {
  static Future<bool> checkApp() async {
    return await Future.value(true);
  }

  static launchURL(String url, {bool inAppWebView = false}) async {
    final Uri myUrl = Uri.parse(url);
    try {
      await launchUrl(myUrl,
          webViewConfiguration: WebViewConfiguration(),
          mode: inAppWebView
              ? LaunchMode.inAppWebView
              : LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("error launch url Could not launch $myUrl /n error $e");
    }
  }

  static Future<dynamic> fetchRemoteConfig(String key) async {
    try {
      await FirebaseRemoteConfig.instance
          .setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));

      await FirebaseRemoteConfig.instance.fetchAndActivate();

      final value = FirebaseRemoteConfig.instance.getString(key);

      debugPrint("Fetched: $value");

      return value;
    } on Exception catch (e) {
      debugPrint("Error remoteConfig: $e");
    }
  }

  static Future<dynamic> fetchBoolRemoteConfig(String key) async {
    try {
      await FirebaseRemoteConfig.instance.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await FirebaseRemoteConfig.instance.fetchAndActivate();

      final value = FirebaseRemoteConfig.instance.getBool(key);

      debugPrint("Fetched: $value");

      return value;
    } on Exception catch (e) {
      debugPrint("Error remoteConfig: $e");
    }
  }
}
