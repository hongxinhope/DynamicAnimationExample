//
//  WeatherSettingViewController.h
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/29.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WeatherMode) {
    WeatherModeNone = 0,
    WeatherModeSnowy,
    WeatherModeRainy,
};

@interface WeatherSettingViewController : UITableViewController

@property (nonatomic) WeatherMode weather;
@property (nonatomic) BOOL windy;

@end
