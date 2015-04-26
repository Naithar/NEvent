Pod::Spec.new do |s|
  s.name             = "NEvent"
  s.version          = "0.5.0"
  s.summary          = "Custom event manager for ios"
  s.description      = <<-DESC
                       Block-based event manager based on NSNotificationCenter.
                       DESC
  s.homepage         = "https://github.com/naithar/NEvent"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Naithar" => "devias.naith@gmail.com" }
  s.source           = { :git => "https://github.com/naithar/NEvent.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/naithar'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/**/*'

  s.public_header_files = 'Pod/**/*.h'
end
