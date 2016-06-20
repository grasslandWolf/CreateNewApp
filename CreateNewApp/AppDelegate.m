//
//  AppDelegate.m
//  CreateNewApp
//
//  Created by MAC Mini on 16/1/25.
//  Copyright © 2016年 test. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import <SMS_SDK/SMSSDK.h>
#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "NewViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#define SHAREkey  @"118f8cfac4f1c"
#define SHAREsecret   476a2a4e8c6c274a480c6fb5f199a143

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NewViewController * vc = [[NewViewController alloc] init];
//    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = vc;
 
    
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    // 发布APP的时候 需要删除
   // [MobClick setLogEnabled:YES];
    
    // 获取版本号
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSLog(@"version 是什么%@ ",version);
    
    [MobClick setAppVersion:version];
    // 集成友盟统计 
    [MobClick startWithAppkey:@"56a59388e0f55a53ef000cac" reportPolicy:BATCH channelId:@""];
    
    // 短信验证
    [SMSSDK registerApp:@"fbffcac3498f" withSecret:@"889345890d58bf356281b8367eb5815b"];

    NSArray * platforms = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeTencentWeibo),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)];
    // 社会化分享
    [ShareSDK registerApp:SHAREkey activePlatforms:platforms onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class] ];
                
                break;
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
                
            default:
                break;
        }
        
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"" appKey:@"" authType:SSDKAuthTypeBoth];
                break;
                case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"" appSecret:@""];
                break;
                case SSDKPlatformTypeSinaWeibo:
                [appInfo SSDKSetupSinaWeiboByAppKey:@"679374051" appSecret:@"516f19f25babee1d4d10b8889fcc7e67" redirectUri:@"http://www.3d414.com/home" authType:SSDKAuthTypeBoth];
                break;
                case SSDKPlatformTypeTencentWeibo:
                [appInfo SSDKSetupTencentWeiboByAppKey:@"1105327952" appSecret:@"jz52BqMxZQlh2xSL" redirectUri:@""];
               
                
            default:
                break;
        }
    }];
    //[NSThread sleepForTimeInterval:2.0];
    [self.window makeKeyAndVisible];
   // [self startpageAnimation];

    return YES;
}

// 启动页动画
-(void)startpageAnimation {
    UIImageView * niceView = [[UIImageView alloc] initWithFrame:self.window.bounds];
    niceView.image = [UIImage imageNamed:@"456"];
    [self.window addSubview:niceView];
    [self.window bringSubviewToFront:niceView];
    //开始设置动画;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDelegate:self];
    
    niceView.alpha = 0.0;
    niceView.frame = CGRectMake(-60, -85, self.window.bounds.size.width *1.1, self.window.bounds.size.height *1.1);
    [UIView commitAnimations];


}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
