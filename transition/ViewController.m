//
//  ViewController.m
//  transition
//
//  Created by Lazy Lee on 2021/6/5.
//

#import "ViewController.h"
#import "VC2.h"
#import "Transition.h"

@interface ViewController ()<UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property(nonatomic, strong)Transition *transition;
@property(nonatomic, strong)UIPercentDrivenInteractiveTransition *interactive;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transition = [Transition new];
//    self.transition.type = TransitionTypeOpenDoor;
    self.navigationController.delegate = self;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.image.userInteractionEnabled = YES;
    [self.image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action)]];
    
}


- (void)action {
    VC2 *vc = [VC2 new];
    
    // push
    [self.navigationController pushViewController:vc animated:YES];
    return;
    
    // present
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    
}

// push delegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  API_AVAILABLE(ios(7.0)); {
    return self.transition;
}


// present delegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source; {
    return self.transition;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed; {
    return self.transition;
}

@end
