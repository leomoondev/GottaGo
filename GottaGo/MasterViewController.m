//
//  MasterViewController.m
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-06.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController () <MKMapViewDelegate>

- (IBAction)listViewButton:(id)sender;
- (IBAction)gottaGoButton:(id)sender;
//@property DetailViewController *detailVC;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    //need to show all the pins on the map from the database
    [self showPin];
}

-(void)presentMoreInfo:(id)sender {
    
    [self performSegueWithIdentifier:@"showDetail" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        //pass information here
        DetailViewController *detailVC = segue.destinationViewController;
        //how can I differentiate between which pin is selected?
    }
    
}

- (IBAction)listViewButton:(id)sender {
    //segue to the table view
}

- (IBAction)gottaGoButton:(id)sender {
    //pops you out to external maps app to give you directions to closest one
}

//how to change this when there are multiple pins?
-(void)showPin {
    
    //need to get the location of all the pins from the data base
    CLLocationCoordinate2D lctn = CLLocationCoordinate2DMake(49.27588097, -123.024072);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5f, 0.5f);
    self.masterMapView.region = MKCoordinateRegionMake(lctn, span);
    
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    [pin setCoordinate:lctn];
    [pin setTitle:@"Adanac Park"];
    [pin setSubtitle:@"1025 Boundary Road"];
    [self.masterMapView addAnnotation:pin];
    
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationViewReuseIdentifier"];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationViewReuseIdentifier"];
    }
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    UIButton *moreWashroomInformation = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [moreWashroomInformation addTarget:self action:@selector(presentMoreInfo:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = moreWashroomInformation;
    
    //use this if we want to change the pin to an imageview of something
//    UIImageView *washroomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    catImageView.image = [self.detailItem catImage];
//    [annotationView addSubview:catImageView];
    
    return annotationView;
}

@end
