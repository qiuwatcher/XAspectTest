//
//  XAspect-GTDelegate.m
//  XAspectTest
//
//  Created by SoulWater on 16/12/29.
//  Copyright © 2016年 SoulWater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <XAspect/XAspect.h>
#import "CPGTConfigManager.h"
#import "GeTuiSdk.h"

//请先添加个图相关key
#define kGtAppId           @""
#define kGtAppKey          @""
#define kGtAppSecret       @""


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#define AtAspect GeTuiModule

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)

@synthesizeNucleusPatch(Default, -, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions);
@synthesizeNucleusPatch(Default, -, void, application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken);
@synthesizeNucleusPatch(Default, -, void, application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler);
@synthesizeNucleusPatch(Default, -, void, application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error);
@synthesizeNucleusPatch(Default, -, void, application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings);
@synthesizeNucleusPatch(Default, -, void, application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler);
@synthesizeNucleusPatch(Default, -, void, applicationDidBecomeActive:(UIApplication *)application);
//@synthesizeNucleusPatch(Default, -, void, application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo);


AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions)
{
    CPGTConfigManager *manager = [CPGTConfigManager sharedInstance];
    [manager configGTAppid:kGtAppId GTAppKey:kGtAppKey GTAppSecret:kGtAppSecret];

    [GeTuiSdk startSdkWithAppId:manager.GTAppId appKey:manager.GTAppKey appSecret:manager.GTAppSecret delegate:self];

    //注册APNS
    [self registerRemoteNotification];

    //  userInfo为收到远程通知的内容
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        // 有推送的消息，处理推送的消息
        NSString *payloadMsg = [userInfo objectForKey:@"payload"];
        NSString *body=[[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]objectForKey:@"body"];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:body message:payloadMsg delegate:self cancelButtonTitle:@"yes" otherButtonTitles:@"didFinishLaunchingWithOptions", nil];
        [alert show];

    }

//    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
////        [self addLocalNotification];
//    }else{
//        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
//    }

//    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
//        UILocalNotification *localNotifi = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
//        [self changeLocalNotifi:localNotifi];
//    }


    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}

/** 远程通知注册成功委托 向个推服务器注册DeviceToken */
AspectPatch(-, void, application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken)
{
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];

    [GeTuiSdk registerDeviceToken:myToken];

    NSLog(@"\n>>>[DeviceToken值]:%@\n\n", myToken);

    return XAMessageForward(application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken);
}

/** Background Fetch 接口回调处理 */
AspectPatch(-, void, application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler)
{
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);

    return XAMessageForward(application:application performFetchWithCompletionHandler:completionHandler);
}

//如果App处于Background状态时，只用用户点击了通知消息时才会调用该方法；如果App处于Foreground状态，会直接调用该方法。
AspectPatch(-, void,application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler)
{
    //除了个推还要处理走苹果的信息放在body里面
    if (userInfo) {
        NSString *payloadMsg = [userInfo objectForKey:@"payload"];
        NSString *body=[[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]objectForKey:@"body"];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:body message:payloadMsg delegate:self cancelButtonTitle:@"yes" otherButtonTitles:@"didReceiveRemoteNotification", nil];
        [alert show];
    }

    [GeTuiSdk setBadge:1]; //同步本地角标值到服务器
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1]; //APP 显示角标需开发者调用系统方法进行设置
//
//    if (application.applicationState == UIApplicationStateInactive) {
//
//    } else if (application.applicationState == UIApplicationStateBackground){
////        
////        [GeTuiSdk setBadge:1]; //同步本地角标值到服务器
////        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1]; //APP 显示角标需开发者调用系统方法进行设置
//    } else if (application.applicationState == UIApplicationStateActive){
//        [self addLocalNotification:(userInfo[@"aps"])[@"category"]];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"alert" message:@"message" delegate:self cancelButtonTitle:@"yes" otherButtonTitles:@"didReceiveRemoteNotification", nil];
//        [alert show];
//    }

    if (application.applicationState == UIApplicationStateActive) {
        // 转换成一个本地通知，显示到通知栏，你也可以直接显示出一个alertView，只是那样稍显aggressive：）
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }



    //统计APNs通知的点击数发给个推
    [GeTuiSdk handleRemoteNotification:userInfo];

    if (userInfo) {
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
    return XAMessageForward(application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler);
}

