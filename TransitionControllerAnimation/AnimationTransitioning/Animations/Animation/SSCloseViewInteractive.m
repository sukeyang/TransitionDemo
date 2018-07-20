//
//  SSCloseViewInteractive.h
//  SS
//
//  Created by yangshuo on 2018/6/14.
//  Copyright © 2018年 . All rights reserved.
//

#import "SSCloseViewInteractive.h"

/// 完成的进度阈值,大于这个会执行完成
static const CGFloat KSSAnimatedThreshold = 0.5;

@interface SSCloseViewInteractive ()<UIGestureRecognizerDelegate>

@property (nonatomic,assign) BOOL shouldComplete;
@property (nonatomic) UIViewController *animationViewController;
@property (nonatomic) UIScreenEdgePanGestureRecognizer *edgePan;

@end

@implementation SSCloseViewInteractive

- (void)addCloseViewInteractiveToViewController:(UIViewController *)viewController {
    self.animationViewController = viewController;
    self.edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    self.edgePan.edges = UIRectEdgeLeft;
//    self.edgePan.maximumNumberOfTouches = 1;
    self.edgePan.delegate = self;
//    NSArray *gestures = viewController.view.gestureRecognizers;
//    if (gestures.count) {
//        [self.edgePan requireGestureRecognizerToFail:gestures.lastObject];
//    }
    [viewController.view addGestureRecognizer:self.edgePan];
}

- (void)onPan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:pan.view.superview];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            // 开始驱动动画
            self.interactionInProgress = YES;
            [self.animationViewController.navigationController popViewControllerAnimated:YES];
        } break;
        case UIGestureRecognizerStateChanged: {
            CGFloat percent =  translation.x / [UIScreen mainScreen].bounds.size.width;
            percent = MIN(1.0, MAX(0.0, percent));
            [self updateInteractiveTransition:percent];
            // see: https://github.com/ColinEberhardt/VCTransitionsLibrary/issues/4
            if (percent >= 1.0) {
                percent = 0.99;
            }
            self.shouldComplete = percent > KSSAnimatedThreshold;
        }  break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
             self.interactionInProgress = NO;
            if (pan.state == UIGestureRecognizerStateCancelled || !self.shouldComplete) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
        } break;
        default:
            break;
    }
}

/**
 手势最后的运动速度
 @return 速度值
 */
- (CGFloat)completionSpeed {
    return 1 - self.percentComplete;
}
@end
