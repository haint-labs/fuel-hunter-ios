# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'fuelhunter' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for fuelhunter

  pod 'SwiftLint' => '0.32.0'
  pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '4.3.1'
  pod 'Mixpanel-swift' => '2.6.2'
  pod 'ActiveLabel' => '1.1.0'

  target 'fuelhunterTests' do
    inherit! :search_paths
    # Pods for testing

    pod 'SwiftLint' => '0.32.0'
    pod 'ActiveLabel' => '1.1.0'
  end

  target 'fuelhunterUITests' do
    inherit! :search_paths
    # Pods for testing

    pod 'SwiftLint' => '0.32.0'
    pod 'ActiveLabel' => '1.1.0'
  end

end
