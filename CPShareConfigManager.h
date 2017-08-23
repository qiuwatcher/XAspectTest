//
//  CPShareConfigManager.h
//  XAspectDemo
//
//  Created by SoulWater on 16/12/23.
//  Copyright © 2016年 SoulWater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

//配置类型
typedef NS_ENUM(NSInteger,UMSocialPlatConfigType)
{
    UMSocialPlatConfigType_Sina,        //新浪
    UMSocialPlatConfigType_Wechat,      //微信
    UMSocialPlatConfigType_Tencent,     //腾讯
};

//平台类型 新浪、微信聊天、微信朋友圈、QQ聊天页面、qq空间
typedef NS_ENUM(NSInteger,CPSocialPlatformType)
{
    CPSocialPlatformType_Sina,          //新浪
    CPSocialPlatformType_WechatSession, //微信聊天
    CPSocialPlatformType_WechatTimeLine,//微信朋友圈
    CPSocialPlatformType_QQ,            //QQ聊天页面
};

@interface CPShareConfigManager : NSObject

+ (CPShareConfigManager *)sharedInstance;

@property (nonatomic, strong) NSString *UMAppKey;
@property (nonatomic, strong) NSString *SinaAppKey;
@property (nonatomic, strong) NSString *SinaAppSecret;
@property (nonatomic, strong) NSString *SinaRedirectUrl;
@property (nonatomic, strong) NSString *QQAppId;
@property (nonatomic, strong) NSString *QQAppKey;
@property (nonatomic, strong) NSString *WXAppId;
@property (nonatomic, strong) NSString *WXAppSecret;
@property (nonatomic, strong) NSString *shareUrl;

- (void)setPlaform:(UMSocialPlatConfigType)platformType
            appKey:(NSString *)appKey
         appSecret:(NSString *)appSecret
       redirectURL:(NSString *)redirectURL;

+ (UMSocialPlatformType)getUMSocialPlatformCPPlatformType:(CPSocialPlatformType)platformType;
@end
