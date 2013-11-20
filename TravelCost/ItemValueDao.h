//
//  ItemValueDao.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/05.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemValueModel.h"
#import "ItemSettingDao.h"
#import "Dao.h"

@interface ItemValueDao : Dao

+ (NSString *) createTableSql;

- (NSArray *) getValueModels: (int) travelCostId;

- (NSString *)getHistoryValues: (int) itemSettingId;

@end
