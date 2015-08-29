//
//  Animal.m
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/29.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import "Animal.h"

static const CGSize ANIMAL_SIZE = {40, 40};

@implementation Animal

+ (UILabel *)animal {
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = ANIMAL_SIZE;
    
    UILabel *animalLabel = [[UILabel alloc] initWithFrame:frame];
    animalLabel.backgroundColor = [UIColor clearColor];
    animalLabel.text = [self createAnimal];
    
    return animalLabel;
}

+ (NSString *)createAnimal {
    switch (arc4random() % 8) {
            case 0: return @"🐷";
            case 1: return @"🐶";
            case 2: return @"🐻";
            case 3: return @"🐸";
            case 4: return @"🐌";
            case 5: return @"🐮";
            case 6: return @"🐯";
            case 7: return @"🐵";
            
            default:return @"🐷";
    }
    return @"🐷";
}

@end
