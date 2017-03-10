//
//  PinInfo.h
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-06.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKFoundation.h>
#import <MapKit/MKAnnotation.h>

@interface PinInfo : NSObject <MKAnnotation>

@property (nonatomic, strong, nullable) id <MKAnnotation> pinAnnotation;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@property (nonatomic, copy, nullable) NSString *pinType;
@property (nonatomic, copy, nullable) NSString *pinLocation;
@property (nonatomic, copy, nullable) NSString *pinSummerHours;
@property (nonatomic, copy, nullable) NSString *pinWinterHours;
@property (nonatomic, copy, nullable) NSString *pinWheelchairAccess;
@property (nonatomic, copy, nullable) NSString *pinMaintainer;

@end
