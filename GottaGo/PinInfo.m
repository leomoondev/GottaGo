//
//  PinInfo.m
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-06.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "PinInfo.h"

@implementation PinInfo

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    [self willChangeValueForKey:@"coordinate"];
    _coordinate = coordinate;
    [self didChangeValueForKey:@"coordinate"];
}

- (void)setTitle:(NSString *)title {
    _title = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
}

@end
