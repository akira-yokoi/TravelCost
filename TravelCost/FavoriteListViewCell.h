//
//  FavoriteListViewCell.h
//  TravelCost
//
//  Created by 横井朗 on 2013/11/15.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end
