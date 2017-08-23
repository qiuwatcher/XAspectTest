//
//  CPShareMenuView.h
//  XAspectDemo
//
//  Created by SoulWater on 16/12/26.
//  Copyright © 2016年 SoulWater. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectItemBlock)(NSInteger index);

//分享面板样式
typedef NS_ENUM(NSInteger, CPShareViewStyle) {
    CPShareViewStylePlain = 0,          // 平铺
    CPShareViewStylePopping = 1         // 弹出
};

@interface CPShareMenuView : UIView

//菜单文字设置
@property(nonatomic,strong)UIFont *shareItemButtonFont;
@property(nonatomic,strong)UIColor *shareItemButtonColor;

//底部取消相关设置
@property(nonatomic,strong)UIColor *cancelBackgroundColor;
@property(nonatomic,copy)NSString *cancelButtonText;
@property(nonatomic,strong)UIFont *cancelButtonFont;
@property(nonatomic,strong)UIColor *cancelButtonColor;

/**
 *  弹出分享
 *
 *  @param superView       父视图
 *  @param style           样式
 *  @param selectShareItem 点击回调
 */
- (void)addShareItems:(UIView *)superView  style:(CPShareViewStyle)style frame:(CGRect)frame selectShareItem:(selectItemBlock)selectShareItem;





@end
