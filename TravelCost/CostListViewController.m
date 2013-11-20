//
//  ListViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/09.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "CostListViewController.h"

#import "ViewUtil.h"
#import "MenuManager.h"
#import "CSV.h"
#import "CHCSVParser.h"
#import "SettingViewController.h"



@interface CostListViewController ()
{
    NSMutableArray *values;
    NSDate *month;
    
    MenuManager *menuManager;
}

@end

@implementation CostListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *previousMonthItem = [[UIBarButtonItem alloc]
                                          initWithImage:[ViewUtil createButtonImage:@"\uf053"] style:UIBarButtonItemStylePlain
                                          target:self action:@selector(previousMonth)];
    
    UIBarButtonItem *nextMonthItem = [[UIBarButtonItem alloc]
                                      initWithImage:[ViewUtil createButtonImage:@"\uf054"] style:UIBarButtonItemStylePlain
                                      target:self action:@selector(nextMonth)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:nextMonthItem, previousMonthItem, nil];
    [ViewUtil setToolbarImages:self.toolbar];
}

- (void) previousMonth{
    month = [DateTimeUtil adjustMonth:month monthCnt:-1];
    [self reload];
}

- (void) nextMonth{
    month = [DateTimeUtil adjustMonth:month monthCnt:1];
    [self reload];
}

- (void) viewWillAppear:(BOOL)animated{
    [self reload];
}


