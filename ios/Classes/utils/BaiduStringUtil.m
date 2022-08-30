//
//  BaiduStringUtil.m
//  baiduad
//
//  Created by gstory on 2022/8/29.
//

#import "BaiduStringUtil.h"

@implementation BaiduStringUtil

+ (BOOL)isStringEmpty:(NSString *)string{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
@end

