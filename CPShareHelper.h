//
//  CPShareHelper.h
//  XAspectTest
//
//  Created by SoulWater on 16/12/28.
//  Copyright © 2016年 SoulWater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPShareConfigManager.h"
typedef void(^CPShareCompletionHandler)(id result,NSError *error);
@interface CPShareHelper : NSObject
@property (nonatomic, copy) CPShareCompletionHandler shareCompletionBlock;

/**
 图文分享

 @param platformType      平台类型
 @param shareImage        分享的图片（可以是UIImage类对象，也可以是NSdata类对象，也可以是图片链接imageUrl NSString类对象）图片大小根据各个平台限制而定
 @param title             标题
 @param descr             简介
 @param thumImage         缩略图（UIImage或者NSData类型，或者image_url）
 @param completionHandler 结果
 */
+ (void)shareImageTextDataWithPlatform:(CPSocialPlatformType)platformType withShareImage:(id)shareImage withTitle:(NSString *)title withDescr:(NSString *)descr withThumImage:(id)thumImage withCompletion:(CPShareCompletionHandler)completionHandler;

/**
 URL分享

 @param platformType      平台类型
 @param shareUrl          分享的URL
 @param title             标题
 @param descr             简介
 @param thumImage         缩略图（UIImage或者NSData类型，或者image_url）
 @param completionHandler 结果
 */
+ (void)shareUrlDataWithPlatform:(CPSocialPlatformType)platformType withShareUrl:(NSString *)shareUrl withTitle:(NSString *)title withDescr:(NSString *)descr withThumImage:(id)thumImage Target:(id)target withCompletion:(CPShareCompletionHandler)completionHandler;


@end
