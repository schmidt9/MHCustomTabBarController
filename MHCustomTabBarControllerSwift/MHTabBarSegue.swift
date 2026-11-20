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

import UIKit

/// Embeds the destination view controller into the source tab bar controller's container.
///
/// The class deliberately does **not** claim the Objective-C runtime name `MHTabBarSegue`;
/// that name belongs to the Objective-C implementation, and claiming it here would make the
/// two variants produce duplicate symbols when both are linked into one app. Storyboards
/// must therefore reference this segue with the module:
/// `customClass="MHTabBarSegue" customModule="MHCustomTabBarControllerSwift"`.
@objcMembers
open class MHTabBarSegue: UIStoryboardSegue {

    open var replacesOldViewController = false

    public override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        replacesOldViewController = true
    }

    open override func perform() {
        guard let tabBarViewController = source as? MHCustomTabBarController,
              let container = tabBarViewController.container,
              let destinationViewController = tabBarViewController.destinationViewController else {
            return
        }

        // remove old viewController
        if let oldViewController = tabBarViewController.oldViewController, replacesOldViewController {
            oldViewController.willMove(toParent: nil)
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParent()
        }

        tabBarViewController.addChild(destinationViewController)

        let view = destinationViewController.view!
        view.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        destinationViewController.didMove(toParent: tabBarViewController)
    }
}
