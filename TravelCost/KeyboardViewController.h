//
//  KeyboardViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/31.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardViewController : UIViewController

@property (nonatomic, copy) dispatch_block_t okBlock;
@property (nonatomic, copy) dispatch_block_t cancelBlock;

@end
