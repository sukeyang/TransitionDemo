---
title: iOS 视图控制器转场详解
categories: 'ios'
date: 2018-07-19 16:23:50
tags:
---

最近在研究微信小程序的入场和出场动画所以对这块进行了调研，总结一些踩过的坑

### 一.model转场动画Present\Dismiss。

```
转场代理
@protocol UIViewControllerTransitioningDelegate
```

```
// 展示的动画
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;

// 消失的动画
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;

// 手势驱动的动画，手势驱动的实现
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator;

// 手势驱动的动画消失，手势驱动的实现
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator;

// 新的方法，操作性比较大
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0);

```

### 二.UINavigationControllerDelegate，Pop 和 Push 的自定义动画。

```

// 手势驱动
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0);

// 转场动画
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0);
                                                  
```

### 三.手势交互,主要类是UIPercentDrivenInteractiveTransition

```
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
            self.shouldComplete = percent > 0.5;
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
```
### 四.动画实现类，UIViewControllerAnimatedTransitioning

```
// 动画时间
-(NSTimeInterval)transitionDuration:(id < UIViewControllerContextTransitioning >)transitionContext; 

// 转场动画效果实现的位置
-(void)animateTransition:(id < UIViewControllerContextTransitioning >)transitionContext; 。

```

具体代码

```
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // 1. Get controllers from transition context
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 2. Set init frame for toVC
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height);
    
    // 3. Add toVC's view to containerView
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    // 4. Do animate now
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         toVC.view.frame = finalFrame;
                     } completion:^(BOOL finished) {
                         // 5. Tell context that we completed.
                         [transitionContext completeTransition:YES];
                     }];
}
```

`一些注意:`
1.在动画结束后我们必须向context报告VC切换完成，是否成功（在这里的动画切换中，没有失败的可能性，因此直接pass一个YES过去）。系统在接收到这个消息后，将对VC状态进行维护。
2.尽量使用系统提供的方法`finalFrameForViewController`来确定位置，`由于 iOS11和iOS10等系统对转场动画结束的处理方式不一致，在手势驱动结束和取消的时候进行动画的还原`否则会出现莫名其妙的 bug，例如黑屏，

```
-(CGRect)initialFrameForViewController:(UIViewController *)vc; 某个VC的初始位置，可以用来做动画的计算。

-(CGRect)finalFrameForViewController:(UIViewController *)vc; 与上面的方法对应，得到切换结束时某个VC应在的frame。

-(UIView *)containerView; VC切换所发生的view容器，开发者应该将切出的view移除，将切入的view加入到该view容器中。

-(UIViewController *)viewControllerForKey:(NSString *)key; 提供一个key，返回对应的VC。现在的SDK中key的选择只有UITransitionContextFromViewControllerKey和UITransitionContextToViewControllerKey两种，分别表示将要切出和切入的VC。

```

`问题：`

1.目前发现在iOS9.0模拟器表现不正确，目前最新已经是 ios12Beta，未找到真机测试，测试了几个比较好，都有这个问题，在这里推荐一个比较好的库[VCTransitionsLibrary](https://github.com/ColinEberhardt/VCTransitionsLibrary#using-an-interaction-controller)

2.还有就是在手势滑动结束的时候，动画会闪动,然后变成正常的位置，转场动画尽量添加到containerView，进行否则会出现莫名其妙的的 bug,使用下面代码，尝试去解决

```
/**
 手动接管 取消流程,在10.3.2 plus上取消时,位置不正确
 cancelInteractiveTransition
 */
- (void)continueAction {
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(UIChange)];
         [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopCADisplayLink {
    [_link setPaused:YES];
    [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [_link invalidate];
    _link = nil;
}

- (void)UIChange{
    CGFloat timeDistance = 2.0/60;
    if (_percent > 0.5) {
        _percent += timeDistance;
    } else {
        _percent -= timeDistance;
    }
    [self updateInteractiveTransition:_percent];
    if (_percent >= 1.0) {
        [self finishInteractiveTransition];
        [self stopCADisplayLink];
    }
    
   if (_percent <= 0.0) {
        [self cancelInteractiveTransition];
        [self stopCADisplayLink];
    }
}

```

手势驱动结束滑动之后，剩余距离的速度
```
/**
 手势最后的运动速度
 @return 速度值
 */
- (CGFloat)completionSpeed {
    return 1 - self.percentComplete;
}
```


-----------------------

[参考链接1](http://kittenyang.com/magicmove/)

[onecat](https://onevcat.com/2013/10/vc-transition-in-ios7/)

[生命周期](http://wangling.me/2014/02/the-inconsistent-order-of-view-transition-events.html)

[唐巧大大](https://blog.devtang.com/2016/03/13/iOS-transition-guide/)

[参考地址](https://satanwoo.github.io/2015/11/12/Swift-UITransition-iOS8/)
