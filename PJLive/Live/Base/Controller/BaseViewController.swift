//
//  BaseViewController.swift
//  GKGame_Swift
//
//  Created by Tony-sg on 2019/9/29.
//  Copyright © 2019 Tony-sg. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit

class BaseViewController: UIViewController,UIGestureRecognizerDelegate {
    
    // MARK: 定义属性
    var contentView : UIView?

    // MARK: 懒加载属性
    fileprivate lazy var animImageView : UIImageView = {[unowned self] in
        
        let imageView = UIImageView(image: UIImage(named: "img_loading_1"))
        
        imageView.center = self.view.center
        imageView.animationImages = [UIImage(named: "img_loading_1")!, UIImage(named: "img_loading_2")!]
        imageView.animationDuration = 0.5
        imageView.animationRepeatCount = LONG_MAX
        imageView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        imageView.isUserInteractionEnabled = false
        
        return imageView
    }()
    
    // MARK: 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = [];
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.view.backgroundColor = UIColor.white
        self.fd_prefersNavigationBarHidden = false
        self.fd_interactivePopDisabled = false
        
//        setUpUI()
    }
    
    deinit {
        print(self.classForCoder, "is deinit");
    }

    //MARK:UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    override var shouldAutorotate: Bool{
        return false
    }
    override var prefersStatusBarHidden: Bool{
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
}

extension BaseViewController {
    
    @objc func setUpUI() {
        
        //1. 先隐藏内容 view
        contentView?.isHidden = true
        
        //2. 添加执行动画的 UIImageVIiew
        view.addSubview(animImageView)
        
        //3. 给 animImageView 执行动画
        animImageView.startAnimating()
        
        //4. 设置 view 的背景颜色
        view.backgroundColor = UIColor(r: 250, g: 250, b: 250)
    }
    
    
    func loadDataFinished() {
        
        //1. 停止动画
        animImageView.stopAnimating()
        
        //2. 隐藏 animImageView
        animImageView.isHidden = true
        
        //3. 显示 contentView
        contentView?.isHidden = false
        
    }
    
    
}
