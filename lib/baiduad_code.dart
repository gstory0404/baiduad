part of 'baiduad.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/29 10:50
/// @Email gstory0404@gmail.com
/// @Description: 百度广告相关code

///数据类型
class BaiduAdType {
  static const String adType = "adType";

  ///激励广告
  static const String rewardAd = "rewardAd";

  ///插屏广告
  static const String interactAd = "interactAd";
}

class BaiduAdMethod {
  ///stream中 广告方法
  static const String onAdMethod = "onAdMethod";

  ///广告加载状态 view使用
  ///显示view
  static const String onShow = "onShow";

  ///加载失败
  static const String onFail = "onFail";

  ///点击
  static const String onClick = "onClick";

  ///广告关闭
  static const String onClose = "onClose";

  ///广告奖励校验
  static const String onVerify = "onVerify";

  ///广告预加载完成
  static const String onReady = "onReady";

  ///广告未预加载
  static const String onUnReady = "onUnReady";

  ///跳过
  static const String onSkip = "onSkip";
}




