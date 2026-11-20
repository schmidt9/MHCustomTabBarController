# MHCustomTabBarController

[![Join the chat at https://gitter.im/mhaddl/MHCustomTabBarController](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/mhaddl/MHCustomTabBarController?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

![](https://raw.github.com/mhaddl/MHCustomTabBarController/screenshots/screenshots/iOS%20Simulator%20Bildschirmfoto%2009.05.2013%2018.24.40.png)

MHCustomTabBarController is a customizable UITabBarController replacement using Storyboard and segues.
It's built with Apples Custom Container ViewController API.

The library ships **two equivalent implementations**, packaged as two independent pods:

* **Objective-C** (the original) — pod `MHCustomTabBarController`.
* **Swift 5** — a 1:1 port — pod `MHCustomTabBarControllerSwift`.

Both variants require **iOS 15.0+** and use the same storyboard setup. They use different
Objective-C runtime class names, so both pods can be linked into the same app — for example
when another pod already depends on the Objective-C variant.

+ [MHTabBarController](https://github.com/hollance/MHTabBarController "MHTabBarController") (His initials are also M and H ;))
+ [CustomTabBarExample](http://www.scott-sherwood.com/ios-5-creating-a-custom-side-tabbar-using-storyboards-and-custom-segues/ "CustomTabBarExample")

## Installation

### Objective-C

```ruby
pod 'MHCustomTabBarController'
```

### Swift

```ruby
pod 'MHCustomTabBarControllerSwift'
```

The Swift port is a separate pod, so import it with:

```swift
import MHCustomTabBarControllerSwift
```

> The two pods have distinct Objective-C runtime class names, so a Podfile may list both
> (directly or through another pod that depends on the Objective-C variant). Unlike the
> former `MHCustomTabBarController/Swift` subspec, there is no duplicate-symbol conflict.

## Setup

Have a look at the demoproject and do the following steps.

### Create your Custom TabBarController

![](https://raw.github.com/mhaddl/MHCustomTabBarController/screenshots/screenshots/Screenshot%20on%202013-05-09%20at%2017.48.04.png "Create you custom tabbar controller")

Insert a UIViewController into your storyboard and set the class to "MHCustomTabBarController". Place a UIView (your "UITabBar") into the ViewController. Add UIButtons (your "UITabBarItems") to the view (the buttons must IN the UIView). Add a Container View above (or where you want) to the ViewController.

This works identically for the Objective-C and Swift variants, except that storyboards
must tell the two same-named classes apart:

* Objective-C variant: `customClass="MHCustomTabBarController"` (no `customModule`).
* Swift variant: `customClass="MHCustomTabBarController" customModule="MHCustomTabBarControllerSwift"`.

If the controller in the storyboard is your own subclass (the usual case), set the module to
the one that declares the subclass; the Swift base class module only matters when the
base class itself is referenced from the storyboard.

### Hook up the outlets

Hook up the outlets in MHCustomTabBarController with your created views in the storyboard.
```objective-c
@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
```

In Swift these outlets are `@IBOutlet weak var container: UIView!` and
`@IBOutlet var buttons: [UIButton]!` — the property names are unchanged, so the same
storyboard connections work.

### Create your ContentViewControllers

![](https://raw.github.com/mhaddl/MHCustomTabBarController/screenshots/screenshots/Screenshot%20on%202013-05-09%20at%2018.17.54.png)

Place your desired ViewControllers into the storyboard and connect them with a UIButton in the CustomTabBarController. Give the created segues identifiers matching this scheme:
* initial, first ViewController = "viewController1"
* second ViewController = "viewController2"
+ ...

Set the style of the segues to "custom" and the class to "MHTabBarSegue". With the Swift
pod the segue is module-scoped, so set `customModule="MHCustomTabBarControllerSwift"`
as well; with the Objective-C pod no `customModule` is required.

## Swift

The Swift implementation is a direct port of the Objective-C one; every public member keeps
its name:

```swift
import MHCustomTabBarControllerSwift

final class MyTabViewController: MHCustomTabBarController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "someNonTabViewController" {
            nonTabViewControllers = [segue.destination]
        }

        super.prepare(for: segue, sender: sender)
    }
}
```

Notes:

* `buttons` is `[UIButton]!` (the `IBOutletCollection`), `container` is
  `UIView!`, `destinationViewController` is `weak`, `selectedIndex` is `private(set)`.
* The notification constants became `Notification.Name` values. The raw strings are
  identical to the Objective-C constants, so mixed Objective-C/Swift observers still work:
  ```swift
  NotificationCenter.default.addObserver(
      forName: .MHCustomTabBarControllerViewControllerChanged,
      object: nil,
      queue: .main
  )
  ```
* The ObjC `extern` constants are not exported by the Swift pod; use the literals above
  from Objective-C code that links only the Swift variant.
* Deprecated container APIs were replaced with `children`/`addChild`/`didMove(toParent:)`.
  The old rotation override is not needed because the segue pins the destination view to the
  container with Auto Layout.

## Demo projects

`MHCustomTabBarControllerDemo.xcodeproj` contains four targets:

| Target | Language | Kind |
|---|---|---|
| `MHCustomTabBarController` | Objective-C | framework |
| `MHCustomTabBarControllerDemo` | Objective-C | app |
| `MHCustomTabBarControllerSwift` | Swift | framework |
| `MHCustomTabBarControllerSwiftDemo` | Swift | app |

Shared schemes exist for the ObjC framework (`MHCustomTabBarController`) and for both Swift
targets. Build or run the Swift demo with:

```bash
xcodebuild -project MHCustomTabBarControllerDemo.xcodeproj \
  -scheme MHCustomTabBarControllerSwiftDemo \
  -destination 'platform=iOS Simulator,name=iPhone 17' build
```

## License

The MIT License (MIT)

Copyright (c) 2015 Martin Hartl

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
