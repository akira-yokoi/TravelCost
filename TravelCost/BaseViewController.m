//
//  BaseViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/17.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    UIScrollView *autoScrollView;
    UITextField *activeField;
    
    CGFloat adjustHeight;
    NSMutableArray *inputFields;
}
@end

@implementation BaseViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 背景をキリックしたら、キーボードを隠す
//    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
//    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    activeField = nil;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self focusNextField:textField];
    return YES;
}

- (void) focusNextField:(UITextField *)textField{
    [textField resignFirstResponder];
    /*
    UITextField *nextTextField = [self getNextFocusField:textField];
    
    if( nextTextField == nil){
        // キーボードを閉じる
        [textField resignFirstResponder];
    }
    else{
        // 次のフィールドへフォーカスを合わせる
        [textField resignFirstResponder];
        [nextTextField becomeFirstResponder];
    }
    */
}

/**
 * 次にフォーカスを合わせるべきフィールドを取得する
 */
- (UITextField *)getNextFocusField: (UITextField *)currentTextField{
    if( inputFields == nil || [inputFields count] == 0){
        return nil;
    }
    int nextIndex = (int)[inputFields indexOfObject:currentTextField] + 1;

    while( [inputFields count] > nextIndex){
        UITextField *nextTextField = inputFields[ nextIndex++];
        if( nextTextField == nil){
            return nil;
        }
        if(! [nextTextField isHidden]){
            return nextTextField;
        }
    }
    return nil;
}

- (void) updateReturnKey{
    BOOL isLast = YES;
    int fieldCnt = (int)[inputFields count];
    for( int cnt = fieldCnt - 1; cnt >= 0; cnt--){
        UITextField *inputField = inputFields[ cnt];
        if(! [inputField isHidden]){
            if( isLast){
                inputField.returnKeyType = UIReturnKeyDone;
                isLast = NO;
            }
            else{
                inputField.returnKeyType = UIReturnKeyNext;
            }
        }
    }
}

// キーボードを隠す処理
- (void)closeSoftKeyboard {
//    [self.view endEditing: YES];
}


#pragma mark Software Keyboard Methods

- (void)autoScroll:(UIScrollView *)scrollView{
    autoScrollView = scrollView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    // キーボードの表示・非表示の通知を登録する
    if( autoScrollView){
        NSNotificationCenter *center;
        center = [ NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:self selector:@selector(keybaordWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // キーボードの表示・非表示の通知を削除する
    if( autoScrollView){
        NSNotificationCenter *center;
        center = [NSNotificationCenter defaultCenter];
        [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void) addInputField:(UITextField *)inputField{
    if( inputFields == nil){
       inputFields = [[NSMutableArray alloc] init];
    }
    [inputFields addObject: inputField];
}

- (void) clearInputField{
    if( inputFields != nil){
        [inputFields removeAllObjects];
    }
}

- (void)keyboardWillShow:(NSNotification*)notification{
    
    // キーボードの表示完了時の場所と大きさを取得。
    CGRect keyboardFrameEnd = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 表示領域の計算
    CGPoint currentOffset = [autoScrollView contentOffset];
    
    CGRect dispRect = self.view.frame;
    dispRect.size.height -= keyboardFrameEnd.size.height;
    // 現在のオフセットを考慮
    dispRect.origin.y += currentOffset.y;
    
    // フィールドの描画領域
    CGRect activeFieldRect = activeField.frame;

    
    // 表示領域にアクティブなフィールドが含まれるかどうか
    // この判定がうまくいっていない
    // ナビゲーションアイテム分の高さが入っていない？
    if (!CGRectContainsPoint(dispRect, activeFieldRect.origin) ) {
        CGFloat dispBottom  = dispRect.origin.y + dispRect.size.height;
        CGFloat fieldBottom = activeFieldRect.origin.y + activeFieldRect.size.height;

        adjustHeight = fieldBottom - dispBottom;
        // キーボードが隠れる場合はoffsetを調節してアクティブなフィールドが表示されるように
        [autoScrollView setContentOffset:CGPointMake(0.0, adjustHeight) animated:YES];
    }
}

- (void)keybaordWillHide:(NSNotification*)notification{
    if( adjustHeight != 0){
        [autoScrollView setContentOffset:CGPointMake(0.0, adjustHeight * -1) animated:YES];
    }
}


@end
