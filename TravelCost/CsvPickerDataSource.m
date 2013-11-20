//
//  CsvPickerDelegate.m
//  TravelCost
//
//  Created by 横井朗 on 2013/11/02.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "CsvPickerDataSource.h"

@implementation CsvPickerDataSource
{
    NSArray *values;
}

- (id)initWithString:(NSString *)csv{
    self = [super init];
	if (self)
	{
        values = [csv componentsSeparatedByString:@","];
    }
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    return (int)[values count];
}

// 表示する内容を返す
-(NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return values[ row];
}

- (NSString *) getSelectedItem: (NSInteger )selectedIndex{
    return values[ selectedIndex];
}

- (NSInteger) indexOf:( NSString *)item{
    return [values indexOfObject:item];
}

@end
