//
//  DetailViewController.h
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-06.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *detailMapView;

//create the properties that are gonna be passed
@property NSString *nameOfWashroom;
@property NSString *addressOfWashroom;
@property NSString *typeOfWashroom;
@property NSString *locationOfWashroom; 
@property NSString *summerHoursOfWashroom;
@property NSString *winterHoursOfWashroom;
@property NSString *wheelchairAccessOfWashroom;
@property NSString *maintainerOfWashroom;

@property CLLocationCoordinate2D locationOfPin;


@end
