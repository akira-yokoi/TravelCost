//
//  OutputSettingListViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/18.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemSettingModel.h"
#import "ItemSettingDao.h"
#import "ListViewController.h"
#import "OutputSettingListViewCell.h"
#import "OutputSettingEditViewController.h"

@interface OutputSettingListViewController : ListViewController

@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@end
