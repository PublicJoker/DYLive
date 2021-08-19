//
//  MainViewController.swift
//  PJLive
//
//  Created by Mr_Han on 2019/4/12.
//  Copyright © 2019 Mr_Han. All rights reserved.

//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVc("Home")
//        addChildVc("Live")
        addChildVc("Follow")
        addChildVc("Profile")
        
        delegate = self
    }
    
    private func addChildVc(_ name : String) {
        
        //1. 通过 storyboard 来获取控制器
        let childVc = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
        
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

}
