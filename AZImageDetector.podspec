Pod::Spec.new do |s|
  s.name         = "AZImageDetector"
  s.version      = "0.0.1"
  s.summary      = "iOS image detector."
  s.homepage     = "https://github.com/AndrewZhuCC/AZImageDetector"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Andrew" => "zaz92537@126.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/AndrewZhuCC/AZImageDetector.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/*.{h,m}"
  s.requires_arc = true
  s.vendored_framework = "LogoDetector/opencv2.framework"
end
