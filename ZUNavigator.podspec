#
# Be sure to run `pod lib lint Navigator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZUNavigator'
  s.version          = '0.0.3'
  s.summary          = 'Navigator allows you to make segues, update data by urls. And some other useful stuff.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Navigator allows you to reduce dependencies between controllers without calling them directly and make modular app, where each module is pod for example.
  List of main features:
  - Make push/pop segues by url.
  - Prevent push segue if view controller already in view controllers stack or if in next tab - depends on policy.
  - Update data on pop segue in target view controller.
  - Simple switch tabs or switch tabs with segue.
  - Call update method by url in first matching target view controller in stack. Or every matching. Or in next tabs. - depends on policy.
  - Call update by url everywhere in app.(Navigation and tab bar controllers must be registered in Navigator - or use ZNTabBarController/ZNBavigationController).
  - Prints links map of your stack.
  - And some other things.
  All public methods documented and separated to files for fast access. Look at classes root folder.
                       DESC

  s.homepage         = 'https://github.com/ZordZ/ZUNavigator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MrTrent' => 'show6time@gmail.com' }
  s.source           = { :git => 'https://github.com/ZordZ/ZUNavigator.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.platform = :ios
  s.module_name = "ZUNavigator"
  s.swift_version = '5.0'
  
  s.ios.deployment_target = '13.0'

  s.source_files = 'ZUNavigator/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Navigator' => ['Navigator/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ZUCore', '~> 0.1.2'

end
