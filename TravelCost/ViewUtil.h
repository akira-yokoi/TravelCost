//
//  ViewUtil.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/08.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iToast.h"

@interface ViewUtil : NSObject

+(void) showMessage:(NSString *)title message:(NSString *)message;
+(void) showConfirm:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate;
+(void) showToast:(NSString *)message;

+(void) closeView:(UIViewController *)vc;

@end
