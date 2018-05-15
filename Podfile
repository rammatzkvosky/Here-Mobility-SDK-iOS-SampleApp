source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/HereMobilityDevelopers/Here-Mobility-SDK-iOS.git'

platform :ios, '11.0'

target 'sampleApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  pod 'HereSDKDemandKit', '~> 1.0.1'
  pod 'HereSDKMapKit', '~> 1.0.1'
end

# Workaround for https://github.com/CocoaPods/CocoaPods/pull/6964
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''
    end
  end
end
