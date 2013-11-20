//
//  OkCancelAccessoryViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/11/06.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KeyboardViewController.h"

@interface OkCancelAccessoryViewController : KeyboardViewController

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)cancelSelected:(id)sender;
- (IBAction)okSelected:(id)sender;

- (void) deleteCancelButton;

@end
