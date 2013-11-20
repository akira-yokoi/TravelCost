//
//  ViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/03.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface CostInputViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property BOOL fromFavorite;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) NSNumber *travelCostRowId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)selectMenu:(id)sender;
- (IBAction)selectSave:(id)sender;

@end
