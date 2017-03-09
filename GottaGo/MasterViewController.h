//
//  MasterViewController.h
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-06.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "CSVParser.h"
#import "DetailViewController.h"
#import "Pin.h"
#import "PinInfo.h"
#import "WashroomTableViewController.h"
#import "SetNavigationTitleImage.h"
#import "ShowOpenWashrooms.h"

@interface MasterViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *masterMapView;

//@property SetNavigationTitleImage *setTitleImage;


@property (assign, nonatomic) NSUInteger zoomLevel;

@end
