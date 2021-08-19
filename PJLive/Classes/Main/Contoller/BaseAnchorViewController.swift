//
//  BaseAnchorViewController.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/22.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit

// MARK: 常量
let kNormalItemW : CGFloat = (kScreenW - kItemMargin * 2 - kDefaultMargin * 2) / 3
let kNormalItemH : CGFloat = kNormalItemW * 5 / 3
let kPrettyItemH : CGFloat = kNormalItemW * 5 / 3
let kItemMargin : CGFloat = 10.0
private let kHeaderViewH : CGFloat = 50.0


private let kNormalCellID = "kNormalCellID"
private let kHeaderViewID = "kHeaderViewID"
let kPrettyCellID = "kPrettyCellID"


class BaseAnchorViewController: BaseViewController {

    // MARK: 定义属性
    var baseVM : BaseViewModel!
    lazy var collectionView : UICollectionView = {[unowned self] in
        //1. 创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kNormalItemW, height: kNormalItemH)
        layout.minimumLineSpacing = kDefaultMargin
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kDefaultMargin, bottom: 0, right: kDefaultMargin)
        
        //2. 创建 UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
//        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
        }()
    
    // MARK: 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置 UI 界面
        setUpUI()
        
        // 请求数据
        loadData()
        
    }

}


// MARK: 设置 UI 界面
extension BaseAnchorViewController {
    
    override func setUpUI() {
        
        //1. 给父类中内容 View 的引用进行赋值
        contentView = collectionView
        
        //2. 再添加 collectionView
        view.addSubview(collectionView)
        
        //3. 再调用 super
        super.setUpUI()
    }
    
}

// MARK: 请求数据
extension BaseAnchorViewController {
    
    @objc func loadData() {
    }
    
    @objc func didClickMore() {
        
    }
}


// MARK: 遵守 UICollectionViewDataSource 协议
extension BaseAnchorViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return baseVM.anchorGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return baseVM.anchorGroups[section].video_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
        cell.anchor = baseVM.anchorGroups[indexPath.section].video_list[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //1. 取出 headerView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        
        headerView.moreBtn.addTarget(self, action: #selector(didClickMore), for: .touchUpInside)
        
        //2. 给 headerView 设置数据
        headerView.group = baseVM.anchorGroups[indexPath.section]
        return headerView
    }
    
}


// MARK: 遵守 UICollectionViewDelegate 协议
extension BaseAnchorViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //1. 取出主播信息
        let anchor = baseVM.anchorGroups[indexPath.section].video_list[indexPath.item]
        
        AppJump.jumpToPlayControl(movieId: anchor.vod_id)
    }
}
