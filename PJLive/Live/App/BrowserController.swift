//
//  HxBrowserController.swift
//  elevatese
//
//  Created by Tony-sg on 2020/07/07.
//  
//

import UIKit
import WebKit

class BrowserController: BaseViewController {
    private var url: String = "https://www.1231d.com/"
    
    convenience init(url: String = "https://www.1231d.com/") {
        self.init()
        self.url = url
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        showNavTitle(title: "发现")
        
        self.view.addSubview(self.webView)
        self.view.addSubview(self.progressView)
        self.view.bringSubviewToFront(self.progressView) // 将进度条至于最顶层
        self.webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.webView.load(URLRequest.init(url: URL.init(string: self.url)!))
    }
            
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //  加载进度条
        if keyPath == "estimatedProgress" {
            progressView.alpha = 1.0
            progressView.setProgress(Float((self.webView.estimatedProgress)), animated: true)
            if (self.webView.estimatedProgress) >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    /// 添加进度条
    private lazy var progressView: UIProgressView = {
        self.progressView = UIProgressView.init(frame: CGRect(x: 0.0, y: 0, width: kScreenWidth, height: 1.5))
        self.progressView.tintColor = .green        // 进度条颜色
        self.progressView.trackTintColor = .white    // 进度条背景色
        return self.progressView
    }()
    
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = true
        
        let preferences = WKPreferences()
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        config.preferences = preferences
        
        let webView = WKWebView.init(frame: view.bounds, configuration: config)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webView
    }()
}
