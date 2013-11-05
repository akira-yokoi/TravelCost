//
//  ItemSettingManager.m
//  TravelCost
//
//  Created by 横井朗 on 2013/11/01.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "ItemSettingManager.h"

@implementation ItemSettingManager
{
    NSMutableArray *inputItemSettings;
    NSDate *updateTime;
}

static ItemSettingManager *sharedInstance = nil;

+ (ItemSettingManager *)instance{
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

- (id)init{
    self = [super init];
    if( self){
    }
    return self;
}

- (void) setUpdate: (NSDate *) update{
    updateTime = update;
    [self reload];
}

- (NSDate *) getUpdateTime{
    return updateTime;
}

- (NSMutableArray *) getInputItemSettingList{
    if( inputItemSettings == nil){
        [self reload];
    }
    return inputItemSettings;
}

- (void) reload{
    ItemSettingDao *settingDao = [[ItemSettingDao alloc] init];
    NSString *where = [NSString stringWithFormat:@"%@ != 0", ISM_COLUMN_INPUT_FLAG ];
    inputItemSettings = [settingDao list:where order:ISM_COLUMN_INPUT_ORDER_NUM];
}

@end
