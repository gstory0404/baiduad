
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'baiduad_callback.dart';
part 'baiduad_code.dart';
part 'baiduad_stream.dart';
part 'widget/baiduad_native_widget.dart';
part 'widget/baiduad_splash_widget.dart';

class Baiduad {
  static const MethodChannel _channel = MethodChannel('baiduad');

  /// SDK注册初始化
  /// [androidAppId] andorid广告id
  ///
  /// [iosAppId] ios广告id
  ///
  /// [debug] 是否打印日志
  static Future<bool> register({
    required String androidAppId,
    required String iosAppId,
    bool? debug,
  }) async {
    return await _channel.invokeMethod("register", {
      "iosAppId": iosAppId,
      "androidAppId": androidAppId,
      "debug": debug ?? false,
    });
  }

  ///
  /// # 隐私敏感权限API&限制个性化广告推荐
  ///
  /// [readDeviceID] 读取设备ID的权限（建议授权）
  ///
  /// [appList] 读取已安装应用列表权限（建议授权）
  ///
  /// [location] 读取粗略地理位置权限
  ///
  /// [storage] 读写外部存储权限
  ///
  /// [personalAds] 设置限制个性化广告推荐
  ///
  /// [bDPermission] ios 新标志能力，该能力默认开启，如果有监管或隐私要求，在app内配置是否开启该能力。
  ///
  static Future<bool> privacy(
      {bool? readDeviceID,
        bool? appList,
        bool? location,
        bool? storage,
        bool? personalAds,
        bool? bDPermission}) async {
    return await _channel.invokeMethod("privacy", {
      "readDeviceID": readDeviceID ?? true,
      "appList": appList ?? true,
      "location": location ?? true,
      "storage": storage ?? true,
      "personalAds": personalAds ?? true,
      "bDPermission": bDPermission ?? true
    });
  }

  ///
  /// # 获取SDK版本号
  static Future<String> getSDKVersion() async {
    return await _channel.invokeMethod("getSDKVersion");
  }

  ///
  /// # 激励视频广告预加载
  ///
  /// [androidId] android广告ID
  ///
  /// [iosId] ios广告ID
  ///
  /// [appSid] 支持动态设置APPSID，该信息可从移动联盟获得
  ///
  /// [rewardName] 奖励名称
  ///
  /// [rewardAmount] 奖励金额
  ///
  /// [userId] 用户id
  ///
  /// [customData] 扩展参数，服务器回调使用
  ///
  /// [useSurfaceView] 是否使用SurfaceView，默认使用TextureView
  ///
  /// [isShowDialog] 设置点击跳过时是否展示提示弹框
  ///
  /// [useRewardCountdown] 设置是否展示奖励领取倒计时提示
  ///
  static Future<bool> loadRewardAd({
    required String androidId,
    required String iosId,
    String? appSid,
    required String rewardName,
    required int rewardAmount,
    required String userId,
    String? customData,
    bool? useSurfaceView,
    bool? isShowDialog,
    bool? useRewardCountdown,
  }) async {
    return await _channel.invokeMethod("loadRewardAd", {
      "androidId": androidId,
      "iosId": iosId,
      "appSid": appSid ?? "",
      "rewardName": rewardName,
      "rewardAmount": rewardAmount,
      "userId": userId,
      "customData": customData ?? "",
      "useSurfaceView": useSurfaceView ?? false,
      "isShowDialog": isShowDialog ?? false,
      "useRewardCountdown": useRewardCountdown ?? false,
    });
  }

  ///
  /// # 显示激励广告
  ///
  static Future<bool> showRewardVideoAd() async {
    return await _channel.invokeMethod("showRewardAd", {});
  }

  ///
  /// # 预加载插屏广告(智选模版)
  ///
  /// [androidId] android广告ID
  ///
  /// [iosId] ios广告ID
  ///
  static Future<bool> loadInterstitialAd({
    required String androidId,
    required String iosId,
  }) async {
    return await _channel.invokeMethod("loadInterstitialAd", {
      "androidId": androidId,
      "iosId": iosId,
    });
  }

  ///
  /// # 显示插屏广告（百度优选）
  ///
  static Future<bool> showInterstitialAd() async {
    return await _channel.invokeMethod("showInterstitialAd", {});
  }

}
