//
//  InputSettingEditViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/17.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "ItemSettingModel.h"

@interface InputSettingEditViewController : BaseViewController

@property (nonatomic) ItemSettingModel *settingModel;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// 項目名
@property (weak, nonatomic) IBOutlet UITextField *nameText;

// データタイプ
@property (weak, nonatomic) IBOutlet UITextField *dataTypeText;

// デフォルト値
@property (weak, nonatomic) IBOutlet UILabel *defaultValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *defaultValueText;

// 単位,選択肢
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UITextField *unitText;

// 桁数
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UITextField *intLengthText;
@property (weak, nonatomic) IBOutlet UITextField *decimalLengthText;

// アクション
- (IBAction)helpSelected:(id)sender;
- (IBAction)deleteSelected:(id)sender;
- (IBAction)saveSelected:(id)sender;
@end
