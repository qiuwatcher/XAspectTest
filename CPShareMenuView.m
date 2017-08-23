//
//  CPShareMenuView.m
//  XAspectDemo
//
//  Created by SoulWater on 16/12/26.
//  Copyright © 2016年 SoulWater. All rights reserved.
//

#import "CPShareMenuView.h"

#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height
#define kScaleWidth kScreenWidth/414.0
#define kScaleHeight kScreenHeight/736.0
#define kSpace 10
#define kBtnH 60
#define kMarginY 15
#define RGB(r, g, b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]


@interface CPShareMenuView()
@property (nonatomic, strong) NSArray *sharItems;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *canleBtn;
@property (nonatomic, copy) void(^btnBlock)(NSInteger index);
@end

@implementation CPShareMenuView

- (void)addShareItems:(UIView *)superView  style:(CPShareViewStyle)style frame:(CGRect)frame selectShareItem:(selectItemBlock)selectShareItem {
    _sharItems = @[@{@"name":@"微信",@"icon":@"sns_icon_7"},
                   @{@"name":@"朋友圈",@"icon":@"sns_icon_8"},
                   @{@"name":@"QQ",@"icon":@"sns_icon_4"},
                   @{@"name":@"新浪微博",@"icon":@"sns_icon_3"}
                   ];
    for (int i = 0; i < _sharItems.count; i++) {
        NSDictionary *dic = _sharItems[i];
        NSString *name = dic[@"name"];
        NSString *icon = dic[@"icon"];

        CGFloat itemWidth = 75.0f * kScaleWidth;
        CGFloat itemSpace = (kScreenWidth-4*itemWidth)/(_sharItems.count+1);
        UIButton *shareBtn = [self createBtn:CGRectMake(itemWidth * i + itemSpace * (i+1), (120*kScaleHeight-itemWidth)/2-kSpace/2, itemWidth, itemWidth) imageName:icon title:name Target:self Sel:@selector(btnClick:)];
        shareBtn.tag = i;

        [self addSubview:shareBtn];
    }

    if (style == CPShareViewStylePopping) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addBackgroundView:superView];

        CGFloat height = 160*kScaleHeight;
        //分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,  height-44*kScaleHeight - 0.5, kScreenWidth, 0.5)];
        line.backgroundColor = RGB(180, 180, 180);
        [self addSubview:line];

        //取消
        NSString *cannelText=self.cancelButtonText?:@"取消";
        self.canleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.canleBtn.frame = CGRectMake(0, CGRectGetMaxY(line.frame), self.frame.size.width, 44*kScaleHeight);
        [self.canleBtn setTitle:cannelText forState:UIControlStateNormal];
        self.canleBtn.titleLabel.font =self.cancelButtonFont?:[UIFont systemFontOfSize:16];
        [self.canleBtn setBackgroundColor:self.cancelBackgroundColor?:[UIColor whiteColor]];
        [self.canleBtn setTitleColor:self.cancelButtonColor?:[UIColor grayColor] forState:UIControlStateNormal];
        [self.canleBtn addTarget:self action:@selector(cancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.canleBtn];

        CGFloat originY = [UIScreen mainScreen].bounds.size.height;
        self.frame = CGRectMake(0, originY, 0, height);
        [UIView animateWithDuration:0.25 animations:^{
            CGRect sF = self.frame;
            sF.origin.y = kScreenHeight - sF.size.height;
            self.frame = sF;
        }];

    } else {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.frame = frame;
    }
    self.btnBlock = ^(NSInteger tag){
        if(selectShareItem) selectShareItem(tag);
    };

    //增加
    [superView addSubview:self];
}


- (UIButton *)createBtn:(CGRect)frame imageName:(NSString *)imangeName title:(NSString *)title Target:(id)target Sel:(SEL)sel {
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = frame;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imangeName]];
    CGFloat imgWidth = frame.size.width-2*kSpace;
    imageView.frame = CGRectMake((frame.size.width - imgWidth)/2,5, imgWidth, imgWidth);
    [shareBtn addSubview:imageView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(imageView.frame)+5,frame.size.width, 15)];
    [label setText:title];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [shareBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [shareBtn addSubview:label];
    return shareBtn;
}


- (void)setFrame:(CGRect)frame {
    frame.size.width = kScreenWidth;
    if (frame.size.height <= 0) {
        frame.size.height = 0;
    }
    frame.origin.x = 0;
    [super setFrame:frame];
}

- (void)addBackgroundView:(UIView *)superView {
    _backgroundView = [[UIView alloc] initWithFrame:superView.bounds];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.4;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleButtonAction)];
    [_backgroundView addGestureRecognizer:tap];
    [superView addSubview:_backgroundView];
}

- (void)cancleButtonAction {
    [_backgroundView removeFromSuperview];
    _backgroundView = nil;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect sf = self.frame;
        sf.origin.y = kScreenHeight;
        self.frame = sf;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)btnClick:(UIButton *)sender {
    NSInteger index = [self getHandleTypeWithIndex:sender.tag];
    if(_btnBlock) _btnBlock(index);
}

- (NSInteger)getHandleTypeWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 5;
            break;
        default:
            break;
    }
    return 0;
}

@end

