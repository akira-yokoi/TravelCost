//
//  OkCancelAccessoryViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/11/06.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "OkCancelAccessoryViewController.h"

@interface OkCancelAccessoryViewController ()

@end

@implementation OkCancelAccessoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)okSelected:(id)sender {
    if( self.okBlock){
        self.okBlock();
    }
}

- (IBAction)cancelSelected:(id)sender {
    if( self.cancelBlock){
        self.cancelBlock();
    }
}

@end
