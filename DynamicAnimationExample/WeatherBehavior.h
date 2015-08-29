//
//  WeatherBehavior.h
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/29.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherBehavior : UIDynamicBehavior

@property (strong, nonatomic) UICollisionBehavior *collider;
@property (strong, nonatomic) UIPushBehavior *windBlow;

@property (nonatomic) CGFloat weatherGravityMagnitude;

- (instancetype)initWithGravityMagnitude:(CGFloat)gravityMagnitude;

- (void)addItem:(id <UIDynamicItem>)item;
- (void)removeItem:(id <UIDynamicItem>)item;

@end
