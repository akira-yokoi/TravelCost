//
//  TravelCostModel.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "TravelCostModel.h"

@implementation TravelCostModel

NSString * const TCM_TABLE_NAME = @"travel_cost";

NSString * const TCM_COLUMN_ROW_ID = @"row_id";
NSString * const TCM_COLUMN_DATE = @"date";
NSString * const TCM_COLUMN_TRANS_TYPE = @"trans_type";
NSString * const TCM_COLUMN_RIDE_LOCATION = @"ride_location";
NSString * const TCM_COLUMN_DROP_OFF_LOCATION = @"drop_off_location";
NSString * const TCM_COLUMN_ONE_WAY = @"one_way";
NSString * const TCM_COLUMN_AMOUNT = @"amount";
NSString * const TCM_COLUMN_FAVORITE_ORDER = @"favorite_order";

- (NSString *)getTableName{
    return TCM_TABLE_NAME;
}

- (NSString *)getIdColumnName{
    return TCM_COLUMN_ROW_ID;
}

- (NSArray *)getValueColumnNames{
    return @[ TCM_COLUMN_DATE, TCM_COLUMN_TRANS_TYPE, TCM_COLUMN_RIDE_LOCATION, TCM_COLUMN_DROP_OFF_LOCATION, TCM_COLUMN_ONE_WAY, TCM_COLUMN_AMOUNT, TCM_COLUMN_FAVORITE_ORDER];
}

- (Model *)newEntity{
    return [[TravelCostModel alloc]init];
}

@end
