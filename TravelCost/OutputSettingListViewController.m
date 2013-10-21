//
//  InputSettingListViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/14.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "OutputSettingListViewController.h"

@interface OutputSettingListViewController ()
{
    NSMutableArray *values;
}
@end

@implementation OutputSettingListViewController

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
    
    [self reload];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [_settingTableView setEditing:editing animated:animated];
    
    // 編集終了
    if(! editing){
        NSLog(@"編集終了");
        
        NSMutableDictionary *settingMap = [[NSMutableDictionary alloc] init];
        for( ItemSettingModel *setting in values){
            [settingMap setValue:setting forKey:setting.name];
        }
        
        // 並び順を保存
        ItemSettingDao *dao = [[ItemSettingDao alloc] init];
        int orderNum = 1;
        NSInteger sectionCnt = [self numberOfSectionsInTableView: _settingTableView];
        for ( int section = 0; section < sectionCnt ; section++){
            NSInteger numberOfRowInSection = [ _settingTableView numberOfRowsInSection:section];
            
            for( int row = 0; row < numberOfRowInSection; row++){
                NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
                
                OutputSettingListViewCell *cell = (OutputSettingListViewCell *)[_settingTableView cellForRowAtIndexPath:path];
                NSString *settingName = cell.nameLabel.text;
                
                // 並び順を更新して保存
                ItemSettingModel *settingModel = [settingMap valueForKey:settingName];
                settingModel.outputOrderNum = orderNum++;
                [dao saveModel:settingModel];
            }
        }
    }
}

- (void) reload{
    ItemSettingDao *dao = [[ItemSettingDao alloc]init];
    values = [dao list:nil order:ISM_COLUMN_OUTPUT_ORDER_NUM];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    OutputSettingListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[OutputSettingListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // セルにテキストを設定
    ItemSettingModel *settingModel = values[ indexPath.row];
    cell.nameLabel.text = settingModel.name;
    cell.detailLabel.text = settingModel.dataType;
    cell.onOffSwitch.on = settingModel.outputFlag;
    
    // 入力項目の場合はON/OFFのみで詳細はなし
    if( settingModel.inputFlag){
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    // 出力項目の場合は詳細あり
    else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // ここで追加・削除をさせないことを示す
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView
shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 編集モードでインデントもしない
    return NO;
}

@end
