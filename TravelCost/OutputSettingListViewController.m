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
    NSMutableDictionary *idSettingMap;
}
@end

@implementation OutputSettingListViewController

static NSString * const EMPTY_STR  = @"";

- (void)viewDidLoad
{
    [super viewDidLoad];

    idSettingMap = [[NSMutableDictionary alloc] init];
}


- (NSArray *) getValues{
    ItemSettingDao *dao = [[ItemSettingDao alloc]init];
    return [dao list:nil order:ISM_COLUMN_OUTPUT_ORDER_NUM];
}

- (UITableView *) getTableView{
    return _settingTableView;
}

- (void) updateOrder{
    int orderNum = 1;
    
    for( ItemSettingModel *model in values){
        model.outputOrderNum = orderNum++;
    }
    // 並び順を保存
    ItemSettingDao *dao = [[ItemSettingDao alloc] init];
    [dao saveModels:values];
}

- (void) selectRow: (id)item{
    ItemSettingModel *settingModel = (ItemSettingModel *)item;
    if(! settingModel.inputFlag){
        OutputSettingEditViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"OutputSettingEditViewController"];
        mvc.settingModel = settingModel;
        [[self navigationController] pushViewController:mvc animated:YES];
    }
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

    NSNumber *rowId = settingModel.rowId;
    cell.nameLabel.text = settingModel.name;
    cell.onOffSwitch.on = settingModel.outputFlag;
    cell.onOffSwitch.tag = [settingModel.rowId intValue];

    // マップに値をつめる
    NSString *key = [StringUtil toStringNumber:rowId];
    [idSettingMap setValue:settingModel forKey:key];
    
    // ON/OFF切り替え時に呼びされる関数を指定する
	[ cell.onOffSwitch addTarget:self action:@selector( onChangeSwitch: ) forControlEvents:UIControlEventValueChanged ];
    
    // 入力項目の場合はON/OFFのみで詳細はなし
    if( settingModel.inputFlag){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailLabel.text = settingModel.dataType;
    }
    // 出力項目の場合は詳細あり
    else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailLabel.text = EMPTY_STR;
    }
    return cell;
}

- ( void )onChangeSwitch:( id )sender{
    UISwitch *onOffSwitch = (UISwitch *)sender;
    int tag = (int)[onOffSwitch tag];
    ItemSettingModel *settingModel = [idSettingMap valueForKey: [StringUtil toStringInt: tag]];
    settingModel.outputFlag = onOffSwitch.on;
    
    ItemSettingDao *dao = [[ItemSettingDao alloc] init];
    [dao saveModel:settingModel];
}
@end
