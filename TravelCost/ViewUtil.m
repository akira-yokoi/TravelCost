//
//  ViewUtil.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/08.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "ViewUtil.h"

#import "FontAwesomeKit.h"
#import "StringUtil.h"
#import "SVProgressHUD.h"

@implementation ViewUtil

+(void) showMessage:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

+(void) showConfirm:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
                                                   delegate: delegate cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    [alert show];
}

+(void) showToast:(NSString *)message {
    [SVProgressHUD showImage:nil status:message];
}

+(void) closeView:(UIViewController *)vc{
    [vc dismissViewControllerAnimated:YES completion:nil];
}


+(void) setToolbarImages:(UIToolbar *) toolbar{
    NSArray *items = [toolbar items];
    NSMutableDictionary *titleIconMap = [[NSMutableDictionary alloc] init];
    
    titleIconMap[ @"save"] = @"\uf0c7";
    titleIconMap[ @"delete"] = @"\uf014";
    titleIconMap[ @"favorite"] = @"\uf005";
    titleIconMap[ @"list"] = @"\uf03A";
    titleIconMap[ @"menu"] = @"\uf085";
    titleIconMap[ @"copy"] = @"\uf0c5";
    titleIconMap[ @"add"] = @"\uf055";
    titleIconMap[ @"mail"] = @"\uf0e0";
    titleIconMap[ @"left"] = @"\uf053";
    titleIconMap[ @"right"] = @"\uf054";
    
    for( UIBarButtonItem *item in items){
        NSString *title = item.title;
        NSString *icon = [titleIconMap valueForKey:title];
        
        if( icon){
            item.image = [self createButtonImage:icon];
        }
    }
    [toolbar setItems:items];
}

+ (UIImage *) createButtonImage:(NSString *)unicode{
    FAKFontAwesome *fontIcon = [FAKFontAwesome iconWithCode:unicode size:25];
    return [fontIcon imageWithSize:CGSizeMake(44, 44)];
}

+ (void)removeItem:(UIToolbar *)toolbar title:(NSString *)title{
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[toolbar items]];
    int removeIndex = -1;
    for( int cnt = 0; cnt < [items count]; cnt++){
        UIBarButtonItem *item = (UIBarButtonItem *)items[ cnt];
        if( [StringUtil equals:item.title str2:title]){
            removeIndex = cnt;
            break;
        }
    }
    
    if( removeIndex != -1){
        [items removeObjectAtIndex:removeIndex];
        // Flexible space bar buttonも消す
        [items removeObjectAtIndex:removeIndex - 1];
        [toolbar setItems:items];
    }
}

@end