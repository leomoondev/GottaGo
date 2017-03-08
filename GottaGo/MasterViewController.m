//
//  MasterViewController.m
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-06.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

- (IBAction)gottaGoButton:(id)sender;
- (IBAction)listView:(id)sender;

//array of pins
@property NSMutableArray *pinArray;

//distance sorted array
@property NSArray *sortedArray;
@property NSArray *distanceArray;

//getting the user's current location
@property CLLocationManager *locationManager;

// Initialize instance of parser for CSV
@property CSVParser *parserCSV;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //user location
    self.masterMapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //request location services from user
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    self.masterMapView.showsUserLocation = YES;
    
    // Create an instance of CSVParser
    CSVParser *parserCSV = [[CSVParser alloc] init];
    
    self.pinArray = [[NSMutableArray alloc] initWithArray:[parserCSV parseDataFromCSV]];
    self.sortedArray = [[NSArray alloc] init];
    self.distanceArray = [[NSArray alloc] init];
    
}

-(void)viewDidAppear:(BOOL)animated {
    //need to show all the pins on the map from the database
    [self showPins];
}

- (IBAction)gottaGoButton:(id)sender {
    
    CLLocation *userLocation = self.masterMapView.userLocation.location;
    
    NSMutableDictionary *locationDic = [NSMutableDictionary dictionary];
    
    for (Pin *object in self.pinArray) {
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:object.latitude longitude:object.longitude];
        CLLocationDistance distance = [loc distanceFromLocation:userLocation];

        [locationDic setObject:loc forKey:@(distance)];
    }
    
    NSArray *sorting = [[locationDic allKeys] sortedArrayUsingSelector:@selector(compare:)];

    NSArray *closest = [sorting subarrayWithRange:NSMakeRange(0, MIN(1, sorting.count))];

    NSArray *closestLocation = [locationDic objectsForKeys:closest notFoundMarker:[NSNull null]];

    NSLog(@"%@", closestLocation.firstObject);
    
    CLLocation *closestOne = closestLocation.firstObject;
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:closestOne.coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:@"Closest Washroom"];
    [mapItem openInMapsWithLaunchOptions:nil];
}

- (IBAction)listView:(id)sender {
    
    CLLocation *userLocation = self.masterMapView.userLocation.location;
    
    NSMutableDictionary *washroomObjects = [NSMutableDictionary dictionary];
    
    for (Pin *object in self.pinArray) {
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:object.latitude longitude:object.longitude];
        CLLocationDistance distance = [loc distanceFromLocation:userLocation];
        
        [washroomObjects setObject:object forKey:@(distance)];
    }
    
    NSArray *sortedKeys = [[washroomObjects allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSLog(@"%@", sortedKeys);
        
    NSArray *washrooms = [washroomObjects objectsForKeys:sortedKeys notFoundMarker:[NSNull null]];
    
    self.sortedArray = washrooms;
    self.distanceArray = sortedKeys; 
    
    [self performSegueWithIdentifier:@"showList" sender:sender];
    
}

-(void)showPins {
    
    //add all pins to the map
    for (Pin *object in self.pinArray) {
        CLLocationCoordinate2D lctn = CLLocationCoordinate2DMake(object.latitude, object.longitude);
        MKCoordinateSpan span = MKCoordinateSpanMake(0.3f, 0.3f);
        self.masterMapView.region = MKCoordinateRegionMake(lctn, span);
        
        PinInfo *pin = [[PinInfo alloc] init];
        
        //set values to the pin
        [pin setCoordinate:lctn];
        [pin setTitle:object.name];
        [pin setSubtitle:object.address];
        [pin setPinType:object.type];
        [pin setPinLocation:object.location];
        [pin setPinSummerHours:object.summerHours];
        [pin setPinWinterHours:object.winterHours];
        [pin setPinWheelchairAccess:object.wheelchairAccess];
        [pin setPinMaintainer:object.maintainer];
        
        //add the pin to the map
        [self.masterMapView addAnnotation:pin];

    }
    
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    PinInfo *info = (PinInfo *)view.annotation;
    
    NSLog(@"%@", info.title);
    NSLog(@"%@", info.subtitle);
    NSLog(@"%@", info.pinType);
    NSLog(@"%@", info.pinLocation);
    NSLog(@"%@", info.pinSummerHours);
    NSLog(@"%@", info.pinWinterHours);
    NSLog(@"%@", info.pinWheelchairAccess);
    NSLog(@"%@", info.pinMaintainer);
    
    [self performSegueWithIdentifier:@"showDetail" sender:info];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        PinInfo * info = (PinInfo *)sender;
        DetailViewController *detailVC = segue.destinationViewController;
        
        //pass on the values of the selected pin to the detail view controller
        detailVC.nameOfWashroom = info.title;
        detailVC.addressOfWashroom = info.subtitle;
        detailVC.typeOfWashroom = info.pinType;
        detailVC.locationOfWashroom = info.pinLocation;
        detailVC.summerHoursOfWashroom = info.pinSummerHours;
        detailVC.winterHoursOfWashroom = info.pinWinterHours;
        detailVC.wheelchairAccessOfWashroom = info.pinWheelchairAccess;
        detailVC.maintainerOfWashroom = info.pinMaintainer;
        detailVC.locationOfPin = info.coordinate;
    }
    
    if ([[segue identifier] isEqualToString:@"showList"]) {
        WashroomTableViewController *washroomTableVC = segue.destinationViewController;
        washroomTableVC.washrooms = self.sortedArray;
        washroomTableVC.distances = self.distanceArray; 
        
        //do I pass on the array of pins?
        }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationViewReuseIdentifier"];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationViewReuseIdentifier"];
    }
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    UIButton *moreWashroomInformation = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = moreWashroomInformation;
    
    //sets the user location to a blue ball instead of a pin
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    return annotationView;
}

@end


