//
//  BilliardsView.h
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/29.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat BILLIARD_BORDER_WIDTH = 60.0;
static const CGFloat GOALHOLE_OFFSET = 8.0;
static const CGFloat GOALHOLE_RADIUS = 30.0;

@interface BilliardsView : UIView

@property (strong, nonatomic) UIBezierPath *path;
@property (nonatomic) BOOL isDrawingServeLine;

@end
