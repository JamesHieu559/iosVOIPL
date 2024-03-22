#
# Be sure to run `pod lib lint MifoneSdkNative.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MifoneSdkNative'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MifoneSdkNative.'
  s.ios.deployment_target = '12.0'
  s.requires_arc = true
  s.swift_version = "5"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/37453099/MifoneSdkNative'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '37453099' => 'hieu.ho@mitek.vn' }
  s.source           = { :git => 'https://github.com/37453099/MifoneSdkNative.git', :tag => s.version.to_s }
  #s.source_urls      = ['https://gitlab.linphone.org/BC/public/podspec.git', 'https://github.com/CocoaPods/Specs.git']
  #s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  

  # s.source_files = 'MifoneSdkNative/Classes/**/*'
  s.source_files = 'MifoneSdkNative/**/*'

  s.dependency 'linphone-sdk', '~> 5.1.60'
  s.dependency 'Swinject', '~> 2.8.2'
end
