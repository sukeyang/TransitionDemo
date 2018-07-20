//
//  SSCloseViewInteractive.h
//  SS
//
//  Created by yangshuo on 2018/6/14.
//  Copyright © 2018年 . All rights reserved.
//

#import "SSSwanAnimatedTransitioning.h"
#import "SSSwanAnimationManage.h"
#import <objc/runtime.h>

@interface UIViewController (SwanAnimationTransitioningSnapshot)
@property (nonatomic, strong) UIView *swanSnapshot;
@end

@implementation UIViewController (SwanAnimationTransitioningSnapshot)

- (UIImage *)swanSnapshot {
    UIImage *view = objc_getAssociatedObject(self, @"SwanAnimationTransitioningSnapshot");
    return view;
}

- (void)setSwanSnapshot:(UIImage *)snapshot {
    objc_setAssociatedObject(self, @"SwanAnimationTransitioningSnapshot", snapshot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
@end


@interface SSAnimatedTransitioning ()
@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation SSAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return KSSAnimatedDurtion;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.transitionType == UINavigationControllerOperationPush) {
        [self push:transitionContext];
    } else if (self.transitionType == UINavigationControllerOperationPop) {
        [self pop3:transitionContext];
    }
}

-(UIImage *)screenShotView:(UIView *)view{
    UIImage *imageRet = [[UIImage alloc]init];
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
}

/**
 push 的自定义动画
 @param transitionContext transitionContext
 */
- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    fromVC.view.hidden = YES;
    __block UIView *fromSnapshotView = [[UIApplication sharedApplication].keyWindow snapshotViewAfterScreenUpdates:NO];
    UIView *toView = toVC.view;
    CGRect frame = toView.frame;
    //调整截图位置
    toView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [[transitionContext containerView] addSubview:toView];
    
    [[toVC.navigationController.view superview] insertSubview:fromSnapshotView belowSubview:toVC.navigationController.view];
    toVC.navigationController.view.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(bounds));
    fromSnapshotView.alpha = KSSAnimatedAlpha;
    [SSSwanAnimationManage addShadowToView:toVC.navigationController.view];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         //                         fromVC.swanSnapshot.alpha = KSSAnimatedAlpha;
                         toVC.navigationController.view.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         [SSSwanAnimationManage removeShadowToView:toVC.navigationController.view];
                         
                         toView.frame = frame;
                         fromVC.view.hidden = NO;
                         [fromSnapshotView removeFromSuperview];
                         //                         [toVC.swanSnapshot removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}


//- (void)push1:(id<UIViewControllerContextTransitioning>)transitionContext {
//    UIView * toView   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
//    UIView * fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
//    UIView * containerView = [transitionContext containerView];
//
//    //    self.containerLayer = containerView.layer;
//    UIView * maskView = [[UIView alloc]initWithFrame:containerView.bounds];
//    maskView.alpha = 0.5;
//    UIColor * maskViewBgColor = [UIColor blackColor];
//    maskView.backgroundColor = maskViewBgColor;
//
//    [containerView addSubview:fromView];
//    [containerView addSubview:maskView];
//    [containerView addSubview:toView];
//
//    __weak typeof(self)this = self;
//    __weak typeof(containerView) containerViewWeaked = containerView;
//    __weak typeof(fromView) fromViewWeaked = fromView;
//    __weak typeof(toView) toViewWeaked = toView;
//    __weak typeof(maskView) maskViewWeaked = maskView;
//    __weak typeof(transitionContext)transitionContextWeaked = transitionContext;
//
//    CGRect fromViewDesRect = containerView.bounds;
//    float changeRation = 1.0f;
//    fromViewDesRect.origin.x = CGRectGetWidth(fromViewDesRect) * changeRation;
//    toView.frame = fromViewDesRect;
//
//    //    [self animationDidStart:containerView andToView:toView andFromView:fromView andMaskView:maskView];
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f options:UIViewAnimationOptionTransitionNone animations:
//     ^{
//           toView.frame = containerView.bounds;
////         CGRect fromViewDesRect = containerView.bounds;
////         float changeRation = 1.0f;
////         fromViewDesRect.origin.x = CGRectGetWidth(fromViewDesRect) * changeRation;
////         toView.frame = fromViewDesRect;
//
//         maskView.alpha = 0.0f;
//
//     } completion:^(BOOL finished) {
//         [transitionContextWeaked completeTransition:![transitionContextWeaked transitionWasCancelled]];
//         [maskViewWeaked removeFromSuperview];
//     }];
//}

