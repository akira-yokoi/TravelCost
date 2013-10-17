//
//  ListViewCell.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/09.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *transTypeLabel;

@end
