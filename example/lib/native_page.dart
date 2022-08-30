import 'package:baiduad/baiduad.dart';
import 'package:flutter/material.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/29 12:11
/// @Email gstory0404@gmail.com
/// @Description: dart类作用描述 

class NativePage extends StatefulWidget {
  const NativePage({Key? key}) : super(key: key);

  @override
  _NativePageState createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("信息流广告"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BaiduNativeAdView(
              //android广告位id
              androidId: "8352393",
              //ios广告位id
              iosId: "8353656",
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
            BaiduNativeAdView(
              androidId: "8352393",
              iosId: "8353656",
              width: 500, //推荐您将Banner的宽高比固定为20：3以获得最佳的广告展示效果
              height: 300,
            ),
            BaiduNativeAdView(
              androidId: "8352393",
              iosId: "8353656",
              width: 400, //推荐您将Banner的宽高比固定为20：3以获得最佳的广告展示效果
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}