//- (void)pop:(id <UIViewControllerContextTransitioning>)transitionContext {
//    UIView * toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
//    UIView * fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
//    UIView * containerView = [transitionContext containerView];
//
////    self.containerLayer = containerView.layer;
//    UIView * maskView = [[UIView alloc]initWithFrame:containerView.bounds];
//    maskView.alpha = 0.5;
//    UIColor * maskViewBgColor = [UIColor blackColor];
//    maskView.backgroundColor = maskViewBgColor;
//
//    [containerView addSubview:toView];
//    [containerView addSubview:maskView];
//    [containerView addSubview:fromView];
//
//    __weak typeof(self)this = self;
//    __weak typeof(containerView) containerViewWeaked = containerView;
//    __weak typeof(fromView) fromViewWeaked = fromView;
//    __weak typeof(toView) toViewWeaked = toView;
//    __weak typeof(maskView) maskViewWeaked = maskView;
//    __weak typeof(transitionContext)transitionContextWeaked = transitionContext;
//
////    [self animationDidStart:containerView andToView:toView andFromView:fromView andMaskView:maskView];
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f options:UIViewAnimationOptionTransitionNone animations:
//     ^{
//         CGRect fromViewDesRect = containerView.bounds;
//         float changeRation = 1.0f;
//         fromViewDesRect.origin.x = CGRectGetWidth(fromViewDesRect) * changeRation;
//         fromView.frame = fromViewDesRect;
//         toView.frame = containerView.bounds;
//         maskView.alpha = 0.0f;
//
//     } completion:^(BOOL finished) {
//         [transitionContextWeaked completeTransition:![transitionContextWeaked transitionWasCancelled]];
//         [maskViewWeaked removeFromSuperview];
//     }];
//}
//
//- (void)removeOtherViews:(UIView*)viewToKeep {
//    UIView* containerView = viewToKeep.superview;
//    for (UIView* view in containerView.subviews) {
//        if (view != viewToKeep) {
//            [view removeFromSuperview];
//        }
//    }
//}

- (UIView *)getNavigationBarSnapShotWithViewController:(UIViewController *)controller {
    UIView *bar = controller.navigationController.navigationBar;
    bool hidden = bar.hidden || bar.alpha < 0.01;
    if (!hidden) {
        CGRect rect = controller.navigationController.navigationBar.frame;
        //navigation bar的frame不包含status bar与底部分割线
        rect.size.height = CGRectGetMaxY(rect) + 1;
        rect.origin.y = 0;
        //页面复杂截全屏相当耗时, 展示一张图片的页面平均耗时20~30ms, 只保留bar的快照约10ms
        //            self.popAnimation.snapshotBar = [self.weakNavigationController.view snapshotViewAfterScreenUpdates:NO];
        return [controller.navigationController.view resizableSnapshotViewFromRect:rect afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    }
    return nil;
}

/**
 pop 的自定义动画
 @param transitionContext transitionContext
 */

- (void)animationEnded:(BOOL) transitionCompleted {
    UIViewController *toVC = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (toVC.navigationController.navigationBar ) {
        [UIView animateWithDuration:0.2 animations:^{
            toVC.navigationController.navigationBar.alpha = 1.0;
        }];
    }
    
}

- (void)pop3:(id <UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;
    
    UIViewController *toVC  = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC  = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (fromVC.navigationController.navigationBar) {
        fromVC.navigationController.navigationBar.alpha = 0.0;
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    CGRect bounds = [[UIScreen mainScreen] bounds];
//     UIView *containerView = [transitionContext containerView];
    
    __block UIView *fromSnapshotView = [[UIApplication sharedApplication].keyWindow snapshotViewAfterScreenUpdates:NO];
    
    UIViewController *pushedVC =  fromVC.navigationController.viewControllers.lastObject;
    __block UIImage *toSnapshot;
    __block UIImageView *toSnapshotView;
    toSnapshot = pushedVC.swanSnapshot;
//    toSnapshotView.size;
    
//    __block UIView *toSnapshotView = [toVC.navigationController.view snapshotViewAfterScreenUpdates:NO];
    
//    fromVC.snapshot =fromSnapshotView;
    UIView * maskView = [[UIView alloc]initWithFrame:containerView.bounds];
    maskView.alpha = KSSAnimatedAlpha;
//   __block UIView *maskView = nil;
//    maskView = toVC.navigationController.view;
//     maskView.alpha = KSSAnimatedAlpha;
    
    UIColor * maskViewBgColor = [UIColor blackColor];
    maskView.backgroundColor = maskViewBgColor;
    if (toSnapshot) {
        toSnapshotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, toSnapshot.size.width, toSnapshot.size.height)];
        
        CGRect fromViewDesRect = toSnapshotView.bounds;
        fromViewDesRect.origin.y = -CGRectGetHeight(fromViewDesRect);
        toSnapshotView.frame = fromViewDesRect;
        [toView addSubview:toSnapshotView];
    }
    
    [fromView addSubview:fromSnapshotView];
//    }
    [SSSwanAnimationManage addShadowToView:fromSnapshotView];
    
    [containerView addSubview:toView];
    [containerView addSubview:maskView];
    [containerView addSubview:fromView];
    
    __weak typeof(maskView) maskViewWeaked = maskView;
    __weak typeof(transitionContext)transitionContextWeaked = transitionContext;
    // 导航栏 由于导航栏可能没有,缓存中加载的
    __block  UINavigationController *swanNavigation = fromVC.navigationController;
    if (!swanNavigation) {
        swanNavigation = toVC.navigationController;
    }
    swanNavigation.navigationBar.hidden = YES;

    
    //    [self animationDidStart:containerView andToView:toView andFromView:fromView andMaskView:maskView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f options:UIViewAnimationOptionTransitionNone animations:
     ^{
         CGRect fromViewDesRect = containerView.bounds;
         fromViewDesRect.origin.y = CGRectGetHeight(fromViewDesRect);
         fromView.frame = fromViewDesRect;
         toView.frame = containerView.bounds;
         maskView.alpha = 0.0f;
     } completion:^(BOOL finished) {
         toVC.navigationController.navigationBar.hidden = NO;
//          maskView.alpha = 1.0f;
         
         if ([transitionContextWeaked transitionWasCancelled]) {
               [containerView addSubview:fromView];
         } else {
               [containerView addSubview:toView];
         }
         [transitionContextWeaked completeTransition:![transitionContextWeaked transitionWasCancelled]];
         [maskViewWeaked removeFromSuperview];
//         maskViewWeaked = nil;
         [toSnapshotView removeFromSuperview];
          [fromSnapshotView removeFromSuperview];
//         fromSnapshotView = nil;
     }];
    
    return;
