//
//  WashroomTableViewCell.h
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-07.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pin.h"

@interface WashroomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *wheelchairAccessLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (nonatomic) Pin *pin;

@end
