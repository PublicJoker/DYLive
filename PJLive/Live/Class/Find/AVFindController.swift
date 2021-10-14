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
    
    var listId: String?
    
    private lazy var listData : [FindListModel] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavTitle(title: "发现")
        setupRefresh(scrollView: self.collectionView, options: .defaults)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshData(page: RefreshPageStart)
    }
    override func refreshData(page: Int) {
        let size = Int(RefreshPageSize)
        
        weak var weakFindVM = findViewModel
        findViewModel.requestData(listId: listId) {
            if page == RefreshPageStart{
                self.listData.removeAll()
            }
            
            self.listData.append(contentsOf: weakFindVM!.listModels)
            self.collectionView.reloadData()
            self.endRefresh(more:weakFindVM!.listModels.count >= size)
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }
       override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return self.listData.count
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
           cell.info = self.listData[indexPath.row]
           return cell
       }
       override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let model = self.listData[indexPath.row]
           AppJump.jumpToCategeryControl(listId: model.special_id)
       }
}
