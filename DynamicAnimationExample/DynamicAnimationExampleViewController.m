//
//  DynamicAnimationExampleViewController.m
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/12/13.
//  Copyright © 2015年 Xin Hong. All rights reserved.
//

#import "DynamicAnimationExampleViewController.h"

@interface DynamicAnimationExampleViewController ()

@end

@implementation DynamicAnimationExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;
}

@end
