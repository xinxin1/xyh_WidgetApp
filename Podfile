# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'WidgetApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RealmSwift', '~> 10.41.1'
  pod 'SnapKit'
  pod 'HandyJSON'
  pod 'Moya'
  pod 'Kingfisher', '7.7.0'
  pod 'AFNetworking/Reachability', '~> 4.0.1'

  pod 'IBAnimatable'
  pod "MJRefresh"
  pod 'SPPermissions/PhotoLibrary'
  pod 'SPPermissions/Camera'
  pod 'SPPermissions/Tracking'
  pod 'SPPermissions/LocationAlways'
  pod 'SPPermissions/Health'
  pod 'PopupDialog'
  pod 'ZIPFoundation'
  pod 'YYKit'
  pod 'IQKeyboardManagerSwift'
  pod 'SHFullscreenPopGestureSwift'
  pod 'CameraManager'
  pod 'lottie-ios'
  
  pod 'UMCCommon'
  pod 'UMCSecurityPlugins'
  
  pod 'NVActivityIndicatorView'
  pod 'SwiftyStoreKit'
  pod 'JXSegmentedView'
  pod 'JXBanner'
  pod 'JXPagingView/Paging'
  pod 'JPImageresizerView'
  pod 'Toast-Swift'
  pod 'TZImagePickerController'
  
  pod 'WechatOpenSDK-XCFramework'
end


target 'WidgetExtensionExtension' do
  use_frameworks!
  pod 'HandyJSON'
  pod 'AFNetworking/Reachability', '~> 4.0.1'
  pod 'RealmSwift', '~> 10.41.1'
  pod 'WCDB.swift', '~> 2.0.3'
end

target 'DynamicWidget' do
  use_frameworks!
  pod 'HandyJSON'
  pod 'AFNetworking/Reachability', '~> 4.0.1'
  pod 'RealmSwift', '~> 10.41.1'
  pod 'WCDB.swift', '~> 2.0.3'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['CODE_SIGN_IDENTITY'] = ''
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      end
  end
end
