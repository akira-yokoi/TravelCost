//
//  ItemSettingDao.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/05.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemSettingModel.h"
#import "Dao.h"

@interface ItemSettingDao : Dao

+ (NSString *) createTableSql;

@end
