//
//  SSCloseViewInteractive.h
//  SS
//
//  Created by yangshuo on 2018/6/14.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSCloseViewInteractive : UIPercentDrivenInteractiveTransition

/**
 标识开始进入手势驱动动画
 */
@property (nonatomic, assign) BOOL interactionInProgress;
/**
 添加退场手势
 @param viewController viewController
 */
- (void)addCloseViewInteractiveToViewController:(UIViewController *)viewController;

@end
