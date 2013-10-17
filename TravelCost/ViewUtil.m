//
//  ViewUtil.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/08.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "ViewUtil.h"

@implementation ViewUtil

+(void) showAlert:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle{
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = title;
    alert.message = message;
    [alert addButtonWithTitle:buttonTitle];
    [alert show];
}

+(void) showToast:(NSString *)message {
    iToast *toast = [iToast makeText:message];
    [toast setDuration:2000];
    [toast show];
}

@end