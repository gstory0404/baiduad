//
//  BaiduRewardAd.h
//  baiduad
//
//  Created by gstory on 2022/8/29.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@interface BaiduRewardAd : NSObject
+ (instancetype)sharedInstance;
- (void)loadAd:(NSDictionary *)arguments;
- (void)showAd;
@end
NS_ASSUME_NONNULL_END
