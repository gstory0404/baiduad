//
//  BaiduAdEvent.m
//  baiduad
//
//  Created by gstory on 2022/8/29.
//

#import "BaiduAdEvent.h"

#import <Flutter/Flutter.h>
@interface BaiduAdEvent()<FlutterStreamHandler>
@property(nonatomic,strong) FlutterEventSink eventSink;
@end

@implementation BaiduAdEvent
+ (instancetype)sharedInstance{
    static BaiduAdEvent *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[BaiduAdEvent alloc]init];
    }
    return myInstance;
}
- (void)initEvent:(NSObject<FlutterPluginRegistrar>*)registrar{
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"com.gstory.baiduad/adevent"   binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:self];
}
-(void)sentEvent:(NSDictionary*)arguments{
    self.eventSink(arguments);
}
#pragma mark - FlutterStreamHandler
- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.eventSink = nil;
    return nil;
}
- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    self.eventSink = events;
    return nil;
}
@end
