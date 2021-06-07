//
//  VC2.m
//  transition
//
//  Created by Lazy Lee on 2021/6/5.
//

#import "VC2.h"
#import "Transition.h"

@interface VC2 ()<UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>
@property(nonatomic, strong)Transition *transition;
@property(nonatomic, strong)UIPercentDrivenInteractiveTransition *interactive;
@end

@implementation VC2
- (IBAction)action:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义转场
    self.navigationController.delegate = self;
    self.transition = [Transition new];
//    self.transition.type = TransitionTypeOpenDoor;
    
    // 自定义手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
}

// 转场动画
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  API_AVAILABLE(ios(7.0)); {
    return self.transition;
}


// 手势返回
-(void)handlePan:(UIScreenEdgePanGestureRecognizer *)recognizer{
    //计算手指滑的物理距离（滑了多远，与起始位置无关）
    CGFloat progress = [recognizer translationInView:self.view].x / self.view.bounds.size.width;
    NSLog(@"%f", progress);
    progress = MIN(1.0, MAX(0.0, progress)); //把这个百分比限制在0~1之间
    
    //当手势刚刚开始，我们创建一个 UIPercentDrivenInteractiveTransition 对象
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.interactive = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        //当手慢慢划入时，我们把总体手势划入的进度告诉 UIPercentDrivenInteractiveTransition 对象。
        [self.interactive updateInteractiveTransition:progress];
    }else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
        //当手势结束，我们根据用户的手势进度来判断过渡是应该完成还是取消并相应的调用 finishInteractiveTransition 或者 cancelInteractiveTransition 方法.
        if (progress > 0.5) {
            [self.interactive finishInteractiveTransition];
        }else{
            [self.interactive cancelInteractiveTransition];
        }
    }
}

// 手势返回的过程
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController API_AVAILABLE(ios(7.0)); {
    return self.interactive;
}



@end
