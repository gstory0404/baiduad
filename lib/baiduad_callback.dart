part of 'baiduad.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/29 10:48
/// @Email gstory0404@gmail.com
/// @Description: 百度广告回调

///显示
typedef BDOnShow = void Function();

///点击
typedef BDOnClick = void Function();

///关闭
typedef BDOnClose = void Function();

///失败
typedef BDOnFail = void Function(dynamic message);

///跳过
typedef BDOnSkip = void Function();

///广告预加载完成
typedef BDOnReady = void Function();

///广告预加载未完成
typedef BDOnUnReady = void Function();

///广告奖励验证
typedef BDOnVerify = void Function(
    bool verify, String rewardName, int rewardAmount);

///激励广告回调
class BaiduAdRewardCallBack {
  BDOnShow? onShow;
  BDOnClose? onClose;
  BDOnFail? onFail;
  BDOnClick? onClick;
  BDOnSkip? onSkip;
  BDOnReady? onReady;
  BDOnUnReady? onUnReady;
  BDOnVerify? onVerify;

  BaiduAdRewardCallBack({
    this.onShow,
    this.onClick,
    this.onClose,
    this.onFail,
    this.onSkip,
    this.onReady,
    this.onUnReady,
    this.onVerify,
  });
}

///插屏广告回调
class BaiduAdInteractionCallBack {
  BDOnShow? onShow;
  BDOnClick? onClick;
  BDOnClose? onClose;
  BDOnFail? onFail;
  BDOnReady? onReady;
  BDOnUnReady? onUnReady;

  BaiduAdInteractionCallBack(
      {this.onShow,
      this.onClick,
      this.onClose,
      this.onFail,
      this.onReady,
      this.onUnReady});
}

///banner广告回调
class BaiduAdBannerCallBack {
  BDOnShow? onShow;
  BDOnFail? onFail;
  BDOnClick? onClick;
  BDOnClose? onClose;

  BaiduAdBannerCallBack(
      {this.onShow, this.onFail, this.onClick, this.onClose});
}


///信息流广告回调
class BaiduAdNativeCallBack {
  BDOnShow? onShow;
  BDOnFail? onFail;
  BDOnClick? onClick;
  BDOnClose? onClose;

  BaiduAdNativeCallBack(
      {this.onShow, this.onFail, this.onClick, this.onClose});
}


///信息流广告回调
class BaiduAdSplashCallBack {
  BDOnShow? onShow;
  BDOnFail? onFail;
  BDOnClick? onClick;
  BDOnClose? onClose;

  BaiduAdSplashCallBack(
      {this.onShow, this.onFail, this.onClick, this.onClose});
}

