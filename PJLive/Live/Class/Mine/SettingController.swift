//
//  SettingController.swift
//  PJLive
//
//  Created by Tony on 2021/10/12.
//  Copyright © 2021 PublicJoker. All rights reserved.
//

import UIKit
import MBProgressHUD

class SettingController: BaseViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cacheSizeLabel: UILabel!
    
    @IBOutlet weak var playSwitch: UISwitch!
    @IBOutlet weak var downloadSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showNavTitle(title: "设置中心")
        view.backgroundColor = kBgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let playStatus = UserDefaults.standard.bool(forKey: "kCanPlayOn4G")
        let downloadStatus = UserDefaults.standard.bool(forKey: "kCanDownloadOn4G")
        playSwitch.isOn = playStatus
        downloadSwitch.isOn = downloadStatus
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @IBAction func onSwitchChangedForPlay(_ sender: UISwitch) {
        let status = sender.isOn
        UserDefaults.standard.set(status, forKey: "kCanPlayOn4G")
    }
    
    @IBAction func onSwitchChagedForDownload(_ sender: UISwitch) {
        let status = sender.isOn
        UserDefaults.standard.set(status, forKey: "kCanDownloadOn4G")
    }
    
    @IBAction func onClickClearCache(_ sender: UIButton) {
        cacheSizeLabel.text = "0KB"
    }
    
    @IBAction func onClickCopyEmail(_ sender: UIButton) {
        let pas = UIPasteboard.general
        pas.string = emailLabel.text
        
        SVProgressHUD.showSuccess(withStatus: "邮箱复制成功")
        SVProgressHUD.dismiss(withDelay: 1.0)
    }
    
    @IBAction func onClickJoinGroup(_ sender: UIButton) {
        //    点击链接加入群聊【超影（电影、影视）交流群】：https://jq.qq.com/?_wv=1027&k=uJH1uhPr
        let groupId = "753394765"
        let key = "5c3b335c462d0c87492634d4934190e0a0e524f7701a5bbc1e1cd79465e1b5f9"
        let inviteUrl = "mqqapi://card/show_pslcard?src_type=internal&version=1&uin=\(groupId)&key=\(key)&card_type=group&source=external&jump_from=webapi"
        UIApplication.shared.open(URL(string: inviteUrl)!, options: [:], completionHandler: nil)
    }
}
