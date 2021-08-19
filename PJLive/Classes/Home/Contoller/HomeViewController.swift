//
//  HomeViewController.swift
//  PJLive
//
//  Created by Mr_Han on 2019/4/15.
//  Copyright © 2019 Mr_Han. All rights reserved.

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

        titles.append("推荐")

        // 设置 UI 页面
        setUpUI()
        homeViewModel.requestData {
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
        navigationController?.navigationBar.barTintColor = kPageTitleBgColor
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = UIColor.white
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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    
    private func setUpNavigationBar() {
        //1. 设置左侧 item
//        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo", viewController: self, selector: #selector(logoAction))
        
        //2. 设置右侧 item
        let historyItem = UIBarButtonItem(image: UIImage(named: "icon_history")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(historyAction))
        let searchItem = UIBarButtonItem(image: UIImage(named: "icon_download")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(searchAction))
        let grcodeItem = UIBarButtonItem(image: UIImage(named: "icon_filter")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(scanAction))
        
        navigationItem.rightBarButtonItems = [grcodeItem,searchItem,historyItem]
        
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
    
    @objc fileprivate func logoAction() {
        print("logo")
    }
    
    @objc fileprivate func historyAction() {
        print("历史记录")
    }
    
    @objc fileprivate func searchAction() {
        print("下载")
    }
    
    @objc fileprivate func scanAction() {
        print("筛选")
    }
    
}
