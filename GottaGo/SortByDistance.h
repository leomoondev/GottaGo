//
//  SortByDistance.h
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-09.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Pin.h"

@interface SortByDistance : NSObject

-(NSDictionary *)sortDistanceWith:(MKMapView *)mapView withWashroomArray:(NSMutableArray *)washroomArray;

@end
