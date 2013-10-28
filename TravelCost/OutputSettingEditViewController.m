//
//  OutputSettingEditViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/18.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "OutputSettingEditViewController.h"

@interface OutputSettingEditViewController ()
{
    NSMutableArray *values;
}
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
    
    values = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)helpSelected:(id)sender {
}

- (IBAction)addItemSelected:(id)sender {
    //UIViewControllerを継承したModalViewController
    OutputSettingItemViewController *mvc = [[OutputSettingItemViewController alloc] initWithNibName:@"OutputSettingItemView" bundle:nil];
    mvc.delegate = self;
    [self presentViewController:mvc animated:YES completion:nil];
}

- (IBAction)saveSelected:(id)sender {
}

#pragma mark Table
/** セクションの数 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/** データの数 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [values count];
    return count;
}

/** セルの作成 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // セルにテキストを設定
    id value = values[ indexPath.row];
    if( [ReflectionUtil instanceof:value class:[ ItemSettingModel class]]){
        ItemSettingModel *settingModel = (ItemSettingModel *) value;
        cell.textLabel.text = settingModel.name;
    }
    if( [ReflectionUtil instanceof:value class:[ NSString class]]){
        NSString *fixStr = (NSString *) value;
        cell.textLabel.text = fixStr;
    }
    
    return cell;
}

/** セルの選択 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id value = values[ indexPath.row];
    //UIViewControllerを継承したModalViewController
    OutputSettingItemViewController *mvc = [[OutputSettingItemViewController alloc] initWithNibName:@"OutputSettingItemView" bundle:nil];
    mvc.delegate = self;
    mvc.defaultValue = value;
    [self presentViewController:mvc animated:YES completion:nil];
}


#pragma mark Delegate
- (void) ok:(id)value{
    [values addObject:value];
    [_tableView reloadData];
}

- (void)cancel{
}

@end
