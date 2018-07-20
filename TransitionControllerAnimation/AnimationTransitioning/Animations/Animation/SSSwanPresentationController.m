//
//  CustomPresentationController.m
//  PresentDismissTransitionDemo
//
//  Created by Yang,Shuo(MBD) on 2018/7/6.
//  Copyright © 2018年 . All rights reserved.
//

#import "SSSwanPresentationController.h"
#import "SSSwanAnimationManage.h"

@interface SSSwanPresentationController()

@property (strong, nonatomic) UIView *maskView;
@property (nonatomic,strong) UIView *contview;
@property(nonatomic,strong)id <UIViewControllerTransitionCoordinator>transitionCoordinator;

@end

@implementation SSSwanPresentationController

- (UIView *)maskView {
    if (_maskView) {
        return _maskView;
    }
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = KSSAnimatedAlpha;
    return _maskView;
}

//过渡即将开始时的处理
- (void)presentationTransitionWillBegin {
    self.maskView.frame = self.containerView.frame;
    self.contview = self.containerView;
    [self.contview addSubview:self.presentingViewController.view];
    [self.contview addSubview:self.maskView];
    [self.contview addSubview:self.presentedView];
    
    // 使用 presentingViewController 的 transitionCoordinator,
    // 背景 maskView 的淡入效果与过渡效果一起执行
    self.maskView.alpha = 0.0;
    self.transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.maskView.alpha = KSSAnimatedAlpha;
        
    } completion:nil];
}

- (BOOL)shouldRemovePresentersView {
    return YES;
}

//在呈现过渡结束时被调用的
- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.maskView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    self.transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.maskView.alpha = 0;
    } completion:nil];
}

//过渡消失时的处理
- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.maskView removeFromSuperview];
    }
//  [[[UIApplication sharedApplication]keyWindow] addSubview:self.presentingViewController.view];
}

@end
