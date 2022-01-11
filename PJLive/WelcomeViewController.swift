//
//  WelcomeViewController.swift
//  PJLive
//
//  Created by PublicJoker on 2022/1/3.
//  Copyright © 2022 PublicJoker. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var adsBgView: UIImageView!
    
    var isChecked: Bool = UserDefaults.isVersionChecked()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isChecked {
            showBg()
        }
        autoUpdate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestIDFA()
    }
    
    func autoUpdate() {
        if UserDefaults.isVersionChecked() {//版本已过审
            adsBgView.isHidden = false
            adsBgView.image = UIImage(named: "splash_slogan")
            logoImg.image = UIImage(named: "splash_logo")
        } else {
            adsBgView.isHidden = true
            logoImg.isHidden = true
            adsBgView.image = UIImage(named: "AppLogo")
            logoImg.image = UIImage(named: "bg_custom_update")
            getCheckStatus()
        }
    }
    
    func showBg() {
        if isChecked {
            adsBgView.isHidden = false
            adsBgView.image = UIImage(named: "app_logo")
            logoImg.image = UIImage(named: "splash_logo")
        } else {
            adsBgView.isHidden = false
//            adsBgView.image = UIImage(named: "AppLogo")
//            logoImg.image = UIImage(named: "bg_custom_update")
        }
    }
    
    func getCheckStatus() {
        ApiMoya.apiMoyaRequest(target: ApiMoya.getAppVersion(appId: "1581815639")) { json in
            let model = AppVersion.deserialize(from: json.rawString())
            //线上版本
            let appStoreVersion = model?.results.first?.version ?? ""
            //当前版本号
            let currentVersion = UserDefaults.currentVersionNum()
            //当前版本已上线 = 当前版本<=线上版本
            let checked = currentVersion.compare(appStoreVersion) != .orderedDescending
            self.isChecked = checked
            UserDefaults.setVersionChecked(flag: checked)//更新状态标识
            self.showBg()
            if checked { self.changeIcon() }
        } failure: { error in
//            self.showLive(false)
        }
    }
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                if status == .authorized {//已授权
                    
                }
                self.initAd()
            })
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                
            }
            self.initAd()
        }
    }
    
    func initAd() {
        BUAdSDKManager.setAppID("5208554")
        
        #if DEBUG
        BUAdSDKManager.setLoglevel(.debug)
        #endif
        
        /// Coppa 0 adult, 1 child
        BUAdSDKManager.setCoppa(0)
        
        DispatchQueue.main.async {
            self.splashAdView.delegate = self
            self.splashAdView.loadAdData()
            self.view.addSubview(self.splashAdView)
            self.splashAdView.rootViewController = self
        }
    }
    
    lazy var splashAdView: BUSplashAdView = {
        let frame = UIScreen.main.bounds
        let adView = BUSplashAdView(slotID: "887544324", frame: frame)
//        adView.hideSkipButton = true//隐藏跳过按钮
        return adView
    }()

    func changeIcon() {
        if #available(iOS 10.3, *) {
            guard UIApplication.shared.supportsAlternateIcons else {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIApplication.shared.setAlternateIconName("2021") { error in
                    print(error?.localizedDescription ?? "")
                }
            }
        }
    }
}

extension WelcomeViewController: BUSplashAdDelegate {
    func changeHomePage() {
        if isChecked {
            kAppdelegate?.window?.rootViewController = MainViewController()
        } else {
            let vc = IATViewController()
            kAppdelegate?.window?.rootViewController = vc
            vc.userId = kAppdelegate?.keyChainUuid ?? ""
        }
    }
    
    func splashAdDidClickSkip(_ splashAd: BUSplashAdView) {
        splashAd.removeFromSuperview()
        
        changeHomePage()
    }
    
    func splashAdDidLoad(_ splashAd: BUSplashAdView) {
        
    }
    
    func splashAdCountdown(toZero splashAd: BUSplashAdView) {
        splashAd.removeFromSuperview()
        
        changeHomePage()
    }
    
    func splashAd(_ splashAd: BUSplashAdView, didFailWithError error: Error?) {
        splashAd.removeFromSuperview()
        
        changeHomePage()
    }
}
