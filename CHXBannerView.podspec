Pod::Spec.new do |s|
  s.name         = "CHXBannerView"
  s.version      = "0.8.2"
  s.summary      = "CHXBannerView is a immensity scrollview banner view, which is supported for Autolayout and framed"

  s.description  = <<-DESC
                CHXBannerView . Why description can not be same as summary, it
idot. WTF, description can not shoter than summary. I wrote, can you realize
those word is all blah
                   DESC

  s.homepage     = "https://github.com/showmecode/CHXBannerView"
  s.license      = "MIT"
  s.author             = { "Moch" => "atcuan@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/showmecode/CHXBannerView.git",
:tag => s.version.to_s }
  s.requires_arc = true
  s.source_files  = "CHXBannerView/Source/*"
  s.frameworks = 'Foundation', 'UIKit'
end
