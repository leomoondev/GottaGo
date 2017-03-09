//
//  ShowOpenWashrooms.m
//  GottaGo
//
//  Created by Hyung Jip Moon on 2017-03-08.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "ShowOpenWashrooms.h"

@implementation ShowOpenWashrooms


- (void) convertOpeningHours {
    /*
     NSDate *today = [NSDate date];
     NSDateFormatter *weekdayFormatter = [[NSDateFormatter alloc] init] ;
     [weekdayFormatter setDateFormat: @"EEEE"];
     NSString *weekday = [weekdayFormatter stringFromDate: today];
     
     NSLog(@"%@", weekday);
     */
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSLog(@"newDateString %@", newDateString); //19:17:14
    
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dataComps = [gregorianCal components: (NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:now];
    
    NSLog(@"%@", dataComps);
    self.currentMinutes = [dataComps minute];
    self.currentHours = [dataComps hour];
    
    NSLog(@"%li", (long)self.currentMinutes);
    NSLog(@"%li", (long)self.currentHours);
    
    
    for (Pin *object in self.pinArray) {
        
        PinInfo *pin = [[PinInfo alloc] init];
        
        [pin setPinSummerHours:object.summerHours];
        [pin setPinWinterHours:object.winterHours];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth |NSCalendarUnitYear fromDate:[NSDate date]];
        //        NSInteger day = [components day];
        NSInteger month = [components month];
        //        NSInteger year = [components year];
        //        NSLog(@"%li",(long)day);
        //        NSLog(@"%li",(long)month);
        //        NSLog(@"%li",(long)year);
        
        // October to Februrary : Show Winter Hours
        if((10 <= month) || (month <= 3)) {
            // Show Winter Hours
            if ([object.winterHours isEqualToString:@"Dawn to Dusk"]) {
                
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                
                [self checkOpeningFirst:self.startingHourWinter second:self.startingMinutesWinter third:self.closingHourWinter fourth:self.closingMinutesWinter];
                if(self.isWashroomOpen == true) {
                    
                    [self.storeOpenWashrooms addObject:object];
                }
            }
            if([object.winterHours isEqualToString:@"24 hrs"]) {
                self.startingHourWinter = 0;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 61;
                
                [self checkOpeningFirst:self.startingHourWinter second:self.startingMinutesWinter third:self.closingHourWinter fourth:self.closingMinutesWinter];
                
                if(self.isWashroomOpen == true) {
                    
                    [self.storeOpenWashrooms addObject:object];
                    
                }
                
            }
            if([object.winterHours isEqualToString:@"10:00 am - Dusk"]) {
                self.startingHourWinter = 10;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                
            }
            if([object.winterHours isEqualToString:@"12:00 pm - 4:00 pm"]) {
                self.startingHourWinter = 12;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 16;
                self.closingMinutesWinter = 0;
            }
            
            if([object.winterHours isEqualToString:@"5:30 am - Dusk"]) {
                self.startingHourWinter = 5;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
            }
            if([object.winterHours isEqualToString:@"6:00 am - 8:30 pm"]) {
                self.startingHourWinter = 6;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 20;
                self.closingMinutesWinter = 30;
            }
            if([object.winterHours isEqualToString:@"7:00 am - Dusk"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
            }
            if([object.winterHours isEqualToString:@"7:30 am - 9:00 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 21;
                self.closingMinutesWinter = 0;
            }
            if([object.winterHours isEqualToString:@"7:30 am - Dusk"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
            }
            if([object.winterHours isEqualToString:@"9:00 am - Dusk"]) {
                self.startingHourWinter = 9;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
            }
            if([object.winterHours isEqualToString:@"Closed"]) {
                self.startingHourWinter = 25;
                self.startingMinutesWinter = 99;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 99;
                [self checkOpeningFirst:self.startingHourWinter second:self.startingMinutesWinter third:self.closingHourWinter fourth:self.closingMinutesWinter];
                
                if(self.isWashroomOpen == true) {
                    
                    [self.storeOpenWashrooms addObject:object];
                    
                }
            }
            if([object.winterHours isEqualToString:@"Dawn - 11:00 pm"]) {
                self.startingHourWinter = 07;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 23;
                self.closingMinutesWinter = 0;
            }
            if([object.winterHours isEqualToString:@"Dawn to 10:15 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 22;
                self.closingMinutesWinter = 15;
            }
            if([object.winterHours isEqualToString:@"Dawn to 11:15 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 23;
                self.closingMinutesWinter = 15;
            }
            if([object.winterHours isEqualToString:@"Dawn to Dusk Weekends only"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 00;
            }
            if([object.winterHours isEqualToString:@"Hours of operation only"]) {
                self.startingHourWinter = 25;
                self.startingMinutesWinter = 99;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 99;
            }
            if([object.winterHours isEqualToString:@"Hours of the centre"]) {
                self.startingHourWinter = 25;
                self.startingMinutesWinter = 99;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 99;
                
            }
            if([object.winterHours isEqualToString:@"Men: 6am, Women: 8am to Midnight"]) {
                self.startingHourWinter = 8;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 23;
                self.closingMinutesWinter = 59;
                
            }
            if([object.winterHours isEqualToString:@"Mon - Fri 7:00 am - 3:30 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 15;
                self.closingMinutesWinter = 30;
                
            }
            if([object.winterHours isEqualToString:@"Tue - Sat 9:00 am - 5:00 pm"]) {
                self.startingHourWinter = 9;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 17;
                self.closingMinutesWinter = 0;
            }
            if([object.winterHours isEqualToString:@"Weekdays only 8:30 am - 5:00 pm"]) {
                self.startingHourWinter = 8;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 17;
                self.closingMinutesWinter = 0;
            }
            
            // NSLog(@"%ld", self.storeOpenWashrooms.count);
        }
        
        // March to September : Show Summer Hours
        else {
            if([object.summerHours isEqualToString:@"Dawn to Dusk"]) {
                NSLog(@"COM HERE");
            }
            
        }
        
        //
        //        NSMutableArray *storeSummerHours = [NSMutableArray array];
        //        NSMutableArray *storeWinterHours = [NSMutableArray array];
        //
        //        [storeSummerHours addObject:object.summerHours];
        //        [storeWinterHours addObject:object.winterHours];
        
        //add the pin to the map
        //        [self.masterMapView addAnnotation:pin];
        
    }
    
    
    //  NSDate *dummyData;
    //    PinInfo *info = (PinInfo *)view.annotation;
    //    if([info.pinWinterHours isEqualToString:@"Dawn To Dusk"]) {
    //
    //        NSLog(@"COME HERE???");
    //
    //    }
    
    
    //    return dummyData;
}


- (void)checkOpeningFirst:(double )startingHours second:(double )StartingMinutes third:(double )closingHours fourth:(double )closingMinutes{
    
    if((startingHours <= self.currentHours)  && (self.currentHours < closingHours)){
        
        if((startingHours == self.currentHours) || (self.currentHours == closingHours)) {
            
            if((StartingMinutes <= self.currentMinutes) && (self.currentMinutes < closingMinutes)) {
                
                self.isWashroomOpen = true;
                
                NSLog(@"SHOW Washroom ON");
            }
        }
        else {
            self.isWashroomOpen = true;
            
            NSLog(@"SHOW Washroom ON");
            
        }
    }
    else {
        self.isWashroomOpen = false;
    }
}

@end
