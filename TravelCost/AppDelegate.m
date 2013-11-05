//
//  AppDelegate.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/03.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "AppDelegate.h"

#import "ModelManager.h"
#import "DatabaseManager.h"
#import "TravelCostDao.h"
#import "ItemSettingDao.h"
#import "ItemValueDao.h"
#import "StringUtil.h"
#import "TableUtil.h"
#import "ViewUtil.h"

#import "TravelCostModel.h"
#import "ItemSettingDao.h"
#import "ItemValueDao.h"

@implementation AppDelegate

NSInteger const DB_VERSION = 1;
NSString *const DB_VERSION_KEY = @"DB_VERSION";

- (void) initData{
    // 初期設定データ
    {
        NSMutableArray *itemSettings = [[NSMutableArray alloc] init];
        
        // 日付
        int orderNum = 1;
        ItemSettingDao *itemSettingDao = [[ItemSettingDao alloc]init];
        {
            ItemSettingModel *model = [[ItemSettingModel alloc]init];
            [model setDataType: ISM_DATA_TYPE_DATE];
            [model setName:@"日付"];
            [model setInputOrderNum: orderNum];
            [model setOutputOrderNum: orderNum];
            [model setCanUpdateFlag:NO ];
            model.inputFlag = YES;
            model.outputFlag = YES;
            [itemSettings addObject:model];
        }
        
        // 交通手段
        orderNum++;
        {
            ItemSettingModel *model = [[ItemSettingModel alloc]init];
            [model setDataType: ISM_DATA_TYPE_SELECT];
            [model setName:@"交通手段"];
            [model setSelectItems:@"電車,バス,タクシー,その他"];
            [model setDefaultValue:@"電車"];
            [model setInputOrderNum: orderNum];
            [model setOutputOrderNum: orderNum];
            [model setCanUpdateFlag:NO ];
            model.inputFlag = YES;
            model.outputFlag = YES;
            [itemSettings addObject:model];
        }
        
        // 乗車
        orderNum++;
        {
            ItemSettingModel *model = [[ItemSettingModel alloc]init];
            [model setDataType: ISM_DATA_TYPE_STRING];
            [model setName:@"乗車"];
            [model setInputOrderNum: orderNum];
            [model setOutputOrderNum: orderNum];
            [model setCanUpdateFlag:NO ];
            model.inputFlag = YES;
            model.outputFlag = YES;
            [itemSettings addObject:model];
        }
        
        // 降車
        orderNum++;
        {
            ItemSettingModel *model = [[ItemSettingModel alloc]init];
            [model setDataType: ISM_DATA_TYPE_STRING];
            [model setName:@"降車"];
            [model setInputOrderNum: orderNum];
            [model setOutputOrderNum: orderNum];
            [model setCanUpdateFlag:NO ];
            model.inputFlag = YES;
            model.outputFlag = YES;
            [itemSettings addObject:model];
        }
        
        // 経由
        orderNum++;
        {
            ItemSettingModel *model = [[ItemSettingModel alloc]init];
            [model setDataType: ISM_DATA_TYPE_STRING];
            [model setName:@"経由"];
            [model setInputOrderNum: orderNum];
            [model setOutputOrderNum: orderNum];
            [model setCanUpdateFlag:YES ];
            model.inputFlag = YES;
            model.outputFlag = YES;
            [itemSettings addObject:model];
        }
        
        // 片道・往復
        orderNum++;
        {
            ItemSettingModel *model = [[ItemSettingModel alloc]init];
            [model setDataType: ISM_DATA_TYPE_SELECT];
            [model setName:@"片/往"];
            [model setSelectItems:@"片道,往復"];
            [model setDefaultValue:@"片道"];
            [model setInputOrderNum: orderNum];
            [model setOutputOrderNum: orderNum];
            [model setCanUpdateFlag:NO ];
            model.inputFlag = YES;
            model.outputFlag = YES;
            [itemSettings addObject:model];
        }
        
        // 金額
        orderNum++;
        {
            ItemSettingModel *model = [[ItemSettingModel alloc]init];
            [model setDataType: ISM_DATA_TYPE_Num];
            [model setName:@"金額"];
            [model setInputOrderNum: orderNum];
            [model setOutputOrderNum: orderNum];
            [model setCanUpdateFlag:NO ];
            model.inputFlag = YES;
            model.outputFlag = YES;
            [itemSettings addObject:model];
        }
        
        // 理由
        orderNum++;
        {
            ItemSettingModel *model = [[ItemSettingModel alloc]init];
            [model setDataType: ISM_DATA_TYPE_STRING];
            [model setName:@"理由"];
            [model setInputOrderNum: orderNum];
            [model setOutputOrderNum: orderNum];
            [model setCanUpdateFlag:YES ];
            model.inputFlag = YES;
            model.outputFlag = YES;
            [itemSettings addObject:model];
        }
        
        // お気に入り
        orderNum++;
        {
            ItemSettingModel *model = [[ItemSettingModel alloc]init];
            [model setDataType: ISM_DATA_TYPE_CHECK];
            [model setName:@"お気に入り"];
            [model setInputOrderNum: orderNum];
            [model setOutputOrderNum: orderNum];
            [model setCanUpdateFlag:NO ];
            model.inputFlag = YES;
            model.outputFlag = NO;
            [itemSettings addObject:model];
        }
        BOOL result = [itemSettingDao saveModels:itemSettings];
        if( !result){
            [ViewUtil showToast:@"初期データの登録に失敗しました"];
        }
    }
    
    {
        ItemSettingDao *settingDao = [[ItemSettingDao alloc] init];
        NSMutableArray *list = [ settingDao list];
        for ( Model *model in list){
            AmdLog( @"%@", [model description]);
        }
    }
    
}

- (void) initDatabase{
    // データベースの初期化
    DatabaseManager *dbManager = [DatabaseManager instance];
    NSArray *createSqls = @[[TravelCostDao createTableSql], [ItemSettingDao createTableSql], [ItemValueDao createTableSql]];
    [dbManager executeUpdates:createSqls];
    
    [self initData];
}

- (void) versionUpDatabase : (NSInteger) oldVersion currentVersion:(NSInteger)currentVersion{
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // モデルの初期化
    ModelManager *modelManager = [ModelManager instance];
    [modelManager addModel: [ TravelCostModel class]];
    [modelManager addModel: [ ItemValueModel class]];
    [modelManager addModel: [ ItemSettingModel class]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 前回のデータベースのバージョンを取得
    NSInteger dbVersion = [defaults integerForKey:DB_VERSION_KEY];
    
    // 新規
    if( dbVersion == 0){
        [ self initDatabase];
    }
    else{
        // アップデート
        if( dbVersion != DB_VERSION){
            [ self versionUpDatabase:dbVersion currentVersion:DB_VERSION];
        }
    }
    
    // 現在のバージョンを記録
    [defaults setInteger:DB_VERSION forKey:DB_VERSION_KEY];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such [0]	__NSCFString *	@" create table if not exists  travel_cost  (   row_id integer primary key autoincrement,   date real,   ride_location text,   drop_off_location text,   favorite_order integer )"	0x0000000109401b70as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
