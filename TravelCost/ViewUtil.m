//
//  ViewUtil.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/08.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "ViewUtil.h"

@implementation ViewUtil

+(void) showMessage:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    
    id obj = nil;
    // タイトル文字列が存在しない場合はsubviewsの1番目の要素
    if (!title || !([title length] > 0)) {
        if ([[alert subviews] count] > 0) {
            obj = [[alert subviews] objectAtIndex:0];
        }
    }
    // タイトル文字列が存在する場合はsubviewsの2番目の要素
    else if ([title length] > 0) {
        if ([[alert subviews] count] > 1) {
            obj = [[alert subviews] objectAtIndex:1];
        }
    }
    
    // UILabel型であればtextAlignmentを左寄せにセット
    if (obj && [obj isKindOfClass:[UILabel class]]) {
        ((UILabel *)obj).textAlignment = NSTextAlignmentLeft;
    }

    UILabel *label = (UILabel *)[[alert subviews] objectAtIndex:0];
    label.text = @"SSS";
    label.textAlignment = NSTextAlignmentLeft;

}

+(void) showConfirm:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
                                                   delegate: delegate cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    [alert show];
}

+(void) showToast:(NSString *)message {
    iToast *toast = [iToast makeText:message];
    [toast setDuration:2000];
    [toast show];
}

+(void) closeView:(UIViewController *)vc{
    [vc.navigationController popViewControllerAnimated:YES];
}

@end