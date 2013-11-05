//
//  SettingViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/11/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
{
    NSUserDefaults *defaults;
}

@end

@implementation SettingViewController

NSString * const USER_DEFAULT_KEY_MAIL_ADDRESS = @"mail_address";

- (void) viewDidLoad{
    [super viewDidLoad];
    
    self.mailText.delegate = self;
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *mailAddress = [defaults stringForKey:USER_DEFAULT_KEY_MAIL_ADDRESS];
    self.mailText.text = mailAddress;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    [defaults setObject:textField.text forKey:USER_DEFAULT_KEY_MAIL_ADDRESS];
    
    return YES;
}

@end
