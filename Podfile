source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!
#inhibit_all_warnings!

target 'PJLive' do
  pod 'ATRefresh_Swift', '~> 0.2'
  pod 'ATKit_Swift', '~> 0.2'
  pod 'Moya', '~> 13.0'
  pod 'SwiftyJSON', '~> 5.0'
  pod 'HandyJSON', '~> 5.0'
  pod 'SnapKit', '~> 5.0'
  pod 'Hue', '~> 5.0'
  pod 'MGJRouter_Swift', '~> 0.1'
  pod 'FDFullscreenPopGesture', '~> 1.1'
  pod 'FMDB', '~> 2.7'
  pod 'SVProgressHUD', '~> 2.2'
  pod 'MBProgressHUD', '~> 1.2'
  pod 'VTMagic', '~> 1.2'
  
# 网络请求框架
pod 'Alamofire', '~> 4.8'
# 图片加载框架
pod 'Kingfisher', '~> 4.10'
# 友盟统计
pod 'UMCCommon', '~> 7.3'
# Log
pod 'XCGLogger', '~> 7.0'
# 极光推送
pod 'JPush', '~> 3.7'
# 轮播
pod 'LLCycleScrollView', '~> 1.5'
# 穿山甲 SDK版本 >=3.4.0.0 - https://www.pangle.cn/support/doc/5fbdb5eb1ee5c2001d3f0c79
pod 'Ads-CN'
end

# 指定target的swift版本
post_install do |installer|
  installer.pods_project.targets.each do |target|
    # 也可以不用 if，讓所有pod的版本都設為一樣的
#    if ['RxSwift', 'RxSwiftExt', 'RxCocoa', 'XCGLogger', 'HandyJSON'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '5.0'
#      end
    end
  end
end
