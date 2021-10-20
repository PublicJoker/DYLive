//
//  RecommendViewController.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/16.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit
import LLCycleScrollView

// MARK: 常量
private let kCycleViewH : CGFloat = kScreenW * 9 / 16.0
private let kGameViewH : CGFloat = 90.0

class RecommendViewController: BaseAnchorViewController {
    var listId: String?
    
    var cycleModels : [CycleModel]? {
        didSet {
            cycleView.titles = cycleModels?.compactMap({ $0.vod_name }) ?? []
            cycleView.imagePaths = cycleModels?.compactMap({ $0.vod_pic_slide }) ?? []
        }
    }
    
    convenience init(_ listId: String?) {
        self.init()
        self.listId = listId
    }
    
    // MARK: 懒加载属性
    private lazy var recommendViewModel = RecommendViewModel()
    
    private lazy var cycleView : LLCycleScrollView = {
        let cycleView = LLCycleScrollView()
        cycleView.customPageControlStyle = .pill
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
            cycleView.delegate = self
            
            //3. 设置 collectionView 的内边距
            collectionView.contentInset = UIEdgeInsets(top: kCycleViewH, left: 0, bottom: 0, right: 0)
        } else {
            //2. 设置 collectionView 的内边距
            collectionView.contentInset = UIEdgeInsets.zero
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


// MARK: 请求数据
extension RecommendViewController {
    
    override func didClickMore() {
        super.didClickMore()
        
        AppJump.jumpToSearchControl()
    }
    
    override func loadData() {
        //0. 给父类中 viewModel 赋值
        baseVM = recommendViewModel
        RefreshPageSize = (20)
        //1. 请求推荐数据
        recommendViewModel.requestData(listId: listId) {
            //1.1 展示推荐数据
            self.collectionView.reloadData()
            //1.2.3 数据请求完成
            self.loadDataFinished()
        }
        
        //2. 请求轮播数据
        recommendViewModel.requestCycleData {
            self.cycleModels = self.recommendViewModel.cycleModels
        }
    }
}

extension RecommendViewController: LLCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: LLCycleScrollView, didSelectItemIndex index: NSInteger) {
        let model = self.cycleModels![index]
        print("点击了视频:\(model.vod_id)")
        AppJump.jumpToPlayControl(movieId: "\(model.vod_id)")
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
