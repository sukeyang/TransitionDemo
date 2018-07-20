//
//  WHBackPriorViewAnimation.m
//  SwitchControllerAnimation
//
//  Created by  www.6dao.cc on 16/6/16.
//  Copyright © 2016年 ss. All rights reserved.
//

#import "WHBackPriorViewAnimation.h"


@implementation WHBackPriorViewAnimation

- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController * fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    fromVc.view.hidden = YES;
    [[transitionContext containerView] addSubview:fromVc.snapshot];
    [[transitionContext containerView] addSubview:toVc.view];
    [[toVc.navigationController.view superview] insertSubview:fromVc.snapshot belowSubview:toVc.navigationController.view];
    
    toVc.navigationController.view.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(bounds));
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromVc.snapshot.alpha = 0.3;
                         fromVc.snapshot.transform = CGAffineTransformMakeScale(0.965, 0.965);
                         toVc.navigationController.view.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
                     }
                     completion:^(BOOL finished) {
                         fromVc.view.hidden = NO;
                         [fromVc.snapshot removeFromSuperview];
                         [toVc.snapshot removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

- (UIView *)getNavigationBarSnapShotWtihNav:(UINavigationController *)nav {
    
    UIView *bar = nav.navigationBar;
    BOOL hidden = bar.hidden || bar.alpha < 0.01;
    if (!hidden) {
        
        CGRect rect = nav.navigationBar.frame;
        //navigation bar的frame不包含status bar与底部分割线
        rect.size.height = CGRectGetMaxY(rect) + 1;
        rect.origin.y = 0;
        //页面复杂截全屏相当耗时, 展示一张图片的页面平均耗时20~30ms, 只保留bar的快照约10ms
        //            self.popAnimation.snapshotBar = [self.weakNavigationController.view snapshotViewAfterScreenUpdates:NO];
        UIView *view = [nav.view resizableSnapshotViewFromRect:rect afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        return view;
        
    }
    return nil;
    
}
- (void)pop1:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController * fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
   __block CGRect bounds = [[UIScreen mainScreen] bounds];
    
//    [fromVc.view addSubview:fromVc.snapshot];
  
    fromVc.view.transform = CGAffineTransformIdentity;
    
//    toVc.view.hidden = YES;
    
    toVc = toVc.navigationController.viewControllers.lastObject;
    UIView *toContent = toVc.navigationController.view;
//    [toContent addSubview:[self getNavigationBarSnapShotWtihNav:fromVc.navigationController]];
    
    toContent.alpha = 0.3;
    toContent.transform = CGAffineTransformMakeScale(0.965, 0.965);
    
    [[transitionContext containerView] addSubview:toVc.view];
//    [[transitionContext containerView] addSubview:fromVc.view];
//    UIView *window = [toVcsusup.navigationController.view superview];
    [[transitionContext containerView] addSubview:fromVc.view];
    
     UIView *window = [toVc.navigationController.view superview];
    [window addSubview:fromVc.view];
    
//    [[transitionContext containerView] addSubview:toVc.snapshot];
//    [[transitionContext containerView] sendSubviewToBack:toVc.snapshot];
    
    fromVc.navigationController.navigationBar.hidden = YES;
    [UIView animateWithDuration:1.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromVc.view.frame = CGRectMake(0, CGRectGetHeight(bounds),bounds.size.width,bounds.size.height);
                         toContent.alpha = 1.0;
                         toContent.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         
                        
                      
                         
                         [fromVc.snapshot removeFromSuperview];
                         [fromVc.view removeFromSuperview];
//                         [toContent removeFromSuperview];
                         fromVc.snapshot = nil;
                         
                         toVc.view.hidden = NO;
                          toVc.navigationController.navigationBar.hidden = NO;
                         // Reset toViewController's `snapshot` to nil
                         if (![transitionContext transitionWasCancelled]) {
                             toContent.alpha = 1.0;
                         }
                         
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

- (void)pop:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    __block UIView *fromSnapshotView = [[UIApplication sharedApplication].keyWindow snapshotViewAfterScreenUpdates:NO];
    __block UIView *toSnapshotView = nil;
    toSnapshotView = toVC.navigationController.view;;
    UIView *containerView = [transitionContext containerView];
    
    //    CGRect frame = fromSnapshotView.frame;
    //    //调整截图位置
    //    fromSnapshotView.frame = CGRectMake(0, self.animationStartPositionY, frame.size.width, frame.size.height);
    //    [fromVC.view addSubview:fromSnapshotView];
    //    fromVC.view.transform = CGAffineTransformIdentity;
    
    //    toVC.view.hidden = YES;
    
    [containerView addSubview:toVC.view];
    //    [containerView addSubview:toSnapshotView];
    toSnapshotView.alpha = 0.4;
    //    [containerView addSubview:fromVC.view];
    UIView *window = [toVC.navigationController.view superview];
    [window addSubview:fromSnapshotView];
    
    //    [containerView addSubview:fromVC.view];
    
    // 导航栏 由于导航栏可能没有,缓存中加载的
    UINavigationController *swanNavigation = fromVC.navigationController;
    if (!swanNavigation) {
        swanNavigation = toVC.navigationController;
    }
    swanNavigation.navigationBar.hidden = YES;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromSnapshotView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(bounds));
                         //                         toSnapshotView.alpha = 0.0;
                         toSnapshotView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         toVC.navigationController.navigationBar.hidden = NO;
                         toVC.view.hidden = NO;
                         
                         //                         fromVC.view.transform = CGAffineTransformIdentity;
                         [fromSnapshotView removeFromSuperview];
                         //                          [fromVC.view removeFromSuperview];
                         //                         [toSnapshotView removeFromSuperview];
                         fromSnapshotView = nil;
                         
                         // 重设 toViewController's `snapshot` to nil
                         if (![transitionContext transitionWasCancelled]) {
                             toSnapshotView.alpha = 1.0;
                         }
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}


@end



// 正常的动画使用 SpringWithDamping 类型的动画; 使用手势pop时候, 使用这个类, 使用普通样式的动画, 因为这时候使用SpringWithDamping类型动画会导致滑动过快.
@implementation WHBackPriorViewAnimationInteractive

- (void)pop:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
   __block UIView *fromSnapshotView = [[UIApplication sharedApplication].keyWindow snapshotViewAfterScreenUpdates:NO];
    UIView *toSnapshotView = nil;
    toSnapshotView = toVC.navigationController.view;;
    UIView *containerView = [transitionContext containerView];
    
    //    CGRect frame = fromSnapshotView.frame;
    //    //调整截图位置
    //    fromSnapshotView.frame = CGRectMake(0, self.animationStartPositionY, frame.size.width, frame.size.height);
    //    [fromVC.view addSubview:fromSnapshotView];
    //    fromVC.view.transform = CGAffineTransformIdentity;
    
    //    toVC.view.hidden = YES;
    
    [containerView addSubview:toVC.view];
    //    [containerView addSubview:toSnapshotView];
    toSnapshotView.alpha = 0.4;
    //    [containerView addSubview:fromVC.view];
    UIView *window = [toVC.navigationController.view superview];
    [window addSubview:fromSnapshotView];
    
    //    [containerView addSubview:fromVC.view];
    
    // 导航栏 由于导航栏可能没有,缓存中加载的
    UINavigationController *swanNavigation = fromVC.navigationController;
    if (!swanNavigation) {
        swanNavigation = toVC.navigationController;
    }
    swanNavigation.navigationBar.hidden = YES;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromSnapshotView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(bounds));
                         //                         toSnapshotView.alpha = 0.0;
                         toSnapshotView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         toVC.navigationController.navigationBar.hidden = NO;
                         toVC.view.hidden = NO;
                         
                         //                         fromVC.view.transform = CGAffineTransformIdentity;
                         [fromSnapshotView removeFromSuperview];
                         //                          [fromVC.view removeFromSuperview];
                         //                         [toSnapshotView removeFromSuperview];
                         fromSnapshotView = nil;
                         
                         toSnapshotView.alpha = 1.0;
                         // 重设 toViewController's `snapshot` to nil
                         if (![transitionContext transitionWasCancelled]) {
                           
                         } else {
                             
                         }
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}


@end

