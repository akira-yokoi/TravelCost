//
//  DatabaseManager.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager

static DatabaseManager *sharedInstance = nil;

NSString *const DB_FILE = @"sqlite.db";


+ (DatabaseManager *)instance{
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

- (BOOL)executeUpdate:(NSString*)sql, ... {
    FMDatabase *db = [self connect];
    [db open];
    
    va_list args;
    va_start(args, sql);
    BOOL result = [db executeUpdate:sql, args];
    va_end(args);
    
    [self disConnect:db];
    
    return result;
}

- (BOOL) executeUpdates:(NSArray *)sqls{
    FMDatabase *db = [self connect];
    [db open];
    BOOL result = NO;
    for( NSString *sql in sqls){
        result = [db executeUpdate:sql];
        if( result == NO){
            break;
        }
    }
    [self disConnect:db];
    return result;
}


/**
 * データベースへ接続
 */
- (FMDatabase *)connect{
    BOOL success;
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent: DB_FILE];
    NSLog(@"%@",writableDBPath);
    success = [fm fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: DB_FILE];
        success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if(!success){
            NSLog(@"%@",[error localizedDescription]);
        }
    }
    FMDatabase *fmdb = [FMDatabase databaseWithPath:writableDBPath];
    fmdb.traceExecution = YES;
    return fmdb;
}



/**
 * データベースの切断
 */
-(void)disConnect:(FMDatabase *)db{
    [db close];
}

@end
