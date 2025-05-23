/*
 * Copyright (c) 2015 Martin Hartl
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

#import <UIKit/UIKit.h>

extern NSString *const MHCustomTabBarControllerViewControllerChangedNotification;
extern NSString *const MHCustomTabBarControllerViewControllerAlreadyVisibleNotification;

@interface MHCustomTabBarController : UIViewController

@property (weak,nonatomic) UIViewController *destinationViewController;
@property (strong, nonatomic) UIViewController *oldViewController;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, readonly) NSInteger selectedIndex;
/**
 * Button to be selected initially,
 * set it in subclass before [super viewWillAppear:] call
 */
@property (nonatomic) UIButton *initialSelectedButton;
/**
 * Segue identifier for view controller that should be opened initially,
 * set it in subclass before [super viewWillAppear:] call
 */
@property (nonatomic) NSString *initialSegueIdentifier;
/**
 * Do not clear previous selection
 */
@property (nonatomic) BOOL keepsSelection;
/**
 * Replace old view controller with new one.
 * self.childViewControllers will contain only one (current) view controller in this case
 */
@property (nonatomic) BOOL replacesOldViewController;
/**
 * Defaults to YES, If NO behave as ordinary view controller (not using custom segues logic)
 */
@property (nonatomic) BOOL usesTabs;
/**
 Contains non-tab child view controllers (for instance embedded view controllers), which should not be handled by tabs logic.
 They can be added for instance in subclass in `- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender`
 */
@property (nonatomic) NSArray<UIViewController *> *nonTabViewControllers;

@end
