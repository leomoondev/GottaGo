//
//  DetailViewController.m
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-06.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "DetailViewController.h"
#import "RateWashroomViewController.h"
#import "GottaGo-Swift.h"

@class SetNavigationTitleImage;

@interface DetailViewController () <MKMapViewDelegate, CLLocationManagerDelegate> {
    
        MKPolyline *_routeOverlay;
        MKRoute *_currentRoute;
}

//all the labels on the detailed view
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *summerHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *winterHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *wheelchairAccessLabel;
@property (weak, nonatomic) IBOutlet UILabel *maintainerLabel;
- (IBAction)goButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *goButtonOutlet;
- (IBAction)rateWashroomButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *thumbRatingLabel;

@property CLLocationManager *locationManager;

@property (nonatomic, retain) MKPolylineView *routeLineView;

@property NSMutableArray* locations;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.detailMapView.delegate = self;

    //request location services from user
    [self.locationManager requestWhenInUseAuthorization];
    SetNavigationTitleImage *setTitleImage = [[SetNavigationTitleImage alloc] init];
    [setTitleImage setImage:self.navigationController withNavItem:self.navigationItem];
    
    //round the corner of the go button
    self.goButtonOutlet.layer.cornerRadius = 10;
    self.goButtonOutlet.clipsToBounds = YES;
    
    //show thumb rating for washroom
    self.thumbRatingLabel.hidden = YES;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self configure];
    [self showPin];
    if (self.washroomThumbPassed == nil) {
        self.thumbRatingLabel.hidden = YES;
    } else {
        self.thumbRatingLabel.hidden = NO;
        self.thumbRatingLabel.text = [NSString stringWithFormat:@"%@", self.washroomThumbPassed];
    }

}

-(void)configure {

    //set the label text to the passed properties, may need to add more text (stringWithFormat)
    self.nameLabel.text = self.nameOfWashroom;
    
    if ([self.addressOfWashroom isEqualToString:@"\"\""] || [self.addressOfWashroom isEqualToString:@" "]) {
        self.addressLabel.hidden = YES;
    } else {
        self.addressLabel.text = [NSString stringWithFormat:@"Address: %@", self.addressOfWashroom];
    }
    self.typeLabel.text = self.typeOfWashroom;
    self.locationLabel.text = [NSString stringWithFormat:@"Located: %@", self.locationOfWashroom];
    self.summerHoursLabel.text = [NSString stringWithFormat:@"Summer Hours: %@", self.summerHoursOfWashroom];
    self.winterHoursLabel.text = [NSString stringWithFormat:@"Winter Hours: %@", self.winterHoursOfWashroom];
    self.wheelchairAccessLabel.text = [NSString stringWithFormat:@"Wheelchair Access: %@", self.wheelchairAccessOfWashroom];
    self.maintainerLabel.text = [[NSString stringWithFormat:@"Maintained By: %@", self.maintainerOfWashroom] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
}

-(void)showPin {
    
    //show the passed pin on the map view
    CLLocationCoordinate2D lctn = self.locationOfPin;
    
    //zoom in on it
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01f, 0.01f);
    self.detailMapView.region = MKCoordinateRegionMake(lctn, span);
    
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    [pin setCoordinate:lctn];
    
    [pin setTitle:self.nameOfWashroom];
    [pin setSubtitle:self.addressOfWashroom];
    [self.detailMapView addAnnotation:pin];
}

- (IBAction)goButton:(id)sender {
    //this will open an external map application and map you to this pin
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.locationOfPin addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:self.nameOfWashroom];
    [mapItem openInMapsWithLaunchOptions:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"rateWashroom"]) {
    RateWashroomViewController *rateWashroomVC = segue.destinationViewController;
    rateWashroomVC.washroomToBeRated = self.nameOfWashroom;
    }
}

- (IBAction)rateWashroomButton:(id)sender {
    [self performSegueWithIdentifier:@"rateWashroom" sender:sender];
}

@end
