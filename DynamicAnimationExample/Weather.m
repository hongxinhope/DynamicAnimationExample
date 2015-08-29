//
//  Weather.m
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/29.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import "Weather.h"

static const CGSize RAINDROP_SIZE = {22, 24};
static const CGSize SNOWFLAKE_SIZE = {22, 21};

@implementation Weather

+ (UILabel *)raindrop {
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = RAINDROP_SIZE;
    
    NSInteger x = (arc4random() % (NSInteger)kScreenWidth) / RAINDROP_SIZE.width;
    frame.origin.x = x * RAINDROP_SIZE.width;
    
    UILabel *raindropLabel = [[UILabel alloc] initWithFrame:frame];
    raindropLabel.backgroundColor = [UIColor clearColor];
    raindropLabel.text = @"💧";
    raindropLabel.tag = raindropTag;
    
    return raindropLabel;
}

+ (UILabel *)snowflake {
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = SNOWFLAKE_SIZE;
    
    NSInteger x = (arc4random() % (NSInteger)kScreenWidth) / SNOWFLAKE_SIZE.width;
    frame.origin.x = x * SNOWFLAKE_SIZE.width;
    
    UILabel *snowflakeLabel = [[UILabel alloc] initWithFrame:frame];
    snowflakeLabel.backgroundColor = [UIColor clearColor];
    snowflakeLabel.font = [UIFont systemFontOfSize:17];
    snowflakeLabel.text = @"❄️";
    snowflakeLabel.tag = snowflakeTag;
    
    return snowflakeLabel;

}

+ (double)rainInterval {
    switch(arc4random() % 10) {
        case 1: return 0.1;
        case 2: return 0.2;
        case 3: return 0.3;
//        case 4: return 0.4;
//        case 5: return 0.5;
//        case 6: return 0.6;
//        case 7: return 0.7;
//        case 8: return 0.8;
//        case 9: return 0.9;
        default: return 0.2;
    }
    return 0.2;
}

+ (double)snowInterval {
    switch(arc4random() % 10) {
//        case 1: return 0.1;
//        case 2: return 0.2;
        case 3: return 0.3;
        case 4: return 0.4;
        case 5: return 0.5;
        case 6: return 0.6;
        case 7: return 0.7;
//        case 8: return 0.8;
//        case 9: return 0.9;
        default: return 0.5;
    }
    return 0.5;
}

@end
