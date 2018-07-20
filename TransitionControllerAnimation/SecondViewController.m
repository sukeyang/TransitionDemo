//
//  SecondViewController.m
//  SwitchControllerAnimation
//
//  Created by  www.6dao.cc on 16/6/13.
//  Copyright © 2016年 ss. All rights reserved.
//

#import "SecondViewController.h"
#import "WHBaseAnimationTransitioning.h"
#import "SSCloseViewInteractive.h"
#import "SSSwanAnimatedTransitioning.h"

@interface SecondViewController ()
@property(nullable,nonatomic,weak) id <UINavigationControllerDelegate> originalDelegate;
@property (nonatomic, strong) SSCloseViewInteractive *interactiveTransition;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
//    self.navigationController.delegate = self;
    self.navigationController.delegate = self;
    
    [self configUI];
    self.originalDelegate = self.navigationController.delegate;
    self.navigationController.delegate = self;
    [self setUpPanGestureRecognizer];
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(0, 0, 200, 30);
    btn.backgroundColor = [UIColor redColor];
    
    [btn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpPanGestureRecognizer {
    if ([self isPresentDismiss]) {
        // 当前页面禁止侧滑返回
//        self.SSPopGestureDisable = YES;
        self.interactiveTransition = [[SSCloseViewInteractive alloc] init];
        [self.interactiveTransition addCloseViewInteractiveToViewController:self];
    }
    
    //    SSPopPanGestureRecognizer * realizer = [[SSPopPanGestureRecognizer alloc]initWithNavigationController:self.navigationController andSupportDirection:SupportGestureDirectionsToTop | SupportGestureDirectionsToBottom | SupportGestureDirectionsToRight | SupportGestureDirectionsToLeft];
    //    [self.view addGestureRecognizer:realizer];
}


- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)closeView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                       interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
//    return   self.interactiveTransition;
    BOOL isPresentDismiss = [self isPresentDismiss];
    return isPresentDismiss && self.interactiveTransition.interactionInProgress ? self.interactiveTransition : nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                                animationControllerForOperation:(UINavigationControllerOperation)operation
                                                             fromViewController:(UIViewController *)fromVC
                                                               toViewController:(UIViewController *)toVC {
    
    BOOL isPresentDismiss = [self isPresentDismiss];
    if (isPresentDismiss) {
        SSAnimatedTransitioning *transition = [SSAnimatedTransitioning new];
        transition.animationStartPositionY = -64;
        transition.transitionType = operation;
        return transition;
    } else {
        return  nil;
    }
}
- (BOOL)isPresentDismiss {
    return YES;
}
@end
