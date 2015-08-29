//
//  CrazyFruitGameBehavior.m
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/30.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import "CrazyFruitGameBehavior.h"

@interface CrazyFruitGameBehavior ()

@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior;

@end

@implementation CrazyFruitGameBehavior

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
        _collider.translatesReferenceBoundsIntoBoundary = NO;
    }
    return _collider;
}

- (UIDynamicItemBehavior *)itemBehavior {
    if (!_itemBehavior) {
        _itemBehavior = [[UIDynamicItemBehavior alloc] init];
        _itemBehavior.allowsRotation = NO;
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
