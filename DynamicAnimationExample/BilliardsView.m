//
//  BilliardsView.m
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/29.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import "BilliardsView.h"

@implementation BilliardsView

- (void)setPath:(UIBezierPath *)path {
    _path = path;
    _isDrawingServeLine = YES;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *gameArea = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(BILLIARD_BORDER_WIDTH, BILLIARD_BORDER_WIDTH, self.bounds.size.width - BILLIARD_BORDER_WIDTH * 2, self.bounds.size.height - BILLIARD_BORDER_WIDTH * 2) cornerRadius:10];
    [[UIColor colorWithRed:0 /255.f green:128 / 255.f blue:0 / 255.f alpha:1.0] setFill];
    [gameArea fill];
    
    UIBezierPath *leftTopGoalHole = [UIBezierPath bezierPathWithArcCenter:CGPointMake(BILLIARD_BORDER_WIDTH + GOALHOLE_OFFSET, BILLIARD_BORDER_WIDTH + GOALHOLE_OFFSET) radius:GOALHOLE_RADIUS startAngle:0.0 endAngle:180.0 clockwise:YES];
    [[UIColor blackColor] setFill];
    [leftTopGoalHole fill];
    
    UIBezierPath *leftBottomGoalHole = [UIBezierPath bezierPathWithArcCenter:CGPointMake(BILLIARD_BORDER_WIDTH + GOALHOLE_OFFSET, self.bounds.size.height - BILLIARD_BORDER_WIDTH - GOALHOLE_OFFSET) radius:GOALHOLE_RADIUS startAngle:0.0 endAngle:180.0 clockwise:YES];
    [[UIColor blackColor] setFill];
    [leftBottomGoalHole fill];
    
    UIBezierPath *rightTopGoalHole = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width - BILLIARD_BORDER_WIDTH - GOALHOLE_OFFSET, BILLIARD_BORDER_WIDTH + GOALHOLE_OFFSET) radius:GOALHOLE_RADIUS startAngle:0.0 endAngle:180.0 clockwise:YES];
    [[UIColor blackColor] setFill];
    [rightTopGoalHole fill];
    
    UIBezierPath *rightBottomGoalHole = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width - BILLIARD_BORDER_WIDTH - GOALHOLE_OFFSET, self.bounds.size.height - BILLIARD_BORDER_WIDTH - GOALHOLE_OFFSET) radius:GOALHOLE_RADIUS startAngle:0.0 endAngle:180.0 clockwise:YES];
    [[UIColor blackColor] setFill];
    [rightBottomGoalHole fill];
    
    UIBezierPath *middleTopGoalHole = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, BILLIARD_BORDER_WIDTH) radius:GOALHOLE_RADIUS startAngle:0.0 endAngle:180.0 clockwise:YES];
    [[UIColor blackColor] setFill];
    [middleTopGoalHole fill];
    
    UIBezierPath *middleBottomGoalHole = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - BILLIARD_BORDER_WIDTH) radius:GOALHOLE_RADIUS startAngle:0.0 endAngle:180.0 clockwise:YES];
    [[UIColor blackColor] setFill];
    [middleBottomGoalHole fill];
    
    if (_isDrawingServeLine) {
        [self.path setLineWidth:7.0];
        [[UIColor whiteColor] setStroke];
        [self.path stroke];
    }
}

@end
