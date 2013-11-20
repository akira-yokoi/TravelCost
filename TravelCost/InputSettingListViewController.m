//
//  InputSettingListViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/14.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "InputSettingListViewController.h"

#import "DataTypeDataSource.h"
#import "ItemSettingManager.h"
#import "ViewUtil.h"

@interface InputSettingListViewController ()

@end

@implementation InputSettingListViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    [ViewUtil setToolbarImages:self.toolbar];
}

-(UITableView *)getTableView{
    return _tableView;
}

-(NSArray *)getValues{
    ItemSettingDao *dao = [[ItemSettingDao alloc]init];
    NSString *where = [NSString stringWithFormat:@"%@ != 0", ISM_COLUMN_INPUT_FLAG];
    return [dao list:where order:ISM_COLUMN_INPUT_ORDER_NUM];
}

- (void) updateOrder{
    int orderNum = 1;
    
    for( ItemSettingModel *model in values){
        model.inputOrderNum = orderNum++;
    }
    // 並び順を保存
    ItemSettingDao *dao = [[ItemSettingDao alloc] init];
    [dao saveModels:values];
    
    // 更新時間を設定
    [[ItemSettingManager instance] setUpdate:[ NSDate date]];
}

-(void)setCellData:(UITableViewCell *)cell value:(id)value{
    // セルにテキストを設定
    ItemSettingModel *settingModel = (ItemSettingModel *)value;
    cell.textLabel.text = settingModel.name;
    cell.detailTextLabel.text = [DataTypeDataSource getDataTypeName:settingModel.dataType];
}

-(void)selectRow:(id)item{
    ItemSettingModel *settingModel = (ItemSettingModel *)item;

    InputSettingEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InputSettingEditViewController"];
    vc.settingModel = settingModel;
    [[self navigationController] pushViewController:vc animated:YES];
}

@end
