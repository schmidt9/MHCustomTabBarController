Pod::Spec.new do |s|
  s.name = "MHCustomTabBarController"
  s.version = "1.4.0"
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
    :tag => "v#{s.version}"
  }

  # `swift_versions` is a root-only CocoaPods attribute and cannot be declared
  # inside a subspec. It has no effect on ObjC-only consumers.
  s.swift_versions = ["5.0"]

  # A bare `pod 'MHCustomTabBarController'` keeps resolving to the ObjC variant.
  s.default_subspecs = "ObjC"

  # Objective-C implementation (original library).
  s.subspec("ObjC") do |ss|
    ss.source_files = "MHCustomTabBarController/*.{m,h}"
  end

  # Swift 5 port. Select either this subspec or 'ObjC', not both: the two
  # variants declare the same ObjC runtime class names.
  s.subspec("Swift") do |ss|
    ss.source_files = "MHCustomTabBarControllerSwift/*.swift"
    ss.pod_target_xcconfig = {"DEFINES_MODULE" => "YES"}
  end
end
