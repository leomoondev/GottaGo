//
//  CSVParser.m
//  GottaGo
//
//  Created by Hyung Jip Moon on 2017-03-07.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "CSVParser.h"
 
@implementation CSVParser

- (NSArray *) parseDataFromCSV {
    
    NSString *stringURL2 = @"ftp://webftp.vancouver.ca/OpenData/csv/public_washrooms.csv";
    NSURL  *url2 = [NSURL URLWithString:stringURL2];
    NSData *urlData2 = [NSData dataWithContentsOfURL:url2];
    NSString *csvResponseString2 = [[NSString alloc] initWithData:urlData2   encoding:NSUTF8StringEncoding];
    
    NSArray *locations = [csvResponseString2 componentsSeparatedByString:@"\n"];
    
    NSMutableArray *storeAllArray = [NSMutableArray array];
    NSDictionary *dict = [NSMutableDictionary dictionary];
    //changed the first item's index to equal 1 so we wouldn't get the headings
    for (int i = 1; i < locations.count-1; i++) {
        NSString *location = [locations objectAtIndex:i];
        
        NSArray *components = [self parseCSVStringIntoArray:location];
        
        NSString *pId =  components[0];
        NSString *pName = components[1];
        NSString *pAddress = components[2];
        NSString *pType = components[3];
        NSString *pLocation = components[4];
        NSString *pSummerHours = components[5];
        NSString *pWinterHours = components[6];
        NSString *pWheelchair = components[7];
        NSString *pNote = components[8];
        double latitude   = [components[9] doubleValue];
        double longitude  = [components[10] doubleValue];
        NSString *pMaintainer = components[11];
        
        
        dict = @{@"PRIMARYIND": pId,
                 @"NAME": pName,
                 @"ADDRESS": pAddress,
                 @"TYPE": pType,
                 @"LOCATION": pLocation,
                 @"SUMMER_HOURS": pSummerHours,
                 @"WINTER_HOURS": pWinterHours,
                 @"WHEELCHAIR_ACCESS": pWheelchair,
                 @"NOTE": pNote,
                 @"LATITUDE": @(latitude),
                 @"LONGITUDE": @(longitude),
                 @"MAINTAINTER": pMaintainer
                 };
        
        Pin *objectPin = [[Pin alloc] initWithName:pName andWithAddress:pAddress andWithType:pType andWithLocation:pLocation andWithSummerHours:pSummerHours andWithWinterHours:pWinterHours andWithWheelchairAccess:pWheelchair andWithMaintainer:pMaintainer andWithLatitude:latitude andWithLongitude:longitude];
        
        [storeAllArray addObject:objectPin];
        
    }
    return [storeAllArray copy];
    
}


- (NSMutableArray *)parseCSVStringIntoArray:(NSString *)csvString {
    
    // Handle the empty field from the CSV file
    csvString = [csvString stringByReplacingOccurrencesOfString:@",," withString:@",\"\","];
    // Handle the quotation mark inside of String from the CSV file
    csvString = [csvString stringByReplacingOccurrencesOfString:@"\"\"" withString:@" "];

    
    NSMutableArray *csvDataArray = [[NSMutableArray alloc] init];
    
    // Break string into an array of individual characters
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[csvString length]];
    unsigned long csvStringLength = [csvString length];
    
    for (int c=0; c < csvStringLength; c++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [csvString characterAtIndex:c]];
        [characters addObject:ichar];
    }
    
    BOOL quotationMarksPresent = FALSE;
    
    for (NSString *ichar in characters) {
        
        if ([ichar isEqualToString:@"\""]) {
            quotationMarksPresent = TRUE;
            break;
        }
    }
    
    if (!quotationMarksPresent) {
        // quotation marks are NOT present
        // simply break by comma and return
        
        NSArray *componentArray = [csvString componentsSeparatedByString:@","];
        csvDataArray = [NSMutableArray arrayWithArray:componentArray];
        
        return csvDataArray;
        
    }
    else {
        // quotation marks ARE present
        
        NSString *field = [NSString string];
        BOOL ignoreCommas = FALSE;
        int counter = 0;
        
        for (NSString *ichar in characters) {
            
            if ([ichar isEqualToString:@"\n"]) {
                // end of line reached
                [csvDataArray addObject:field];
                
                return csvDataArray;
            }
            
            if (counter == ([characters count]-1)) {
                // end of character stream reached
                // add last character to field, add to array and return
                field = [field stringByAppendingString:ichar];
                [csvDataArray addObject:field];
                
                return csvDataArray;
            }
            
            if (ignoreCommas == FALSE) {
                
                if ( [ichar isEqualToString:@","] == FALSE) {
                    // ichar is NOT a comma
                    
                    if ([ichar isEqualToString:@"\""] == FALSE) {
                        // ichar is NOT a double-quote
                        field = [field stringByAppendingString:ichar];
                    }
                    else {
                        // ichar IS a double-quote
                        ignoreCommas = TRUE;
                        field = [field stringByAppendingString:ichar];
                    }
                }
                
                else {
                    // comma reached - add field to array
                    if ([field isEqualToString:@""] == FALSE) {
                        
                        [csvDataArray addObject:field];
                        field = @"";
                    }
                }
                
            }
            else {
                
                if ([ichar isEqualToString:@"\""] == FALSE) {
                    // ichar is NOT a double-quote
                    field = [field stringByAppendingString:ichar];
                }
                else {
                    // ichar IS a double-quote
                    // closing double-quote reached
                    ignoreCommas = FALSE;
                    field = [field stringByAppendingString:ichar];
                    // end of field reached - add field to array
                    if ([field isEqualToString:@""] == FALSE) {
                        [csvDataArray addObject:field];
                        field = @"";
                    }
                }
            } // END if (ignoreCommas == FALSE)
            counter++;
        } // END for (NSString *ichar in characters)
    }
    return nil;
}

@end
