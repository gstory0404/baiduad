import 'package:baiduad/baiduad.dart';
import 'package:flutter/material.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/29 12:11
/// @Email gstory0404@gmail.com
/// @Description: dart类作用描述 

class BannerPage extends StatefulWidget {
  const BannerPage({Key? key}) : super(key: key);

  @override
  _BannerPageState createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banner横幅广告"),
      ),
      body: Column(
        children: [
          BaiduBannerAdView(
            //android广告位id
            androidId: "7792006",
            //ios广告位id
            iosId: "8280989",
            //广告宽 推荐您将Banner的宽高比固定为20：3以获得最佳的广告展示效果
            width: 280,
            //广告高 加载完成后会自动修改为sdk返回广告高
            height: 120,
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
          BaiduBannerAdView(
            androidId: "7804504",
            iosId: "8360367",
            width: 640, //推荐您将Banner的宽高比固定为7：3以获得最佳的广告展示效果
            height: 270,
          ),
          BaiduBannerAdView(
            androidId: "7804504",
            iosId: "8360367",
            width: 640, //推荐您将Banner的宽高比固定为20：3以获得最佳的广告展示效果
            height: 270,
          ),
        ],
      ),
    );
  }
}


