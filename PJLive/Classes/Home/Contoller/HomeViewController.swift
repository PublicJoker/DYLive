//
//  HomeViewController.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/15.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit

private let kTitleViewH : CGFloat = 60

extension UIView {
    /// 递归隐藏所有的线
    func hideAllLine() {
        for subV in subviews {
            if subV.frame.height.isLessThanOrEqualTo(1) && CGFloat(0.1).isLessThanOrEqualTo(subV.frame.height) {
                subV.alpha = 0
            } else {
                subV.hideAllLine()
            }
        }
    }
}

class HomeViewController: UIViewController {
    // MARK: 懒加载属性
    private lazy var homeViewModel : HomeViewModel = HomeViewModel()
    
    var titles = [String]()
    
    // MARK: 懒加载属性
    private lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: 0, width: kScreenW, height: kTitleViewH)
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var pageContentView : PageContentView = {[weak self] in
        //1. 确定内容 frame
        let contentH = kScreenH - kNavigationBarH - kTitleViewH - kTabBarH
        let contentFrame = CGRect(x: 0, y: kTitleViewH, width: kScreenW, height: contentH)
        
        //2. 确定所有子控制器
        var childVcs = [UIViewController]()
        
        for (index, title) in titles.enumerated() {
            if index == 0 {//推荐
                childVcs.append(RecommendViewController())
            } else {
                // 传分类id
                childVcs.append(RecommendViewController(homeViewModel.tabModels[index-1].list_id))
            }
        }
        
        let pageContentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentVc: self)
        pageContentView.delegate = self
        
        return pageContentView
    }()
    
    // MARK: 系统的回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        // 三方SDK初始化(延迟初始化,避免与请求ATT权限弹框冲突)
//        PlatformConfig.shared.init3rdSDK(application: UIApplication.shared, launchOptions: appDelegate.appLaunchOptions)
        
        titles.append("推荐")
        // 设置 UI 页面
        setUpUI()
        homeViewModel.requestData {
            RefreshPageSize = (20)
            print(self.homeViewModel.tabModels)
            
            let tabs = self.homeViewModel.tabModels.compactMap { $0.list_name }
            self.titles.append(contentsOf: tabs)
            let titleFrame = CGRect(x: 0, y: 0, width: kScreenW, height: kTitleViewH)
            self.pageTitleView = PageTitleView(frame: titleFrame, titles: self.titles)
            self.pageTitleView.delegate = self
            
            //2. 添加 titleView
            self.view.addSubview(self.pageTitleView)
            
            //3. 添加 contentView
            self.view.addSubview(self.pageContentView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = false

        if #available(iOS 13.0, *) {
            let naviAppearance = UINavigationBarAppearance()
            naviAppearance.backgroundImage = nil
            naviAppearance.shadowImage = nil
            naviAppearance.backgroundColor = kPageTitleBgColor
            navigationController?.navigationBar.scrollEdgeAppearance = naviAppearance
            navigationController?.navigationBar.standardAppearance = naviAppearance
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = kPageTitleBgColor
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = true
        
        let imageV : UIImage = UIImage.imageWithColor(color: UIColor.init(hex:"ffffff"))
        
        if #available(iOS 13.0, *) {
            let naviAppearance = UINavigationBarAppearance()
            naviAppearance.backgroundImage = imageV
            naviAppearance.backgroundColor = UIColor.white
            naviAppearance.shadowImage = nil
            navigationController?.navigationBar.scrollEdgeAppearance = naviAppearance
            navigationController?.navigationBar.standardAppearance = naviAppearance
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = UIColor.white
            navigationController?.navigationBar.setBackgroundImage(imageV, for: .default)
            navigationController?.navigationBar.shadowImage = UIImage.init()
        }
    }
    
}

// MARK: 设置 UI 界面
extension HomeViewController {
    
    private func setUpUI() {
        
        //0. 不需要调整 UIScrollView 的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        //1. 设置导航栏
        setUpNavigationBar()
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    private func setUpNavigationBar() {
        //1. 设置左侧 item
        let searchView = UIView(frame:CGRect(x: kDefaultMargin, y: kTopSafeH, width: kScreenW * 0.55, height: 44))
        let searchBtn = UIButton(frame: CGRect(x: 0, y: 5, width: kScreenW * 0.55, height: 34))
        searchBtn.setTitle("你想看的都在这里", for: .normal)
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        searchBtn.setTitleColor(kTextLightGrayColor, for: .normal)
        searchBtn.setImage(UIImage(named: "icon_search"), for: .normal)
        searchBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        searchBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        searchBtn.contentHorizontalAlignment = .left
        searchBtn.backgroundColor = .white
        searchBtn.layer.cornerRadius = 17
        searchBtn.layer.masksToBounds = true
        searchBtn.addTarget(self, action: #selector(searcAction), for: .touchUpInside)
        
        searchView.addSubview(searchBtn)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchView)
        
        //2. 设置右侧 item
        let historyItem = UIBarButtonItem(image: UIImage(named: "icon_history")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(historyAction))
//        let downloadItem = UIBarButtonItem(image: UIImage(named: "icon_download")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(downloadAction))
        let filterItem = UIBarButtonItem(image: UIImage(named: "icon_filter")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(filterAction))
        
//        navigationItem.rightBarButtonItems = [filterItem,downloadItem,historyItem]
        navigationItem.rightBarButtonItems = [filterItem, historyItem]
        
        // 隐藏导航栏底部的线
        navigationController?.navigationBar.hideAllLine()
    }
    
}

// MARK: 遵守 PageTitleViewDelegate 协议
extension HomeViewController : PageTitleViewDelegate {

    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setContentIndex(currentIndex: index)
    }
    
}


// MARK: 遵守 PageContentViewDelegate 协议
extension HomeViewController : PageContentViewDelegate {
    
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
}


// MARK: 监听事件点击
extension HomeViewController {
    
    @objc fileprivate func searcAction() {
        AppJump.jumpToSearchControl()
    }
    
    @objc fileprivate func historyAction() {
        AppJump.jumpToHisControl()
    }
    
    @objc fileprivate func downloadAction() {
        print("下载")
    }
    
    @objc fileprivate func filterAction() {
        print("筛选")
    }
    
}
