//
//  SSSwanAnimatedTransitioning.h
//  SS
//
//  Created by yangshuo on 2018/6/14.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SSAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
/// push方向
@property (nonatomic, assign) UINavigationControllerOperation transitionType;
/// 调整截屏的位置
@property (nonatomic, assign) CGFloat animationStartPositionY;
@end

