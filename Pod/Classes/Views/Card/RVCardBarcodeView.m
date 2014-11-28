//
//  RVCardBarcodeView.m
//  Rover
//
//  Created by Ata Namvari on 2014-10-14.
//  Copyright (c) 2014 Rover Labs Inc. All rights reserved.
//

#import "RVCardBarcodeView.h"
#import "RVCardView.h"

#import <RSBarcodes/RSCodeGen.h>

@implementation RVCardBarcodeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:41/255.f green:41/255.f blue:41/255.f alpha:1];
        [self setTitle:@"use this offer"];
        [self.buttonBar setLeftButtonTitle:@"Back" andRightButtonTitle:nil];
        //[self.longDescriptionTextView setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}

- (void)setBarcode:(NSString *)code withType:(NSString *)barcodeType
{
    if ([barcodeType isEqualToString:@"PLU"]) {
        [self setPLUCode:code];
    } else {
        [self setStandardBarcode:code withType:barcodeType];
    }
}

- (void)setPLUCode:(NSString *)code
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(560, 350), YES, [UIScreen mainScreen].scale);

    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:126],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]
                                     };
    
    CGSize textSize = [code boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:textAttributes context:nil].size;
    
    [code drawAtPoint:CGPointMake(280 - (textSize.width / 2), 110) withAttributes:textAttributes];
    
    [@"PLU" drawAtPoint:CGPointMake(245, 60) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:36],
                                                              NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
	UIImage *PLUImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setImage:PLUImage];
}

- (void)setStandardBarcode:(NSString *)code withType:(NSString *)barcodeType
{
    UIImage *codeImage = [CodeGen genCodeWithContents:code machineReadableCodeObjectType:barcodeType];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(560, 350), YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    {
        //Set the stroke (pen) color
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        //Set the width of the pen mark
        CGContextSetLineWidth(context, 10.0);
        
        // Draw a line
        CGContextMoveToPoint(context, 65.0, 75.0);
        CGContextAddLineToPoint(context, 65.0, 275.0);
        CGContextStrokePath(context);
    }
    
    CGContextDrawImage(context, CGRectMake(70, 75, 420, 200), [codeImage CGImage]);
    {
        // Draw a line
        CGContextMoveToPoint(context, 495.0, 75.0);
        CGContextAddLineToPoint(context, 495.0, 275.0);
        CGContextStrokePath(context);
    }
    
    // text
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:34],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                     NSKernAttributeName: @10.f};
    CGSize textSize = [code boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:textAttributes context:nil].size;
    [code drawAtPoint:CGPointMake(280 - (textSize.width / 2), 280) withAttributes:textAttributes];
    
    CGContextRestoreGState(context);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self setImage:newImage];
}

- (void)cardTapped
{
    if (!self.isExpanded) {
        [self flipToCardView];
    }
}

#pragma mark - RVCardViewBarButtonDelegate

- (void)buttonBarLeftButtonPressed:(RVCardViewButtonBar *)buttonBar {
    if (self.isExpanded) {
        [self slideInCardView];
    } else {
        [self flipToCardView];
    }
}

- (void)buttonBarRightButtonPressed:(RVCardViewButtonBar *)buttonBar {
    // Add to Passbook
}

- (void)flipToCardView
{
    [UIView transitionWithView:self.superview duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self removeFromSuperview];
                        [self.cardView addSubview:self.cardView.containerView];
                        [self.cardView configureContainerLayout];
                    } completion:NULL];
}

- (void)slideInCardView
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.superview.layer addAnimation:transition forKey:nil];
    
    [self removeFromSuperview];
    [self.cardView addSubview:self.cardView.containerView];
    [self.cardView configureContainerLayout];
}

- (void)contractToFrame:(CGRect)frame atCenter:(CGPoint)center animated:(BOOL)animated
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [super contractToFrame:frame atCenter:center animated:animated];
        self.frame = self.cardView.bounds;
    } completion:^(BOOL finished) {
        
    }];
}

@end