//AspectPatch(-, void, application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo)
//{
//    if (application.applicationState == UIApplicationStateActive) {
//        // 转换成一个本地通知，显示到通知栏，你也可以直接显示出一个alertView，只是那样稍显aggressive：）
//        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//        localNotification.userInfo = userInfo;
//        localNotification.soundName = UILocalNotificationDefaultSoundName;
//        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//        localNotification.fireDate = [NSDate date];
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//    }
//    return XAMessageForward(application:application didReceiveRemoteNotification:userInfo);
//}

/** 已登记用户通知 */
AspectPatch(-, void, application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings)
{
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];

    if (notificationSettings.types!=UIUserNotificationTypeNone) {
//        [self addLocalNotification];
    }

    return XAMessageForward(application:application didRegisterUserNotificationSettings:notificationSettings);
}


/** 远程通知注册失败委托 */
AspectPatch(-, void, application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error){

    [GeTuiSdk registerDeviceToken:@""];

    NSLog(@"\n>>>[DeviceToken失败]:%@\n\n", error.description);

    return XAMessageForward(application:application didFailToRegisterForRemoteNotificationsWithError:error);
}



AspectPatch(-, void, applicationDidBecomeActive:(UIApplication *)application) {
    [GeTuiSdk resetBadge]; //重置角标计数
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; // APP 清空角标
    return XAMessageForward(applicationDidBecomeActive:application);
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {

    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);

    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 后台点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {

    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);

    [GeTuiSdk resetBadge]; //重置角标计数
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; // APP 清空角标

    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];

    completionHandler();
}

#endif

#pragma mark - 本地推送、处理后台和前台通知点击 -
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [self changeLocalNotifi:notification];
}



#pragma mark - GeTuiSdk Delegate-
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }

    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    if (offLine) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息" message:payloadMsg delegate:self cancelButtonTitle:@"yes" otherButtonTitles:@"透传离线", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息" message:payloadMsg delegate:self cancelButtonTitle:@"yes" otherButtonTitles:@"透传在线", nil];
        [alert show];

    }

    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self addLocalNotification:payloadMsg];
    }

//        if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
//            [self addLocalNotification:payloadMsg];
//
//        }else{
//            [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
//        }
}



#pragma mark -注册 APNs-
/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */

    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];

        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

#pragma mark - 添加本地推送 -
- (void)addLocalNotification:(NSString *)body {
//    //定义本地通知对象
//    UILocalNotification *notification=[[UILocalNotification alloc]init];
//    //设置调用时间
//    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:0];//立即触发
//    //设置通知属性
////    notification.alertBody=@"HELLO，我是本地通知哦!"; //通知主体
//    notification.alertBody= body;
//    notification.applicationIconBadgeNumber=1;//应用程序图标右上角显示的消息数
//    notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
//    notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
//    //调用通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//

    // 1.创建通知
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];

    // 2.设置通知的必选参数
    // 设置通知显示的内容
    localNotification.alertBody = body;
    // 设置通知的发送时间
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    // 3.发送通知
    // 方式一: 根据通知的发送时间(fireDate)发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];


}

//处理本地推送点击
- (void)changeLocalNotifi:(UILocalNotification *)localNotifi {
    NSLog(@"%@",localNotifi.alertBody);
    //如果在前台直接返回
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        return;
    }
//    // 获取通知信息
//    NSString *selectIndex = localNotifi.userInfo[@"selectIndex"];
//    // 获取根控制器TabBarController
//    UITabBarController *rootController = (UITabBarController *)self.window.rootViewController;
//    // 跳转到指定控制器
//    rootController.selectedIndex = [selectIndex intValue];
}
@end
#undef AtAspectOfClass
#undef AtAspect



