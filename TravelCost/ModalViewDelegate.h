//
//  ModalDelegate.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/21.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModalViewDelegate <NSObject>

- (void)ok:(id)value;

- (void)cancel;

@end
