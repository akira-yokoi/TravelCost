//
//  FavoriteListViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/11/15.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "FavoriteListViewController.h"

#import "TravelCostDao.h"
#import "ViewUtil.h"
#import "CostInputViewController.h"
#import "FavoriteListViewCell.h"

@interface FavoriteListViewController ()
{
    NSMutableArray *values;
}
@end

@implementation FavoriteListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reload];
}

- (void) reload{
    // 一覧の取得
    TravelCostDao *dao = [[TravelCostDao alloc] init];
    
    NSString *where = [NSString stringWithFormat:@"%@ is not null", TCM_COLUMN_FAVORITE_ORDER];
    values = [dao list:where order:TCM_COLUMN_FAVORITE_ORDER];
    [self.tableView reloadData];
    
    if( [values count] == 0){
        [ViewUtil showToast:@"対象データが存在しません"];
    }
}

#pragma mark Table

/** セルの選択 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TravelCostModel *costModel = [values objectAtIndex:indexPath.row];
    
    CostInputViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CostInputViewController"];
    vc.travelCostRowId = [costModel rowId];
    vc.fromFavorite = YES;
    [[self navigationController] pushViewController:vc animated:YES];
}

/** セクションの数 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/** データの数 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [values count];
    return count;
}

/** セルの作成 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    TravelCostModel *costModel = values[ indexPath.row];
    
    NSMutableString *routeText = [[NSMutableString alloc] init];
    
    // 乗車駅
    NSString *rideLocation = [StringUtil killNull: costModel.rideLocation];
    [routeText appendString: [StringUtil killNull: rideLocation]];
    
    // 降車駅
    NSString *dropOffLocation = [StringUtil killNull: costModel.dropOffLocation];
    if(! [StringUtil isEmpty:dropOffLocation]){
        [routeText appendString: [NSString stringWithFormat: @"〜%@", dropOffLocation]];
    }
    cell.routeLabel.text = routeText;
    cell.amountLabel.text = [StringUtil addComma: [costModel.amount intValue]];
    return cell;
}

@end
