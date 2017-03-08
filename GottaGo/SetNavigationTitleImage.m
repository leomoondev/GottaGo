//
//  SetNavigationTitleImage.m
//  GottaGo
//
//  Created by Scott Hetland on 2017-03-08.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

#import "SetNavigationTitleImage.h"

@implementation SetNavigationTitleImage

-(void)setImage:(UINavigationController *)navigationController withNavItem:(UINavigationItem *)navItem {
    
    UIImage *image = [UIImage imageNamed:@"logo-1"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:image];
    [logoView setImage:image];
    float targetHeight = navigationController.navigationBar.frame.size.height;
    [logoView setFrame:CGRectMake(0, 0, 0, targetHeight)];
    [logoView setContentMode:UIViewContentModeScaleAspectFit];
    
    navItem.titleView = logoView;
    
}

@end
