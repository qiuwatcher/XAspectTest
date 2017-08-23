//
//  ViewController.m
//  XAspectTest
//
//  Created by SoulWater on 16/12/28.
//  Copyright © 2016年 SoulWater. All rights reserved.
//

#import "ViewController.h"
#import "CPShareMenuView.h"
#import "CPShareConfigManager.h"
#import "CPShareHelper.h"
#import <MAMapKit/MAMapKit.h>
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()
{
    UIButton *share;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(10, kScreenHeight-50, 60, 30);
    share.center = self.view.center;
    [share setTitle:@"分享" forState:UIControlStateNormal];
    [share setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(sharedApplication) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:share];
    NSLog(@"----%f,%f",share.frame.origin.x,share.frame.origin.y);

}


- (void)sharedApplication {
    
    CPShareMenuView *shareV = [[CPShareMenuView alloc] init];

    [shareV addShareItems:self.view style:CPShareViewStylePopping frame:CGRectMake(0, 100, kScreenWidth, 120) selectShareItem:^(NSInteger index) {
        [CPShareHelper shareUrlDataWithPlatform:CPSocialPlatformType_WechatSession withShareUrl:@"http://baidu.com" withTitle:@"极限挑战" withDescr:@".............ing" withThumImage:[UIImage imageNamed:@"user_img"] Target:self withCompletion:^(id result, NSError *error) {
            NSLog(@"%@--%@",result,error);

        }];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
