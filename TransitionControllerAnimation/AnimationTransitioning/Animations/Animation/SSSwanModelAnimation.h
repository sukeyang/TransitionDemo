//
//  SSSwanModelAnimatiom.h
//  PresentDismissTransitionDemo
//
//  Created by Yang,Shuo(MBD) on 2018/7/5.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,SSSwanModelAnimationType) {
    SSSwanModelAnimationTypeePresent                    = 0,
    SSSwanModelAnimationTypeDissmiss,
};

@interface SSSwanModelAnimation : NSObject <UIViewControllerAnimatedTransitioning>

//动画类型
@property(nonatomic,assign) SSSwanModelAnimationType animationType;

@end
