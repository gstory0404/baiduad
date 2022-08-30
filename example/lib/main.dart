import 'dart:async';
import 'dart:io';

import 'package:baiduad/baiduad.dart';
import 'package:baiduad_example/banner_page.dart';
import 'package:baiduad_example/native_page.dart';
import 'package:baiduad_example/splash_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? _isRegister;
  String _sdkVersion = "";

  StreamSubscription? _adStream;

  @override
  void dispose() {
    _adStream?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initRegister();
    _adStream = BaiduAdStream.initAdStream(
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
          Baiduad.showRewardVideoAd();
        },
        onUnReady: () {
          print("激励广告预加载未准备就绪");
        },
        onVerify: (verify, rewardName, rewardAmount) {
          print("激励广告奖励  $verify   $rewardName   $rewardAmount");
        },
      ),
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
      ),
    );
  }

  //注册
  void _initRegister() async {
    _isRegister = await Baiduad.register(
      //百青藤广告 Android appid 必填
      androidAppId: "b423d90d",
      //百青藤广告 ios appid 必填
      iosAppId: "a6b7fed6",
      //是否打印日志 发布时改为false
      debug: true,
    );
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
    _sdkVersion = await Baiduad.getSDKVersion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('百度广告插件'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Text('百青藤SDK初始化: $_isRegister\n'),
                Text('百青藤SDK版本: $_sdkVersion\n'),
                //激励广告
                MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: const Text('激励广告'),
                  onPressed: () async {
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
                  },
                ),
                //插屏广告
                MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: const Text('插屏广告(智选模版)'),
                  onPressed: () async {
                    await Baiduad.loadInterstitialAd(
                      //android广告位id
                      androidId: "8351686",
                      //ios广告位id
                      iosId: "7803486",
                    );
                  },
                ),
                //横幅广告
                MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: const Text('横幅广告'),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return const BannerPage();
                        },
                      ),
                    );
                  },
                ),
                //横幅广告
                MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: const Text('信息流广告(优选模版)'),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return const NativePage();
                        },
                      ),
                    );
                  },
                ),
                //开屏广告
                MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: const Text('开屏广告'),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return const SplashPage();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
