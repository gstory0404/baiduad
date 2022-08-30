//
//  BaiduLogUtil.m
//  baiduad
//
//  Created by gstory on 2022/8/29.
//

#import "BaiduLogUtil.h"


@interface BaiduLogUtil()
@property(nonatomic,assign) BOOL isDebug;
@end
@implementation BaiduLogUtil
+ (instancetype)sharedInstance{
    static BaiduLogUtil *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[BaiduLogUtil alloc]init];
    }
    return myInstance;
}
- (void)debug:(BOOL)isDebug{
    _isDebug = isDebug;
}
- (void)print:(NSString *)message{
    if(_isDebug){
        GLog(@"%@", message);
    }
}
@end
