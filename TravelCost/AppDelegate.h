//
//  AppDelegate.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/03.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

#define AmdLog(fmt,...) NSLog((@"%s:%d "fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@property (strong, nonatomic) UIWindow *window;

@end
