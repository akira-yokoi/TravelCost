//
//  HelpViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/11/15.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "BaseViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface HelpViewController : BaseViewController<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)mailSelected:(id)sender;

@end
