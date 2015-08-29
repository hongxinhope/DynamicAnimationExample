//
//  SwitchCell.h
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/12/13.
//  Copyright © 2015年 Xin Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kSwitchCellID = @"SwitchCell";

@interface SwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;

@end
