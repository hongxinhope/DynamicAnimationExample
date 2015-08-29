//
//  BilliardsBehavior.m
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/29.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import "BilliardsBehavior.h"

@interface BilliardsBehavior ()

@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior;

@end

@implementation BilliardsBehavior

- (instancetype)init {
    if (self = [super init]) {
        [self addChildBehavior:self.collider];
        [self addChildBehavior:self.itemBehavior];
    }
    
    return self;
}

- (UICollisionBehavior *)collider {
    if (!_collider) {
        _collider = [[UICollisionBehavior alloc] init];
        _collider.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collider;
}

- (UIDynamicItemBehavior *)itemBehavior {
    if (!_itemBehavior) {
        _itemBehavior = [[UIDynamicItemBehavior alloc] init];
//        _itemBehavior.density = 10; // 密度
//        _itemBehavior.friction = 1.0; // 摩擦力
//        _itemBehavior.resistance = 1.0; // 阻力
//        _itemBehavior.elasticity = 10.0; // 弹力
    }
    return _itemBehavior;
}

- (void)addItem:(id <UIDynamicItem>)item {
    [self.collider addItem:item];
    [self.itemBehavior addItem:item];
}

- (void)removeItem:(id <UIDynamicItem>)item {
    [self.collider removeItem:item];
    [self.itemBehavior removeItem:item];
}

@end
