//
//  ReflectionUtil.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/27.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "ReflectionUtil.h"

@implementation ReflectionUtil

+ ( BOOL) instanceof:(id)obj class:(Class) clazz{
    return [[ obj class] isSubclassOfClass: clazz];
}

@end
