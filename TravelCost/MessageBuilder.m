//
//  MessageBuilder.m
//  TravelCost
//
//  Created by 横井朗 on 2013/11/01.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "MessageBuilder.h"

@implementation MessageBuilder
{
    NSMutableArray *messages;
}


-(id) init{
    if (self = [super init]) {
        messages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addMessage: (NSString *)message{
    [messages addObject:message];
}

- (BOOL) isEmpty{
    return [messages count] == 0;
}

- (NSString *)description{
    NSMutableString *description = [[NSMutableString alloc] init];
    for( NSString *message in messages){
        // 2行目以降は改行
        if( description.length != 0){
            [description appendString:@"\n"];
        }
        [description appendString:message];
    }
    return description;
}

@end
