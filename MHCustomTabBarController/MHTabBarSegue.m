/*
 * Copyright (c) 2013 Martin Hartl
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MHTabBarSegue.h"
#import "MHCustomTabBarController.h"

@implementation MHTabBarSegue

- (instancetype)initWithIdentifier:(nullable NSString *)identifier
                            source:(UIViewController *)source
                       destination:(UIViewController *)destination
{
    if ((self = [super initWithIdentifier:identifier source:source destination:destination])) {
        self.replacesOldViewController = YES;
    }
    return self;
}

- (void)perform {
    MHCustomTabBarController *tabBarViewController = (MHCustomTabBarController *)self.sourceViewController;
    UIViewController *destinationViewController = tabBarViewController.destinationViewController;

    //remove old viewController
    if (tabBarViewController.oldViewController && self.replacesOldViewController) {
        [tabBarViewController.oldViewController willMoveToParentViewController:nil];
        [tabBarViewController.oldViewController.view removeFromSuperview];
        [tabBarViewController.oldViewController removeFromParentViewController];
    }
    
    [tabBarViewController addChildViewController:destinationViewController];

    UIView *view = destinationViewController.view;
    view.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *container = tabBarViewController.container;
    [container addSubview:view];

    [view.leadingAnchor constraintEqualToAnchor:container.leadingAnchor].active = YES;
    [view.trailingAnchor constraintEqualToAnchor:container.trailingAnchor].active = YES;
    [view.topAnchor constraintEqualToAnchor:container.topAnchor].active = YES;
    [view.bottomAnchor constraintEqualToAnchor:container.bottomAnchor].active = YES;

    [destinationViewController didMoveToParentViewController:tabBarViewController];
}

@end
