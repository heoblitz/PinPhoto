# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'PinPhoto' do
  # Comment the next line if you don't want to use dynamic frameworks
  pod 'YPImagePicker'
  pod 'Firebase/Analytics'
  pod 'Kingfisher', '~> 5.0'
  pod 'lottie-ios'
  use_frameworks!

  # Pods for PinPhoto

end

target 'PinPhotoExtension' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Firebase/Analytics'
  # Pods for PinPhotoExtension

end

target 'PinPhotoWidgetExtension' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PinPhotoExtension

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
