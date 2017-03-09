//
//  RateWashroomViewController.m
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-08.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "RateWashroomViewController.h"
#import "DetailViewController.h"

@interface RateWashroomViewController ()
@property (weak, nonatomic) IBOutlet UILabel *washroomTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *thumbsDownOutlet;
@property (weak, nonatomic) IBOutlet UIButton *thumbsUpOutlet;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;

@end

@implementation RateWashroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.washroomTitleLabel.text = self.washroomToBeRated;
}

- (IBAction)thumbsDown:(id)sender {
    //give a rating property a bad review, disables other button
    self.thumbsUpOutlet.enabled = NO;
    self.thumbsDownOutlet.backgroundColor = [UIColor greenColor];
    self.washroomThumb = [NSString stringWithFormat:@"👎"];

}
- (IBAction)thumbsUp:(id)sender {
    //give a rating property a good review, disables other button
    self.thumbsDownOutlet.enabled = NO;
    self.thumbsUpOutlet.backgroundColor = [UIColor greenColor];
    self.washroomThumb = [NSString stringWithFormat:@"👍"];

}

//can connect button to this but causes crash
- (IBAction)saveReview:(id)sender {
    //saves it, pops back to previous screen
    self.washroomReview = [[NSString alloc] initWithString:self.reviewTextView.text];
    NSLog(@"%@", self.washroomReview);
    
    //need to pass the data back to the detail view controller
//    DetailViewController *detailVC = segue.destinationViewController;
//    detailVC.washroomReviewPassed = self.washroomReview;
//    detailVC.washroomThumbPassed = self.washroomThumb;
    
    
    //when this is implemented it does not pass back the given review to the detail view controller
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"saveReviewToDetail"]) {
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.washroomReviewPassed = self.washroomReview;
        detailVC.washroomThumbPassed = self.washroomThumb;
        //do I need to pass the values back?

    }
}


@end
