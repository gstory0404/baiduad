part of 'baiduad.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/29 10:52
/// @Email gstory0404@gmail.com
/// @Description: 百度广告stream

const EventChannel baiduAdEventEvent =
    EventChannel("com.gstory.baiduad/adevent");

class BaiduAdStream {
  ///
  /// # 注册stream监听原生返回的信息
  ///
  /// [baiduAdRewardCallBack] 激励广告回调
  ///
  /// [interactionAdCallBack] 插屏广告回调
  ///
  static StreamSubscription initAdStream(
      {BaiduAdRewardCallBack? baiduAdRewardCallBack,
      BaiduAdInteractionCallBack? baiduAdInteractionCallBack}) {
    StreamSubscription _adStream =
        baiduAdEventEvent.receiveBroadcastStream().listen((event) {
      switch (event[BaiduAdType.adType]) {

        ///激励广告
        case BaiduAdType.rewardAd:
          switch (event[BaiduAdMethod.onAdMethod]) {
            case BaiduAdMethod.onShow:
              baiduAdRewardCallBack?.onShow!();
              break;
            case BaiduAdMethod.onClose:
              baiduAdRewardCallBack?.onClose!();
              break;
            case BaiduAdMethod.onClick:
              baiduAdRewardCallBack?.onClick!();
              break;
            case BaiduAdMethod.onFail:
              baiduAdRewardCallBack?.onFail!(event["message"]);
              break;
            case BaiduAdMethod.onSkip:
              baiduAdRewardCallBack?.onSkip!();
              break;
            case BaiduAdMethod.onReady:
              baiduAdRewardCallBack?.onReady!();
              break;
            case BaiduAdMethod.onUnReady:
              baiduAdRewardCallBack?.onUnReady!();
              break;
            case BaiduAdMethod.onVerify:
              baiduAdRewardCallBack?.onVerify!(
                  event["verify"], event["rewardName"], event["rewardAmount"]);
              break;
          }
          break;

        ///插屏广告
        case BaiduAdType.interactAd:
          switch (event[BaiduAdMethod.onAdMethod]) {
            case BaiduAdMethod.onShow:
              baiduAdInteractionCallBack?.onShow!();
              break;
            case BaiduAdMethod.onClose:
              baiduAdInteractionCallBack?.onClose!();
              break;
            case BaiduAdMethod.onClick:
              baiduAdInteractionCallBack?.onClick!();
              break;
            case BaiduAdMethod.onFail:
              baiduAdInteractionCallBack?.onFail!(event["message"]);
              break;
            case BaiduAdMethod.onReady:
              baiduAdInteractionCallBack?.onReady!();
              break;
            case BaiduAdMethod.onUnReady:
              baiduAdInteractionCallBack?.onUnReady!();
              break;
          }
          break;
      }
    });
    return _adStream;
  }
}
