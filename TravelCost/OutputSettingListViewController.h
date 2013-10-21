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
#import "BaseViewController.h"
#import "OutputSettingListViewCell.h"

@interface OutputSettingListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@end
