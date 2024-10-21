#import "BaiduadPlugin.h"
#import <BaiduMobAdSDK/BaiduMobAdCommonConfig.h>
#import <BaiduMobAdSDK/BaiduMobAdSetting.h>
#import "BaiduAdManager.h"
#import "BaiduAdEvent.h"
#import "BaiduLogUtil.h"
#import "BaiduRewardAd.h"
#import "BaiduInterstitialAd.h"
#import "BaiduAdNativeView.h"
#import "BaiduAdSplashView.h"

@implementation BaiduadPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"baiduad"
                                     binaryMessenger:[registrar messenger]];
    BaiduadPlugin* instance = [[BaiduadPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    //注册event
    [[BaiduAdEvent sharedInstance]  initEvent:registrar];
    //注册信息流
    [registrar registerViewFactory:[[BaiduAdNativeViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"com.gstory.baiduad/NativeAdView"];
    //注册开屏
    [registrar registerViewFactory:[[BaiduAdSplashViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"com.gstory.baiduad/SplashAdView"];

}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"register" isEqualToString:call.method]) {
        NSString *appId = call.arguments[@"iosAppId"];
        [[BaiduAdManager sharedInstance] initAppId:appId];
        BOOL debug = [call.arguments[@"debug"] boolValue];
        [[BaiduLogUtil sharedInstance] debug:debug];
        result(@YES);
    }else if([@"getSDKVersion" isEqualToString:call.method]){
        result(SDK_VERSION_IN_MSSP);
    }else if([@"privacy" isEqualToString:call.method]){
        BOOL bDPermission = [call.arguments[@"bDPermission"] boolValue];
        BOOL personalAds = [call.arguments[@"personalAds"] boolValue];
        [[BaiduMobAdSetting sharedInstance] setBDPermissionEnable:bDPermission];
        [[BaiduMobAdSetting sharedInstance] setLimitBaiduPersonalAds:personalAds];
        result(@YES);
    }else if([@"loadRewardAd" isEqualToString:call.method]){
        BaiduRewardAd *rewardAd = [BaiduRewardAd sharedInstance];
        [rewardAd loadAd:call.arguments];
    }else if([@"showRewardAd" isEqualToString:call.method]){
        [[BaiduRewardAd sharedInstance] showAd];
        //加载插屏广告
    }else if([@"loadInterstitialAd" isEqualToString:call.method]){
        [[BaiduInterstitialAd sharedInstance] loadAd:call.arguments];
        //展示插屏广告
    }else if([@"showInterstitialAd" isEqualToString:call.method]){
        [[BaiduInterstitialAd sharedInstance] showAd];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
