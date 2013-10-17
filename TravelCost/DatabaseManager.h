//
//  DatabaseManager.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DatabaseManager : NSObject

+(DatabaseManager *) instance;

-(BOOL) executeUpdate:(NSString *)sql,...;

-(BOOL) executeUpdates:(NSArray *)sqls;

-(FMDatabase *)connect;

-(void)disConnect:(FMDatabase *)db;

@end
