//
//  InputSettingListViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/14.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "OutputSettingListViewController.h"

@interface OutputSettingListViewController ()

@end

@implementation OutputSettingListViewController

static NSString * const EMPTY_STR  = @"";

- (NSArray *) getValues{
    ItemSettingDao *dao = [[ItemSettingDao alloc]init];
    NSString *where = [NSString stringWithFormat:@"%@ != 0", ISM_COLUMN_OUTPUT_FLAG];
    return [dao list:where order:ISM_COLUMN_OUTPUT_ORDER_NUM];
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
    cell.nameLabel.text = settingModel.name;
    cell.onOffSwitch.on = settingModel.outputFlag;
    
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
@end
