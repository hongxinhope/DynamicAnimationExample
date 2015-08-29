//
//  Weather.h
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/29.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define raindropTag 100
#define snowflakeTag 200

@interface Weather : NSObject

+ (UILabel *)raindrop;
+ (UILabel *)snowflake;
+ (double)rainInterval;
+ (double)snowInterval;

@end