- (void) reload{
    if( month == nil){
        month = [[NSDate alloc] init];
        month = [DateTimeUtil getFirstDayOfMonth: month];
    }
    
    self.navigationItem.title = [DateTimeUtil getYYYYM_JP:month];
    
    NSDate *lastDateOfMonth = [DateTimeUtil getLastDayOfMonth: month];
    
    // 一覧の取得
    TravelCostDao *dao = [[TravelCostDao alloc] init];
    NSTimeInterval from = [month timeIntervalSince1970];
    NSTimeInterval to = [lastDateOfMonth timeIntervalSince1970];
    
    NSString *where = [NSString stringWithFormat:@"%@ between %f and %f", TCM_COLUMN_DATE, from, to];
    values = [dao list:where order:TCM_COLUMN_DATE];
    [self.tableView reloadData];
    
    int total = 0;
    for( TravelCostModel *model in values){
        total += [model.amount intValue];
    }
    
    self.totalLabel.text = [StringUtil addComma:total];
    
    if( [values count] == 0){
        [ViewUtil showToast:@"対象データが存在しません"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    TravelCostModel *costModel = values[ indexPath.row];
    
    cell.dateLabel.text = [NSString stringWithFormat: @"%@日", [DateTimeUtil getD:costModel.date]];
    
    NSMutableString *routeText = [[NSMutableString alloc] init];
    
    // 乗車駅
    NSString *rideLocation = [StringUtil killNull: costModel.rideLocation];
    [routeText appendString: [StringUtil killNull: rideLocation]];
    
    // 降車駅
    NSString *dropOffLocation = [StringUtil killNull: costModel.dropOffLocation];
    if(! [StringUtil isEmpty:dropOffLocation]){
        [routeText appendString: [NSString stringWithFormat: @"〜%@", dropOffLocation]];
    }
    cell.routeLabel.text = routeText;
    
    // 片道
    NSString *oneWay = [StringUtil killNull: costModel.oneWay];
    cell.oneWayLabel.text = oneWay;
    
    // 交通手段
    NSString *transType = [StringUtil killNull: costModel.transType];
    cell.transTypeLabel.text = transType;
    
    cell.amountLabel.text = [StringUtil addComma: [costModel.amount intValue]];
    return cell;
}

/**
 * 詳細画面へ
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *sequeId = [segue identifier];
    if ([sequeId isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TravelCostModel *costModel = values[ indexPath.row];
        NSNumber *rowId = costModel.rowId;
        [[segue destinationViewController] setTravelCostRowId:rowId];
    }
}

- (IBAction)menuSelected:(id)sender {
    if( menuManager == nil){
        menuManager = [[MenuManager alloc] init];
    }
    menuManager.mViewController = self;
    [menuManager show];
}

- (IBAction)mailSelected:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    
    // メール本文を設定
    NSString *monthStr = [DateTimeUtil getYYYYM_JP:month];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.%@", NSTemporaryDirectory(), monthStr, @".csv"];
    [ self writeCsv:fileName];
    
    // 題名を設定
    [mailController setSubject:@"楽々交通費精算"];
    [mailController setMessageBody:[NSString stringWithFormat:@"%@月分データ", monthStr] isHTML:NO];
    
    // 宛先を設定
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mailAddress = [defaults stringForKey:USER_DEFAULT_KEY_MAIL_ADDRESS];
    if( mailAddress){
        [mailController setToRecipients:[NSArray arrayWithObjects:mailAddress, nil]];
    }
    
    // 添付ファイル名を設定
    NSData* fileData = [NSData dataWithContentsOfFile:fileName];
    [mailController addAttachmentData:fileData mimeType:@"text/csv" fileName:fileName];
    
    // メール送信用のモーダルビューを表示
    [self presentViewController:mailController animated:TRUE completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [ViewUtil closeView:controller];
}

- (NSString *)writeCsv:(NSString *)fileName{
    ItemSettingDao *settingDao = [[ItemSettingDao alloc] init];
    ItemValueDao *valueDao = [[ItemValueDao alloc] init];
    
    NSString *where = [NSString stringWithFormat:@"%@!=0", ISM_COLUMN_OUTPUT_FLAG];
    
    
    NSMutableArray *csvRows = [[NSMutableArray alloc] init];
    
    NSArray *outputSettings = [settingDao list:where order:ISM_COLUMN_OUTPUT_ORDER_NUM];
    // ヘッダ
    {
        NSMutableArray *headerSource = [[NSMutableArray alloc] init];
        for( ItemSettingModel *outputSetting in outputSettings){
            [headerSource addObject:outputSetting.name];
        }
        CSVRow *row = [[CSVRow alloc] initWithValues: headerSource];
        [csvRows addObject:row];
    }
    
    for( TravelCostModel *costModel in values){
        // 値を取得
        NSArray *valueModels = [ valueDao getValueModels:[ costModel.rowId intValue]];
        
        // 設定IDをキーとしたマップにつめ直す
        NSMutableDictionary *settingIdValues = [[NSMutableDictionary alloc] init];
        for( ItemValueModel *valueModel in valueModels){
            NSString *key = [StringUtil toStringNumber:valueModel.itemSettingId];
            [settingIdValues setValue:valueModel forKey:key];
        }
        
        // 1行分のCSVの作成
        NSMutableArray *csvSource = [[NSMutableArray alloc] init];
        for( ItemSettingModel *outputSetting in outputSettings){
            NSString *key = [StringUtil toStringNumber:outputSetting.rowId];
            ItemValueModel *value = [settingIdValues valueForKey:key];
            if( value.value != nil){
                if( [StringUtil equals:outputSetting.dataType str2:ISM_DATA_TYPE_DATE]){
                    double interval = [value.value doubleValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
                    [csvSource addObject: [DateTimeUtil getYYYYMD:date]];
                }
                else{
                    [csvSource addObject: value.value];
                }
            }
            else{
                [csvSource addObject:@""];
            }
        }
        CSVRow *row = [[CSVRow alloc] initWithValues: csvSource];
        [csvRows addObject:row];
    }
    CSVTable *csvTable = [[CSVTable alloc] initWithRows:csvRows];
    NSMutableString *output = [[NSMutableString alloc] init];
    CSVSerializer *serializer = [[CSVSerializer alloc] initWithOutput:output];
    [serializer serialize:csvTable];
    
    
    CHCSVWriter *csvWriter = [[CHCSVWriter alloc] initForWritingToCSVFile:fileName];
    // ヘッダ
    {
        for( ItemSettingModel *outputSetting in outputSettings){
            [csvWriter writeField:outputSetting.name];
        }
        [csvWriter finishLine];
    }
    
    // データ
    for( TravelCostModel *costModel in values){
        // 値を取得
        NSArray *valueModels = [ valueDao getValueModels:[ costModel.rowId intValue]];
        
        // 設定IDをキーとしたマップにつめ直す
        NSMutableDictionary *settingIdValues = [[NSMutableDictionary alloc] init];
        for( ItemValueModel *valueModel in valueModels){
            NSString *key = [StringUtil toStringNumber:valueModel.itemSettingId];
            [settingIdValues setValue:valueModel forKey:key];
        }
        
        // 1行分のCSVの作成
        for( ItemSettingModel *outputSetting in outputSettings){
            NSString *key = [StringUtil toStringNumber:outputSetting.rowId];
            ItemValueModel *value = [settingIdValues valueForKey:key];
            if( value.value != nil){
                if( [StringUtil equals:outputSetting.dataType str2:ISM_DATA_TYPE_DATE]){
                    double interval = [value.value doubleValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
                    [csvWriter writeField:[DateTimeUtil getYYYYMD:date]];
                }
                else{
                    [csvWriter writeField:value.value];
                }
            }
            else{
                [csvWriter writeField:@""];
            }
        }
        [csvWriter finishLine];
    }
    [csvWriter closeStream];
    
    return output;
}



@end
