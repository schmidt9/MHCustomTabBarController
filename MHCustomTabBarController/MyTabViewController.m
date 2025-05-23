//
//  MyTabViewController.m
//  MHCustomTabBarController
//
//  Created by Alexander Kormanovsky on 13.03.2025.
//  Copyright © 2025 Martin Hartl. All rights reserved.
//

#import "MyTabViewController.h"

@implementation MyTabViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s | segue identifier: %@", __func__, segue.identifier);
    
    if ([segue.identifier isEqualToString:@"someNonTabViewController"]) {
        self.nonTabViewControllers = @[segue.destinationViewController];
    }
    
    [super prepareForSegue:segue sender:sender];
}

@end
