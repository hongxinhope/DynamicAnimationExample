//
//  Fruit.m
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/30.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import "Fruit.h"

static const CGSize FRUIT_SIZE = {40, 44};

@implementation Fruit

+ (UILabel *)fruit {
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = FRUIT_SIZE;
    
    frame.origin.x = kScreenWidth - FRUIT_SIZE.width;
    NSInteger y = (arc4random() % (NSInteger)kScreenHeight) / FRUIT_SIZE.height;
    frame.origin.y = y * FRUIT_SIZE.height;
    
    UILabel *fruitLabel = [[UILabel alloc] initWithFrame:frame];
    fruitLabel.backgroundColor = [UIColor clearColor];
    fruitLabel.font = [UIFont systemFontOfSize:34];
    fruitLabel.text = [self createFruit];
    
    return fruitLabel;
}

+ (NSString *)createFruit {
    switch (arc4random() % 8) {
        case 0: return @"🍅";
        case 1: return @"🍊";
        case 2: return @"🍏";
        case 3: return @"🍑";
        case 4: return @"🍐";
        case 5: return @"🍍";
        case 6: return @"🍉";
        case 7: return @"🍎";
            
        default:return @"🍅";
    }
    return @"🍅";
}

@end
