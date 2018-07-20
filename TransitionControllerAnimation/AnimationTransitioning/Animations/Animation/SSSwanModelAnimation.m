//
//  SSSwanModelAnimatiom.m
//  PresentDismissTransitionDemo
//
//  Created by Yang,Shuo(MBD) on 2018/7/5.
//  Copyright © 2018年 . All rights reserved.
//

#import "SSSwanModelAnimation.h"
#import "SSSwanAnimationManage.h"

@implementation SSSwanModelAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return KSSAnimatedDurtion;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    switch (_animationType) {
        case SSSwanModelAnimationTypeePresent:
            [self presentAnimation:transitionContext];
            break;
        case SSSwanModelAnimationTypeDissmiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}

#pragma mark - 不同动画效果

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    //设定presented view 一开始的位置，在屏幕下方
    CGRect initialframe = [transitionContext finalFrameForViewController:toVC];
    CGRect startframe = CGRectOffset(initialframe, 0, initialframe.size.height);
    toView.frame = startframe;
    [SSSwanAnimationManage addShadowToView:toView];
    
    [UIView animateWithDuration:duration animations:^{
        toView.frame = initialframe;
    } completion:^(BOOL finished) {
        if (finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }
    }];
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    [SSSwanAnimationManage addShadowToView:fromView];
    
    [UIView animateWithDuration:duration animations:^{
        // 滑下去
        CGRect finalframe = fromView.frame;
        finalframe.origin.y = containerView.bounds.size.height;
        fromView.frame = finalframe;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }
    }];
}

@end
