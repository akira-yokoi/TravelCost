//
//  MessageBuilder.h
//  TravelCost
//
//  Created by 横井朗 on 2013/11/01.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageBuilder : NSObject

- (void) addMessage: (NSString *)message;

- (BOOL) isEmpty;

- (NSString *)description;

@end
