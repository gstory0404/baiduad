//
//  BaiduAdManager.h
//  baiduad
//
//  Created by gstory on 2022/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaiduAdManager : NSObject
+ (instancetype)sharedInstance;
- (void)initAppId:(NSString*)appId;
- (NSString*)getAppId;
@end

NS_ASSUME_NONNULL_END
