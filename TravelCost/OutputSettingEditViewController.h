//
//  OutputSettingEditViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/18.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OutputSettingItemViewController.h"
#import "ModalViewDelegate.h"

@interface OutputSettingEditViewController : UIViewController<ModalViewDelegate>
- (IBAction)helpSelected:(id)sender;
- (IBAction)addStringSelected:(id)sender;
- (IBAction)addItemSelected:(id)sender;
- (IBAction)saveSelected:(id)sender;

@end
