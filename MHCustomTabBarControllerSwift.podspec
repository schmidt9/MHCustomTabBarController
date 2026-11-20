Pod::Spec.new do |s|
  s.name = "MHCustomTabBarControllerSwift"
  s.version = "1.5.0"
  s.platform = :ios
  s.ios.deployment_target = "15.0"
  s.summary = "Swift 5 port of MHCustomTabBarController (custom UITabBar replacement using storyboard and segues)."
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

  # Separate pod rather than a subspec of `MHCustomTabBarController`, so that both
  # implementations can be linked into one app: if a library depends on the
  # Objective-C pod, and host apps may additionally choose the Swift one. The Swift
  # classes do not claim the Objective-C runtime names, so no duplicate symbols.
  s.swift_versions = ["5.0"]
  s.source_files = "MHCustomTabBarControllerSwift/*.swift"
  s.pod_target_xcconfig = {"DEFINES_MODULE" => "YES"}
end
