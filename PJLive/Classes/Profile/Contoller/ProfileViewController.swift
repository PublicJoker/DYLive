//
//  ProfileViewController.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/25.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit
import LLCycleScrollView

private let kProfileNormalCellID = "kProfileNormalCellID"

private let kProfileHeaderViewH : CGFloat = kScreenH - kTabBarH
// MARK: 常量
private let kCycleViewH : CGFloat = kScreenW * 9 / 16.0

class ProfileViewController: BaseViewController, LLCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: LLCycleScrollView, didSelectItemIndex index: NSInteger) {
        let model = self.cycleModels![index]
        print("点击了视频:\(model.vod_id)")
        AppJump.jumpToPlayControl(movieId: model.vod_id)
    }
    
    var cycleModels : [Player_vod]? {
        didSet {
            cycleView.titles = cycleModels?.compactMap({
                
                let his = String(format:"%.1f",Float($0.playItem.currentTime/$0.playItem.totalTime*100))
                return $0.vod_name + " \($0.playItem.title)" + " 观看至" + his + "%" + "\n点击继续观看"
            }) ?? []
            cycleView.imagePaths = cycleModels?.compactMap({ $0.vod_pic }) ?? []
            cycleView.imageViewContentMode = .scaleAspectFill
            
            profileHeaderView.bgImageView.addSubview(cycleView)
            cycleView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            profileHeaderView.bgImageView.isUserInteractionEnabled = true
            cycleView.delegate = self
        }
    }
    
    private lazy var cycleView : LLCycleScrollView = {
        let cycleView = LLCycleScrollView()
        cycleView.customPageControlStyle = .pill
        cycleView.frame = CGRect.zero
        return cycleView
    }()
    
    fileprivate lazy var profileHeaderView : ProfileHeaderView = {
        
        let profileHeaderView = ProfileHeaderView.profileHeaderView()
        
        profileHeaderView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kProfileHeaderViewH)
        
        return profileHeaderView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // 设置 UI
        setUpUI()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
}


// MARK: 设置 UI 界面
extension ProfileViewController {
    
    override func setUpUI() {
        view.addSubview(profileHeaderView)
        self.loadDataFinished()
        super.setUpUI()
    }
}


// MARK: 设置导航栏
extension ProfileViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置导航栏和阴影为透明色
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        
        fd_prefersNavigationBarHidden = true
        navigationController?.navigationBar.isTranslucent = true
        edgesForExtendedLayout = [.top]
        
        let size = Int(RefreshPageSize);
        AVBrowseDataQueue.getBrowseDatas(page:RefreshPageStart, size: size) { (listData) in
            let firstRecord = listData.first
            
            guard firstRecord != nil else {
                return
            }
            
            self.cycleModels = listData
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        fd_prefersNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        edgesForExtendedLayout = []
    }
}
