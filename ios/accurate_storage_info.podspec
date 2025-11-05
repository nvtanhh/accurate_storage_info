#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint accurate_storage_info.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'accurate_storage_info'
  s.version          = '0.0.1'
  s.summary          = 'Accurate disk storage info for iOS and Android.'
  s.description      = <<-DESC
Accurate disk storage info for iOS and Android.
                       DESC
  s.homepage         = 'https://github.com/nvtanhh/accurate_storage_info'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tan Nguyen' => 'nvtanh.dev@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # s.resource_bundles = {'accurate_storage_info_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
