//
//  ItemSettingManager.h
//  TravelCost
//
//  Created by 横井朗 on 2013/11/01.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ItemSettingDao.h"
#import "ItemSettingModel.h"

@interface ItemSettingManager : NSObject

+ (ItemSettingManager *) instance;

- (void) setUpdate: (NSDate *) update;

- (NSDate *) getUpdateTime;

- (NSMutableArray *) getInputItemSettingList;

- (void) reload;

@end
