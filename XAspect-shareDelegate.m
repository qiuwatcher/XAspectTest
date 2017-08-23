//
//  XAspect-shareDelegate.m
//  XAspectDemo
//
//  Created by SoulWater on 16/12/26.
//  Copyright © 2016年 SoulWater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <XAspect/XAspect.h>
#import <UMSocialCore/UMSocialCore.h>
#import "CPShareConfigManager.h"

//请先添加友盟相关的key
// 友盟SDK
#define UMENG_APPKEY @""

/*sina*/
#define K_Sina_AppKey    @""
#define K_Sina_AppSecret @""
#define K_Redirect_Url   @"https://api.weibo.com/oauth2/default.html"
/*QQ*/
#define K_QQ_AppId       @""
#define K_QQ_AppKey      @""
/*微信*/
#define K_WX_AppID       @""
#define K_WX_AppSecret   @""


#define AtAspect ShareModule

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)

AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions)
{
    NSLog(@"成功加载友盟分享");

    [[UMSocialManager defaultManager] openLog:YES];

    //友盟分享
    CPShareConfigManager *jiaShareConfig=[CPShareConfigManager sharedInstance];
    jiaShareConfig.UMAppKey = UMENG_APPKEY;

    //设置平台
    [jiaShareConfig setPlaform:UMSocialPlatConfigType_Tencent appKey:K_QQ_AppId appSecret:K_QQ_AppKey redirectURL:@"http://www.umeng.com/social"];
    [jiaShareConfig setPlaform:UMSocialPlatConfigType_Wechat appKey:K_WX_AppID appSecret:K_WX_AppSecret redirectURL:@"http://www.umeng.com/social"];
    [jiaShareConfig setPlaform:UMSocialPlatConfigType_Sina appKey:K_Sina_AppKey appSecret:K_Sina_AppSecret redirectURL:K_Redirect_Url];
    
    

    CPShareConfigManager *shareManager = [CPShareConfigManager sharedInstance];
    if (shareManager.UMAppKey) {
        [[UMSocialManager defaultManager] setUmSocialAppkey:shareManager.UMAppKey];
    }
    
    //各平台的详细配置
    if(shareManager.WXAppId && shareManager.WXAppSecret) {
        //设置微信的appId和appKey
        NSLog(@"分享-微信平台已经配置");

        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:shareManager.WXAppId appSecret:shareManager.WXAppSecret redirectURL:shareManager.shareUrl];
    }

    if(shareManager.QQAppId && shareManager.QQAppKey) {
        //设置分享到QQ互联的appId和appKey
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:shareManager.QQAppId  appSecret:shareManager.QQAppKey redirectURL:shareManager.shareUrl];
    }

    if(shareManager.SinaAppKey && shareManager.SinaAppSecret) {
        //设置新浪的appId和appKey
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:shareManager.SinaAppKey  appSecret:shareManager.SinaAppSecret redirectURL:shareManager.SinaRedirectUrl];
    }

    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}



@end
#undef AtAspectOfClass
#undef AtAspect


