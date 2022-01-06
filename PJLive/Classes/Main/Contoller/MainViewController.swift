//
//  MainViewController.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/12.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit
import Lottie

class MainViewController: UITabBarController {
    var lottieNameArr = ["tab_home", "tab_find", "tab_my"]
    
    var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //1. 设置 Tabbar 的 tintColor
        UITabBar.appearance().tintColor = .blue
        
        addChildVc("Home", "首页")
        addChildVc("Follow", "发现")
        addChildVc("Profile", "我的")

        UserDefaults.setHasShowNewFeature(flag: true)
        delegate = self
    }
    
    private func addChildVc(_ name : String, _ title: String) {
        
        //1. 通过 storyboard 来获取控制器
        let childVc = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
        
        childVc.title = title
        //2. 将自控制器添加
        addChild(childVc)
    }
}

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.children.first {
            UINavigationBar.appearance().barTintColor = kPageTitleBgColor
        } else {
            UINavigationBar.appearance().barTintColor = .white
        }
        
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        setupAnimation(tabBarController, viewController)
    }
    
    private func getAnimationViewAtTabBarIndex(_ index: Int, _ frame: CGRect)-> AnimationView{
            
        // tabbar1 。。。 tabbar3
        let view = AnimationView(name: lottieNameArr[index])
        view.frame = frame
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 1
        return view
    }

    private func setupAnimation(_ tabBarVC: UITabBarController, _ viewController: UIViewController){
        
        if animationView != nil {
            animationView!.stop()
        }
        
    //        1. 获取当前点击的是第几个
        let index = tabBarVC.viewControllers?.firstIndex(of: viewController)
        var tabBarSwappableImageViews = [UIImageView]()
        var tabBarButtons = [Any]()
        
    //        2.遍历取出所有的 tabBarButton
        for tempView in tabBarVC.tabBar.subviews {
            if tempView.isKind(of: NSClassFromString("UITabBarButton")!) {
                //2.1 继续遍历tabBarButton 找到 UITabBarSwappableImageView 并保存
    //                print("tempView : \(tempView.subviews)" )
                    //从subviews中查找
                    for tempImgV in tempView.subviews {
                        //第一种层级关系 UITabBarButton --> UITabBarSwappableImageView
                        if tempImgV.isKind(of: NSClassFromString("UITabBarSwappableImageView")!) {
                            tabBarSwappableImageViews.append(tempImgV as! UIImageView)
                        }else{
                            //第二种：UITabBarButton --> UIVisualEffectView --> _UIVisualEffectContentView--> UITabBarSwappableImageView
                             let array = tempView.subviews[0].subviews[0].subviews
                            for tempImg in array {
                                if tempImg.isKind(of: NSClassFromString("UITabBarSwappableImageView")!) {
                                    tabBarSwappableImageViews.append(tempImg as! UIImageView)
                                }
                            }
                        }
                    }
                tabBarButtons.append(tempView)
            }
        }
        
        
    //        3. 找到当前的UITabBarButton
        let currentTabBarSwappableImageView = tabBarSwappableImageViews[index!]
        let currentTabBarButton = tabBarButtons[index!]
    //        4. 获取UITabBarButton中的 UITabBarSwappableImageView 并隐藏
        var frame = (currentTabBarButton as? UIView)?.frame ?? CGRect.zero
        frame.origin.x = 0
        frame.origin.y = 0
        var animation: AnimationView? = getAnimationViewAtTabBarIndex(index!, frame)
        self.animationView = animation
         self.animationView!.center = currentTabBarSwappableImageView.center
        
        
    //        5. 创建动画 view 加载到 当前的 UITabBarButton 并隐藏 UITabBarSwappableImageView
        currentTabBarSwappableImageView.superview?.addSubview( animation!)
        currentTabBarSwappableImageView.isHidden = true
        
    //        6. 执行动画，动画结束后 显示 UITabBarSwappableImageView 移除 动画 view 并置空
        animation!.play(fromProgress: 0.1, toProgress: 1) { (finished) in
            currentTabBarSwappableImageView.isHidden = false
            animation!.removeFromSuperview()
             animation = nil
        }
    }
}

