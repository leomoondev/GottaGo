//
//  Pin.h
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-06.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pin : NSObject

//should change the name to washroom

@property NSString *name;
@property NSString *address;
@property NSString *type;
@property NSString *location;
@property NSString *summerHours;
@property NSString *winterHours;
@property NSString *wheelchairAccess;
@property NSString *maintainer;
@property double latitude;
@property double longitude;

//-(instancetype)initWithName:(NSString *)name andWithAddress:(NSString *)address andWithType:(NSString *)type andWithLocation:(NSString *)location andWithSummerHours:(NSString *)summerHours andWithWinterHours:(NSString *)winterHours andWithWheelchairAccess:(NSString *)wheelchairAccess andWithMaintainer:(NSString *)maintainer andWithLatitude:(double)latitude andWithLongitude:(double)longitude;
-(instancetype)initWithName:(NSString *)name andWithAddress:(NSString *)address andWithType:(NSString *)type andWithSummerHours:(NSString *)summerHours andWithWinterHours:(NSString *)winterHours andWithWheelchairAccess:(NSString *)wheelchairAccess andWithLatitude:(double)latitude andWithLongitude:(double)longitude;

@end
