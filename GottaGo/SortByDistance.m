//
//  SortByDistance.m
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-09.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "SortByDistance.h"

@implementation SortByDistance

-(NSDictionary *)sortDistanceWith:(MKMapView *)mapView withWashroomArray:(NSMutableArray *)washroomArray {
    
    CLLocation *userLocation = mapView.userLocation.location;
    NSMutableDictionary *sortedDictionary = [NSMutableDictionary dictionary];
    
    for (Pin *object in washroomArray) {
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:object.latitude longitude:object.longitude];
        CLLocationDistance distance = [loc distanceFromLocation:userLocation];
        
        distance = trunc(distance * 1) / 1;
        [sortedDictionary setObject:object forKey:@(distance)];
    }
   
    return sortedDictionary;
    
}

@end
