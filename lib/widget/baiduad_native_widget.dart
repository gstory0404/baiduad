part of '../baiduad.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/29 11:33
/// @Email gstory0404@gmail.com
/// @Description: 百度信息流广告

class BaiduNativeAdView extends StatefulWidget {
  final String androidId;
  final String iosId;
  final String? appSid;
  final double width;
  final double height;
  final BaiduAdNativeCallBack? callBack;

  /// 百度信息流广告(优选模版)
  ///
  ///[androidId] android广告位id
  ///
  /// [iosId] ios广告位id
  ///
  /// [appSid] 动态设置APPSID，该信息可从移动联盟获得
  ///
  /// [width] 宽
  ///
  /// [height] 高
  ///
  /// [callBack] 回调 [BaiduAdNativeCallBack]
  const BaiduNativeAdView(
      {Key? key,
      required this.androidId,
      required this.iosId,
      this.appSid,
      required this.width,
      required this.height,
      this.callBack})
      : super(key: key);

  @override
  _BaiduNativeAdViewState createState() => _BaiduNativeAdViewState();
}

class _BaiduNativeAdViewState extends State<BaiduNativeAdView> {
  String _viewType = "com.gstory.baiduad/NativeAdView";

  MethodChannel? _channel;

  //广告是否显示
  bool _isShowAd = true;
  double _width = 0;
  double _height = 0;

  @override
  void initState() {
    super.initState();
    // setState(() {
    _width = widget.width.toDouble();
    _height = widget.height.toDouble();
    _isShowAd = true;
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShowAd) {
      return Container();
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return SizedBox(
        width: _width,
        height: _height,
        child: AndroidView(
          viewType: _viewType,
          creationParams: {
            "androidId": widget.androidId,
            "appSid": widget.appSid ?? "",
            "width": widget.width,
            "height": widget.height,
          },
          onPlatformViewCreated: _registerChannel,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return SizedBox(
        width: _width,
        height: _height,
        child: UiKitView(
          viewType: _viewType,
          creationParams: {
            "iosId": widget.iosId,
            "appSid": widget.appSid ?? "",
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
    switch (call.method) {
      //显示广告
      case BaiduAdMethod.onShow:
        Map map = call.arguments;
        if (mounted) {
          setState(() {
            _isShowAd = true;
            _width = (map["width"]).toDouble();
            _height = (map["height"]).toDouble();
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
