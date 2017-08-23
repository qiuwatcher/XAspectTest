//
//  CPGTConfigManager.m
//  XAspectTest
//
//  Created by SoulWater on 16/12/29.
//  Copyright © 2016年 SoulWater. All rights reserved.
//

#import "CPGTConfigManager.h"

@implementation CPGTConfigManager

+ (CPGTConfigManager *)sharedInstance
{
    static CPGTConfigManager* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CPGTConfigManager new];
    });

    return instance;
}

- (void)configGTAppid:(NSString *)appid GTAppKey:(NSString *)appkey GTAppSecret:(NSString *)appsecret {
    self.GTAppId = appid;
    self.GTAppKey = appkey;
    self.GTAppSecret = appsecret;
}
@end
