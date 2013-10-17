//
//  PickerKeyboardViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/07.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerKeyboardViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end
