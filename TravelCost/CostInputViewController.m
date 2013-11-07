//
//  ViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/03.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "CostInputViewController.h"

#import "ItemSettingManager.h"
#import "CsvPickerDataSource.h"

#import "ItemSettingDao.h"
#import "ItemValueDao.h"
#import "TravelCostDao.h"

#import "ItemValueModel.h"
#import "ItemSettingModel.h"
#import "TravelCostModel.h"

#import "InputViewCell.h"
#import "InputViewSwitchCell.h"

#import "DateKeyboardViewController.h"
#import "PickerKeyboardViewController.h"
#import "InputSettingListViewController.h"
#import "OutputSettingListViewController.h"
#import "SettingViewController.h"
#import "OkCancelAccessoryViewController.h"

#import "FMDatabase.h"

#import "ViewUtil.h"
#import "DateTimeUtil.h"
#import "TableUtil.h"
#import "iToast.h"
#import "StringUtil.h"

@interface CostInputViewController ()
{
    NSMutableArray *values;
    NSIndexPath *focusIndexPath;
    
    OkCancelAccessoryViewController *accessoryViewController;
    KeyboardViewController *keyboardViewController;
    CsvPickerDataSource *pickerDataSource;
    NSMutableDictionary *rowItemSettingMap;
    
    NSDate *settingLoadTime;
    
    UIView *keyboard;
}
@property (strong, nonatomic) FMDatabase *db;

@end

