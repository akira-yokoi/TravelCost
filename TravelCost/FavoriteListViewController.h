//
//  FavoriteListViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/11/15.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "BaseViewController.h"

@interface FavoriteListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
