//
//  BaiduAdManager.m
//  baiduad
//
//  Created by gstory on 2022/8/29.
//

#import "BaiduAdManager.h"

@interface BaiduAdManager()
@property(nonatomic,strong)NSString *appid;
@end

@implementation BaiduAdManager

+ (instancetype)sharedInstance{
    static BaiduAdManager *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[BaiduAdManager alloc]init];
    }
    return myInstance;
}

//传入appId
-(void)initAppId:(NSString *)appId{
    self.appid = appId;
}

- (NSString*)getAppId{
    return self.appid;
}

@end

