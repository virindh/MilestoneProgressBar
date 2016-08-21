#
# Be sure to run `pod lib lint MilestoneProgressBar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MilestoneProgressBar'
  s.version          = '1.0'
  s.summary          = 'MilestoneProgressBar is a UIProgressView subclass that allows you to add milestones'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'MilestoneProgressBar is a UIProgressView subclass that allows you to add milestones. Milestones are images displayed along the way of the bar. Milestones can be light up optionally.' 

  s.homepage         = 'https://github.com/virindh/MilestoneProgressBar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Virindh Borra' => 'borra.virindh@gmail.com' }
  s.source           = { :git => 'https://github.com/virindh/MilestoneProgressBar.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/virindh'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MilestoneProgressBar/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MilestoneProgressBar' => ['MilestoneProgressBar/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
