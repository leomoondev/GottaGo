//
//  ShowOpenWashrooms.m
//  GottaGo
//
//  Created by Hyung Jip Moon on 2017-03-08.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "ShowOpenWashrooms.h"

@interface ShowOpenWashrooms ()

@property Pin *object;

@end

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
    
    
    for (_object in self.pinArray) {
        
        PinInfo *pin = [[PinInfo alloc] init];
        
        [pin setPinSummerHours:self.object.summerHours];
        [pin setPinWinterHours:self.object.winterHours];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth |NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger month = [components month];

        
        // October to Februrary : Show Winter Hours
        if((10 <= month) || (month <= 3)) {
            // Show Winter Hours
            if ([self.object.winterHours isEqualToString:@"Dawn to Dusk"]) {
                
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"24 hrs"]) {
                self.startingHourWinter = 0;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 61;
                
                [self addOpenWashroomsToArray];
            }
            if([self.object.winterHours isEqualToString:@"10:00 am - Dusk"]) {
                self.startingHourWinter = 10;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"12:00 pm - 4:00 pm"]) {
                self.startingHourWinter = 12;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 16;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];

            }
            
            if([self.object.winterHours isEqualToString:@"5:30 am - Dusk"]) {
                self.startingHourWinter = 5;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"6:00 am - 8:30 pm"]) {
                self.startingHourWinter = 6;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 20;
                self.closingMinutesWinter = 30;
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"7:00 am - Dusk"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"7:30 am - 9:00 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 21;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"7:30 am - Dusk"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"9:00 am - Dusk"]) {
                self.startingHourWinter = 9;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"Closed"]) {
                self.startingHourWinter = 25;
                self.startingMinutesWinter = 99;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 99;
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"Dawn - 11:00 pm"]) {
                self.startingHourWinter = 07;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 23;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"Dawn to 10:15 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 22;
                self.closingMinutesWinter = 15;
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"Dawn to 11:15 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 23;
                self.closingMinutesWinter = 15;
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"Dawn to Dusk Weekends only"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 00;
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"Hours of operation only"]) {
                self.startingHourWinter = 25;
                self.startingMinutesWinter = 99;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 99;
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"Hours of the centre"]) {
                self.startingHourWinter = 25;
                self.startingMinutesWinter = 99;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 99;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours containsString:@"Men"]) {
                self.startingHourWinter = 8;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 23;
                self.closingMinutesWinter = 59;
                [self addOpenWashroomsToArray];

                
            }
            if([self.object.winterHours isEqualToString:@"Mon - Fri 7:00 am - 3:30 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 15;
                self.closingMinutesWinter = 30;
                [self addOpenWashroomsToArray];

                
            }
            if([self.object.winterHours isEqualToString:@"Tue - Sat 9:00 am - 5:00 pm"]) {
                self.startingHourWinter = 9;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 17;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];

            }
            if([self.object.winterHours isEqualToString:@"Weekdays only 8:30 am - 5:00 pm"]) {
                self.startingHourWinter = 8;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 17;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];

            }
        }
        
        // March to September : Show Summer Hours
        else {
            if ([self.object.winterHours isEqualToString:@"Dawn to Dusk"]) {
                
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"24 hrs"]) {
                self.startingHourWinter = 0;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 61;
                
                [self addOpenWashroomsToArray];
            }
            if([self.object.winterHours isEqualToString:@"10:00 am - Dusk"]) {
                self.startingHourWinter = 10;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"12:00 pm - 4:00 pm"]) {
                self.startingHourWinter = 12;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 16;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];
                
            }
            
            if([self.object.winterHours isEqualToString:@"5:30 am - Dusk"]) {
                self.startingHourWinter = 5;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"6:00 am - 8:30 pm"]) {
                self.startingHourWinter = 6;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 20;
                self.closingMinutesWinter = 30;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"7:00 am - Dusk"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"7:30 am - 9:00 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 21;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"7:30 am - Dusk"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"9:00 am - Dusk"]) {
                self.startingHourWinter = 9;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"Closed"]) {
                self.startingHourWinter = 25;
                self.startingMinutesWinter = 99;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 99;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"Dawn - 11:00 pm"]) {
                self.startingHourWinter = 07;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 23;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"Dawn to 10:15 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 22;
                self.closingMinutesWinter = 15;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"Dawn to 11:15 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 23;
                self.closingMinutesWinter = 15;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"Dawn to Dusk Weekends only"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 00;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"Hours of operation only"]) {
                self.startingHourWinter = 25;
                self.startingMinutesWinter = 99;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 99;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"Hours of the centre"]) {
                self.startingHourWinter = 25;
                self.startingMinutesWinter = 99;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 99;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours containsString:@"Men"]) {
                self.startingHourWinter = 8;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 23;
                self.closingMinutesWinter = 59;
                [self addOpenWashroomsToArray];
                
                
            }
            if([self.object.winterHours isEqualToString:@"Mon - Fri 7:00 am - 3:30 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 15;
                self.closingMinutesWinter = 30;
                [self addOpenWashroomsToArray];
                
                
            }
            if([self.object.winterHours isEqualToString:@"Tue - Sat 9:00 am - 8:00 pm"]) {
                self.startingHourWinter = 9;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 20;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];
                
            }
            if([self.object.winterHours isEqualToString:@"Weekdays only 8:30 am - 5:00 pm"]) {
                self.startingHourWinter = 8;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 17;
                self.closingMinutesWinter = 0;
                [self addOpenWashroomsToArray];
                
            }
        }
    }
}

- (void)checkOpeningFirst:(double )startingHours second:(double )StartingMinutes third:(double )closingHours fourth:(double )closingMinutes{
    
    if((startingHours <= self.currentHours)  && (self.currentHours < closingHours)){
        
        if((startingHours == self.currentHours) || (self.currentHours == closingHours)) {
            
            if(StartingMinutes <= self.currentMinutes) {
                
                self.isWashroomOpen = true;
            }
        }
        else {
            self.isWashroomOpen = true;
        }
    }
    else {
        self.isWashroomOpen = false;
    }
}

- (void) addOpenWashroomsToArray {
    [self checkOpeningFirst:self.startingHourWinter second:self.startingMinutesWinter third:self.closingHourWinter fourth:self.closingMinutesWinter];
    if(self.isWashroomOpen == true) {
        
        [self.storeOpenWashrooms addObject:self.object];
    }
}
@end
