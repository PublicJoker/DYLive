//
//  ShareController.swift
//  PJLive
//
//  Created by Tony on 2021/10/12.
//  Copyright © 2021 PublicJoker. All rights reserved.
//

import UIKit

class ShareController: BaseViewController {
    @IBOutlet weak var qrcodeView: UIImageView!
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var copyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showNavTitle(title: "分享好友")
        shareBtn.layer.cornerRadius = 25
        shareBtn.layer.masksToBounds = true
        
        saveBtn.layer.cornerRadius = 25
        saveBtn.layer.masksToBounds = true
        
        copyBtn.layer.cornerRadius = 25
        copyBtn.layer.masksToBounds = true
    }

    @IBAction func shareAction(_ sender: Any) {
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
    }
    
    @IBAction func copyLink(_ sender: Any) {
        let pas = UIPasteboard.general
        pas.string = ""
        
        SVProgressHUD.showSuccess(withStatus: "邮箱复制成功")
        SVProgressHUD.dismiss(withDelay: 1.0)
    }
}
