//
//  CSVParser.h
//  GottaGo
//
//  Created by Hyung Jip Moon on 2017-03-07.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Pin.h"

@interface CSVParser : NSObject

- (NSArray *) parseDataFromCSV;
- (NSMutableArray *)parseCSVStringIntoArray:(NSString *)csvString;

@end
