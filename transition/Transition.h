//
//  Transition.h
//  transition
//
//  Created by Lazy Lee on 2021/6/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, TransitionType) {
    TransitionTypeMagicMove,
    TransitionTypeOpenDoor,
};
@interface Transition : NSObject<UIViewControllerAnimatedTransitioning>
@property(nonatomic, assign)TransitionType type;
@end

NS_ASSUME_NONNULL_END
