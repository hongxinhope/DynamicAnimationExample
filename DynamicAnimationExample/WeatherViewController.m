//
//  WeatherViewController.m
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/29.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherSettingViewController.h"
#import "Animal.h"
#import "Weather.h"
#import "WeatherBehavior.h"
#import "BezierPathView.h"

@interface WeatherViewController ()

@property (weak, nonatomic) IBOutlet BezierPathView *weatherView;
@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (strong, nonatomic) WeatherBehavior *rainBehavior;
@property (strong, nonatomic) WeatherBehavior *snowBehavior;

@property (nonatomic) BOOL isRaining;
@property (nonatomic) BOOL isSnowing;
@property (nonatomic) BOOL isWindy;
@property (strong, nonatomic) NSTimer *rainTimer;
@property (strong, nonatomic) NSTimer *snowTimer;

@end

@implementation WeatherViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.weatherView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weatherDidChanged:) name:kWeatherDidChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windDidChanged:) name:kWindDidChanged object:nil];
}

- (void)dealloc {
    if (self.rainTimer) {
        [self.rainTimer invalidate];
        self.rainTimer = nil;
    }
    
    if (self.snowTimer) {
        [self.snowTimer invalidate];
        self.snowTimer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Rain
- (void)rain {
    self.isRaining = YES;
    self.rainBehavior = [[WeatherBehavior alloc] initWithGravityMagnitude:0.8];
    [self.animator addBehavior:self.rainBehavior];
    self.rainTimer = [NSTimer scheduledTimerWithTimeInterval:[Weather rainInterval] target:self selector:@selector(addRaindrop) userInfo:nil repeats:YES];
}

- (void)addRaindrop {
    UILabel *raindrop = [Weather raindrop];
    
    if (self.rainBehavior.windBlow) {
        CGFloat rotateAngle = -atan(self.rainBehavior.windBlow.magnitude / self.rainBehavior.weatherGravityMagnitude);
        
        raindrop.transform = CGAffineTransformMakeRotation(rotateAngle);
    }
    
    [self.weatherView addSubview:raindrop];
    [self.rainBehavior addItem:raindrop];
}

- (void)stopRain {
    [self.rainTimer invalidate];
    self.rainTimer = nil;
    [self.animator removeBehavior:self.rainBehavior];
    for (UIView *subview in self.weatherView.subviews) {
        if ([subview isKindOfClass:[UILabel class]] && subview.tag == raindropTag) {
            [subview removeFromSuperview];
        }
    }
    self.isRaining = NO;
}

#pragma mark - Snow
- (void)snow {
    self.isSnowing = YES;
    self.snowBehavior = [[WeatherBehavior alloc] initWithGravityMagnitude:0.08];
    [self.animator addBehavior:self.snowBehavior];
    self.snowTimer = [NSTimer scheduledTimerWithTimeInterval:[Weather snowInterval] target:self selector:@selector(addSnowflake) userInfo:nil repeats:YES];
}

- (void)addSnowflake {
    UILabel *snowflake = [Weather snowflake];
    
    if (self.snowBehavior.windBlow) {
        CGFloat rotateAngle = -atan(self.snowBehavior.windBlow.magnitude / self.snowBehavior.weatherGravityMagnitude);
        
        snowflake.transform = CGAffineTransformMakeRotation(rotateAngle);
    }
    
    [self.weatherView addSubview:snowflake];
    [self.snowBehavior addItem:snowflake];
}

- (void)stopSnow {
    [self.snowTimer invalidate];
    self.snowTimer = nil;
    [self.animator removeBehavior:self.snowBehavior];
    for (UIView *subview in self.weatherView.subviews) {
        if ([subview isKindOfClass:[UILabel class]] && subview.tag == snowflakeTag) {
            [subview removeFromSuperview];
        }
    }
    self.isSnowing = NO;
}

#pragma mark - Wind
- (void)wind {
    WeatherBehavior *weatherBehavior;
    CGFloat windMagnitude = 0.0;
    if (self.isRaining) {
        weatherBehavior = self.rainBehavior;
        windMagnitude = 0.2;
    } else if (self.isSnowing) {
        weatherBehavior = self.snowBehavior;
        windMagnitude = 0.015;
    } else {
        return;
    }
    
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[] mode:UIPushBehaviorModeContinuous];
    pushBehavior.angle = 0.0;
    pushBehavior.magnitude = windMagnitude;
    weatherBehavior.windBlow = pushBehavior;
    [weatherBehavior addChildBehavior:weatherBehavior.windBlow];
    
    self.isWindy = YES;
}

- (void)stopWind {
    WeatherBehavior *weatherBehavior;
    if (self.isRaining) {
        weatherBehavior = self.rainBehavior;
    } else if (self.isSnowing) {
        weatherBehavior = self.snowBehavior;
    } else {
        return;
    }
    
    weatherBehavior.windBlow = nil;
    self.isWindy = NO;
}

#pragma mark - Selector
- (void)weatherDidChanged:(NSNotification *)notification {
    NSInteger weather = [notification.object integerValue];
    
    if (weather == WeatherModeNone) {
        if (self.isRaining) {
            [self stopRain];
        }
        if (self.isSnowing) {
            [self stopSnow];
        }
    } else if (weather == WeatherModeSnowy) {
        if (self.isRaining) {
            [self stopRain];
        }
        [self snow];
    } else if (weather == WeatherModeRainy) {
        if (self.isSnowing) {
            [self stopSnow];
        }
        [self rain];
    }
}

- (void)windDidChanged:(NSNotification *)notification {
    BOOL needWind = [notification.object boolValue];
    
    if (needWind) {
        [self wind];
    } else {
        [self stopWind];
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PresentSettingViewController"]) {
        if ([segue.destinationViewController isKindOfClass:[WeatherSettingViewController class]]) {
            WeatherSettingViewController *settingViewController = segue.destinationViewController;
            if (self.isSnowing) {
                settingViewController.weather = WeatherModeSnowy;
            } else if (self.isRaining) {
                settingViewController.weather = WeatherModeRainy;
            } else {
                settingViewController.weather = WeatherModeNone;
            }
            settingViewController.windy = self.isWindy;
        }
    }
}

@end
