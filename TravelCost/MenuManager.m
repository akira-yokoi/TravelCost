//
//  MenuDelegate.m
//  TravelCost
//
//  Created by 横井朗 on 2013/11/09.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "MenuManager.h"

@implementation MenuManager


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //遷移先のインスタンスを生成
    if ( buttonIndex == 0){
        [self.mViewController performSegueWithIdentifier:@"help" sender:self];
    }
    if ( buttonIndex == 1){
        [self.mViewController performSegueWithIdentifier:@"inputSetting" sender:self];
    }
    else if( buttonIndex == 2){
        [self.mViewController performSegueWithIdentifier:@"outputSetting" sender:self];
    }
    else if( buttonIndex == 3){
        [self.mViewController performSegueWithIdentifier:@"sendSetting" sender:self];
    }
}

- (void) show{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"メニュー" delegate:self cancelButtonTitle:@"キャンセル" destructiveButtonTitle:nil otherButtonTitles:@"ヘルプ", @"入力項目設定", @"出力項目設定", @"送信設定",nil];
    [sheet showInView:self.mViewController.view];
}

@end