@implementation CostInputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    values = [[NSMutableArray alloc] init];
    rowItemSettingMap = [[NSMutableDictionary alloc] init];
    
    [self reload];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];

    // 必要に応じてリロード
    {
        ItemSettingManager *settingManager = [ItemSettingManager instance];
        NSDate *updateDate = [settingManager getUpdateTime];
        if( updateDate != nil){
            if( [DateTimeUtil d1_gt_d2:updateDate date2:settingLoadTime]){
                // 設定が変わっているので再読み込み
                [self reload];
            }
        }
    }
    
    // キーボードの表示・非表示の通知を登録する
    if( self){
        NSNotificationCenter *center;
        center = [ NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:self selector:@selector(keybaordWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // キーボードの表示・非表示の通知を削除する
    if( self){
        NSNotificationCenter *center;
        center = [NSNotificationCenter defaultCenter];
        [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
    ItemValueModel *value = values[ indexPath.row];
    ItemSettingModel *setting = [value _itemSettingModel];

    NSString *strValue = [StringUtil killNull:[value value]];
    NSString *dataType = [setting dataType];
    
    [rowItemSettingMap setObject:setting forKey: [StringUtil toStringLong:indexPath.row]];
    

    if ( [dataType isEqualToString: ISM_DATA_TYPE_CHECK]){
        InputViewSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switchCell" forIndexPath:indexPath];
        
        cell.titleLabel.text = [setting name];
        BOOL boolValue = [ strValue boolValue];
        cell.swith.on = boolValue;
        return cell;
    }
    else{
        InputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        cell.titleLabel.text = [setting name];

        UITextField *valueText = [cell valueText];
        [ super addInputField: valueText];
        
        if ( [dataType isEqualToString: ISM_DATA_TYPE_Num]){
            // 数値の場合はカンマで区切る
            if(! [StringUtil isEmpty:strValue]){
                strValue = [StringUtil addCommaToString:strValue];                
            }
            valueText.text = strValue;
            [valueText addTarget:self action:@selector(addComma:) forControlEvents:UIControlEventEditingChanged];
        }
        else{
            valueText.text = strValue;
        }
        
        valueText.delegate = self;
        valueText.tag = indexPath.row;
        
        
        // データ型が日付の場合
        if ( [dataType isEqualToString: ISM_DATA_TYPE_DATE]){
            double dValue = [strValue doubleValue];
            if( dValue != 0){
                NSDate *date = [DateTimeUtil getDate:[strValue doubleValue]];
                cell.valueText.text = [DateTimeUtil getYYYYMD: date];
            }
        }
        // 数値
        else if( [dataType isEqualToString: ISM_DATA_TYPE_Num]){
            valueText.keyboardType = UIKeyboardTypeDecimalPad;
        }
        
        // 最終行以外はリターンキーの文字を次へにする
        if( indexPath.row != values.count - 1){
            valueText.returnKeyType = UIReturnKeyNext;
        }
        else{
            valueText.returnKeyType = UIReturnKeyDone;
        }
        return cell;
    }
}

-(void) addComma:(UITextField*)textField{
    NSString *text = [StringUtil removeComma:textField.text];
    textField.text = [StringUtil addCommaToString:text];
}

/** セルの選択 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

/** セルの編集開始 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSInteger rowNum = [textField tag];
    // 編集中の行を保持しておく
    focusIndexPath = [NSIndexPath indexPathForRow:rowNum inSection:0];
    
    ItemSettingModel *setting = [rowItemSettingMap valueForKey: [StringUtil toStringLong:rowNum]];

    NSString *dataType = [setting dataType];
    // データ型が日付の場合
    if ( [dataType isEqualToString: ISM_DATA_TYPE_DATE]){
        keyboardViewController = [[DateKeyboardViewController alloc] init];
        
        __block KeyboardViewController *blockViewController = keyboardViewController;
        keyboardViewController.okBlock = ^{
            DateKeyboardViewController *dateKeyboard = ((DateKeyboardViewController *) blockViewController);
            textField.text = [DateTimeUtil getYYYYMD: dateKeyboard.datePicker.date];
            [super focusNextField: textField];
        };
    }
    // データ型が選択方式の場合
    else if( [dataType isEqualToString: ISM_DATA_TYPE_SELECT]){
        PickerKeyboardViewController *pickerKeyboard = [[PickerKeyboardViewController alloc] init];
        keyboardViewController = pickerKeyboard;
        keyboardViewController.okBlock = ^{
            [super focusNextField: textField];
        };
    }
    
    // キャンセル時の処理
    accessoryViewController = [[OkCancelAccessoryViewController alloc] init];
    UIView *accessory = [accessoryViewController view];
    // サイズを指定しないと駄目？
    accessory.frame = CGRectMake(0.0f, 0.0f, 280.0f, 40.0f);
    accessoryViewController.cancelBlock = ^{
        [textField resignFirstResponder];
    };
    

    textField.inputAccessoryView = accessory;
    textField.inputView = [keyboardViewController view];
    
    // データ型が選択方式の場合にPickerの中身を設定
    if( [dataType isEqualToString: ISM_DATA_TYPE_SELECT]){
        PickerKeyboardViewController *pickerKeyboard = (PickerKeyboardViewController *)keyboardViewController;
        pickerDataSource = [[CsvPickerDataSource alloc] initWithString:setting.selectItems];
        pickerKeyboard.picker.delegate = pickerDataSource;
        pickerKeyboard.picker.dataSource = pickerDataSource;
    }
    
    return YES;
}

- (UIView *)getAccessoryView
{
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 40.0f)];
    accessoryView.backgroundColor = [UIColor blueColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(250.0f, 5.0f, 65.0f, 34.0f);
    [button setTitle:@"とじる" forState:UIControlStateNormal];
    
    // View にボタン追加
    [accessoryView addSubview:button];
    
    return accessoryView;
}

#pragma mark Logic

/**
 * メニュー選択時の処理
 */
- (IBAction)selectMenu:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"メニュー" delegate:self cancelButtonTitle:@"キャンセル" destructiveButtonTitle:nil otherButtonTitles:@"ヘルプ", @"入力項目設定", @"出力項目設定", @"送信設定",nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //遷移先のインスタンスを生成
    if ( buttonIndex == 1){
        InputSettingListViewController *inputSettingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InputSettingListViewController"];
        [[self navigationController] pushViewController:inputSettingViewController animated:YES];
    }
    else if( buttonIndex == 2){
        OutputSettingListViewController *outputSettingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OutputSettingListViewController"];
        [[self navigationController] pushViewController:outputSettingViewController animated:YES];
    }
    else if( buttonIndex == 3){
        SettingViewController *settingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
        [[self navigationController] pushViewController:settingViewController animated:YES];
        
//        [self performSegueWithIdentifier:@"setting" sender:self];
    }
}

/**
 * 保存ボタン押下時の処理
 */
- (IBAction)selectSave:(id)sender {
    TravelCostModel *costModel = nil;
    if( _travelCostRowId == nil){
        costModel = [[TravelCostModel alloc] init];
    }
    else{
        TravelCostDao *dao = [[TravelCostDao alloc] init];
        costModel = (TravelCostModel *)[ dao load: _travelCostRowId];
    }
    
    // 値の設定
    // 入力チェック＆モデルに値を設定
    NSMutableString *errorMsg = [[NSMutableString alloc] init];
    for( int cnt = 0; cnt < values.count; cnt++){
        ItemValueModel *valueModel = values[ cnt];
        ItemSettingModel *settingModel = [ valueModel _itemSettingModel];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cnt inSection:0];
        
        NSString *dataType = settingModel.dataType;
        
        NSString *value = nil;
        // データタイプによる判定
        if ( [dataType isEqualToString: ISM_DATA_TYPE_CHECK]){
            InputViewSwitchCell *cell = (InputViewSwitchCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            if( cell.swith.on){
                value = @"1";
            }
            else{
                value = @"0";
            }
        }
        else{
            InputViewCell *cell = (InputViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            UITextField *textField = [cell valueText];
            
            if ( [dataType isEqualToString: ISM_DATA_TYPE_DATE]){
                if(! [StringUtil isEmpty: textField.text]){
                    NSDate *date = [DateTimeUtil getDateFromYYYYMMDD:textField.text];
                    value = [StringUtil toStringDouble: (double)[date timeIntervalSince1970]];
                }
            }
            else if ( [dataType isEqualToString: ISM_DATA_TYPE_Num]){
                value = [StringUtil removeComma:textField.text];
            }
            else{
                value = textField.text;
            }
        }
        
        
        // モデルに値を設定
        [valueModel setValue: value];
        
        int rowId = [[settingModel rowId] intValue];
        // 必須チェック　日付、金額
        bool invalid = NO;
        
        if( rowId == 1 || rowId == 7){
            // 必須チェック
            if( [StringUtil isEmpty: valueModel.value]){
                // 2行目以降は改行
                if( errorMsg.length != 0){
                    [errorMsg appendString:@"\n"];
                }
                invalid = YES;
                [errorMsg appendFormat:@"%@を入力してください", settingModel.name];
            }
        }
        
        // 親のモデルに値を設定
        if( !invalid){
            // TravelCostModelにも値を設定
            // 日付
            if  (rowId == 1) {
                costModel.date = [DateTimeUtil getDate: [valueModel.value doubleValue]];
            }
            // 交通手段
            else if( rowId == 2){
                costModel.transType = valueModel.value;
            }
            // 乗車
            else if( rowId == 3){
                costModel.rideLocation = valueModel.value;
            }
            // 降車
            else if( rowId == 4){
                costModel.dropOffLocation = valueModel.value;
            }
            // 片道・往復
            else if( rowId == 6){
                costModel.oneWay = valueModel.value;
            }
            // 金額
            else if( rowId == 7){
                double dValue = [valueModel.value doubleValue];
                costModel.amount = [NSNumber numberWithDouble:dValue];
            }
            // お気に入り
            else if( rowId == 9){
                // フラグがON
                if( [ valueModel.value boolValue]){
                    if( costModel.favoriteOrder == nil){
                        // 新たにお気に入り追加されたものは最大値+1
                        TravelCostDao *dao = [[TravelCostDao alloc]init];
                        costModel.favoriteOrder = [NSNumber numberWithInt:[dao getMax:TCM_COLUMN_FAVORITE_ORDER] + 1];
                    }
                }
                else{
                    costModel.favoriteOrder = nil;
                }
            }
        }
        
        
        NSLog(@"%@ %@", [settingModel name], valueModel.value);
    }
    
    // エラーを表示して終了
    if( errorMsg.length != 0){
        [ViewUtil showMessage:@"入力エラー" message:errorMsg];
    }
    else{
        // 保存
        TravelCostDao *dao = [[TravelCostDao alloc] init];
        BOOL result = [dao saveTravelCost:costModel values:values];
        if( result){
            [ViewUtil showToast:@"保存しました"];
        }
        else{
            [ViewUtil showToast:@"保存に失敗しました"];
        }
        
    }
}

- (void) reload{
    [values removeAllObjects];
    [super clearInputField];
    focusIndexPath = nil;
    
    NSMutableDictionary *settingValueMap = [[NSMutableDictionary alloc] init];
    if ( _travelCostRowId != nil){
        ItemValueDao *valueDao = [[ItemValueDao alloc] init];
        
        NSString *where = [NSString stringWithFormat: @"%@='%d'", IVM_COLUMN_TRAVEL_COST_ID, [_travelCostRowId intValue]];
        NSArray *valueModels = [ valueDao list:where order:nil];
        
        for( ItemValueModel *value in valueModels){
            [settingValueMap setObject:value forKey: [StringUtil toStringNumber:value.itemSettingId]];
        }
    }
    
    // 初期データを取得する
    ItemSettingManager *settingManager = [ItemSettingManager instance];
    NSArray *settings = [settingManager getInputItemSettingList];
    for( ItemSettingModel *setting in settings){
        ItemValueModel *value = [settingValueMap valueForKey:[ StringUtil toStringNumber:setting.rowId]];
        if( value == nil){
            value = [ItemValueModel initFromSetting:setting];
        }
        value._itemSettingModel = setting;
        [values addObject:value];
    }
    [ self.tableView reloadData];
    
    settingLoadTime = [NSDate date];
}


#pragma mark Software Keyboard Methods

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    // 1. キーボードの top を取得する
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // スクリーンサイズの取得
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGFloat appContentHeight = screenRect.size.height;
    CGFloat keyboardTop = (appContentHeight) - (keyboardFrame.size.height + 55.f );   // 55.f:予測変換領域の高さ
    
    
    // 2. 編集中セルの bottom を取得する
    // テーブル ビューはスクロールしていることがあるので、オフセットを考慮すること
    NSInteger row = focusIndexPath.row;
    NSInteger section = focusIndexPath.section;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row
                                                                                     inSection:section]];
    CGRect cellFrame = cell.frame;
    CGPoint offset = CGPointZero;
    offset =  self.tableView.contentOffset;
    
    CGRect cellRectOrigin = CGRectZero;
    cellRectOrigin.origin.x = cellFrame.origin.x - offset.x;
    cellRectOrigin.origin.y = cellFrame.origin.y - offset.y;
    
    CGFloat cellBottom = cellRectOrigin.origin.y + cellFrame.size.height + 30.f;   // 30.f:マージン
    
    // 編集中セルの bottom がキーボードの top より上にある場合、
    // キーボードに隠れないよう位置を調整する処理対象外とする
    if (cellBottom < keyboardTop) {
        return;
    }
    
    // 3. 編集中セルとキーボードが重なる場合、編集中セルを画面中央へ移動させる
    // キーボードの高さ分の insets を作成する
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, keyboardTop, 0.0f);
    
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    void (^animations)(void);
    animations = ^(void) {
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    };
    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:animations completion:nil];
    
    // 編集中セルの位置を調整する
    CGRect rect = cell.frame;
    rect.origin.y = cellFrame.origin.y - 300.f;
    
    [self.tableView scrollRectToVisible:rect animated:YES];
}

- (void)keybaordWillHide:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    void (^animations)(void);
    animations = ^(void) {
        // insets を 0 にする
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    };
    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:animations completion:nil];
    
    keyboardViewController = nil;
    pickerDataSource = nil;
}

@end
