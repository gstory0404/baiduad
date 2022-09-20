//
//  BaiduInterstitialAd.m
//  baiduad
//
//  Created by gstory on 2022/8/29.
//

#import "BaiduInterstitialAd.h"
#import "BaiduMobAdSDK/BaiduMobAdExpressInterstitial.h"
#import "BaiduUIViewController.h"
#import "BaiduAdManager.h"
#import "BaiduStringUtil.h"
#import "BaiduAdEvent.h"
#import "BaiduLogUtil.h"

@interface BaiduInterstitialAd()<BaiduMobAdExpressIntDelegate>
@property(nonatomic,strong) BaiduMobAdExpressInterstitial *bdInsertAd;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,strong) NSString *appSid;
@end

@implementation BaiduInterstitialAd

+ (instancetype)sharedInstance{
    static BaiduInterstitialAd *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[BaiduInterstitialAd alloc]init];
    }
    return myInstance;
}

//预加载插屏广告
-(void)loadAd:(NSDictionary*)arguments{
    NSDictionary *dic = arguments;
    self.codeId = dic[@"iosId"];
    self.appSid = dic[@"appSid"];
    self.bdInsertAd = [[BaiduMobAdExpressInterstitial alloc]init];
    self.bdInsertAd.adUnitTag = _codeId;
    self.bdInsertAd.delegate = self;
    self.bdInsertAd.enableLocation = false;
    if([BaiduStringUtil isStringEmpty:self.appSid]){
        self.bdInsertAd.publisherId =[BaiduAdManager sharedInstance].getAppId;
    }else{
        self.bdInsertAd.publisherId =self.appSid;
    }
    [self.bdInsertAd load];
}

//展示广告
-(void)showAd{
    BOOL ready = [self.bdInsertAd isReady];
    if (ready) {
        [self.bdInsertAd showFromViewController:[UIViewController jsd_getCurrentViewController]];
    }else{
        [[BaiduLogUtil sharedInstance] print:(@"插屏广告不可用")];
        NSDictionary *dictionary = @{@"adType":@"interactAd",@"onAdMethod":@"onUnReady"};
        [[BaiduAdEvent sharedInstance] sentEvent:dictionary];
    }
}


#pragma mark - 广告请求BaiduMobAdExpressIntDelegate

/**
 * 广告请求成功
 */
- (void)interstitialAdLoaded:(BaiduMobAdExpressInterstitial *)interstitial{;
    [[BaiduLogUtil sharedInstance] print:(@"插屏广告请求成功")];
    NSDictionary *dictionary = @{@"adType":@"interactAd",@"onAdMethod":@"onReady"};
    [[BaiduAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 * 广告请求失败
 */
- (void)interstitialAdLoadFailed:(BaiduMobAdExpressInterstitial *)interstitial withError:(BaiduMobFailReason)reason{
    [[BaiduLogUtil sharedInstance] print:([NSString stringWithFormat:@"插屏广告请求失败 %@",@(reason)])];
    NSDictionary *dictionary = @{@"adType":@"interactAd",@"onAdMethod":@"onFail",@"message":@(reason)};
    [[BaiduAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 *  广告曝光成功
 */
- (void)interstitialAdExposure:(BaiduMobAdExpressInterstitial *)interstitial{
    [[BaiduLogUtil sharedInstance] print:(@"插屏广告曝光成功")];
}

/**
 *  广告展现失败
 */
- (void)interstitialAdExposureFail:(BaiduMobAdExpressInterstitial *)interstitial withError:(int)reason{
    [[BaiduLogUtil sharedInstance] print:[NSString stringWithFormat:@"插屏广告展现失败 %@",@(reason)]];
}


/**
 *  广告被关闭
 */
- (void)interstitialAdDidClose:(BaiduMobAdExpressInterstitial *)interstitial{
    [[BaiduLogUtil sharedInstance] print:(@"插屏广告被关闭")];
    NSDictionary *dictionary = @{@"adType":@"interactAd",@"onAdMethod":@"onClose"};
    [[BaiduAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 *  广告被点击
 */
- (void)interstitialAdDidClick:(BaiduMobAdExpressInterstitial *)interstitial{
    [[BaiduLogUtil sharedInstance] print:(@"插屏广告被点击")];
    NSDictionary *dictionary = @{@"adType":@"interactAd",@"onAdMethod":@"onClick"};
    [[BaiduAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 *  广告落地页关闭
 */
- (void)interstitialAdDidLPClose:(BaiduMobAdExpressInterstitial *)interstitial{
    [[BaiduLogUtil sharedInstance] print:(@"插屏广告落地页关闭")];
}

/**
 *  视频缓存成功
 */
- (void)interstitialAdDownloadSucceeded:(BaiduMobAdExpressInterstitial *)interstitial{
    [[BaiduLogUtil sharedInstance] print:(@"插屏广告视频缓存成功")];
   
}

/**
 *  视频缓存失败
 */
- (void)interstitialAdDownLoadFailed:(BaiduMobAdExpressInterstitial *)interstitial{
    [[BaiduLogUtil sharedInstance] print:(@"插屏广告视频缓存失败")];
}

@end

