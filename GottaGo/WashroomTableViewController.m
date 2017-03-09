//
//  WashroomTableViewController.m
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-07.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "WashroomTableViewController.h"
#import "WashroomTableViewCell.h"
#import "DetailViewController.h"
#import "PinInfo.h"
#import "Pin.h"
#import "GottaGo-Swift.h"

@class SetNavigationTitleImage;

@interface WashroomTableViewController () <MKMapViewDelegate>

@end

@implementation WashroomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    SetNavigationTitleImage *setTitleImage = [[SetNavigationTitleImage alloc] init];
    [setTitleImage setImage:self.navigationController withNavItem:self.navigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //one section right now, could maybe make headers organizing them by distance
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //going to be equal to the count of the array
    return self.washrooms.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WashroomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.pin = self.washrooms[indexPath.row];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%@m", self.distances[indexPath.row]];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"listShowDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        DetailViewController *detailVC = (DetailViewController *)[segue destinationViewController];

        Pin *selectedPin = [[Pin alloc] init];
        selectedPin = self.washrooms[indexPath.row];
        
        detailVC.nameOfWashroom = selectedPin.name;
        detailVC.addressOfWashroom = selectedPin.address;
        detailVC.typeOfWashroom = selectedPin.type;
        detailVC.locationOfWashroom = selectedPin.location;
        detailVC.summerHoursOfWashroom = selectedPin.summerHours;
        detailVC.winterHoursOfWashroom = selectedPin.winterHours;
        detailVC.wheelchairAccessOfWashroom = selectedPin.wheelchairAccess;
        detailVC.maintainerOfWashroom = selectedPin.maintainer;
        
        CLLocationCoordinate2D lctn = CLLocationCoordinate2DMake(selectedPin.latitude, selectedPin.longitude);
        detailVC.locationOfPin = lctn;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"listShowDetail" sender:self];
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
