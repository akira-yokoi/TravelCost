//
//  MenuDelegate.h
//  TravelCost
//
//  Created by 横井朗 on 2013/11/09.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuManager : NSObject<UIActionSheetDelegate>

@property (weak, nonatomic) UIViewController *mViewController;

- (void) show;

@end
