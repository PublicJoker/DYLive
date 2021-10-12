//
//  FollowViewController.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/25.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit

private let kFollowHeaderViewH : CGFloat = 120.0

class FollowViewController: BaseAnchorViewController {
    fileprivate lazy var followViewModel : FollowViewModel = FollowViewModel()
}


// MARK: 设置 UI 界面
extension FollowViewController {
    
    override func setUpUI() {
        
        showNavTitle(title: "发现")
        
        //2. 设置右侧 item
        let historyItem = UIBarButtonItem(image: UIImage(named: "icon_hind_history")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(historyAction))
        let searchItem = UIBarButtonItem(image: UIImage(named: "icon_find_search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(searchAction))
        navigationItem.rightBarButtonItems = [searchItem,historyItem]
        
//        collectionView.addSubview(followHeaderView)
//        collectionView.contentInset = UIEdgeInsets(top: kFollowHeaderViewH, left: 0, bottom: 0, right: 0)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: kScreenWidth - 30, height: 200)
        super.setUpUI()
    }
    
}

// MARK: 监听事件点击
extension FollowViewController {
    
    @objc fileprivate func historyAction() {
        AppJump.jumpToHisControl()
    }
    
    @objc fileprivate func searchAction() {
        print("搜索")
    }
}

// MARK: 请求数据
extension FollowViewController {
    
    override func loadData() {
        
        //0. 给父类中 viewModel 赋值
        baseVM = followViewModel
        
        followViewModel.loadFollowData {
            
            //1. 刷新表格
            self.collectionView.reloadData()
            
            //1.2.3 数据请求完成
            self.loadDataFinished()
        }
        
    }
    
}


// MARK: 重写父类方法
extension FollowViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //1. 取出 headerView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "kHeaderViewID", for: indexPath) as! CollectionHeaderView
        
        //2. 设置属性
        headerView.titleLabel.text = "推荐直播"
        headerView.moreBtn.isHidden = true
        
        return headerView
        
    }
    
}
