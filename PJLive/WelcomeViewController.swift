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
    
    var isTranslated: Bool = UserDefaults.isTranslated()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showBg()
        autoUpdate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestIDFA()
    }
    
    func autoUpdate() {
        if UserDefaults.isTranslated() {
            adsBgView.isHidden = false
            adsBgView.image = UIImage(named: "splash_slogan")
            logoImg.image = UIImage(named: "splash_logo")
        } else {
            adsBgView.isHidden = true
            logoImg.isHidden = true
            adsBgView.image = UIImage(named: "AppLogo")
            logoImg.image = UIImage(named: "bg_custom_update")
//            getAppVersion()
        }
    }
    
    func showBg() {
        if isTranslated {
            adsBgView.isHidden = false
            adsBgView.image = UIImage(named: "app_logo")
            logoImg.image = UIImage(named: "splash_logo")
        } else {
            adsBgView.isHidden = false
//            adsBgView.image = UIImage(named: "AppLogo")
//            logoImg.image = UIImage(named: "bg_custom_update")
        }
    }
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                if status == .authorized || UserDefaults.isTranslated() {//已授权广告标识符
                    self.initAd()
                } else {
                    self.changeHomePage()
                }
            })
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                self.initAd()
            } else {
                self.changeHomePage()
            }
        }
    }
    
    func initAd() {
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
        return adView
    }()
    
    func changeHomePage() {
        DispatchQueue.main.async {
            if self.isTranslated {
                kAppdelegate?.window?.rootViewController = MainViewController()
            } else {
                let vc = IATViewController()
                kAppdelegate?.window?.rootViewController = vc
                vc.userId = kAppdelegate?.keyChainUuid ?? ""
            }
        }
    }
}

extension WelcomeViewController: BUSplashAdDelegate {
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
