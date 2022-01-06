//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#ifndef fvideo_Briding_Header_h
#define fvideo_Briding_Header_h

//修复打印不完整，打印中文显示Unicode码问题
#ifndef __OPTIMIZE__
#define NSLog(FORMAT, ...)  fprintf(stderr, "%s [%s-%d] %s\n", [[[NSDate date] descriptionWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans_US"]] UTF8String], [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[[NSString alloc] initWithData:[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding] UTF8String]?[[[NSString alloc] initWithData:[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding] UTF8String]:[[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

/// 极光推送
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

/// 友盟
#import <UMCommon/UMCommon.h>
/// 穿山甲
#import <BUAdSDK/BUAdSDK.h>

#import "SignUtil.h"
#import "ProxyCheck.h"
#import "UIViewController+ChangeAppIcon.h"

#import "VTMagic.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
//#import "MBProgressHUD+ATAdd.h"
#import "BaseDataQueue.h"
#import "AVSearchDataQueueOC.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

#import "Headers.h"
#endif /* fvideo_Briding_Header_h */
