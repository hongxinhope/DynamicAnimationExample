//
//  BilliardsBall.m
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/29.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import "BilliardsBall.h"

@implementation BilliardsBall

+ (UIView *)ball {
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = CGSizeMake(BALL_RADIUS, BALL_RADIUS);
    
    UIView *ball = [[UIView alloc] initWithFrame:frame];
    ball.backgroundColor = [self ballColor];
    ball.layer.masksToBounds = YES;
    ball.layer.cornerRadius = BALL_RADIUS / 2;
    
    return ball;
}

+ (UIColor *)ballColor {
    switch(arc4random() % 6) {
        case 0: return [UIColor whiteColor];
        case 1: return [UIColor yellowColor];
        case 2: return [UIColor redColor];
        case 3: return [UIColor purpleColor];
        case 4: return [UIColor greenColor];
        case 5: return [UIColor blueColor];
            
        default: return [UIColor whiteColor];
    }
    return [UIColor whiteColor];
}

@end
