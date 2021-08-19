//
//  ProfileViewController.swift
//  PJLive
//
//  Created by Tony-sg on 2019/4/25.
//  Copyright © 2019 Tony-sg. All rights reserved.

//

import UIKit

private let kProfileNormalCellID = "kProfileNormalCellID"

private let kProfileHeaderViewH : CGFloat = kScreenH - 44


class ProfileViewController: BaseViewController {
    // MARK: 懒加载属性
    fileprivate lazy var tableView : UITableView = {
        
        let tableView = UITableView(frame: CGRect(x: 0, y: -(kIsPhoneX ? 88 : 64), width: kScreenW, height: kScreenH + 20), style: .plain)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.dataSource = self
        tableView.bounces = false
        
        tableView.register(UINib(nibName: "TableProfileNormalCell", bundle: nil), forCellReuseIdentifier: kProfileNormalCellID)
        
        return tableView
        
    }()
    
    fileprivate lazy var profileHeaderView : ProfileHeaderView = {
        
        let profileHeaderView = ProfileHeaderView.profileHeaderView()
        
        profileHeaderView.frame = CGRect(x: 0, y: -kProfileHeaderViewH, width: kScreenW, height: kProfileHeaderViewH)
        
        return profileHeaderView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fd_prefersNavigationBarHidden = true
        // 设置 UI
        setUpUI()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


// MARK: 设置 UI 界面
extension ProfileViewController {
    
    override func setUpUI() {
        
        tableView.backgroundColor = UIColor(r: 250, g: 250, b: 250)
        view.addSubview(tableView)
        
        tableView.addSubview(profileHeaderView)
        
        tableView.contentInset = UIEdgeInsets(top: kProfileHeaderViewH, left: 0, bottom: 0, right: 0)
        
        self.loadDataFinished()

        super.setUpUI()
    }
    
}


// MARK: 设置导航栏
extension ProfileViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置导航栏和阴影为透明色
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
}


// MARK: 遵守 UITableViewDataSource 协议
extension ProfileViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kProfileNormalCellID, for: indexPath) as! TableProfileNormalCell
        return cell
    }
    
}


// MARK: 监听事件点击
extension ProfileViewController {
    
    @objc fileprivate func editAction() {
        print("编辑")
    }
    
    @objc fileprivate func msgAction() {
        print("消息")
    }
    
}
