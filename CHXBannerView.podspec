Pod::Spec.new do |s|
  s.name         = "CHXBannerView"
  s.version      = "1.5.6.1"
  s.summary      = "CHXBannerView is a immensity scrollview banner view, which is supported for Autolayout and framed"

  s.description  = <<-DESC
					CHXBannerView is a immensity scrollview banner view, which is supported for Autolayout and framed
                   DESC

  s.homepage     = "https://github.com/showmecode/CHXBannerView"
  s.license      = "MIT"
  s.author             = { "Moch" => "atcuan@gmail.com" }
  s.social_media_url   = "https://twitter.com/MochXiao"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/showmecode/RefreshControl.git",
:tag => "0.1" }
  s.requires_arc = true
  s.source_files  = "CHXBannerView/CHXBannerView/Source/*"
  s.frameworks = 'Foundation', 'UIKit'
end
