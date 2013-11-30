#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "PBGroupScrollController"
  s.version      = "0.1.0"
  s.summary      = "PBGroupScrollController extends functionality of UICollectionViewController"
  s.description  = "Controller that allows great user experiance when scrolling collection view down and up. Instead of classic scrolling it offers scroll whole page."
  s.homepage     = "http://github.com/piotrbernad/PBGroupScrollController"
  s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = 'MIT'
  s.author       = { "piotrbernad" => "piotrbernadd@gmail.com" }
  s.source       = { :git => "git@github.com:piotrbernad/PBGroupScrollController.git", :tag => s.version.to_s }

  # s.platform     = :ios, '6.0'
  # s.ios.deployment_target = '6.0'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets'

  # s.public_header_files = 'Classes/**/*.h'
end
