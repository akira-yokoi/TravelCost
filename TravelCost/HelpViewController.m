//
//  HelpViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/11/15.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (IBAction)mailSelected:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    
    // 題名を設定
    NSString* version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    
    [mailController setSubject:@"楽々交通費精算"];
    [mailController setMessageBody:@"端末のバージョンとか" isHTML:NO];
    
    // 宛先を設定
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mailAddress = @"adventmobiledesigns@gmail.com";
    if( mailAddress){
        [mailController setToRecipients:[NSArray arrayWithObjects:mailAddress, nil]];
    }
    
    // メール送信用のモーダルビューを表示
    [self presentViewController:mailController animated:TRUE completion:nil];
}
@end