//    __block UIView *toMaskView = nil;
    
    
////    toMaskView = toVC.navigationController.view;
//       __block UIView *toMaskView = [toVC.navigationController.view snapshotViewAfterScreenUpdates:NO];
//
////   toMaskView = [[UIView alloc]initWithFrame:containerView.bounds];
////    maskView.alpha = 0.5;
//
//    __weak typeof(transitionContext)transitionContextWeaked = transitionContext;
//
//    [toVC.view addSubview:toMaskView];
//    [containerView addSubview:toVC.view];
//
//    toMaskView.alpha = KSSAnimatedAlpha;
//    toVC.view.hidden = YES;
////    UIView *window = toVC.navigationController.view superview];
//
//    [containerView addSubview:toMaskView];
//
////    [containerView addSubview:fromSnapshotView];
//    [SSSwanAnimationManage addShadowToView:fromSnapshotView];
//    [fromVC.view addSubview:fromSnapshotView];
//    fromVC.view.hidden = YES;
//    [containerView addSubview:fromVC.view];
//
//    // 导航栏 由于导航栏可能没有,缓存中加载的
//    __block  UINavigationController *swanNavigation = fromVC.navigationController;
//    if (!swanNavigation) {
//        swanNavigation = toVC.navigationController;
//    }
//    swanNavigation.navigationBar.hidden = YES;
//
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
//        fromSnapshotView.frame = CGRectMake(0, CGRectGetHeight(bounds),fromSnapshotView.frame.size.width,fromSnapshotView.frame.size.width);
//        toMaskView.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        toVC.navigationController.navigationBar.hidden = NO;
////        if ([transitionContext transitionWasCancelled]) {
////            [self removeOtherViews:fromVC.view];
////        } else {
////            [self removeOtherViews:toVC.view];
////        }
//        fromVC.view.hidden = NO;
//        toVC.view.hidden = NO;
//        [fromSnapshotView removeFromSuperview];
//        fromSnapshotView = nil;
//        toMaskView.alpha = 0.0;
//        [toMaskView removeFromSuperview];
//        toMaskView = nil;
//
//        [transitionContextWeaked completeTransition:![transitionContextWeaked transitionWasCancelled]];
//    }];
    
    
//    [[UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f options:UIViewAnimationOptionTransitionNone animations:
//      ^{
//          fromSnapshotView.frame = CGRectMake(0, CGRectGetHeight(bounds),fromSnapshotView.frame.size.width,fromSnapshotView.frame.size.width);
//          toMaskView.alpha = 1.0;
//
//      } completion:^(BOOL finished) {
//                      toVC.navigationController.navigationBar.hidden = NO;
//                         fromVC.view.hidden = NO;
//                         [fromSnapshotView removeFromSuperview];
//                         fromSnapshotView = nil;
//                         toMaskView.alpha = 1.0;
//                         [transitionContextWeaked completeTransition:![transitionContextWeaked transitionWasCancelled]];
//
//                     }];
}

//- (void)animationEnded:(BOOL)transitionCompleted {
//
//}
@end


