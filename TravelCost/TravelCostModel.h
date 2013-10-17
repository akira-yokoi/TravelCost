//
//  TravelCostModel.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"


@interface TravelCostModel : Model

extern NSString * const TCM_TABLE_NAME;
extern NSString * const TCM_COLUMN_ROW_ID;
extern NSString * const TCM_COLUMN_DATE;
extern NSString * const TCM_COLUMN_TRANS_TYPE;
extern NSString * const TCM_COLUMN_RIDE_LOCATION;
extern NSString * const TCM_COLUMN_DROP_OFF_LOCATION;
extern NSString * const TCM_COLUMN_ONE_WAY;
extern NSString * const TCM_COLUMN_AMOUNT;
extern NSString * const TCM_COLUMN_FAVORITE_ORDER;

@property (strong, nonatomic) NSNumber *rowId;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *transType;
@property (strong, nonatomic) NSString *rideLocation;
@property (strong, nonatomic) NSString *dropOffLocation;
@property (strong, nonatomic) NSString *oneWay;
@property (strong, nonatomic) NSNumber *amount;
@property (strong, nonatomic) NSNumber *favoriteOrder;

@end
