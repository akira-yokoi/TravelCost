//
//  ViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/03.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemSettingDao.h"
#import "ItemValueDao.h"
#import "TravelCostDao.h"

#import "ItemValueModel.h"
#import "ItemSettingModel.h"
#import "TravelCostModel.h"

#import "InputViewCell.h"
#import "InputViewSwitchCell.h"

#import "DateKeyboardViewController.h"
#import "PickerKeyboardViewController.h"

#import "FMDatabase.h"

#import "ViewUtil.h"
#import "DateTimeUtil.h"
#import "TableUtil.h"
#import "iToast.h"

#import "InputSettingListViewController.h"

@interface CostInputViewController : UIViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) NSNumber *travelCostRowId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)selectMenu:(id)sender;
- (IBAction)selectSave:(id)sender;

@end
