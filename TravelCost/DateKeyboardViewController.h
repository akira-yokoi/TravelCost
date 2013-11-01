//
//  DateKeyboardViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/07.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DateTimeUtil.h"
#import "KeyboardViewController.h"

@interface DateKeyboardViewController : KeyboardViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)okSelected:(id)sender;
- (IBAction)cancelSelected:(id)sender;

@end
