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
        
        let downloadUrl = kAppdelegate?.appConfig?.webUrl ?? (kAppdelegate?.appConfig?.url ?? "http://www.chaoying.vip")
        qrcodeView.image = UIImage.createQRCode(downloadUrl, image: UIImage(named: "app_logo"), borderWidth: 0)
        view.backgroundColor = kBgColor
    }

    @IBAction func shareAction(_ sender: Any) {
//        let image = self.qrcodeView.image!
        DispatchQueue.main.async {
            let imageData = UIImage(named: "share_web")!.jpegData(compressionQuality: 1)
            let image = UIImage(data: imageData!)!

            //一个字符串
            let shareString = kAppdelegate?.appConfig?.share_content ?? "超影App, 你想看的都在这里"
            //一个URL
            let shareURL = URL(string: kAppdelegate?.appConfig?.webUrl ?? "http://www.chaoying.vip")!
            //初始化一个UIActivity
            let activity = UIActivity()
            let activityItems = [image, shareString, shareURL] as [Any]
            let activities = [activity]

            let activityVC = UIActivityViewController.init(activityItems: activityItems, applicationActivities: activities)
            //排除一些服务：例如复制到粘贴板，拷贝到通讯录
            activityVC.excludedActivityTypes = [.copyToPasteboard, .assignToContact]
            self.present(activityVC, animated: true)
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
//        let image = self.qrcodeView.image!
        let image = UIImage(named: "share")!
        
        /// 先判断相册权限是否开启
        AVCaptureSessionManager.checkAuthorizationStatusForPhotoLibrary(grant: { [weak self] in
            /// 截屏
            
            DispatchQueue.global().async {
                /// 图片保存到相册
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self!.save(image:didFinishSavingWithError:contextInfo:)), nil)
            }
            
            }, denied: { [weak self] in
                let action = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
                    let url = URL(string: UIApplication.openSettingsURLString)
                    UIApplication.shared.open(url!, options: [:], completionHandler: { (_) in
                        
                    })
                })
                let con = UIAlertController(title: "权限未开启",
                                            message: "您未开启相册权限，点击确定跳转至系统设置开启",
                                            preferredStyle: UIAlertController.Style.alert)
                con.addAction(action)
                self?.present(con, animated: true, completion: nil)
        })
    }
    
    @IBAction func copyLink(_ sender: Any) {
        let pas = UIPasteboard.general
        pas.string = kAppdelegate?.appConfig?.webUrl ?? (kAppdelegate?.appConfig?.url ?? "http://www.chaoying.vip")
        SVProgressHUD.showSuccess(withStatus: "复制成功")
        SVProgressHUD.dismiss(withDelay: 1.0)
    }
    
    @objc func save(image:UIImage, didFinishSavingWithError:NSError?,contextInfo:AnyObject) {
        if didFinishSavingWithError != nil {
            SVProgressHUD.showError(withStatus: didFinishSavingWithError?.localizedDescription)
        } else {
            SVProgressHUD.showSuccess(withStatus: "二维码已保存至手机相册")
            SVProgressHUD.dismiss(withDelay: 1.0)
        }
    }
}


extension UIImage {
    /// 根据文字和图片生成二维码
    ///
    /// - Parameters:
    ///   - text: 文本信息
    ///   - image: 头像信息,可选
    ///   - borderWidth: 头像边框线宽,默认20
    /// - Returns: 二维码图片
    public class func createQRCode(_ text: String, image: UIImage?, borderWidth: CGFloat? = 20) -> UIImage {
        // 创建过滤器
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 默认配置
        filter?.setDefaults()
        //将url加入二维码
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        //取出生成的二维码（不清晰）
        if let outputImage = filter?.outputImage {
            //生成清晰度更高的二维码
            let qrCodeImage = setupHighDefinitionUIImage(outputImage, size: 300)
            //如果有一个头像的话，将头像加入二维码中心
            if var image = image {
                //给头像加一个白色边框
                image = circleImageWithImage(image, borderWidth: 8, borderColor: UIColor.white)
                //合成图片
                let newImage = syntheticImage(qrCodeImage, iconImage: image, width: 100, height: 100)
                
                return newImage
            }
            return qrCodeImage
        }
        
        return UIImage()
    }

    //image: 二维码 iconImage:头像图片 width: 头像的宽 height: 头像的宽
    class func syntheticImage(_ image: UIImage, iconImage:UIImage, width: CGFloat, height: CGFloat) -> UIImage{
        //开启图片上下文
        UIGraphicsBeginImageContext(image.size)
        //绘制背景图片
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let x = (image.size.width - width) * 0.5
        let y = (image.size.height - height) * 0.5
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        //取出绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        //返回合成好的图片
        if let newImage = newImage {
            return newImage
        }
        return UIImage()
    }
    
    //MARK: - 生成高清的UIImage
    class func setupHighDefinitionUIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion);
        bitmapRef.draw(bitmapImage, in: integral);
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }
    
    /// 生成边框
    ///
    /// - Parameters:
    ///   - sourceImage: 目标图片
    ///   - borderWidth: 边框宽度
    ///   - borderColor: 边框颜色
    ///   - borderRadius: 边框圆角半径
    /// - Returns: 添加边框后的图片
    class func circleImageWithImage(_ sourceImage: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        let imageWidth = sourceImage.size.width + 2 * borderWidth
        let imageHeight = sourceImage.size.height + 2 * borderWidth
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
        UIGraphicsGetCurrentContext()
        
        let radius = (sourceImage.size.width < sourceImage.size.height ? sourceImage.size.width:sourceImage.size.height) * 0.5
        
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: imageWidth * 0.5, y: imageHeight * 0.5), radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        bezierPath.lineWidth = borderWidth
        borderColor.setStroke()
        bezierPath.stroke()
        bezierPath.addClip()
        sourceImage.draw(in: CGRect(x: borderWidth, y: borderWidth, width: sourceImage.size.width, height: sourceImage.size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
