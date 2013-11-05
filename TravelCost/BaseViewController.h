//
//  BaseViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/17.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UITextFieldDelegate>


- (void) autoScroll: (UIScrollView *) scrollView;

- (void) addInputField:(UITextField *) inputField;

- (void) clearInputField;

- (void) updateReturnKey;

- (void) focusNextField:(UITextField *)textField;
    
@end
