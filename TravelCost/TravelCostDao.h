//
//  TravelCostDao.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TravelCostModel.h"
#import "Dao.h"
#import "TableUtil.h"
#import "ItemValueDao.h"
#import "StringUtil.h"

@interface TravelCostDao : Dao

+ (NSString *) createTableSql;

- (BOOL) saveTravelCost: (TravelCostModel *)costModel values:(NSArray *)values;

@end
