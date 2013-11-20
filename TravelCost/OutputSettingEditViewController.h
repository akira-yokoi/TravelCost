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
#import "ReflectionUtil.h"
#import "ViewUtil.h"

@interface OutputSettingEditViewController : UIViewController<ModalViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) ItemSettingModel *settingModel;

- (IBAction)helpSelected:(id)sender;
- (IBAction)addItemSelected:(id)sender;
- (IBAction)saveSelected:(id)sender;
- (IBAction)deleteSelected:(id)sender;

@end
