//
//  ListViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/29.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "BaseViewController.h"

@interface ListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *values;
}

- (void) reload;

/** サブクラスで実装 */
- (UITableView *) getTableView;
- (void) setCellData:(UITableViewCell *)cell value:(id)value;
- (NSArray *) getValues;
- (void) selectRow: (id)item;
- (void) updateOrder;
- (BOOL) canDelete;
- (BOOL) canOrder;
@end
