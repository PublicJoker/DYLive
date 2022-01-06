//
//  AppJump.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/26.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit

class AppJump: NSObject {
    class func jumpToFavControl() {
        let vc = AVFavController()
        vc.hidesBottomBarWhenPushed = true
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: false)
    }
    class func jumpToHisControl() {
        let vc = AVBrowseController()
        vc.hidesBottomBarWhenPushed = true
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: false)
    }
    class func jumpToSearchControl() {
        let vc = AVSearchController()
        vc.hidesBottomBarWhenPushed = true
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: false)
    }
    class func jumpToMoreControl(movieId : String) {
//        let vc = AVHomeMoreController(movieId: movieId, ztid: nil)
//        vc.hidesBottomBarWhenPushed = true
//        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
    }
    class func jumpToIndexMoreControl(ztid : String) {
//        let vc = AVHomeMoreController(movieId: nil, ztid: ztid)
//        vc.hidesBottomBarWhenPushed = true
//        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
    }
    class func jumpToPlayControl(movieId : String, isYun: Bool? = false) {
        let vc = AVPlayController(movieId: movieId, isYun: isYun)
        vc.hidesBottomBarWhenPushed = true
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: false)
    }
    
    class func jumpToSettingControl() {
        let vc = SettingController()
        vc.hidesBottomBarWhenPushed = true
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: false)
    }
    
    class func jumpToShareControl() {
        let vc = ShareController()
        vc.hidesBottomBarWhenPushed = true
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: false)
    }
    
    class func jumpToCategeryControl(listId: Int) {
        let vc = AVFindController()
        vc.listId = listId
        vc.hidesBottomBarWhenPushed = true
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: false)
    }
    
    class func showRewardAlert(rootVC: UIViewController) {
        let vc = BaseViewController()
        vc.modalPresentationStyle = .pageSheet
        UIViewController.rootTopPresentedController().present(vc, animated: true, completion: nil)
//        vc.hidesBottomBarWhenPushed = true
//        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: false)
    }
}

