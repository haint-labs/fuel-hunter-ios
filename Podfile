# Uncomment the next line to define a global platform for your project
platform :ios, '11.1'

target 'fuelhunter' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for fuelhunter

  pod 'SwiftLint' => '0.32.0'
  pod 'ActiveLabel' => '1.1.0'
  pod 'SDWebImage' => '5.0.2'
  pod 'Firebase' => '6.21.0'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'FHClient', :git => 'https://github.com/haint-labs/fuel-hunter-client-swift' 

  target 'fuelhunterTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'fuelhunterUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
