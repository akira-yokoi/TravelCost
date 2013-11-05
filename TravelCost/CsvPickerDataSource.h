//
//  CsvPickerDelegate.h
//  TravelCost
//
//  Created by 横井朗 on 2013/11/02.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CsvPickerDataSource : NSObject<UIPickerViewDataSource, UIPickerViewDelegate>

- (id)initWithString:(NSString *)csv;

@end
