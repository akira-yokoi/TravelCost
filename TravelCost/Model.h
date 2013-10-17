//
//  Model.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateTimeUtil.h"

@interface Model : NSObject

-(NSString *)getTableName;
-(NSString *)getIdColumnName;
-(NSArray *)getValueColumnNames;

- (Model *)newEntity;

@end
