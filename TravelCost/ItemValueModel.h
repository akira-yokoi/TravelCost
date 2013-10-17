//
//  ItemValueModel.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "ItemSettingModel.h"
#import "TravelCostModel.h"

@interface ItemValueModel : Model

extern NSString * const IVM_TABLE_NAME;
extern NSString * const IVM_COLUMN_ROW_ID;
extern NSString * const IVM_COLUMN_ITEM_SETTING_ID;
extern NSString * const IVM_COLUMN_TRAVEL_COST_ID;
extern NSString * const IVM_COLUMN_VALUE;

@property (strong, nonatomic) NSNumber *rowId;
@property (strong, nonatomic) NSNumber *itemSettingId;
@property (strong, nonatomic) NSNumber *travelCostId;
@property (strong, nonatomic) NSString *value;

@property (strong, nonatomic) ItemSettingModel *_itemSettingModel;
@property (strong, nonatomic) TravelCostModel *_travelCostModel;

+ (ItemValueModel *) initFromSetting: (ItemSettingModel *)setting;

@end
