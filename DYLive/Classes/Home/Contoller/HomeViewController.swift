//
//  HomeViewController.swift
//  DYLive
//
//  Created by Mr_Han on 2019/4/15.
//  Copyright © 2019 Mr_Han. All rights reserved.
//  CSDN <https://blog.csdn.net/u010960265>
//  GitHub <https://github.com/HanQiGod>
//

import UIKit

private let kTitleViewH : CGFloat = 50

class HomeViewController: UIViewController {

    // MARK: 懒加载属性
    private lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","电影","连续剧","综艺","动漫"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        
        return titleView
    }()
    
    private lazy var pageContentView : PageContentView = {[weak self] in
        //1. 确定内容 frame
        let contentH = kScreenH - kNavigationBarH - kTitleViewH - kTabBarH
        let contentFrame = CGRect(x: 0, y:  kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        
        //2. 确定所有子控制器
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        childVcs.append(RecommendViewController())
        childVcs.append(GameViewController())
        childVcs.append(AmuseViewController())
        childVcs.append(FunnyViewController())
        
        let pageContentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentVc: self)
        pageContentView.delegate = self
        
        return pageContentView
    }()
    
    // MARK: 系统的回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置 UI 页面
        setUpUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        navigationController?.navigationBar.backgroundColor = kPageTitleBgColor
    }
}

// MARK: 设置 UI 界面
extension HomeViewController {
    
    private func setUpUI() {
        
        //0. 不需要调整 UIScrollView 的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        //1. 设置导航栏
        setUpNavigationBar()
        
        //2. 添加 titleView
        view.addSubview(pageTitleView)
        
        //3. 添加 contentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = .purple
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = kPageTitleBgColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.backgroundColor = nil
    }
    
    private func setUpNavigationBar() {
        //1. 设置左侧 item
//        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo", viewController: self, selector: #selector(logoAction))
        
        //2. 设置右侧 item
        let historyItem = UIBarButtonItem(image: UIImage(named: "icon_history")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(historyAction))
        let searchItem = UIBarButtonItem(image: UIImage(named: "icon_download")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(searchAction))
        let grcodeItem = UIBarButtonItem(image: UIImage(named: "icon_filter")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(scanAction))
        
        navigationItem.rightBarButtonItems = [grcodeItem,searchItem,historyItem]
        
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
