//
//  AVBrowseController.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/29.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit

class AVFindController: BaseConnectionController {
    private lazy var findViewModel : FindViewModel = {
        return FindViewModel()
    }()
    
    var listId: Int?
    
    private lazy var listData : [FindListModel] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavTitle(title: "发现")
        setupRefresh(scrollView: self.collectionView, options: .defaults)
    }

    override func refreshData(page: Int) {
        weak var weakFindVM = findViewModel
        
        if listId == nil {
            RefreshPageSize = (5)
            findViewModel.requestData {
                self.listData = weakFindVM!.listModels
                self.collectionView.reloadData()
                self.endRefresh(more:false)
            }
        } else {
            RefreshPageSize = (20)
            findViewModel.requestCategoryData(listId: listId!) {
                self.listData = weakFindVM!.listModels
                self.collectionView.reloadData()
                self.endRefresh(more:self.listData.first?.video_list.count ?? 0 > RefreshPageSize)
            }
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listId == nil {
            return self.listData.count
        } else {
            let videos = self.listData.first?.video_list
            return videos?.count ?? 0
        }
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = SCREEN_WIDTH
        let height = SCREEN_WIDTH/16*9.0
        return CGSize.init(width: width, height:height)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AVFindCell = AVFindCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
        if listId == nil {//类型列表页
            cell.info = self.listData[indexPath.row]
        } else {//分类列表页
            let videos = self.listData.first!.video_list
            cell.video = videos[indexPath.row]
        }
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listId == nil {//类型列表页
            let model = self.listData[indexPath.row]
            AppJump.jumpToCategeryControl(listId: model.albumId)
        } else {//分类列表页
            let videos = self.listData.first!.video_list
            AppJump.jumpToPlayControl(movieId: videos[indexPath.row].vod_id, isYun: videos[indexPath.row].isYun)
        }
    }
}
