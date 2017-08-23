//
//  CPGTConfigManager.h
//  XAspectTest
//
//  Created by SoulWater on 16/12/29.
//  Copyright © 2016年 SoulWater. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPGTConfigManager : NSObject

+ (CPGTConfigManager *)sharedInstance;

//个推配置
@property (nonatomic, strong) NSString *GTAppId;
@property (nonatomic, strong) NSString *GTAppKey;
@property (nonatomic, strong) NSString *GTAppSecret;

- (void)configGTAppid:(NSString *)appid GTAppKey:(NSString *)appkey GTAppSecret:(NSString *)appsecret;
@end
