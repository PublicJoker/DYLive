//
//  RecommendViewController.swift
//  DYLive
//
//  Created by Mr_Han on 2019/4/16.
//  Copyright © 2019 Mr_Han. All rights reserved.
//  CSDN <https://blog.csdn.net/u010960265>
//  GitHub <https://github.com/HanQiGod>
//

import UIKit

// MARK: 常量
private let kCycleViewH : CGFloat = kScreenW * 3 / 8
private let kGameViewH : CGFloat = 90.0

class RecommendViewController: BaseAnchorViewController {
    var listId: String?
    
    convenience init(_ listId: String?) {
        self.init()
        self.listId = listId
    }
    
    // MARK: 懒加载属性
    private lazy var recommendViewModel = RecommendViewModel()
    private lazy var cycleView : RecommendCycleView = {
        
        let cycleView = RecommendCycleView.recommendCycleView()
        cycleView.frame = CGRect(x: 0, y: -(kCycleViewH), width: kScreenW, height: kCycleViewH)
        
        return cycleView
        
    }()
}


// MARK: 设置 UI 界面
extension RecommendViewController {
    
    override func setUpUI() {
        
        //1. 先调用 super.setUpUI()
        super.setUpUI()
        
        if self.listId == nil {//推荐
            //2. 将 cycleView 添加到 collectionView 上
            collectionView.addSubview(cycleView)
            //3. 设置 collectionView 的内边距
            collectionView.contentInset = UIEdgeInsets(top: kCycleViewH, left: 0, bottom: 0, right: 0)
        } else {
            //2. 设置 collectionView 的内边距
            collectionView.contentInset = UIEdgeInsets.zero
        }
    }
}


// MARK: 请求数据
extension RecommendViewController {
    
    override func loadData() {
        //0. 给父类中 viewModel 赋值
        baseVM = recommendViewModel
        
        //1. 请求推荐数据
        recommendViewModel.requestData(listId: listId) {
            //1.1 展示推荐数据
            self.collectionView.reloadData()
            //1.2.3 数据请求完成
            self.loadDataFinished()
        }
        
        //2. 请求轮播数据
        recommendViewModel.requestCycleData {
            self.cycleView.cycleModels = self.recommendViewModel.cycleModels
        }
    }
}



// MARK: 遵循 UICollectionViewDelegateFlowLayout 协议
extension RecommendViewController : UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kNormalItemW, height: kNormalItemH)
    }
    
}
