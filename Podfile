# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SocialLogin-iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for SocialLogin-iOS
  
  pod 'GoogleSignIn', '= 5.0.2', :inhibit_warnings => true
  
  pod 'FBSDKCoreKit', '~>5.8.0'
  pod 'FBSDKLoginKit', '~>5.8.0'
  
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
  
end
