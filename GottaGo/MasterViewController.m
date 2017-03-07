//
//  MasterViewController.m
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-06.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Pin.h"
#import "PinInfo.h"

@interface MasterViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

- (IBAction)listViewButton:(id)sender;
- (IBAction)gottaGoButton:(id)sender;

//array of pins
@property NSMutableArray *pinArray;

//getting the user's current location
@property CLLocationManager *locationManager;


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
    
    
    NSString *stringURL2 = @"ftp://webftp.vancouver.ca/OpenData/csv/public_washrooms.csv";

    NSURL  *url2 = [NSURL URLWithString:stringURL2];
    NSData *urlData2 = [NSData dataWithContentsOfURL:url2];
    NSString *csvResponseString2 = [[NSString alloc] initWithData:urlData2   encoding:NSUTF8StringEncoding];
    
    NSArray *locations = [csvResponseString2 componentsSeparatedByString:@"\n"];
    
    NSMutableArray *storeAllArray = [NSMutableArray array];
    NSDictionary *dict = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < locations.count-1; i++) {
        NSString *location = [locations objectAtIndex:i];
        
        
        NSArray *components = [location componentsSeparatedByString:@","];
        
        NSString *pId =  components[0];
        NSString *pName = components[1];
        NSString *pAddress = components[2];
        NSString *pType = components[3];
        //NSString *pLocation = components[4];
        NSString *pSummerHours = components[components.count-7];
        NSString *pWinterHours = components[components.count-6];
        NSString *pWheelchair = components[components.count-5];
        //NSString *pNote = components[8];
        double latitude   = [components[components.count-3] doubleValue];
        double longitude  = [components[components.count-2] doubleValue];
       // NSString *pLatitude = components[components.count-3];
      //  NSString *pLongtitude = components[components.count-2];
        //NSString *pMaintainer = components[11];
        
        
        dict = @{@"PRIMARYIND": pId,
                 @"NAME": pName,
                 @"ADDRESS": pAddress,
                 @"TYPE": pType,
                 @"NAME": pName,
                 @"SUMMER_HOURS": pSummerHours,
                 @"WINTER_HOURS": pWinterHours,
                 @"WHEELCHAIR_ACCESS": pWheelchair,
                 @"LATITUDE": @(latitude),
                 @"LONGITUDE": @(longitude)
                 
                 };
        
        NSLog(@"%@", dict);
        
        Pin *objectPin = [[Pin alloc] initWithName:pName andWithAddress:pAddress andWithType:pType andWithSummerHours:pSummerHours andWithWinterHours:pWinterHours andWithWheelchairAccess:pWheelchair andWithLatitude:latitude andWithLongitude:longitude];
        [storeAllArray addObject:objectPin];

    }
    
//    NSLog(@"END");

    
//    //hard coded 3 example pins, will replace these with info from database
//    Pin *pin1 = [[Pin alloc] initWithName:@"Adanac Park" andWithAddress:@"1025 Boundary Road" andWithType:@"Washroom in Park" andWithLocation:@"East side, fieldhouse" andWithSummerHours:@"Dawn to Dusk" andWithWinterHours:@"Dawn to Dusk" andWithWheelchairAccess:@"No" andWithMaintainer:@"Parks" andWithLatitude:49.27588097 andWithLongitude:-123.024072];
//    Pin *pin2 = [[Pin alloc] initWithName:@"Andy Livingstone Park" andWithAddress:@"89 Expo Boulevard" andWithType:@"Washroom in Park" andWithLocation:@"South side, fieldhouse" andWithSummerHours:@"12:00 pm - 4:00 pm" andWithWinterHours:@"12:00 pm - 4:00 pm" andWithWheelchairAccess:@"No" andWithMaintainer:@"Parks" andWithLatitude:49.27782097 andWithLongitude:-123.103599];
//    Pin *pin3 = [[Pin alloc] initWithName:@"Balaclava Park" andWithAddress:@"4594 Balaclava Street" andWithType:@"Washroom in Park" andWithLocation:@"Central, field house" andWithSummerHours:@"Dawn to Dusk" andWithWinterHours:@"Dawn to Dusk" andWithWheelchairAccess:@"No" andWithMaintainer:@"Parks" andWithLatitude:49.24523399 andWithLongitude:-123.1754609];
//    
//    //add all pins to the array
//    _pinArray = [[NSMutableArray alloc] initWithArray:@[pin1, pin2, pin3]];
    self.pinArray = [[NSMutableArray alloc] initWithArray:storeAllArray];
    
}

-(void)viewDidAppear:(BOOL)animated {
    //need to show all the pins on the map from the database
    [self showPins];
}

- (IBAction)listViewButton:(id)sender {
    //segue to the table view
}

- (IBAction)gottaGoButton:(id)sender {
    //pops you out to external maps app to give you directions to closest washroom
}

-(void)showPins {
    
    //add all pins to the map
    for (Pin *object in self.pinArray) {
        CLLocationCoordinate2D lctn = CLLocationCoordinate2DMake(object.latitude, object.longitude);
        MKCoordinateSpan span = MKCoordinateSpanMake(0.5f, 0.5f);
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


