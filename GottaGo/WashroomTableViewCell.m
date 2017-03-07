//
//  WashroomTableViewCell.m
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-07.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "WashroomTableViewCell.h"

@implementation WashroomTableViewCell

-(void)setPin:(Pin *)pin {
    _pin = pin;
    
    [self setup];
}


-(void)setup {
    self.nameLabel.text = self.pin.name;
    self.addressLabel.text = self.pin.address;
    
    //need to make this into a bool which shows a wheel chair icon or not
    self.wheelchairAccessLabel.text = [NSString stringWithFormat:@"♿️: %@", self.pin.wheelchairAccess];
    
    //need to also set the distance label
}

@end
