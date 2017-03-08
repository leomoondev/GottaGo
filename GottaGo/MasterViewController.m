//
//  MasterViewController.m
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-06.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "MasterViewController.h"


@interface MasterViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

- (IBAction)openToggleSwitch:(id)sender;

- (IBAction)gottaGoButton:(id)sender;
- (IBAction)listView:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *openSwitch;


//array of pins
@property NSMutableArray *pinArray;

//distance sorted array
@property NSArray *sortedArray;
@property NSArray *distanceArray;

//getting the user's current location
@property CLLocationManager *locationManager;

// Initialize instance of parser for CSV
@property CSVParser *parserCSV;

@property NSInteger currentMinutes;
@property NSInteger currentHours;
@property long startingHourWinter;
@property long startingMinutesWinter;
@property long startingHourSummer;
@property long startingMinutesSummer;
@property long closingHourWinter;
@property long closingMinutesWinter;
@property long closingHourSummer;
@property long closingMinutesSummer;

@property NSMutableArray *storeOpenWashrooms;

@property BOOL isWashroomOpen;
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
    
    self.pinArray = [[NSMutableArray alloc] initWithArray:[parserCSV parseDataFromCSV]];
    self.sortedArray = [[NSArray alloc] init];
    self.distanceArray = [[NSArray alloc] init];
    
    //set logo image
    SetNavigationTitleImage *setTitleImage = [[SetNavigationTitleImage alloc] init];
    [setTitleImage setImage:self.navigationController withNavItem:self.navigationItem];
    
    self.storeOpenWashrooms = [[NSMutableArray alloc] init];
}

-(void)viewDidAppear:(BOOL)animated {

    //need to show all the pins on the map from the database
    [self showPins:self.pinArray];
    [self convertOpeningHours];
    //[self openToggleSwitch:self];
}

- (IBAction)openToggleSwitch:(id)sender {
    if (self.openSwitch.on){
        [self.masterMapView removeAnnotations:self.masterMapView.annotations];
        NSLog(@"%lu", (unsigned long)self.storeOpenWashrooms.count);
        [self showPins:self.storeOpenWashrooms];
        
        //Remember Login Details
        NSLog(@"ON");
    }
    else{
        
        NSLog(@"%lu", (unsigned long)self.pinArray.count);
        [self showPins:self.pinArray];
        NSLog(@"OFF");
        //[self.masterMapView removeAnnotations:self.masterMapView.annotations];
        //[self showPins:self.storeOpenWashrooms];
        
        //[self hidePins];
        //Code something else
    }
}

