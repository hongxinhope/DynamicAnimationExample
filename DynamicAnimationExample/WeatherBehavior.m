//
//  WeatherBehavior.m
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/29.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import "WeatherBehavior.h"

@interface WeatherBehavior ()

@property (strong, nonatomic) UIGravityBehavior *gravity;

@end

@implementation WeatherBehavior

- (instancetype)initWithGravityMagnitude:(CGFloat)gravityMagnitude {
    if (self = [super init]) {
        _weatherGravityMagnitude = gravityMagnitude;
        [self addChildBehavior:self.gravity];
    }
    
    return self;
}

- (UIGravityBehavior *)gravity {
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = _weatherGravityMagnitude;
    }
    return _gravity;
}

- (void)addItem:(id <UIDynamicItem>)item {
    [self.gravity addItem:item];
    if (self.collider) {
        [self.collider addItem:item];
    }
    if (self.windBlow) {
        [self.windBlow addItem:item];
    }
}

- (void)removeItem:(id <UIDynamicItem>)item {
    [self.gravity removeItem:item];
    if (self.collider) {
        [self.collider removeItem:item];
    }
    if (self.windBlow) {
        [self.windBlow removeItem:item];
    }
}

@end
