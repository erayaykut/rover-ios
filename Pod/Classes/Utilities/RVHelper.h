//
//  RVHelper.h
//  Pods
//
//  Created by Ata Namvari on 2014-11-13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RVCardBaseView;

@interface RVHelper : NSObject

+ (void)showMessage:(NSString *)message holdFor:(NSTimeInterval)seconds delay:(NSTimeInterval)delay duration:(NSTimeInterval)duration;
+ (void)displaySwipeTutorialWithCardView:(RVCardBaseView *)cardView completion:( void (^)(BOOL finished) )completion;
+ (void)displayTapTutorialAnimationAtPoint:(CGPoint)point completion:( void (^)(BOOL finished))completion;

@end
