//
//  SettingViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/11/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListViewController.h"

@interface SettingViewController : UITableViewController<UITextFieldDelegate>

extern NSString * const USER_DEFAULT_KEY_MAIL_ADDRESS;

@property (weak, nonatomic) IBOutlet UITextField *mailText;

@end
