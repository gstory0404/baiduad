//
//  BaiduAdEvent.h
//  baiduad
//
//  Created by gstory on 2022/8/29.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN
@interface BaiduAdEvent : NSObject
+ (instancetype)sharedInstance;
- (void)initEvent:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)sentEvent:(NSDictionary*)arguments;
@end
NS_ASSUME_NONNULL_END
