//
//  CPShareConfigManager.m
//  XAspectDemo
//
//  Created by SoulWater on 16/12/23.
//  Copyright © 2016年 SoulWater. All rights reserved.
//

#import "CPShareConfigManager.h"

@implementation CPShareConfigManager
+ (CPShareConfigManager *)sharedInstance
{
    static CPShareConfigManager* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CPShareConfigManager new];
    });

    return instance;
}

- (void)setPlaform:(UMSocialPlatConfigType)platformType
            appKey:(NSString *)appKey
         appSecret:(NSString *)appSecret
       redirectURL:(NSString *)redirectURL {
    switch (platformType) {
        case UMSocialPlatConfigType_Sina:
            self.SinaAppKey = appKey;
            self.SinaAppSecret = appSecret;
            self.SinaRedirectUrl = redirectURL;
            break;
        case UMSocialPlatConfigType_Wechat:
            self.WXAppId = appKey;
            self.WXAppSecret = appSecret;
            break;
        case UMSocialPlatConfigType_Tencent:
            self.QQAppId = appKey;
            self.QQAppKey = appSecret;
            break;
        default:
            break;
    }
}

+ (UMSocialPlatformType)getUMSocialPlatformCPPlatformType:(CPSocialPlatformType)platformType {
    UMSocialPlatformType platFormType = UMSocialPlatformType_UnKnown;
    switch (platformType) {
        case CPSocialPlatformType_QQ:
            platFormType=UMSocialPlatformType_QQ;
            break;
        case CPSocialPlatformType_Sina:
            platFormType=UMSocialPlatformType_Sina;
            break;
        case CPSocialPlatformType_WechatSession:
            platFormType=UMSocialPlatformType_WechatSession;
            break;
        case CPSocialPlatformType_WechatTimeLine:
            platFormType=UMSocialPlatformType_WechatTimeLine;
            break;
        default:
            platFormType=UMSocialPlatformType_UnKnown;
            break;
    }
    return platFormType;
}

@end
