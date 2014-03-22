//
//  SettingsViewController.m
//  One
//
//  Created by Skylar Peterson on 3/17/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "SettingsViewController.h"

#import "Fonts.h"
#import "Colors.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.settingsLabel.font = [Fonts titleFont];
    self.settingsLabel.textColor = [Colors mainGrayColor];
}

@end
