//
//  OutputSettingEditViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/18.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "OutputSettingEditViewController.h"

#import "StringUtil.h"

@interface OutputSettingEditViewController ()
{
    NSMutableArray *values;
    NSInteger targetRowNum;
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
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    if( _settingModel != nil){
        // 初回だけ
        if( [values count] != 0){
            return;
        }
        
        ItemSettingDao *dao = [[ItemSettingDao alloc] init];
        // 初期値の表示
        NSString *outputSetting = _settingModel.outputSetting;
        
        NSArray *items = [StringUtil parseCSV: outputSetting];
        for( NSString *item in items){
            if( [item hasPrefix:@"%%%"]){
                NSString *itemName = [item substringFromIndex:3];
                
                NSString *where = [NSString stringWithFormat:@"%@='%@'", ISM_COLUMN_NAME, itemName];
                NSArray *items = [dao list:where order:nil];
                
                if( [items count] != 0){
                    [values addObject: items[ 0]];
                }
            }
            else{
                [values addObject:item];
            }
        }
        
        [_tableView reloadData];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)helpSelected:(id)sender {
    [ViewUtil showMessage:@"利用方法" message:@"出力項目設定では、入力項目と文字列を組み合わせて出力用の項目が作成できます。\n例えば「乗車〜降車（経由）」といった項目を出力したい場合には下記のように6つの項目を設定します。\n\n乗車・・・入力項目として追加\n〜　・・・文字列として追加\n降車・・・入力項目として追加\n（　・・・文字列として追加\n経由・・・入力項目として追加\n）　・・・文字列として追加"];
}

- (IBAction)addItemSelected:(id)sender {
    targetRowNum = -1;
    //UIViewControllerを継承したModalViewController
    OutputSettingItemViewController *mvc = [[OutputSettingItemViewController alloc] initWithNibName:@"OutputSettingItemView" bundle:nil];
    mvc.delegate = self;
    [self presentViewController:mvc animated:YES completion:nil];
}

- (IBAction)saveSelected:(id)sender {
    ItemSettingDao *dao = [[ItemSettingDao alloc] init];
    if( _settingModel == nil){
        _settingModel = [[ItemSettingModel alloc] init];
        
        int maxOrdr = [dao getMax:ISM_COLUMN_OUTPUT_ORDER_NUM];
        _settingModel.dataType = ISM_DATA_TYPE_STRING;
        _settingModel.canUpdateFlag = YES;
        _settingModel.inputFlag = NO;
        _settingModel.inputOrderNum = -1;
        _settingModel.outputFlag = YES;
        _settingModel.outputOrderNum = (maxOrdr + 1);
    }
    
    // タイトル
    NSMutableString *title = [[NSMutableString alloc] init];
    NSMutableString *outputCsv = [[NSMutableString alloc] init];
    
    for( id value in values){
        if( [ReflectionUtil instanceof:value class:[ ItemSettingModel class]]){
            ItemSettingModel *settingModel = (ItemSettingModel *) value;
            [title appendString: settingModel.name];
            
            if( outputCsv.length != 0){
                [outputCsv appendString:@","];
            }
            [outputCsv appendString:@"%%%"];
            [outputCsv appendFormat:@"%@", settingModel.name];
        }
        else if( [ReflectionUtil instanceof:value class:[ NSString class]]){
            NSString *fixStr = (NSString *) value;
            [title appendString: fixStr];
            
            if( outputCsv.length != 0){
                [outputCsv appendString:@","];
            }
            [outputCsv appendString: fixStr];
        }
    }
    _settingModel.name = title;
    _settingModel.outputSetting = outputCsv;
    
    if( [StringUtil isEmpty: outputCsv]){
        [ViewUtil showMessage:nil message:@"項目を設定してください"];
        return;
    }
    
    [dao saveModel: _settingModel];
    
    [ViewUtil showToast:@"保存しました"];
    [ViewUtil closeView:self];
}

- (IBAction)deleteSelected:(id)sender {
    if( _settingModel == nil){
        [ViewUtil closeView:self];
        return;
    }
    
    [ViewUtil showConfirm:nil message:@"データを削除します。\nよろしいですか？" delegate:self];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if( buttonIndex == 1){
        ItemSettingDao *dao = [[ItemSettingDao alloc] init];
        [dao deleteModel: _settingModel];
    
        [ViewUtil showToast:@"削除しました"];
        [ViewUtil closeView:self];
    }
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
    else if( [ReflectionUtil instanceof:value class:[ NSString class]]){
        NSString *fixStr = (NSString *) value;
        cell.textLabel.text = fixStr;
    }
    
    return cell;
}

/** セルの選択 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    targetRowNum = indexPath.row;
    id value = values[ indexPath.row];
    //UIViewControllerを継承したModalViewController
    OutputSettingItemViewController *mvc = [[OutputSettingItemViewController alloc] initWithNibName:@"OutputSettingItemView" bundle:nil];
    mvc.delegate = self;
    mvc.defaultValue = value;
    [self presentViewController:mvc animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    // 並び替えを可能に
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 削除処理
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [values removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark Delegate
- (void) ok:(id)value{
    if( targetRowNum == -1){
        [values addObject:value];
    }
    else{
        [values removeObjectAtIndex:targetRowNum];
        [values insertObject:value atIndex:targetRowNum];
    }
    
    [_tableView reloadData];
}

- (void)cancel{
}

@end
