//
//  ShowOpenWashrooms.h
//  GottaGo
//
//  Created by Hyung Jip Moon on 2017-03-08.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pin.h"
#import "PinInfo.h"

@interface ShowOpenWashrooms : NSObject

- (void) convertOpeningHours;

@property NSInteger currentMinutes;
@property NSInteger currentHours;
@property long startingHourWinter;
@property long startingMinutesWinter;
@property long startingHourSummer;
@property long startingMinutesSummer;
@property long closingHourWinter;
@property long closingMinutesWinter;
@property long closingHourSummer;
@property long closingMinutesSummer;

@property BOOL isWashroomOpen;

@property NSMutableArray *storeOpenWashrooms;

//array of pins
@property NSMutableArray *pinArray;

@end
