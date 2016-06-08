#
# Be sure to run `pod lib lint AssetManager.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TearAwayModal"
  s.version          = "0.0.1"
  s.summary          = "A cool way of presenting and dismissing a modal view"
  s.description      = <<-DESC
                       Requires iOS 7+
                       DESC
  s.homepage         = "http://pocketresume.net"
  s.license          = '???'
  s.author           = { "Mani Ghasemlou" => "mani.ghasemlou@icloud.com" }
  s.source           = { :git => "https://github.com/manicakes/TearAwayModal.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'TearAwayModalView/TearAway*'
end
