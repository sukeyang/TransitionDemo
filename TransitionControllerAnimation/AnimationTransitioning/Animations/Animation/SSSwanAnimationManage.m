//
//  SSSwanAnimationManage.m
//  SS
//
//  Created by Yang,Shuo(MBD) on 2018/7/5.
//  Copyright © 2018年 . All rights reserved.
//

#import "SSSwanAnimationManage.h"

/// 透明度
const CGFloat KSSAnimatedAlpha = 0.5;
/// 动画时间
const NSTimeInterval KSSAnimatedDurtion = 0.3;
/// 顶部视图阴影的偏移量
const CGFloat SSAnimatedShadowOffsetX = -3.0f;
/// 顶部视图阴影的模糊半径
const CGFloat SSAnimatedShadowRadius = 20.0f;
/// 顶部视图阴影的不透明
const CGFloat  SSAnimatedShadowOpacity = 0.29f;

@implementation SSSwanAnimationManage

+ (void)addShadowToView:(UIView *)view {
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f,SSAnimatedShadowOffsetX);
    view.layer.shadowRadius = SSAnimatedShadowRadius;
    view.layer.shadowOpacity = SSAnimatedShadowOpacity;
}

+ (void)removeShadowToView:(UIView *)view {
    view.layer.shadowColor = nil;
    view.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
    view.layer.shadowRadius = 0;
    view.layer.shadowOpacity = 0;
}

@end
