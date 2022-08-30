//
//  BaiduAdBannerView.m
//  baiduad
//
//  Created by gstory on 2022/8/29.
//

#import "BaiduAdBannerView.h"
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#import "BaiduAdManager.h"
#import "BaiduStringUtil.h"
#import "BaiduLogUtil.h"
#import "BaiduUIViewController.h"


#pragma mark - BaiduAdBannerViewFactory
@implementation BaiduAdBannerViewFactory{
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
    BaiduAdBannerView * banner = [[BaiduAdBannerView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return banner;
}
@end
@interface BaiduAdBannerView()<BaiduMobAdViewDelegate>
@property(nonatomic,strong) BaiduMobAdView *bannerView;
@property(nonatomic,strong) UIView *container;
@property(nonatomic,assign) NSInteger viewId;
@property(nonatomic,strong) FlutterMethodChannel *channel;
@property(nonatomic,strong) NSString *appSid;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,strong) NSNumber *width;
@property(nonatomic,strong) NSNumber *height;
@end
#pragma mark - BaiduAdBannerView
@implementation BaiduAdBannerView
- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        NSDictionary *dic = args;
        self.viewId = viewId;
        self.appSid = dic[@"appSid"];
        self.codeId = dic[@"iosId"];
        self.width =dic[@"width"];
        self.height =dic[@"height"];
        self.container= [[UIView alloc] initWithFrame:frame];
        NSString* channelName = [NSString stringWithFormat:@"com.gstory.baiduad/BannerAdView_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        [self loadBannerAd];
    }
    return self;
}
- (UIView*)view{
    return self.container;
}

/**
 *  应用的APPID
 */
- (NSString *)publisherId{
    if([BaiduStringUtil isStringEmpty:self.appSid]){
        return [BaiduAdManager sharedInstance].getAppId;
    }
    return self.appSid;
}

/**
 *  渠道ID
 */
- (NSString *)channelId{
    return @"";
}
/**
 *  启动位置信息
 */
- (BOOL)enableLocation{
    return false;
}

//加载广告
-(void)loadBannerAd{
    //load横幅
    [self.container removeFromSuperview];
    [self.bannerView removeFromSuperview];
    self.bannerView = [[BaiduMobAdView alloc] init];
    self.bannerView.AdUnitTag = self.codeId;
    self.bannerView.AdType = BaiduMobAdViewTypeBanner;
    self.bannerView.delegate = self;
    self.bannerView.presentAdViewController = [UIViewController jsd_getCurrentViewController];
    [self.container addSubview:self.bannerView];
    self.bannerView.frame = CGRectMake(0, 0, self.width.floatValue, self.height.floatValue);
    [self.bannerView start];
}

#pragma mark - BaiduMobAdViewDelegate
/**
 *  广告将要被载入
 */
- (void)willDisplayAd:(BaiduMobAdView *)adview{
    [[BaiduLogUtil sharedInstance] print:@"横幅广告即将载入"];
}

/**
 *  广告载入失败
 */
- (void)failedDisplayAd:(BaiduMobFailReason)reason{
    [[BaiduLogUtil sharedInstance] print:[NSString stringWithFormat:@"横幅广告载入失败 %@",@(reason)]];
    NSDictionary *dictionary = @{@"message":@(reason)};
    [_channel invokeMethod:@"onFail" arguments:dictionary result:nil];
}


/**
 *  本次广告展示成功时的回调
 */
- (void)didAdImpressed{
    [[BaiduLogUtil sharedInstance] print:@"横幅广告展示成功"];
    [_channel invokeMethod:@"onShow" arguments:nil result:nil];
}

/**
 *  本次广告展示被用户点击时的回调
 */
- (void)didAdClicked{
    [[BaiduLogUtil sharedInstance] print:@"横幅广告点击"];
    [_channel invokeMethod:@"onClick" arguments:nil result:nil];
}

/**
 *  在用户点击完广告条出现全屏广告页面以后，用户关闭广告时的回调
 */
- (void)didDismissLandingPage{
    [[BaiduLogUtil sharedInstance] print:@"横幅广告用户关闭广告落地页时"];
}

/**
 *  用户点击关闭按钮关闭广告后的回调
 */
- (void)didAdClose{
    [[BaiduLogUtil sharedInstance] print:@"横幅广告用户点击关闭按钮关闭广告后的"];
    [_channel invokeMethod:@"onClose" arguments:nil result:nil];
}

@end
