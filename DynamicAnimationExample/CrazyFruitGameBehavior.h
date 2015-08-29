//
//  CrazyFruitGameBehavior.h
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/30.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrazyFruitGameBehavior : UIDynamicBehavior

@property (strong, nonatomic) UICollisionBehavior *collider;

- (instancetype)init;

- (void)addItem:(id <UIDynamicItem>)item;
- (void)removeItem:(id <UIDynamicItem>)item;

@end
