//
//  BaiduAdSplashView.m
//  baiduad
//
//  Created by gstory on 2022/8/29.
//

#import "BaiduAdSplashView.h"
#import "BaiduMobAdSDK/BaiduMobAdSplash.h"
#import "BaiduAdManager.h"
#import "BaiduStringUtil.h"
#import "BaiduLogUtil.h"
#import "BaiduUIViewController.h"

#pragma mark - BaiduAdSplashViewFactory
@implementation BaiduAdSplashViewFactory{
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
    BaiduAdSplashView * splash = [[BaiduAdSplashView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return splash;
}
@end

@interface BaiduAdSplashView()<BaiduMobAdSplashDelegate>
@property(nonatomic,strong) BaiduMobAdSplash *splashAd;
@property(nonatomic,strong) UIView *container;
@property(nonatomic,assign) NSInteger viewId;
@property(nonatomic,strong) FlutterMethodChannel *channel;
@property(nonatomic,strong) NSString *appSid;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,strong) NSNumber *width;
@property(nonatomic,strong) NSNumber *height;
@property(nonatomic,strong) NSNumber *timeout;
@end

#pragma mark - BaiduAdSplashView
@implementation BaiduAdSplashView
- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        NSDictionary *dic = args;
        self.viewId = viewId;
        self.appSid = dic[@"appSid"];
        self.codeId = dic[@"iosId"];
        self.width =dic[@"width"];
        self.height =dic[@"height"];
        self.timeout =dic[@"timeout"];
        self.container= [[UIView alloc] initWithFrame:CGRectMake (0,0,self.width.doubleValue, self.height.doubleValue)];
        NSString* channelName = [NSString stringWithFormat:@"com.gstory.baiduad/SplashAdView_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        [self loadAd];
    }
    return self;
}
- (UIView*)view{
    return self.container;
}

- (NSString *)publisherId {
    if([BaiduStringUtil isStringEmpty:self.appSid]){
        return [BaiduAdManager sharedInstance].getAppId;
    }
    return self.appSid;
}

//????????????
-(void)loadAd{
    [self.container removeFromSuperview];
    self.splashAd = [[BaiduMobAdSplash alloc] init];
    self.splashAd.delegate = self;
    self.splashAd.AdUnitTag = self.codeId;
    self.splashAd.canSplashClick = YES;
    self.splashAd.timeout =(CGFloat)(self.timeout.floatValue / 1000);
    self.splashAd.adSize = CGSizeMake(self.width.floatValue, self.height.floatValue);
    self.splashAd.presentAdViewController = [UIViewController jsd_getCurrentViewController];
    [self.splashAd loadAndDisplayUsingContainerView:self.container];
    [[BaiduLogUtil sharedInstance] print:(@"????????????????????????")];
}

#pragma mark - BaiduMobAdSplashDelegate

/**
 *  ??????????????????
 */
- (void)splashDidExposure:(BaiduMobAdSplash *)splash{
    [[BaiduLogUtil sharedInstance] print:@"????????????????????????"];
}

/**
 *  ??????????????????
 */
- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash{
    [[BaiduLogUtil sharedInstance] print:@"????????????????????????"];
    [_channel invokeMethod:@"onShow" arguments:nil result:nil];
}

/**
 *  ??????????????????
 */
- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason{
    [[BaiduLogUtil sharedInstance] print:[NSString stringWithFormat:@"???????????????????????? %@",@(reason)]];
    NSDictionary *dictionary = @{@"message":[NSString stringWithFormat:@"%@",@(reason)]};
    [_channel invokeMethod:@"onFail" arguments:dictionary result:nil];
    [self.splashAd stop];
}

/**
 *  ???????????????
 */
- (void)splashDidClicked:(BaiduMobAdSplash *)splash{
    [[BaiduLogUtil sharedInstance] print:@"??????????????????"];
    [_channel invokeMethod:@"onClick" arguments:nil result:nil];
}

/**
 *  ??????????????????
 */
- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash{
    [[BaiduLogUtil sharedInstance] print:@"??????????????????"];
    [_channel invokeMethod:@"onClose" arguments:nil result:nil];
    [self.splashAd stop];
}

/**
 *  ?????????????????????
 */
- (void)splashDidDismissLp:(BaiduMobAdSplash *)splash{
    [[BaiduLogUtil sharedInstance] print:@"???????????????????????????"];
}

/**
 *  ??????????????????
 *  adType:???????????? BaiduMobMaterialType
 *  videoDuration:?????????????????????????????????????????????????????????????????????0??? ??????ms
 */
- (void)splashDidReady:(BaiduMobAdSplash *)splash
             AndAdType:(NSString *)adType
         VideoDuration:(NSInteger)videoDuration{
    [[BaiduLogUtil sharedInstance] print:@"????????????????????????"];
    //    [self.splashAd showInContainerView:self.container];
}

/**
 * ????????????????????????
 *
 * @param splash ??????????????????
 */
- (void)splashAdLoadSuccess:(BaiduMobAdSplash *)splash{
    [[BaiduLogUtil sharedInstance] print:@"????????????????????????"];
}

/**
 * ????????????????????????
 *
 * @param errCode ?????????
 * @param message ????????????
 * @param splash ??????????????????
 */
- (void)splashAdLoadFailCode:(NSString *)errCode
                     message:(NSString *)message
                    splashAd:(BaiduMobAdSplash *)nativeAd{
    [[BaiduLogUtil sharedInstance] print:@"????????????????????????"];
    NSDictionary *dictionary = @{@"message":[NSString stringWithFormat:@"%@ %@",errCode,message]};
    [_channel invokeMethod:@"onFail" arguments:dictionary result:nil];
    [self.splashAd stop];
}

@end
