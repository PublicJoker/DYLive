//
//  AVFavController.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/26.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit
import ATKit_Swift
class AVFavController: BaseConnectionController {

    private lazy var listData : [Player_vod] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavTitle(title: "我喜欢的")
        setupRefresh(scrollView: self.collectionView, options: .defaults)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.refreshData(page:RefreshPageStart)
    }
    override func refreshData(page: Int) {
        let size : Int = RefreshPageSize + 1;
        AVFavDataQueue.getFavDatas(page: page, size: size) { (listData) in
            if page == RefreshPageStart{
                self.listData.removeAll()
            }
            self.listData.append(contentsOf: listData);
//            self.listData = AVFavDataQueue.sortDatas(listDatas: self.listData, ascending: false);
            self.collectionView.reloadData();
            self.endRefresh(more: listData.count >= size)
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listData.count;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:10, left: 10, bottom: 0, right: 10);
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (kScreenWidth - 10 * 3) / 3.0;
        return CGSize.init(width: width, height: itemHeight)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AVHomeCell = AVHomeCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
        cell.model = self.listData[indexPath.row]
        return cell;
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.listData[indexPath.row]
        AppJump.jumpToPlayControl(movieId: model.vod_id)
    }
}