- (IBAction)gottaGoButton:(id)sender {
    
    CLLocation *userLocation = self.masterMapView.userLocation.location;
    
    NSMutableDictionary *locationDic = [NSMutableDictionary dictionary];
    
    for (Pin *object in self.pinArray) {
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:object.latitude longitude:object.longitude];
        CLLocationDistance distance = [loc distanceFromLocation:userLocation];

        [locationDic setObject:loc forKey:@(distance)];
    }
    
    //put sorting in its own class and call to it in these two buttons
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
        
        distance = trunc(distance * 1) / 1;
        [washroomObjects setObject:object forKey:@(distance)];
    }
    
    NSArray *sortedKeys = [[washroomObjects allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSLog(@"%@", sortedKeys);
        
    NSArray *washrooms = [washroomObjects objectsForKeys:sortedKeys notFoundMarker:[NSNull null]];
    
    self.sortedArray = washrooms;
    self.distanceArray = sortedKeys; 
    
    [self performSegueWithIdentifier:@"showList" sender:sender];
    
}


////can we animate this on the map?
//-(void)showPins {
//    
//    //add all pins to the map
//    for (Pin *object in self.pinArray) {
//        CLLocationCoordinate2D lctn = CLLocationCoordinate2DMake(object.latitude, object.longitude);
//        MKCoordinateSpan span = MKCoordinateSpanMake(0.3f, 0.3f);
//        self.masterMapView.region = MKCoordinateRegionMake(lctn, span);
//        
//        PinInfo *pin = [[PinInfo alloc] init];
//        
//        //set values to the pin
//        [pin setCoordinate:lctn];
//        [pin setTitle:object.name];
//        [pin setSubtitle:object.address];
//        [pin setPinType:object.type];
//        [pin setPinLocation:object.location];
//        [pin setPinSummerHours:object.summerHours];
//        [pin setPinWinterHours:object.winterHours];
//        [pin setPinWheelchairAccess:object.wheelchairAccess];
//        [pin setPinMaintainer:object.maintainer];
//        
//        //add the pin to the map
//        [self.masterMapView addAnnotation:pin];
//    }
//}

-(void)showPins :(NSArray *) passedArray {
    //add all pins to the map
    //for (Pin *object in self.pinArray) {
    for (Pin *object in passedArray) {
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
        
        
        //[self convertOpeningHours];
        
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
    }
    
    if ([[segue identifier] isEqualToString:@"showList"]) {
        WashroomTableViewController *washroomTableVC = segue.destinationViewController;
        washroomTableVC.washrooms = self.sortedArray;
        washroomTableVC.distances = self.distanceArray; 
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

//- (NSDate *) convertOpeningHours {
- (void) convertOpeningHours {
    /*
     NSDate *today = [NSDate date];
     NSDateFormatter *weekdayFormatter = [[NSDateFormatter alloc] init] ;
     [weekdayFormatter setDateFormat: @"EEEE"];
     NSString *weekday = [weekdayFormatter stringFromDate: today];
     
     NSLog(@"%@", weekday);
     */
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSLog(@"newDateString %@", newDateString); //19:17:14
    
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dataComps = [gregorianCal components: (NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:now];
    
    NSLog(@"%@", dataComps);
    self.currentMinutes = [dataComps minute];
    self.currentHours = [dataComps hour];
    
    NSLog(@"%li", (long)self.currentMinutes);
    NSLog(@"%li", (long)self.currentHours);
    
    
    for (Pin *object in self.pinArray) {
        
        PinInfo *pin = [[PinInfo alloc] init];
        
        [pin setPinSummerHours:object.summerHours];
        [pin setPinWinterHours:object.winterHours];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth |NSCalendarUnitYear fromDate:[NSDate date]];
        //        NSInteger day = [components day];
        NSInteger month = [components month];
        //        NSInteger year = [components year];
        //        NSLog(@"%li",(long)day);
        //        NSLog(@"%li",(long)month);
        //        NSLog(@"%li",(long)year);
        
        // October to Februrary : Show Winter Hours
        if((10 <= month) || (month <= 3)) {
            // Show Winter Hours
            if ([object.winterHours isEqualToString:@"Dawn to Dusk"]) {
                
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                
                [self checkOpeningFirst:self.startingHourWinter second:self.startingMinutesWinter third:self.closingHourWinter fourth:self.closingMinutesWinter];
                if(self.isWashroomOpen == true) {
                    
                    [self.storeOpenWashrooms addObject:object];
                }
            }
            if([object.winterHours isEqualToString:@"24 hrs"]) {
                self.startingHourWinter = 0;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 61;
                
                [self checkOpeningFirst:self.startingHourWinter second:self.startingMinutesWinter third:self.closingHourWinter fourth:self.closingMinutesWinter];
                
                if(self.isWashroomOpen == true) {
                    
                    [self.storeOpenWashrooms addObject:object];
                    
                }
                
            }
            if([object.winterHours isEqualToString:@"10:00 am - Dusk"]) {
                self.startingHourWinter = 10;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
                
            }
            if([object.winterHours isEqualToString:@"12:00 pm - 4:00 pm"]) {
                self.startingHourWinter = 12;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 16;
                self.closingMinutesWinter = 0;
            }
            
            if([object.winterHours isEqualToString:@"5:30 am - Dusk"]) {
                self.startingHourWinter = 5;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
            }
            if([object.winterHours isEqualToString:@"6:00 am - 8:30 pm"]) {
                self.startingHourWinter = 6;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 20;
                self.closingMinutesWinter = 30;
            }
            if([object.winterHours isEqualToString:@"7:00 am - Dusk"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
            }
            if([object.winterHours isEqualToString:@"7:30 am - 9:00 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 21;
                self.closingMinutesWinter = 0;
            }
            if([object.winterHours isEqualToString:@"7:30 am - Dusk"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
            }
            if([object.winterHours isEqualToString:@"9:00 am - Dusk"]) {
                self.startingHourWinter = 9;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 0;
            }
            if([object.winterHours isEqualToString:@"Closed"]) {
                self.startingHourWinter = 25;
                self.startingMinutesWinter = 99;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 99;
                [self checkOpeningFirst:self.startingHourWinter second:self.startingMinutesWinter third:self.closingHourWinter fourth:self.closingMinutesWinter];
                
                if(self.isWashroomOpen == true) {
                    
                    [self.storeOpenWashrooms addObject:object];
                    
                }
            }
            if([object.winterHours isEqualToString:@"Dawn - 11:00 pm"]) {
                self.startingHourWinter = 07;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 23;
                self.closingMinutesWinter = 0;
            }
            if([object.winterHours isEqualToString:@"Dawn to 10:15 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 22;
                self.closingMinutesWinter = 15;
            }
            if([object.winterHours isEqualToString:@"Dawn to 11:15 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 23;
                self.closingMinutesWinter = 15;
            }
            if([object.winterHours isEqualToString:@"Dawn to Dusk Weekends only"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 19;
                self.closingMinutesWinter = 00;
            }
            if([object.winterHours isEqualToString:@"Hours of operation only"]) {
                self.startingHourWinter = 25;
                self.startingMinutesWinter = 99;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 99;
            }
            if([object.winterHours isEqualToString:@"Hours of the centre"]) {
                self.startingHourWinter = 25;
                self.startingMinutesWinter = 99;
                
                self.closingHourWinter = 25;
                self.closingMinutesWinter = 99;
                
            }
            if([object.winterHours isEqualToString:@"Men: 6am, Women: 8am to Midnight"]) {
                self.startingHourWinter = 8;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 23;
                self.closingMinutesWinter = 59;
                
            }
            if([object.winterHours isEqualToString:@"Mon - Fri 7:00 am - 3:30 pm"]) {
                self.startingHourWinter = 7;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 15;
                self.closingMinutesWinter = 30;
                
            }
            if([object.winterHours isEqualToString:@"Tue - Sat 9:00 am - 5:00 pm"]) {
                self.startingHourWinter = 9;
                self.startingMinutesWinter = 0;
                
                self.closingHourWinter = 17;
                self.closingMinutesWinter = 0;
            }
            if([object.winterHours isEqualToString:@"Weekdays only 8:30 am - 5:00 pm"]) {
                self.startingHourWinter = 8;
                self.startingMinutesWinter = 30;
                
                self.closingHourWinter = 17;
                self.closingMinutesWinter = 0;
            }
            
            // NSLog(@"%ld", self.storeOpenWashrooms.count);
        }
        
        // March to September : Show Summer Hours
        else {
            if([object.summerHours isEqualToString:@"Dawn to Dusk"]) {
                NSLog(@"COM HERE");
            }
            
        }
        
        //
        //        NSMutableArray *storeSummerHours = [NSMutableArray array];
        //        NSMutableArray *storeWinterHours = [NSMutableArray array];
        //
        //        [storeSummerHours addObject:object.summerHours];
        //        [storeWinterHours addObject:object.winterHours];
        
        //add the pin to the map
        //        [self.masterMapView addAnnotation:pin];
        
    }
    
    
    //  NSDate *dummyData;
    //    PinInfo *info = (PinInfo *)view.annotation;
    //    if([info.pinWinterHours isEqualToString:@"Dawn To Dusk"]) {
    //
    //        NSLog(@"COME HERE???");
    //
    //    }
    
    
    //    return dummyData;
}



- (void)checkOpeningFirst:(double )startingHours second:(double )StartingMinutes third:(double )closingHours fourth:(double )closingMinutes{
    
    if((startingHours <= self.currentHours)  && (self.currentHours < closingHours)){
        
        if((startingHours == self.currentHours) || (self.currentHours == closingHours)) {
            
            if((StartingMinutes <= self.currentMinutes) && (self.currentMinutes < closingMinutes)) {
                
                self.isWashroomOpen = true;
                
                NSLog(@"SHOW Washroom ON");
            }
        }
        else {
            self.isWashroomOpen = true;
            
            NSLog(@"SHOW Washroom ON");
            
        }
    }
    else {
        self.isWashroomOpen = false;
    }
}




//- (BOOL) checkOpenStatus {
//
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
//    NSInteger day = [components day];
//    NSInteger month = [components month];
//    NSInteger year = [components year];
//    NSLog(@"%li",(long)day);
//    NSLog(@"%li",(long)month);
//    NSLog(@"%li",(long)year);
//
//
//    // October to Februrary : Show Winter Hours
//    if((10 <= month) && (month <= 2)) {
//        // Show Winter Hours
//    }
//
//    // March to September : Show Summer Hours
//    else {
//
//
//    }
//}



//    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
//    NSLog(@"SHOW ME THIS: %lu",(unsigned long)NSCalendarUnitMonth);
//
//    if(
//    NSLog
//    NSDate * now = [NSDate date];
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    [outputFormatter setDateFormat:@"HH:mm:ss"];
//    NSString *newDateString = [outputFormatter stringFromDate:now];
//    NSLog(@"newDateString %@", newDateString);
//
//
//    if(current date is winter)
//        use winter hours
//        
//        if(current time is )
//            return true;
//        else
//            return false;
//    
//    else
//        use summer hours
//        if(current time is )



@end
