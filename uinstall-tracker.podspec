#
# Be sure to run `pod lib lint uinstall-remove.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'uinstall-remove'
  s.version          = '1.0.0'
  s.summary          = 'A short description of uinstall-remove.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "Library to Track uninstalls"

  s.homepage         = 'https://github.com/j7/uinstall-remove'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'j7' => 'qnljoy@gmail.com' }
  spec.source       = { :git => "git@github.com:captain-show/uinstall-remove-pod.git", :tag => "#{spec.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '14.0'

  s.source_files = 'uinstall-tracker/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Combine'
  s.dependency 'Alamofire'
end
