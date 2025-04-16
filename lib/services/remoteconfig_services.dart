import 'dart:math';
import 'dart:developer' as dp;

import 'package:ai_work_assistant/utills/remoteconfig_variables.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();

  factory RemoteConfigService() {
    // Purchases.setEmail(email)
    return _instance;
  }

  RemoteConfigService._internal();

  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    GetRemoteConfig().then((value) {
      SetRemoteConfig();

      remoteConfig.onConfigUpdated.listen((event) async {
        print("Remote Updated");
        //  await remoteConfig.activate();
        SetRemoteConfig();

        // Use the new config values here.
      });
    });
  }

  Future GetRemoteConfig() async {
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );

      await remoteConfig.setDefaults(const {
        "apiKey": "apiKey",
        "geminiModel": "geminiModel",
      });

      await remoteConfig.fetchAndActivate();
    } on Exception catch (e) {
      // TODO
      print("Remote Config error: $e");
    }
  }

  Future SetRemoteConfig() async {
    dp.log("these are rc vaiables ${remoteConfig.getString('apiKey')}");
    RCVariables.apiKey = remoteConfig.getString('apiKey');
    RCVariables.geminiModel = remoteConfig.getString('geminiModel');
  }
}
