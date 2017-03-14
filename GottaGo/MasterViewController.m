//
//  MasterViewController.m
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-06.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "MasterViewController.h"
#import "GottaGo-Swift.h"

@class SetNavigationTitleImage;

@interface MasterViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

- (IBAction)openToggleSwitch:(id)sender;

- (IBAction)gottaGoButton:(id)sender;
- (IBAction)listView:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *openSwitch;

//distance sorted array
@property (copy, nonatomic) NSArray *sortedArray;
@property (copy, nonatomic) NSArray *distanceArray;

//getting the user's current location
@property CLLocationManager *locationManager;

// Initialize instance of parser for CSV
@property CSVParser *parserCSV;

@property ShowOpenWashrooms *showOpenWashrooms;
- (IBAction)mapTypeSegmentedControl:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentControlOutlet;

@property (nonatomic, assign) BOOL completedAnimation;

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
    //[self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    self.masterMapView.showsUserLocation = YES;
    
    // Create an instance of CSVParser
    CSVParser *parserCSV = [[CSVParser alloc] init];
    
    self.showOpenWashrooms = [[ShowOpenWashrooms alloc] init];
    self.showOpenWashrooms.pinArray = [[NSMutableArray alloc] initWithArray:[parserCSV parseDataFromCSV]];
    self.sortedArray = [[NSArray alloc] init];
    self.distanceArray = [[NSArray alloc] init];
    
    //set logo image
    SetNavigationTitleImage *setTitleImage = [[SetNavigationTitleImage alloc] init];
    [setTitleImage setImage:self.navigationController withNavItem:self.navigationItem];
    
    self.showOpenWashrooms.storeOpenWashrooms = [[NSMutableArray alloc] init];
    [self showPins:self.showOpenWashrooms.pinArray];
    
    _sortByDistance = [[SortByDistance alloc] init];
    
    //set border color and width
    self.masterMapView.layer.borderColor = [[UIColor grayColor]CGColor];
    self.masterMapView.layer.borderWidth = 2.0;
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.completedAnimation = NO;
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    //need to show all the pins on the map from the database
    [self openToggleSwitch:self];
    [self.showOpenWashrooms convertOpeningHours];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.masterMapView removeAnnotations:self.masterMapView.annotations];
    
}

//set the initial zoom of the map view to zoom into the user's current location
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.05;
    mapRegion.span.longitudeDelta = 0.05;
    
    self.masterMapView.zoomEnabled = true;
    self.masterMapView.scrollEnabled = true;
    self.masterMapView.userInteractionEnabled = true;
    
    [mapView setRegion:mapRegion animated: YES];
}


- (IBAction)openToggleSwitch:(id)sender {
    if (self.openSwitch.on){
        [self.masterMapView removeAnnotations:self.masterMapView.annotations];
        [self showPinsWhenSwitchOnOff:self.showOpenWashrooms.storeOpenWashrooms];
    }
    else{
        [self showPinsWhenSwitchOnOff:self.showOpenWashrooms.pinArray];
    }
}

- (IBAction)gottaGoButton:(id)sender {

    //return the distance sorted array
    NSDictionary *washroomsSortedByDistance = [self.sortByDistance sortDistanceWith:self.masterMapView withWashroomArray:self.showOpenWashrooms.storeOpenWashrooms];
    
    NSArray *sortedKeys = [[washroomsSortedByDistance allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSArray *sortedWashrooms = [washroomsSortedByDistance objectsForKeys:sortedKeys notFoundMarker:[NSNull null]];
    
    //create a new pin object
    Pin *closestPin = [[Pin alloc] init];
    
    //set this pin equal to the first object in the distance array
    closestPin = sortedWashrooms.firstObject;
    //this is a pin object, need to create a location out of this pin object
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(closestPin.latitude, closestPin.longitude);
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:closestPin.name];
    [mapItem openInMapsWithLaunchOptions:nil];
}

- (IBAction)listView:(id)sender {
    
    NSDictionary *washroomsSortedByDistance = [self.sortByDistance sortDistanceWith:self.masterMapView withWashroomArray:self.showOpenWashrooms.pinArray];
    
    NSArray *sortedKeys = [[washroomsSortedByDistance allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSArray *sortedWashrooms = [washroomsSortedByDistance objectsForKeys:sortedKeys notFoundMarker:[NSNull null]];

    self.sortedArray = sortedWashrooms;
    self.distanceArray = sortedKeys;
    
    [self performSegueWithIdentifier:@"showList" sender:sender];
    
}

-(void)showPins :(NSArray *)passedArray {
    //add all pins to the map
    for (Pin *object in passedArray) {
        CLLocationCoordinate2D lctn = CLLocationCoordinate2DMake(object.latitude, object.longitude);
        
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
                
    }
}

-(void)showPinsWhenSwitchOnOff :(NSArray *)passedArray {
    //add all pins to the map
    for (Pin *object in passedArray) {
        CLLocationCoordinate2D lctn = CLLocationCoordinate2DMake(object.latitude, object.longitude);
        
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
        
        detailVC.detailedMapType = self.masterMapView.mapType;
    }
    
    if ([[segue identifier] isEqualToString:@"showList"]) {
        WashroomTableViewController *washroomTableVC = segue.destinationViewController;
        washroomTableVC.washrooms = self.sortedArray;
        washroomTableVC.distances = self.distanceArray;
        }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationViewReuseIdentifier"];
            
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    annotationView.image = [UIImage imageNamed:@"PinImage"];
    
    UIButton *moreWashroomInformation = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = moreWashroomInformation;
    
    //sets the user location to a blue ball instead of a pin
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    return annotationView;
}

- (IBAction)mapTypeSegmentedControl:(id)sender {
    
    if (self.mapTypeSegmentControlOutlet.selectedSegmentIndex == 0) {
        self.masterMapView.mapType = MKMapTypeStandard;
    }
    if (self.mapTypeSegmentControlOutlet.selectedSegmentIndex == 1) {
        self.masterMapView.mapType = MKMapTypeSatellite;

    }
    if (self.mapTypeSegmentControlOutlet.selectedSegmentIndex == 2) {
        self.masterMapView.mapType = MKMapTypeHybrid;

    }
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    if(self.completedAnimation == NO)
    {
        for (aV in views) {
            CGRect endFrame = aV.frame;
            
            aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 230.0, aV.frame.size.width, aV.frame.size.height);
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.45];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [aV setFrame:endFrame];
            [UIView commitAnimations];
        }
    }
    self.completedAnimation = YES;
}

@end
