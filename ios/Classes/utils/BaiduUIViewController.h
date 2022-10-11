//
//  BaiduUIViewController.h
//  baiduad
//
//  Created by gstory on 2022/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIViewController (getCurrentVC)<UIViewControllerAnimatedTransitioning>
+ (UIViewController *)jsd_getCurrentViewController;
+ (UIViewController *)jsd_getRootViewController;
+ (UIViewController *)getCurrentVCWithCurrentView:(UIView *)currentView;
+ (UITabBarController *)currentTtabarController;
+ (UINavigationController *)currentTabbarSelectedNavigationController;
@end
NS_ASSUME_NONNULL_END
