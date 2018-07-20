//
//  SSSwanAnimationManage.h
//  SS
//
//  Created by Yang,Shuo(MBD) on 2018/7/5.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 透明度
FOUNDATION_EXPORT const CGFloat KSSAnimatedAlpha;
/// 动画时间
FOUNDATION_EXPORT const NSTimeInterval KSSAnimatedDurtion;
/// 顶部视图阴影的偏移量
FOUNDATION_EXPORT const CGFloat SSAnimatedShadowOffsetX;
/// 顶部视图阴影的模糊半径
FOUNDATION_EXPORT const CGFloat SSAnimatedShadowRadius;
/// 顶部视图阴影的不透明
FOUNDATION_EXPORT const CGFloat  SSAnimatedShadowOpacity;

@interface SSSwanAnimationManage : NSObject


/**
 添加阴影效果
 @param view 目标View
 */
+ (void)addShadowToView:(UIView *)view;

/**
 重置删掉阴影效果
 @param view 目标View
 */
+ (void)removeShadowToView:(UIView *)view;
@end
