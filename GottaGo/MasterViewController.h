//
//  MasterViewController.h
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-06.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "CSVParser.h"
#import "DetailViewController.h"
#import "Pin.h"
#import "PinInfo.h"
#import "WashroomTableViewController.h"
#import "ShowOpenWashrooms.h"
#import "SortByDistance.h"

@interface MasterViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *masterMapView;

@property (assign, nonatomic) NSUInteger zoomLevel;

@property SortByDistance *sortByDistance; 

@end
