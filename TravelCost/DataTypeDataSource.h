//
//  DataTypeKeyboardViewController.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/31.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

@interface DataTypeDataSource : NSObject<UIPickerViewDataSource, UIPickerViewDelegate>

+ (NSString *) getDataTypeCode: (NSString *)dataTypeName;
+ (NSString *) getDataTypeName: (NSString *)dataTypeCode;

+ (NSString *) getDataTypeCodeFromIndex: (int)rowIndex;
+ (NSString *) getDataTypeNameFromIndex: (int)rowIndex;

+ (int) getIndex: (NSString *)key;

@end
