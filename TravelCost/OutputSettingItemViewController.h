//
//  OutputSettingItemViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/21.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "ItemSettingDao.h"
#import "ItemSettingModel.h"
#import "ModalViewDelegate.h"

@interface OutputSettingItemViewController : BaseViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSString *outputSetting;
@property (nonatomic) id<ModalViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *fixStringText;
@property (weak, nonatomic) IBOutlet UIPickerView *inputItemPicker;

- (IBAction)segmentChanged:(id)sender;
- (IBAction)okSelected:(id)sender;
- (IBAction)cancelSelected:(id)sender;

@end
