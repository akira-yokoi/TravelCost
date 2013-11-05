//
//  ListViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/09.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "CostListViewController.h"

@interface CostListViewController ()
{
    NSMutableArray *values;
}

@end

@implementation CostListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated{
    [self reload];
}


- (void) reload{
    // 一覧の取得
    TravelCostDao *dao = [[TravelCostDao alloc] init];
    values = [dao list];
    [self.tableView reloadData];
    
    int total = 0;
    for( TravelCostModel *model in values){
        total += [model.amount intValue];
    }
    self.totalLabel.text = [StringUtil addComma:total];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table

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
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    TravelCostModel *costModel = values[ indexPath.row];
    
    cell.dateLabel.text = [NSString stringWithFormat: @"%@日", [DateTimeUtil getD:costModel.date]];
    
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
    
    // 片道
    NSString *oneWay = [StringUtil killNull: costModel.oneWay];
    cell.oneWayLabel.text = oneWay;
    
    // 交通手段
    NSString *transType = [StringUtil killNull: costModel.transType];
    cell.transTypeLabel.text = transType;

    cell.amountLabel.text = [StringUtil addComma: [costModel.amount intValue]];
    return cell;
}

/**
 * 詳細画面へ
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *sequeId = [segue identifier];
    if ([sequeId isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        TravelCostModel *costModel = values[ indexPath.section];
        NSNumber *rowId = costModel.rowId;
  
        [[segue destinationViewController] setTravelCostRowId:rowId];
    }
}

@end
