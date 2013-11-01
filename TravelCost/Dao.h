//
//  SingleEntityDao.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "DatabaseManager.h"
#import "ModelManager.h"
#import "StringUtil.h"
#import "ModelManager.h"

@interface Dao : NSObject
{
    Class clazz;
}

-(id) init;

// 検索系オペレーション
- (BOOL) existTable;
- (int) getCount;
- (int) getMax:(NSString *) columnName;
- (int) getMax:(NSString *) columnName db:(FMDatabase *)db;

-(NSMutableArray *) list;
-(NSMutableArray *) list:(NSString *)where order:(NSString *)order;
-(Model *) load:(NSNumber *)modelId;

// 更新系オペレーション
- (BOOL) saveModel:( Model *)model;
- (BOOL) saveModels:( NSArray *)models;
- (BOOL) deleteModel: (Model *)model;
- (BOOL) deleteModels:( NSArray *)models;

// SQLの生成
-( NSString *) createInsertSql:(Model *)model;
-( NSString *) createUpdateSql:(Model *)model;

// モデルから値を取得
-( NSArray *) getValues:(Model *)model columnNames:(NSArray *)columnNames;


@end
