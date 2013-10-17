//
//  Model.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "Model.h"
#import <objc/runtime.h>

@implementation Model

- (NSString *)getTableName{
    [NSException raise:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] format:nil];
    return nil;
}

- (NSString *)getIdColumnName{
    [NSException raise:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] format:nil];
    return nil;
}

- (NSArray *)getValueColumnNames{
    [NSException raise:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] format:nil];
    return nil;
}

- (Model *)newEntity{
    [NSException raise:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] format:nil];
    return nil;
}

-(id) getValue:(NSString *)columnName{
    [NSException raise:[NSString stringWithFormat:@"%@ is not found.", columnName] format:nil];
    return nil;
}

-(void) setValue:(NSString *)columnName value:(id)value{
    [NSException raise:[NSString stringWithFormat:@"%@ is not found.", columnName] format:nil];
}

- (NSString *) description{
    NSMutableString *description = [[NSMutableString alloc] init];
    
    Class clazz = [self class];
    [description appendString: [clazz description]];
    [description appendString:@"  ["];
    
    {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(clazz, &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            const char *ivar_name = ivar_getName(ivar);
            const char *ivar_type = ivar_getTypeEncoding(ivar);
            
            NSString *name = [NSString stringWithUTF8String:ivar_name];
            NSString *type = [NSString stringWithUTF8String:ivar_type];
            
            
            NSObject *value = [self valueForKey:name];
            if( [type isEqualToString:@"@\"NSDate\""]){
                if ([value isKindOfClass:[NSNumber class]]){
                    NSNumber *number = (NSNumber *)value;
                    NSDate *date = [DateTimeUtil getDate:[number doubleValue]];
                    [description appendFormat:@"%@=%@", name, [ DateTimeUtil getYYYYMD_HHMMSS:date]];
                }
                else{
                    [description appendFormat:@"%@=%@", name, [value description]];
                }
            }
            else{
                [description appendFormat:@"%@=%@", name, [value description]];
            }
            
            if( i != outCount -1){
                [description appendString:@" "];
            }
        }
    }
    [description appendString:@"]"];
    return description;
}

@end
