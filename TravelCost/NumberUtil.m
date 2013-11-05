//
//  NumberUtil.m
//  TravelCost
//
//  Created by 横井朗 on 2013/11/01.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "NumberUtil.h"

@implementation NumberUtil

+ (BOOL) isEmpty:(NSNumber *)number{
    if( !number || [number isEqual:[NSNull null]]){
        return YES;
    }
    return NO;
}

@end