//
//  Transition.m
//  transition
//
//  Created by Lazy Lee on 2021/6/5.
//

#import "Transition.h"
#import "VC2.h"
#import "ViewController.h"

@implementation Transition

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    if(self.type == TransitionTypeMagicMove) {
        ViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        VC2 *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        UIView *containerView = [transitionContext containerView];
        UIView *snapShotView = [fromVC.image snapshotViewAfterScreenUpdates:NO];
        snapShotView.frame = fromVC.image.frame;
        fromVC.image.hidden = YES;
        
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.alpha = 0;
        
        //把动画前后的两个view加到容器中
        [containerView addSubview:snapShotView];
        [containerView addSubview:toVC.view];
        
        //动起来。第二个控制器的透明度0~1；让截图SnapShotView的位置更新到最新；
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toVC.view.alpha = 1;
            snapShotView.frame = [containerView convertRect:toVC.image.frame fromView:toVC.view];
        } completion:^(BOOL finished) {
            fromVC.image.hidden = NO;
            [transitionContext completeTransition:YES];
        }];
    }
    else if(self.type == TransitionTypeOpenDoor) {
        UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        UIView *container = [transitionContext containerView];
        UIView *snapToView = [to.view snapshotViewAfterScreenUpdates:YES];
        
        CGRect leftFrame = from.view.frame;
        leftFrame.size.width = CGRectGetWidth(leftFrame)/2.0;
        
        CGRect rightFrame = from.view.frame;
        rightFrame.size.width = CGRectGetWidth(rightFrame)/2.0;
        rightFrame.origin.x = CGRectGetWidth(rightFrame);
        
        UIView *snapLeft = [from.view resizableSnapshotViewFromRect:leftFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        snapLeft.frame = leftFrame;
        
        UIView *snapRight = [from.view resizableSnapshotViewFromRect:rightFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        snapRight.frame = rightFrame;
        
        snapToView.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1);
        
        [container addSubview:snapToView];
        [container addSubview:snapLeft];
        [container addSubview:snapRight];
        
        // hide from view
        from.view.hidden = YES;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // move left
            snapLeft.frame = CGRectOffset(leftFrame, -leftFrame.size.width, 0);
            // move right
            snapRight.frame = CGRectOffset(rightFrame, rightFrame.size.width, 0);
            snapToView.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            from.view.hidden = NO;
            [snapLeft removeFromSuperview];
            [snapRight removeFromSuperview];
            [snapToView removeFromSuperview];
            BOOL cancel = [transitionContext transitionWasCancelled];
            if(cancel) {
                [container addSubview:from.view];
            }
            else {
                [container addSubview:to.view];
            }
            [transitionContext completeTransition:!cancel];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 2;
}

@end
