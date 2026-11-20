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

import UIKit

public extension Notification.Name {

    /// Posted after a new destination view controller has been selected.
    /// The raw string is identical to the Objective-C constant
    /// `MHCustomTabBarControllerViewControllerChangedNotification`.
    static let MHCustomTabBarControllerViewControllerChanged = Notification.Name("MHCustomTabBarControllerViewControllerChangedNotification")

    /// Posted when the selected tab's view controller is already visible.
    /// The raw string is identical to the Objective-C constant
    /// `MHCustomTabBarControllerViewControllerAlreadyVisibleNotification`.
    static let MHCustomTabBarControllerViewControllerAlreadyVisible = Notification.Name("MHCustomTabBarControllerViewControllerAlreadyVisibleNotification")
}

/// A customizable `UITabBarController` replacement using storyboard and segues.
///
/// The class keeps the Objective-C runtime name `MHCustomTabBarController`, so it can be
/// referenced from storyboards through `customClass` without a `customModule`.
@objc(MHCustomTabBarController)
@objcMembers
open class MHCustomTabBarController: UIViewController {

    private static let defaultSegueIdentifier = "viewController1"

    open weak var destinationViewController: UIViewController?
    open var oldViewController: UIViewController?

    @IBOutlet open weak var container: UIView!
    @IBOutlet open var buttons: [UIButton]!
    @IBOutlet open weak var segmentedControl: UISegmentedControl?

    open private(set) var selectedIndex: Int = 0

    /// Button to be selected initially,
    /// set it in subclass before `super.viewWillAppear(_:)` call
    open var initialSelectedButton: UIButton?

    /// Segue identifier for view controller that should be opened initially,
    /// set it in subclass before `super.viewWillAppear(_:)` call
    open var initialSegueIdentifier: String?

    /// Do not clear previous selection
    open var keepsSelection = false

    /// Replace old view controller with new one.
    /// `children` will contain only one (current) view controller in this case
    open var replacesOldViewController = false

    /// Defaults to `true`, if `false` behave as ordinary view controller
    /// (not using custom segues logic)
    open var usesTabs = false

    /// Contains non-tab child view controllers (for instance embedded view controllers),
    /// which should not be handled by tabs logic.
    /// They can be added for instance in subclass in
    /// `override func prepare(for segue: UIStoryboardSegue, sender: Any?)`
    open var nonTabViewControllers: [UIViewController]?

    private var viewControllersByIdentifier: [String: UIViewController] = [:]
    private var destinationIdentifier: String?

    // MARK: - Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()

        viewControllersByIdentifier = [:]
        replacesOldViewController = true
        usesTabs = true
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !usesTabs {
            return
        }

        assert(buttons != nil || segmentedControl != nil)

        let sender: Any?

        if buttons != nil {
            sender = initialSelectedButton ?? buttons.first
        } else {
            sender = segmentedControl
        }

        if initialSegueIdentifier == nil {
            initialSegueIdentifier = Self.defaultSegueIdentifier
        }

        if children.isEmpty || containsNonTabViewControllersOnly(),
           let initialSegueIdentifier {
            performSegue(withIdentifier: initialSegueIdentifier, sender: sender)
        }
    }

    // MARK: - Segue

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard usesTabs, segue.isKind(of: MHTabBarSegue.self) else {
            super.prepare(for: segue, sender: sender)
            return
        }

        (segue as? MHTabBarSegue)?.replacesOldViewController = replacesOldViewController

        oldViewController = destinationViewController

        // if view controller isn't already contained in the viewControllers-Dictionary
        if let identifier = segue.identifier, viewControllersByIdentifier[identifier] == nil {
            viewControllersByIdentifier[identifier] = segue.destination
        }

        assert(buttons != nil || segmentedControl != nil)

        if let buttons {
            if !keepsSelection {
                for button in buttons {
                    button.isSelected = false
                }
            }

            if let button = sender as? UIButton {
                button.isSelected = true
                selectedIndex = buttons.firstIndex(of: button) ?? NSNotFound
            }
        } else {
            selectedIndex = segmentedControl?.selectedSegmentIndex ?? 0
        }

        destinationIdentifier = segue.identifier

        if let destinationIdentifier {
            destinationViewController = viewControllersByIdentifier[destinationIdentifier]
        }

        NotificationCenter.default.post(name: .MHCustomTabBarControllerViewControllerChanged, object: nil)
    }

    open override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !usesTabs {
            return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        }

        if destinationIdentifier == identifier {
            // Dont perform segue, if visible ViewController is already the destination ViewController
            NotificationCenter.default.post(name: .MHCustomTabBarControllerViewControllerAlreadyVisible, object: nil)
            return false
        }

        return true
    }

    // MARK: - Memory Warning

    open override func didReceiveMemoryWarning() {
        if !usesTabs {
            super.didReceiveMemoryWarning()
            return
        }

        for key in Array(viewControllersByIdentifier.keys) where key != destinationIdentifier {
            viewControllersByIdentifier.removeValue(forKey: key)
        }

        super.didReceiveMemoryWarning()
    }

    // MARK: - Helpers

    private func containsNonTabViewControllersOnly() -> Bool {
        // Delete all non-tab view controllers
        var allChildViewControllers = children

        for viewController in children {
            for nonTabViewController in nonTabViewControllers ?? [] where viewController === nonTabViewController {
                allChildViewControllers.removeAll { $0 === viewController }
            }
        }

        return allChildViewControllers.isEmpty
    }
}
