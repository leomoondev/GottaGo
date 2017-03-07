//
//  DetailViewController.m
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-06.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <MKMapViewDelegate>

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


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [self configure];
    [self showPin];

}

-(void)configure {

    //set the label text to the passed properties, may need to add more text (stringWithFormat)
    self.nameLabel.text = self.nameOfWashroom;
    self.addressLabel.text = self.addressOfWashroom;
    self.typeLabel.text = self.typeOfWashroom;
    self.locationLabel.text = [NSString stringWithFormat:@"Located: %@", self.locationOfWashroom];
    self.summerHoursLabel.text = [NSString stringWithFormat:@"Summer Hours: %@", self.summerHoursOfWashroom];
    self.winterHoursLabel.text = [NSString stringWithFormat:@"Winter Hours: %@", self.winterHoursOfWashroom];
    self.wheelchairAccessLabel.text = [NSString stringWithFormat:@"Wheelchair Access: %@", self.wheelchairAccessOfWashroom];
    self.maintainerLabel.text = [NSString stringWithFormat:@"Maintained By: %@", self.maintainerOfWashroom];
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
}
@end
