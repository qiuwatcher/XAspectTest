//
//  CPShareHelper.m
//  XAspectTest
//
//  Created by SoulWater on 16/12/28.
//  Copyright © 2016年 SoulWater. All rights reserved.
//

#import "CPShareHelper.h"

@implementation CPShareHelper

+ (void)shareImageTextDataWithPlatform:(CPSocialPlatformType)platformType withShareImage:(id)shareImage withTitle:(NSString *)title withDescr:(NSString *)descr withThumImage:(id)thumImage withCompletion:(CPShareCompletionHandler)completionHandler {

    UMSocialPlatformType umPlatFormType = [CPShareConfigManager getUMSocialPlatformCPPlatformType:platformType];

    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:title descr:descr thumImage:thumImage];
    [shareObject setShareImage:shareImage];
    messageObject.shareObject = shareObject;

    //友盟分享
    [[UMSocialManager defaultManager] shareToPlatform:umPlatFormType messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        completionHandler(result,error);
    }];
}

+ (void)shareUrlDataWithPlatform:(CPSocialPlatformType)platformType withShareUrl:(NSString *)shareUrl withTitle:(NSString *)title withDescr:(NSString *)descr withThumImage:(id)thumImage Target:(id)target withCompletion:(CPShareCompletionHandler)completionHandler
{
    UMSocialPlatformType umPlatFormType = [CPShareConfigManager getUMSocialPlatformCPPlatformType:platformType];

    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumImage];
    [shareObject setWebpageUrl:shareUrl];
    messageObject.shareObject = shareObject;

    //友盟分享
    [[UMSocialManager defaultManager] shareToPlatform:umPlatFormType messageObject:messageObject currentViewController:target completion:^(id result, NSError *error) {
        completionHandler(result,error);
    }];
}


@end
