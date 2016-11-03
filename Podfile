# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'github-repo-starring-swift' do
  use_frameworks!
  pod 'OHHTTPStubs'
  pod 'Alamofire', '~> 4.0'
  # Pods for github-repo-starring-list-swift

  target 'github-repo-starring-swiftTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'OHHTTPStubs'
    pod 'Quick'
    pod 'Nimble'
    pod 'KIF', '~> 3.0', :configurations => ['Debug']
  end

  target 'github-repo-starring-swiftUITests' do
    inherit! :search_paths
    # Pods for testing

  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end

   end
end
