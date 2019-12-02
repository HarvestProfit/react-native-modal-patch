
Pod::Spec.new do |s|
  s.name         = "RNReactNativeModalPatch"
  s.version      = "1.0.0"
  s.summary      = "RNReactNativeModalPatch"
  s.description  = <<-DESC
                  RNReactNativeModalPatch
                   DESC
  s.homepage     = "https://github.com/HarvestProfit/react-native-modal-patch"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "jake@harvestprofit.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/HarvestProfit/react-native-modal-patch.git", :tag => "master" }
  s.source_files  = "RNReactNativeModalPatch/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end
