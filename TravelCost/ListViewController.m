//
//  ListViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/29.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

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

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Logic

- (void)reload{
    values = [NSMutableArray arrayWithArray:[self getValues]];
    [[self getTableView] reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    UITableView *tableView = [self getTableView];
    [tableView setEditing:editing animated:animated];
}


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
    [self setCellData:cell value:value];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self canOrder];
}

/**
 * 並び替えを可能にする
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    id source = values[ sourceIndexPath.row];
    [values removeObjectAtIndex: sourceIndexPath.row];
    [values insertObject:source atIndex: destinationIndexPath.row];
    
    [self updateOrder];
}

/**
 * 削除ボタンを表示するかどうか
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // ここで追加・削除をさせないことを示す
    if( [self canDelete]){
        return UITableViewCellEditingStyleDelete;
    }
    else{
        return UITableViewCellEditingStyleNone;
    }
}

/**
 * 編集モードでインデントするかどうか
 */
- (BOOL)tableView:(UITableView *)tableView
shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 編集モードでインデントもしない
    if( [self canDelete]){
        return YES;
    }
    else{
        return NO;
    }
}

/**
 * 一覧上で削除ボタンを表示するかどうか
 * YESを返すと削除ボタンが表示される
 */
- (BOOL) canDelete{
    return NO;
}

/**
 * 一覧上で並び替えを可能にするかどうか
 */
- (BOOL) canOrder{
    return YES;
}

/** セルの選択 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id selectedItem = values[ indexPath.row];
    [self selectRow:selectedItem];
}

/**
 * 並び順の更新
 * サブクラスで実装する
 */
- (void)updateOrder{
}

/**
 * 一覧に表示する値の取得
 * サブクラスで実装する
 */
- (NSArray *)getValues{
    return nil;
}

/**
 * 表示に使用するテーブルの取得
 * サブクラスで実装する
 */
- (UITableView *) getTableView{
    return nil;
}

/**
 * Cellのアップデート
 * サブクラスで実装する
 */
- (void) setCellData:(UITableViewCell *)cell value:(id)value{
    
}

/**
 * セル選択時の処理
 * サブクラスで実装する
 */
-(void) selectRow: (id)item{
}

@end
