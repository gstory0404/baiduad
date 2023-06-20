# 百度百青藤广告Flutter版本

<p>
<a href="https://pub.flutter-io.cn/packages/baiduad"><img src=https://img.shields.io/pub/v/baiduad?color=orange></a>
<a href="https://pub.flutter-io.cn/packages/baiduad"><img src=https://img.shields.io/pub/likes/baiduad></a>
<a href="https://pub.flutter-io.cn/packages/baiduad"><img src=https://img.shields.io/pub/points/baiduad></a>
<a href="https://github.com/gstory0404/baiduad/commits"><img src=https://img.shields.io/github/last-commit/gstory0404/baiduad></a>
<a href="https://github.com/gstory0404/baiduad"><img src=https://img.shields.io/github/stars/gstory0404/baiduad></a>
</p>

## 简介

baiduad是一款集成了百度广告Android和iOS SDK的Flutter插件，可通过[GTAds](https://github.com/gstory0404/GTAds)实现多个广告平台接入、统一管理。

## 官方文档

* [Android](https://union.baidu.com/miniappblog/2020/12/01/newAndroidSDK/)
* [IOS](https://union.baidu.com/miniappblog/2020/08/11/iOSSDK/)

## 版本更新

[更新日志](https://github.com/gstory0404/baiduad/blob/master/CHANGELOG.md)

## 本地开发环境

```
[✓] Flutter (Channel stable, 3.10.5, on macOS 13.4 22F66 darwin-x64, locale
    zh-Hans-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.1)
[✓] Xcode - develop for iOS and macOS (Xcode 14.3.1)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2022.1)
[✓] IntelliJ IDEA Ultimate Edition (version 2023.1.2)
[✓] VS Code (version 1.79.0)
[✓] Connected device (4 available)
[✓] Network resources
```

## 集成步骤

#### 1、pubspec.yaml

```Dart
baiduad: ^latest
```

引入

```Dart
import 'package:baiduad/baiduad.dart';
```

## 使用

#### 1、SDK初始化

```Dart
await Baiduad.register(
    //百青藤广告 Android appid 必填
    androidAppId: "b423d90d",
    //百青藤广告 ios appid 必填
    iosAppId: "a6b7fed6",
    //是否打印日志 发布时改为false
    debug: true,
);
```

#### 2、获取SDK版本

```Dart
await Baiduad.getSDKVersion();
```

#### 3、隐私权限

```dart
//隐私敏感权限API&限制个性化广告推荐
    await Baiduad.privacy(
      //android读取设备ID的权限（建议授权）  ios是否新的设备标志能力
      readDeviceID: false,
      //读取已安装应用列表权限（建议授权）
      appList: false,
      //读取粗略地理位置权限
      location: false,
      //读写外部存储权限
      storage: false,
      //设置限制个性化广告推荐
      personalAds: false,
      // ios 新标志能力，该能力默认开启，如果有监管或隐私要求，在app内配置是否开启该能力。
      bDPermission: false,
    );
```

#### 4、开屏广告

```Dart
BaiduSplashAdView(
    //android广告位id
    androidId: "7792007",
    //ios广告位id
    iosId: "7792007",
    //超时时间
    timeout: 4000,
    //宽
    width: MediaQuery.of(context).size.width,
    //高
    height: MediaQuery.of(context).size.height,
    //广告回调
    callBack: BaiduAdSplashCallBack(
        onShow: () {
          print("开屏广告显示了");
        },
        onClick: () {
          print("开屏广告点击了");
        },
        onFail: (message) {
          print("开屏广告失败了 $message");
          Navigator.pop(context);
        },
        onClose: () {
          print("开屏广告关闭了");
          Navigator.pop(context);
        },
    ),
),
```

#### 5、banner广告

```Dart
BaiduBannerAdView(
    //android广告位id
    androidId: "7792006",
    //ios广告位id
    iosId: "7800783",
    //广告宽 推荐您将Banner的宽高比固定为20：3以获得最佳的广告展示效果
    width: 400,
    //广告高 加载完成后会自动修改为sdk返回广告高
    height: 60,
    //是否自动切换
    autoplay: true,
    //广告回调
    callBack: BaiduAdBannerCallBack(
        onShow: (){
          print("Banner横幅广告显示了");
        },
        onClick: (){
          print("Banner横幅广告点击了");
        },
        onFail: (message){
          print("Banner横幅广告失败了 $message");
        },
        onClose: (){
          print("Banner横幅广告关闭了");
        }
    ),
),
```

#### 6、信息流广告(优选模版)

```dart
BaiduNativeAdView(
    //android广告位id
    androidId: "8352393",
    //ios广告位id
    iosId: "8352393",
    //广告宽 推荐您将Banner的宽高比固定为20：3以获得最佳的广告展示效果
    width: 400,
    //广告高 加载完成后会自动修改为sdk返回广告高
    height: 200,
    //广告回调
    callBack: BaiduAdNativeCallBack(
        onShow: (){
          print("信息流广告显示了");
        },
        onClick: (){
          print("信息流广告点击了");
        },
        onFail: (message){
          print("信息流广告失败了 $message");
        },
        onClose: (){
          print("信息流广告关闭了");
        }
    ),
),
```

#### 7、激励视频广告

预加载激励视频广告

```Dart
await Baiduad.loadRewardAd(
    //android广告id
    androidId: "7792010",
    //ios广告id
    iosId: "7800949",
    //支持动态设置APPSID，该信息可从移动联盟获得
    appSid: "",
    //用户id
    userId: "123",
    //奖励
    rewardName: "100金币",
    //奖励数
    rewardAmount: 100,
    //扩展参数 服务器验证使用
    customData: "",
    //是否使用SurfaceView
    useSurfaceView: false,
    //设置点击跳过时是否展示提示弹框
    isShowDialog: true,
    //设置是否展示奖励领取倒计时提示
    useRewardCountdown: true,
);
```

显示激励视频广告

```dart
  await Baiduad.showRewardVideoAd();
```

监听激励视频结果

```Dart
 BaiduAdStream.initAdStream(
    //激励广告结果监听
    baiduAdRewardCallBack: BaiduAdRewardCallBack(
        onShow: () {
          print("激励广告显示");
        },
        onClose: () {
          print("激励广告关闭");
        },
        onFail: (message) {
          print("激励广告失败 $message");
        },
        onClick: () {
          print("激励广告点击");
        },
        onSkip: () {
          print("激励广告跳过");
        },
        onReady: () {
          print("激励广告预加载准备就绪");
          //展示激励广告
          await Baiduad.showRewardVideoAd();
        },
        onUnReady: () {
          print("激励广告预加载未准备就绪");
        },
        onVerify: (verify, rewardName, rewardAmount) {
          print("激励广告奖励  $verify   $rewardName   $rewardAmount");
      },
  )
);
```

#### 7、插屏广告（智选模版）

预加载插屏广告

```Dart
await Baiduad.loadInterstitialAd(
    //android广告位id
    androidId: "8351686",
    //ios广告位id
    iosId: "8351686",
);
```

显示插屏广告

```dart
await Baiduad.showInterstitialAd();
```

监听插屏广告

```Dart
 BaiduAdStream.initAdStream(
    baiduAdInteractionCallBack: BaiduAdInteractionCallBack(
    onClose: () {
      print("插屏广告关闭了");
    },
    onFail: (message) {
      print("插屏广告出错了 $message");
    },
    onClick: () {
      print("插屏广告点击了");
    },
    onShow: () {
      print("插屏广告显示了");
    },
    onReady: () async {
      print("插屏广告准备就绪");
        //展示广告
        await Baiduad.showInterstitialAd();
    },
    onUnReady: () {
      print("插屏广告未准备就绪");
    },
  )
);
```

## 插件链接


| 插件                      | 地址                                                                     |
| :------------------------ | :----------------------------------------------------------------------- |
| 字节-穿山甲广告插件       | [flutter_unionad](https://github.com/gstory0404/flutter_unionad)         |
| 腾讯-优量汇广告插件       | [flutter_tencentad](https://github.com/gstory0404/flutter_tencentad)     |
| 百度-百青藤广告插件       | [baiduad](https://github.com/gstory0404/baiduad)                         |
| 字节-Gromore聚合广告      | [gromore](https://github.com/gstory0404/gromore)                         |
| Sigmob广告                | [sigmobad](https://github.com/gstory0404/sigmobad)                       |
| 聚合广告插件(迁移至GTAds) | [flutter_universalad](https://github.com/gstory0404/flutter_universalad) |
| GTAds聚合广告             | [GTAds](https://github.com/gstory0404/GTAds)                             |
| 字节穿山甲内容合作插件    | [flutter_pangrowth](https://github.com/gstory0404/flutter_pangrowth)     |
| 文档预览插件              | [file_preview](https://github.com/gstory0404/file_preview)               |
| 滤镜                      | [gpu_image](https://github.com/gstory0404/gpu_image)                     |

### 开源不易，觉得有用的话可以请作者喝杯奶茶🧋

<img src="https://github.com/gstory0404/flutter_unionad/blob/master/image/weixin.jpg" width = "200" height = "160" alt="打赏"/>

## 联系方式

* Email: gstory0404@gmail.com
* blog：https://www.gstory.cn/
* QQ群: <a target="_blank" href="https://qm.qq.com/cgi-bin/qm/qr?k=4j2_yF1-pMl58y16zvLCFFT2HEmLf6vQ&jump_from=webapi"><img border="0" src="//pub.idqqimg.com/wpa/images/group.png" alt="649574038" title="flutter交流"></a>
* [Telegram](https://t.me/flutterex)
