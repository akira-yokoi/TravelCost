//
//  DateKeyboardViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/07.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "DateKeyboardViewController.h"

@interface DateKeyboardViewController ()

@end

@implementation DateKeyboardViewController

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


- (IBAction)okPressed:(id)sender {
    NSLog(@"okPressed");
}
@end
