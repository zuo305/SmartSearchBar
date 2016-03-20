
Pod::Spec.new do |s|
  s.name         = "SmartSearchBar"
  s.version      = "1.0"
  s.summary      = "Animation,Google Autocomplete"
  s.description  = <<-DESC
                    Animation,Google Autocomplete
                   DESC
  s.homepage     = "https://github.com/zuo305/SmartSearchBar"
  
  s.license      = 'MIT'
  s.author       = { "zuo305" => "johnzuo305@gmail.com" }
  s.social_media_url = "https://twitter.com/chinazuo305"
  s.source       = { :git => "https://github.com/zuo305/SmartSearchBar.git", :tag => '1.0' }

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = "SmartSearchBar/SourceClass/**/*.{swift}"
  s.resources = [
    "SmartSearchBar/Resource/**/*.{png}"
  ]
  
  s.frameworks = 'Foundation', 'UIKit'
  s.dependency 'GoogleMaps', '~> 1.12.3'
end