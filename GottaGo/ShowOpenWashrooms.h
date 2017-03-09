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

@property (nonatomic) NSInteger currentMinutes;
@property (nonatomic) NSInteger currentHours;

@property (nonatomic, assign) long startingHourWinter;
@property (nonatomic, assign) long startingMinutesWinter;
@property (nonatomic, assign) long startingHourSummer;
@property (nonatomic, assign) long startingMinutesSummer;
@property (nonatomic, assign) long closingHourWinter;
@property (nonatomic, assign) long closingMinutesWinter;
@property (nonatomic, assign) long closingHourSummer;
@property (nonatomic, assign) long closingMinutesSummer;

@property (assign) BOOL isWashroomOpen;

@property (nonatomic) NSMutableArray *storeOpenWashrooms;
@property (nonatomic) NSMutableArray *pinArray;

- (void) convertOpeningHours;


@end
