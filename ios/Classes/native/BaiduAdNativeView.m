//
//  BaiduAdNativeView.m
//  baiduad
//
//  Created by gstory on 2022/8/29.
//

#import "BaiduAdNativeView.h"
#import "BaiduMobAdSDK/BaiduMobAdExpressNativeView.h"
#import "BaiduMobAdSDK/BaiduMobAdNative.h"
#import "BaiduAdManager.h"
#import "BaiduStringUtil.h"
#import "BaiduLogUtil.h"

#pragma mark - BaiduAdNativeViewFactory
@implementation BaiduAdNativeViewFactory{
    NSObject<FlutterBinaryMessenger>*_messenger;
}
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager{
    self = [super init];
    if (self) {
        _messenger = messager;
    }
    return self;
}
-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}
-(NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{
    BaiduAdNativeView * native = [[BaiduAdNativeView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return native;
}
@end

@interface BaiduAdNativeView()<BaiduMobAdNativeAdDelegate,BaiduMobAdNativeInterationDelegate>
@property(nonatomic,strong) BaiduMobAdNative *nativeAd;
@property(nonatomic,strong) UIView *container;
@property(nonatomic,assign) NSInteger viewId;
@property(nonatomic,strong) FlutterMethodChannel *channel;
@property(nonatomic,strong) NSString *appSid;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,strong) NSNumber *width;
@property(nonatomic,strong) NSNumber *height;
@end

#pragma mark - BaiduAdNativeView
@implementation BaiduAdNativeView
- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        NSDictionary *dic = args;
        self.viewId = viewId;
        self.appSid = dic[@"appSid"];
        self.codeId = dic[@"iosId"];
        self.width =dic[@"width"];
        self.height =dic[@"height"];
        self.container= [[UIView alloc] initWithFrame:frame];
        NSString* channelName = [NSString stringWithFormat:@"com.gstory.baiduad/NativeAdView_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        [self loadAd];
    }
    return self;
}
- (UIView*)view{
    return self.container;
}

//加载广告
-(void)loadAd{
    //load横幅
    [self.container removeFromSuperview];
    self.nativeAd = [[BaiduMobAdNative alloc] init];
    self.nativeAd.adDelegate = self;
    if([BaiduStringUtil isStringEmpty:self.appSid]){
        self.nativeAd.publisherId = [BaiduAdManager sharedInstance].getAppId;
    }else{
        self.nativeAd.publisherId =self.appSid;
    }
    self.nativeAd.adUnitTag = self.codeId;
    // 配置请求优选模板
    self.nativeAd.isExpressNativeAds = YES;
    [self.nativeAd requestNativeAds];
}

#pragma mark - BaiduMobAdNativeAdDelegate
//广告请求成功
//请求成功的BaiduMobAdNativeAdObject数组
//如果是优选模板，nativeAds为BaiduMobAdExpressNativeView数组
- (void)nativeAdObjectsSuccessLoad:(NSArray *)nativeAds nativeAd:(BaiduMobAdNative *)nativeAd{
    [[BaiduLogUtil sharedInstance] print:([NSString stringWithFormat:@"信息流广告请求成功%d",nativeAds.count])];
    if(nativeAds.count > 0){
        BaiduMobAdExpressNativeView *view = [nativeAds objectAtIndex:0];
        // 展现前检查是否过期，30分钟广告将过期，如果广告过期，请放弃展示并重新请求
        if ([view isExpired]) {
            return;
        }
        view.interationDelegate = self;
        //开始渲染
        [view render];
    }
}

//广告请求失败
//失败的错误码 errCode
//失败的原因 message
- (void)nativeAdsFailLoadCode:(NSString *)errCode message:(NSString *)message nativeAd:(BaiduMobAdNative *)nativeAd{
    [[BaiduLogUtil sharedInstance] print:[NSString stringWithFormat:@"信息流广告请求失败 %@ %@",errCode,message]];
    NSDictionary *dictionary = @{@"code":errCode,@"message":[NSString stringWithFormat:@"%@ %@",errCode,message]};
      [_channel invokeMethod:@"onFail" arguments:dictionary result:nil];
}

//广告曝光成功
- (void)nativeAdExposure:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object{
    [[BaiduLogUtil sharedInstance] print:(@"信息流广告曝光成功")];
    [_channel invokeMethod:@"onExpose" arguments:nil result:nil];
}

//优选模板组件渲染成功
//组件调用render渲染完成后会回调
- (void)nativeAdExpressSuccessRender:(BaiduMobAdExpressNativeView *)express nativeAd:(BaiduMobAdNative *)nativeAd{
    [[BaiduLogUtil sharedInstance] print:(@"信息流广告渲染成功")];
    [express trackImpression];
    [self.container addSubview:express];
    NSDictionary *dictionary = @{@"width": @(express.width),@"height":@(express.height)};
     [_channel invokeMethod:@"onShow" arguments:dictionary result:nil];
}

//广告点击
- (void)nativeAdClicked:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object{
    [[BaiduLogUtil sharedInstance] print:(@"信息流广告点击")];
    [_channel invokeMethod:@"onClick" arguments:nil result:nil];
}

//广告详情页关闭
- (void)didDismissLandingPage:(UIView *)nativeAdView{
    [[BaiduLogUtil sharedInstance] print:(@"信息流广告详情页关闭")];
}

//联盟官网点击跳转
- (void)unionAdClicked:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object{
    [[BaiduLogUtil sharedInstance] print:(@"信息流广告联盟官网点击跳转")];
}

//广告曝光失败
- (void)nativeAdExposureFail:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object failReason:(int)reason{
    [[BaiduLogUtil sharedInstance] print:(@"信息流广告曝光失败")];
}

//优选模板负反馈展现
- (void)nativeAdDislikeShow:(UIView *)adView{
    [[BaiduLogUtil sharedInstance] print:(@"信息流广告负反馈展现")];
}

//优选模板负反馈点击
- (void)nativeAdDislikeClick:(UIView *)adView{
    [[BaiduLogUtil sharedInstance] print:(@"信息流广告负反馈点击")];
    [_channel invokeMethod:@"onClose" arguments:nil result:nil];
}

//优选模板负反馈关闭
- (void)nativeAdDislikeClose:(UIView *)adView{
    [[BaiduLogUtil sharedInstance] print:(@"信息流广告负反馈关闭")];
}

@end
