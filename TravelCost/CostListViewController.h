//
//  ListViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/09.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


#import "TravelCostDao.h"

#import "DateTimeUtil.h"
#import "ListViewCell.h"

#import "CostInputViewController.h"

@interface CostListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
- (IBAction)menuSelected:(id)sender;
- (IBAction)mailSelected:(id)sender;

@end
