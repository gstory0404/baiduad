import 'package:baiduad/baiduad.dart';
import 'package:baiduad_example/native_page.dart';
import 'package:flutter/material.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/29 12:11
/// @Email gstory0404@gmail.com
/// @Description: 开屏

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaiduSplashAdView(
        //android广告位id
        androidId: "7792007",
        //ios广告位id
        iosId: "7803231",
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
    );
  }
}
