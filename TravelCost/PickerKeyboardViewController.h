//
//  PickerKeyboardViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/07.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StringUtil.h"
#import "KeyboardViewController.h"

@interface PickerKeyboardViewController : KeyboardViewController

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

- (IBAction)cancelSelected:(id)sender;
- (IBAction)okSelected:(id)sender;

@end
