# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'Sinzak' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Sinzak

	# Lint
  pod 'SwiftLint', '0.49.0'

  # Auth
	pod 'KakaoSDKCommon', '2.13.1'
  pod 'RxKakaoSDKCommon', '2.13.1'
	pod 'KakaoSDKAuth', '2.13.1'
  pod 'RxKakaoSDKAuth', '2.13.1'
  pod 'KakaoSDKUser', '2.13.1'
  pod 'RxKakaoSDKUser', '2.13.1'
  pod 'naveridlogin-sdk-ios', '4.1.5'			

  # Rx
	pod 'RxSwift', '~> 6.5.0'
	pod 'RxCocoa', '~> 6.5.0'				
 
  pod 'lottie-ios', '3.4.2'
  pod 'SwiftConfettiView', '0.1.0'
  pod 'StompClientLib', '1.4.1'


  target 'SinzakTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Firebase/Core', '9.5.0'
    pod 'Firebase/Database', '9.5.0'
    pod 'Firebase/Messaging', '9.5.0'
    pod 'RxBlocking', '6.5.0'
    pod 'RxTest', '6.5.0'
  end

end


 post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
  end
end