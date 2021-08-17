# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'
inhibit_all_warnings!
use_frameworks!
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

target 'DYLive' do

# 网络请求框架
pod 'Alamofire'
# 图片加载框架
pod 'Kingfisher'
# 菜单框架 - https://github.com/monoqlo/ExpandingMenu
pod 'ExpandingMenu', '~> 0.4'
# 友盟统计
pod 'UMCCommon'
# Log
pod 'XCGLogger'
# 极光推送
pod 'JPush'
# 轮播
pod 'LLCycleScrollView'
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
