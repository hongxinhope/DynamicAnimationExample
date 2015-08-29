//
//  BilliardsBehavior.h
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/29.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BilliardsBehavior : UIDynamicBehavior

@property (strong, nonatomic) UICollisionBehavior *collider;

- (void)addItem:(id <UIDynamicItem>)item;
- (void)removeItem:(id <UIDynamicItem>)item;

@end
