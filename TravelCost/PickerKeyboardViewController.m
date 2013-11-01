//
//  PickerKeyboardViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/07.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "PickerKeyboardViewController.h"

@interface PickerKeyboardViewController ()

@end

@implementation PickerKeyboardViewController

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
    // Dispose of any resources that can be recreated.
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
