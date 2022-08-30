part of '../baiduad.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/29 11:33
/// @Email gstory0404@gmail.com
/// @Description: 百度横幅广告

class BaiduSplashAdView extends StatefulWidget {
  final String androidId;
  final String iosId;
  final String? appSid;
  final int? timeout;
  final double width;
  final double height;
  final BaiduAdSplashCallBack? callBack;

  /// 百度开屏广告
  ///
  ///[androidId] android广告位id
  ///
  /// [iosId] ios广告位id
  ///
  /// [appSid] 动态设置APPSID，该信息可从移动联盟获得
  ///
  /// [timeout] 超时时间
  ///
  /// [width] 宽
  ///
  /// [height] 高
  ///
  /// [callBack] 回调 [BaiduAdSplashCallBack]
  const BaiduSplashAdView(
      {Key? key,
        required this.androidId,
        required this.iosId,
        this.appSid,
        this.timeout,
        required this.width,
        required this.height,
        this.callBack})
      : super(key: key);

  @override
  _BaiduSplashAdViewState createState() => _BaiduSplashAdViewState();
}

class _BaiduSplashAdViewState extends State<BaiduSplashAdView> {

  String _viewType = "com.gstory.baiduad/SplashAdView";

  MethodChannel? _channel;

  //广告是否显示
  bool _isShowAd = true;

  @override
  void initState() {
    super.initState();
    _isShowAd = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShowAd) {
      return Container();
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: AndroidView(
          viewType: _viewType,
          creationParams: {
            "androidId": widget.androidId,
            "appSid": widget.appSid ?? "",
            "timeout": widget.timeout ?? 3000,
            "width": widget.width,
            "height": widget.height,
          },
          onPlatformViewCreated: _registerChannel,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: UiKitView(
          viewType: _viewType,
          creationParams: {
            "iosId": widget.iosId,
            "appSid": widget.appSid ?? "",
            "timeout": widget.timeout ?? 3000,
            "width": widget.width,
            "height": widget.height,
          },
          onPlatformViewCreated: _registerChannel,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else {
      return Container();
    }
  }


  //注册cannel
  void _registerChannel(int id) {
    _channel = MethodChannel("${_viewType}_$id");
    _channel?.setMethodCallHandler(_platformCallHandler);
  }

  //监听原生view传值
  Future<dynamic> _platformCallHandler(MethodCall call) async {
    print("执行了 ${call.method} ${call.arguments}");
    switch (call.method) {
    //显示广告
      case BaiduAdMethod.onShow:
        Map map = call.arguments;
        if (mounted) {
          setState(() {
            _isShowAd = true;
          });
        }
        widget.callBack?.onShow!();
        break;
    //广告加载失败
      case BaiduAdMethod.onFail:
        if (mounted) {
          setState(() {
            _isShowAd = false;
          });
        }
        Map map = call.arguments;
        widget.callBack?.onFail!(map["message"]);
        break;
    //点击
      case BaiduAdMethod.onClick:
        widget.callBack?.onClick!();
        break;
    //关闭
      case BaiduAdMethod.onClose:
        if (mounted) {
          setState(() {
            _isShowAd = false;
          });
        }
        widget.callBack?.onClose!();
        break;
    }
  }
}


