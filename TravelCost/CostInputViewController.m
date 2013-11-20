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

#import "InputSettingListViewController.h"
#import "OutputSettingListViewController.h"
#import "SettingViewController.h"
#import "OkCancelAccessoryViewController.h"

#import "FMDatabase.h"
#import "MenuManager.h"

#import "ViewUtil.h"
#import "DateTimeUtil.h"
#import "NumberUtil.h"
#import "TableUtil.h"
#import "StringUtil.h"

@interface CostInputViewController ()
{
    NSMutableArray *mValues;
    NSIndexPath *mFocusIndexPath;
    
    OkCancelAccessoryViewController *mAccessoryViewController;

    CsvPickerDataSource *mPickerDataSource;
    NSMutableDictionary *mRowItemSettingMap;
    
    NSDate *mSettingLoadTime;
    
    UIView *mInputView;
    
    MenuManager *menuManager;
    
    UITextField *mRideOnLocation;
    UITextField *mDropOffLocation;
    
    NSMutableDictionary *mSettingIdIndexMap;
    BOOL historyMode;
}
@property (strong, nonatomic) FMDatabase *db;

@end

@implementation CostInputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mValues = [[NSMutableArray alloc] init];
    mRowItemSettingMap = [[NSMutableDictionary alloc] init];
    mSettingIdIndexMap = [[NSMutableDictionary alloc] init];
    
    [self reload];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];

    // 必要に応じてリロード
    {
        ItemSettingManager *settingManager = [ItemSettingManager instance];
        NSDate *updateDate = [settingManager getUpdateTime];
        if( updateDate != nil){
            if( [DateTimeUtil d1_gt_d2:updateDate date2:mSettingLoadTime]){
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
    NSInteger count = [mValues count];
    return count;
}

/** セルの作成 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemValueModel *value = mValues[ indexPath.row];
    ItemSettingModel *setting = [value _itemSettingModel];

    NSString *strValue = [StringUtil killNull:[value value]];
    NSString *dataType = [setting dataType];
    
    [mRowItemSettingMap setObject:setting forKey: [StringUtil toStringLong:indexPath.row]];
    [mSettingIdIndexMap setObject:indexPath forKey:[ StringUtil toStringNumber:setting.rowId]];

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
        
        // 乗車駅
        if( [setting.rowId integerValue] == 3){
            mRideOnLocation = valueText;
        }
        // 降車駅
        else if( [setting.rowId integerValue] == 4){
            mDropOffLocation = valueText;
        }
        
        
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

        // セルのアクセサリの設定
        UIImageView *cellAccessory = [self createCellAccessory: setting];
        if( cellAccessory){
            cell.accessoryView = cellAccessory;
        }
 
        // 最終行以外はリターンキーの文字を次へにする
        if( indexPath.row != mValues.count - 1){
            valueText.returnKeyType = UIReturnKeyNext;
        }
        else{
            valueText.returnKeyType = UIReturnKeyDone;
        }
        return cell;
    }
}

- (UIImageView *)createCellAccessory: (ItemSettingModel *)setting{
    NSString *dataType = [setting dataType];
    // 文字列
    if( [setting.rowId intValue] == 7 || [dataType isEqualToString: ISM_DATA_TYPE_STRING]){
        // 文字列の場合は履歴ボタンを表示
        UIImage *image = nil;
        if( [setting.rowId intValue] == 7){
            image = [ViewUtil createButtonImage:@"\uf0ac"];
        }
        else{
            image = [ViewUtil createButtonImage:@"\uf017"];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        //画像が大きい場合にはみ出さないようにViewの大きさを固定化
        imageView.userInteractionEnabled = YES;
        imageView.tag = [setting.rowId integerValue];
        [imageView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCellImage:)]];
        return imageView;
    }
    return nil;
}

- (void)clickCellImage: (UITapGestureRecognizer *)sender{
    UIView *view = sender.view;
    if( view.tag == 7){
        NSString *from = mRideOnLocation.text;
        NSString *to = mDropOffLocation.text;
        
        if( [StringUtil isEmpty:from]){
            [ViewUtil showToast:@"乗車を設定してください"];
            return;
        }
        if( [StringUtil isEmpty:to]){
            [ViewUtil showToast:@"降車を設定してください"];
            return;
        }
        
        NSString *urlString = [self getTransitURL:from to:to type:@"dep" express:false];
        NSURL *url = [NSURL URLWithString:urlString];
        
        // ブラウザを起動する
        [[UIApplication sharedApplication] openURL:url];
    }
    else{
        historyMode = YES;

        NSIndexPath *indexPath = [mSettingIdIndexMap valueForKey:[StringUtil toStringInt:view.tag]];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if( [ReflectionUtil instanceof:cell class:[InputViewCell class]]){
            InputViewCell *inputCell = (InputViewCell *)cell;
            UITextField *valueText = [inputCell valueText];
            // 既に編集中の場合もキーボードを開き直すためにいったんクローズ
            [valueText resignFirstResponder];
            // 再度編集モードにする
            [valueText becomeFirstResponder];
        }
    }
}

- (NSString *)getTransitURL:(NSString *)from to:(NSString *)to type:(NSString *)type express:(BOOL) express{
    
    NSMutableString *url = [[NSMutableString alloc] init];
    [url appendString: @"http://www.google.co.jp/maps?ie=UTF8&f=d&dirflg=r"];
    if(! [StringUtil isEmpty:from]){
        NSString *encFrom = [from stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [url appendFormat: @"&saddr=%@", encFrom];
    }
    if(! [StringUtil isEmpty:to]){
        NSString *encTo = [to stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [url appendFormat: @"&daddr=%@", encTo];
    }
    [ url appendFormat: @"&ttype=%@", type];
    [ url appendString: @"&sort=time"];
    
    if( !express){
        [ url appendString: @"&noexp=1"];
    }
    
    return url;
}

-(void) addComma:(UITextField*)textField{
    NSString *text = [StringUtil removeComma:textField.text];
    textField.text = [StringUtil addCommaToString:text];
}

/** セルの選択 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if( [ReflectionUtil instanceof:cell class:[InputViewCell class]]){
        InputViewCell *inputCell = (InputViewCell *)cell;
        UITextField *valueText = [inputCell valueText];
        [valueText resignFirstResponder];
        [valueText becomeFirstResponder];
    }
}

/** セルの編集開始 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSInteger rowNum = [textField tag];
    // 編集中の行を保持しておく
    mFocusIndexPath = [NSIndexPath indexPathForRow:rowNum inSection:0];
    
    ItemSettingModel *setting = [mRowItemSettingMap valueForKey: [StringUtil toStringLong:rowNum]];

    NSString *dataType = [setting dataType];
    
    // 入力部品の作成
    mInputView = nil;
    
    if( historyMode){
        mInputView = [self createHistoryView:setting];
    }
    
    if( mInputView == nil){
        mInputView = [self createInputView:dataType];
    }
    
    textField.inputView = mInputView;

    mAccessoryViewController = [self createAccessoryViewController];
    textField.inputAccessoryView = [mAccessoryViewController view];
    
    // データ型が選択方式の場合にPickerの中身を設定
    if( [dataType isEqualToString: ISM_DATA_TYPE_SELECT]){
        mPickerDataSource = [[CsvPickerDataSource alloc] initWithString:setting.selectItems];
        UIPickerView *picker = (UIPickerView *)mInputView;
        picker.delegate = mPickerDataSource;
        picker.dataSource = mPickerDataSource;

        NSInteger indexOf = [mPickerDataSource indexOf:textField.text];
        [picker selectRow:indexOf inComponent:0 animated:YES];
    }
    
    // 入力が日付の場合
    if( [ReflectionUtil instanceof:mInputView class:[UIDatePicker class]]){
        __block UIView *bInputView = mInputView;
        mAccessoryViewController.okBlock = ^{
            UIDatePicker *datePicker = (UIDatePicker *) bInputView;
            textField.text = [DateTimeUtil getYYYYMD: datePicker.date];
            [super focusNextField: textField];
        };
    }
    // 入力がPickerの場合
    else if( [ReflectionUtil instanceof:mInputView class:[UIPickerView class]]){
        __block UIView *bInputView = mInputView;
        __block CsvPickerDataSource *bDataSource = mPickerDataSource;
        
        mAccessoryViewController.okBlock = ^{
            UIPickerView *pickerView = (UIPickerView *) bInputView;
            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            NSString *selectedItem = [bDataSource getSelectedItem:selectedRow];
            
            textField.text = selectedItem;
            [super focusNextField: textField];
        };
    }
    // 入力がその他の場合
    else{
        [mAccessoryViewController deleteCancelButton];
        mAccessoryViewController.okBlock = ^{
            [textField resignFirstResponder];
        };
    }
    
    mAccessoryViewController.cancelBlock = ^{
        [textField resignFirstResponder];
    };
    
    historyMode = NO;
    
    return YES;
}

- (UIView *)createInputView: (NSString *)dataType{
    UIView *inputView;
    // データ型が日付の場合
    if ( [dataType isEqualToString: ISM_DATA_TYPE_DATE]){
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        inputView = datePicker;
    }
    // データ型が選択方式の場合
    else if( [dataType isEqualToString: ISM_DATA_TYPE_SELECT]){
        inputView = [[UIPickerView alloc] init];
    }
    return inputView;
}

- (UIView *)createHistoryView: (ItemSettingModel *)settingModel{
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    ItemValueDao *valueDao = [[ItemValueDao alloc] init];
    NSString *csvValue = [valueDao getHistoryValues: settingModel.rowId.intValue];
    if( [StringUtil isEmpty:csvValue]){
        [ViewUtil showToast:@"履歴データは存在しません"];
        return nil;
    }
    mPickerDataSource = [[CsvPickerDataSource alloc] initWithString:csvValue];
    pickerView.dataSource = mPickerDataSource;
    pickerView.delegate = mPickerDataSource;
    return pickerView;
}

- (OkCancelAccessoryViewController *) createAccessoryViewController{
    // キャンセル時の処理
    OkCancelAccessoryViewController *viewController = [[OkCancelAccessoryViewController alloc] init];
    UIView *accessoryView = [viewController view];
    
    // サイズを指定しないと駄目？
    accessoryView.frame = CGRectMake(0.0f, 0.0f, 280.0f, 40.0f);
    return viewController;
}

#pragma mark Logic

/**
 * メニュー選択時の処理
 */
- (IBAction)selectMenu:(id)sender {
    if( menuManager == nil){
        menuManager = [[MenuManager alloc] init];
    }
    menuManager.mViewController = self;
    [menuManager show];
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
    for( int cnt = 0; cnt < mValues.count; cnt++){
        ItemValueModel *valueModel = mValues[ cnt];
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
                    if( [NumberUtil isEmpty:costModel.favoriteOrder] ){
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
        BOOL result = [dao saveTravelCost:costModel values:mValues];
        if( result){
            [ViewUtil showToast:@"保存しました"];
        }
        else{
            [ViewUtil showToast:@"保存に失敗しました"];
        }
        
    }
}

- (void) reload{
    [mValues removeAllObjects];
    [super clearInputField];
    mFocusIndexPath = nil;
    
    NSMutableDictionary *settingValueMap = [[NSMutableDictionary alloc] init];
    if ( ![NumberUtil isEmpty:_travelCostRowId]){
        ItemValueDao *valueDao = [[ItemValueDao alloc] init];
        NSArray *valueModels = [ valueDao getValueModels:[_travelCostRowId intValue]];
        
        for( ItemValueModel *value in valueModels){
            if( self.fromFavorite){
                value.rowId = nil;
                // 日付は当日
                if( [value.itemSettingId intValue] == 1){
                    value.value = [StringUtil toStringDouble: (double)[[NSDate date] timeIntervalSince1970]];
                }
                // お気に入りはOFF
                else if( [value.itemSettingId intValue] == 9){
                    value.value = @"NO";
                }
            }

            [settingValueMap setObject:value forKey: [StringUtil toStringNumber:value.itemSettingId]];
        }
        
        if( self.fromFavorite){
            _travelCostRowId = nil;
            [ViewUtil removeItem:self.toolbar title:@"menu"];
        }
        [ViewUtil removeItem:self.toolbar title:@"list"];
        [ViewUtil removeItem:self.toolbar title:@"favorite"];
    }
    
    if ( [NumberUtil isEmpty:_travelCostRowId]){
        [ViewUtil removeItem:self.toolbar title:@"add"];
        [ViewUtil removeItem:self.toolbar title:@"copy"];
        [ViewUtil removeItem:self.toolbar title:@"delete"];
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
        [mValues addObject:value];
    }
    [ self.tableView reloadData];
    
    mSettingLoadTime = [NSDate date];
    
    // ツールバーにアイコンを設定
    [ViewUtil setToolbarImages:self.toolbar];
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
    
    UIView *accessoryView = [mAccessoryViewController view];
    
//    if( accessoryView ){
//        keyboardTop -= accessoryView.frame.size.height;
//    }
    
    
    // 2. 編集中セルの bottom を取得する
    // テーブル ビューはスクロールしていることがあるので、オフセットを考慮すること
    NSInteger row = mFocusIndexPath.row;
    NSInteger section = mFocusIndexPath.section;
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

    rect.origin.y = 20;
    NSLog( @"%d", (int)rect.origin.y);
    
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
    
    mInputView = nil;
    mPickerDataSource = nil;
}

@end
