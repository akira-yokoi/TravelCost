//
//  OutputSettingEditViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/18.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "OutputSettingEditViewController.h"

@interface OutputSettingEditViewController ()

@end

@implementation OutputSettingEditViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)helpSelected:(id)sender {
}

-(void)modalViewDidDissmissed{
    NSLog(@"AAA");
}

- (IBAction)addStringSelected:(id)sender {
    //UIViewControllerを継承したModalViewController
    OutputSettingItemViewController *mvc = [[OutputSettingItemViewController alloc] initWithNibName:@"OutputSettingItemView" bundle:nil];
    mvc.delegate = self;
    [self presentViewController:mvc animated:YES completion:nil];
    
    /*
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Twitter  Login" message:@"\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
    
    UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 15.0, 260.0, 25.0)];
    myTextField.placeholder=@"Enter User Name";
//    [myTextField becomeFirstResponder];
    [myTextField setBackgroundColor:[UIColor yellowColor]];
//    myTextField.textAlignment=UITextAlignmentCenter;
    
    // myTextField.layer.cornerRadius=5.0; Use this if you have added QuartzCore framework
    
    [myAlertView addSubview:myTextField];
    [myAlertView show];
     */
}

- (IBAction)addItemSelected:(id)sender {
}

- (IBAction)saveSelected:(id)sender {
}
@end
