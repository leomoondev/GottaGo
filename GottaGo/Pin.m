//
//  Pin.m
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-06.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "Pin.h"

@implementation Pin

-(instancetype)initWithName:(NSString *)name andWithAddress:(NSString *)address andWithType:(NSString *)type andWithLocation:(NSString *)location andWithSummerHours:(NSString *)summerHours andWithWinterHours:(NSString *)winterHours andWithWheelchairAccess:(NSString *)wheelchairAccess andWithMaintainer:(NSString *)maintainer andWithLatitude:(double)latitude andWithLongitude:(double)longitude {

    if (self = [super init]) {
        _name = name;
        _address = address;
        _type = type;
        _location = location;
        _wheelchairAccess = wheelchairAccess;
        _maintainer = maintainer;
        _latitude = latitude;
        _longitude = longitude;
        _summerHours = summerHours;
        _winterHours = winterHours;
    }
    return self;
}

@end
