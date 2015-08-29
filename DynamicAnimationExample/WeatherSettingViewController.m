//
//  WeatherSettingViewController.m
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/29.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import "WeatherSettingViewController.h"
#import "SwitchCell.h"

static NSString *kWeatherCellID = @"WeatherCell";

@interface WeatherSettingViewController ()

@end

@implementation WeatherSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.weather == WeatherModeNone) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Weather";
    } else if (section == 1) {
        return @"Wind";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWeatherCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWeatherCellID];
        }
        
        if (indexPath.row == self.weather) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"None";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"❄️ Snow";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"☔️ Rain";
        }
        
        return cell;
    } else {
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:kSwitchCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.statusSwitch.on = self.windy;
        [cell.statusSwitch addTarget:self action:@selector(didSwitchWindStatus:) forControlEvents:UIControlEventValueChanged];
        cell.titleLabel.text = @"🍃 Wind";
        return cell;
    }
}

- (void)didSwitchWindStatus:(UISwitch *)sender {
    self.windy = sender.on;
    
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWindDidChanged object:@(self.windy)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row != self.weather)  {
            self.weather = indexPath.row;
            self.windy = NO;
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWindDidChanged object:@(self.windy)];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWeatherDidChanged object:@(self.weather)];
        }
    }
}

@end
