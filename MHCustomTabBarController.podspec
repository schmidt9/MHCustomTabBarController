Pod::Spec.new do |s|
  s.name = "MHCustomTabBarController"
  s.version = "1.5.1"
  s.platform = :ios
  s.ios.deployment_target = "15.0"
  s.summary = "Custom UITabBar replacement using storyboard and segues."
  s.license = "MIT"
  s.homepage = "https://github.com/mhaddl/MHCustomTabBarController"
  s.requires_arc = true
  s.author = {
    "Martin Hartl" => "martin@mhaddl.me"
  }
  s.source = {
    :git => "https://github.com/schmidt9/MHCustomTabBarController.git",
    :tag => "#{s.version}"
  }

  # Objective-C implementation
  #
  # The Swift 5 port lives in a separate pod, `MHCustomTabBarControllerSwift`
  # (MHCustomTabBarControllerSwift.podspec). It is deliberately not a subspec:
  # another pod may depend on the root spec (`spec.dependency("MHCustomTabBarController")`),
  # which activates the default subspec. A host app asking for a `Swift` subspec
  # would then silently compile both implementations into one target. The two pods
  # can be linked into the same app because their Objective-C runtime class names
  # are distinct.
  s.source_files = "MHCustomTabBarController/*.{m,h}"
end
