//
//  OutputSettingItemViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/21.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "OutputSettingItemViewController.h"

@interface OutputSettingItemViewController ()
{
    NSMutableArray *inputItems;
}
@end

@implementation OutputSettingItemViewController

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
    
    ItemSettingDao *settingDao = [[ItemSettingDao alloc] init];
    NSString *where = [NSString stringWithFormat:@"%@ = 1", ISM_COLUMN_INPUT_FLAG];
    inputItems = [settingDao list:where  order:ISM_COLUMN_INPUT_ORDER_NUM];
    
    _inputItemPicker.dataSource = self;
    _inputItemPicker.delegate = self;
    _fixStringText.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    // デフォルト値の反映
    if( _defaultValue != nil){
        if( [ReflectionUtil instanceof:_defaultValue class:[ ItemSettingModel class]]){
            ItemSettingModel *settingModel = (ItemSettingModel *) _defaultValue;
            
            NSInteger index = [inputItems indexOfObject: settingModel];
            if( index != NSNotFound){
                [_inputItemPicker selectRow:index inComponent:0 animated:YES];
            }
            [_segmentedControl setSelectedSegmentIndex:0];
        }
        if( [ReflectionUtil instanceof:_defaultValue class:[ NSString class]]){
            NSString *fixStr = (NSString *) _defaultValue;
            _fixStringText.text = fixStr;
            [_segmentedControl setSelectedSegmentIndex:1];
        }
    }
    [self updateVisible];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentChanged:(id)sender {
    [self updateVisible];
}

- (void)updateVisible{
    switch( _segmentedControl.selectedSegmentIndex){
        case 0:
            [_fixStringText setHidden:YES];
            [_inputItemPicker setHidden:NO];
            break;
        case 1:
            [_fixStringText setHidden:NO];
            [_inputItemPicker setHidden:YES];
            break;
    }
}

#pragma mark Segment Control

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return inputItems.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    ItemSettingModel *settingModel = inputItems[ row];
    return settingModel.name;
}

#pragma mark Menu Action
- (IBAction)okSelected:(id)sender {
    NSInteger segmentIndex = _segmentedControl.selectedSegmentIndex;
    
    id value = nil;
    if( segmentIndex == 0){
        value = [inputItems  objectAtIndex:[_inputItemPicker selectedRowInComponent:0]];
    }
    else if( segmentIndex == 1){
        value = _fixStringText.text;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [_delegate ok: value];
}


- (IBAction)cancelSelected:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [_delegate cancel];
}

@end
