//
//  AVCaptureSessionManager.swift
//  ZZYQRCodeSwift
//
//  Created by 张泽宇 on 2017/5/23.
//  Copyright © 2017年 zzy. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

typealias SuccessBlock = (String?) -> Void
typealias GrantBlock = () -> Void
typealias DeniedBlock = () -> Void

class AVCaptureSessionManager: AVCaptureSession, AVCaptureMetadataOutputObjectsDelegate {

    private lazy var device: AVCaptureDevice? = {
       return AVCaptureDevice.default(for:.video)
    }()
    
    private lazy var preViewLayer: AVCaptureVideoPreviewLayer = {
        return AVCaptureVideoPreviewLayer(session: self)
    }()
    
    /// 监测相机权限
    ///
    /// - Parameters:
    ///   - grant: 同意回调
    ///   - denied: 拒绝回调
    class func checkAuthorizationStatusForCamera(grant:@escaping GrantBlock, denied:DeniedBlock) {
        let availableDevices = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        if availableDevices.count > 0 {
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    if granted {
                        DispatchQueue.main.async(execute: {
                            grant()
                        })
                    }
                })
            case .authorized:
                grant()
            case .denied:
                denied()
            default:
                break
            }
        }
    }
    
    /// 监测相册权限
    ///
    /// - Parameters:
    ///   - grant: 同意回调
    ///   - denied: 拒绝回调
    class func checkAuthorizationStatusForPhotoLibrary(grant:@escaping GrantBlock, denied:DeniedBlock) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async(execute: {
                        grant()
                    })
                }
            })
            
        case .authorized:
            grant()
        case .denied:
            denied()
        default:
            break
        }
    }
}
