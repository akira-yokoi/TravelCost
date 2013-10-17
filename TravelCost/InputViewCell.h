//
//  InputViewCell.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/07.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueText;

@end
