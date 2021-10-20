//
//  ProfileHeaderView.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/25.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit

private let kNormalCellW : CGFloat = (kScreenW - kDefaultMargin * 2 - 20 * 2) / 3

private let kProfileHeaderNormalCell = "kProfileHeaderNormalCell"


class ProfileHeaderView: UIView {
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var expireTimeLabel: UILabel!
    
    // MARK: 控件属性
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: 定义属性
    fileprivate var names : [[String : Any]] = [["name":"全部历史","icon_name":"icon_my_history"],
//                                                ["name":"我的下载","icon_name":"icon_my_download"],
                                                ["name":"我喜欢的","icon_name":"icon_my_like"],
//                                                ["name":"去除广告","icon_name":"icon_my_reward"],
                                                ["name":"设置中心","icon_name":"icon_my_setting"],
                                                ["name":"分享好友","icon_name":"icon_my_share"]]
    

    
    lazy var splashAdView: BUSplashAdView = {
        let frame = UIScreen.main.bounds
        let adView = BUSplashAdView(slotID: "946575694", frame: frame)
        adView.tolerateTimeout = 10
//        adView.hideSkipButton = true//隐藏跳过按钮
        return adView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        autoresizingMask = []
        
        collectionView.register(UINib(nibName: "ProfileBtnsCell", bundle: nil), forCellWithReuseIdentifier: kProfileHeaderNormalCell)
        collectionView.delegate = self
        
        
        expireTimeLabel.text = ""
        versionLabel.textColor = kPageTitleBgColor
        versionLabel.text = "——————— 超影 \(UserDefaults.currentVersion()) ———————"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 修改 item 尺寸
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: kNormalCellW, height: kNormalCellW)
        layout.minimumInteritemSpacing = kDefaultMargin
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: kDefaultMargin, bottom: 20, right: kDefaultMargin)
    }
}


// MARK: 类方法
extension ProfileHeaderView {
    class func profileHeaderView() -> ProfileHeaderView {
        return Bundle.main.loadNibNamed("ProfileHeaderView", owner: nil, options: nil)?.first as! ProfileHeaderView
    }
}


// MARK: 遵守 UICollectionViewDataSource 协议
extension ProfileHeaderView : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kProfileHeaderNormalCell, for: indexPath) as! ProfileBtnsCell
        
        cell.nameLabel.text = names[indexPath.item]["name"] as? String
        cell.iconImageView.image = UIImage(named: names[indexPath.item]["icon_name"] as! String)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            AppJump.jumpToHisControl()
//        case 1:
//            print("我的下载")
        case 1:
            AppJump.jumpToFavControl()
//        case 2:
//            print("去除广告")
//            DispatchQueue.main.async {
//                self.splashAdView.delegate = self
//                self.splashAdView.loadAdData()
//
//                guard let rootVC = kAppdelegate?.window?.rootViewController as? UITabBarController,
//                      let navi = rootVC.selectedViewController as? BaseNavigationController,
//                      let vc = navi.topViewController
//                else { return }
//
//                vc.view.addSubview(self.splashAdView)
//                self.splashAdView.rootViewController = vc
//            }
        case 2:
            AppJump.jumpToSettingControl()
        case 3:
            AppJump.jumpToShareControl()
        default:
            NSLog("...")
        }
    }
    
}

extension ProfileHeaderView: BUSplashAdDelegate {
    func splashAdDidClickSkip(_ splashAd: BUSplashAdView) {
        splashAd.removeFromSuperview()
    }
    
    func splashAdDidLoad(_ splashAd: BUSplashAdView) {
        
    }
    
    func splashAdCountdown(toZero splashAd: BUSplashAdView) {
        splashAd.removeFromSuperview()
    }
    
    func splashAd(_ splashAd: BUSplashAdView, didFailWithError error: Error?) {
        splashAd.removeFromSuperview()
    }
}
