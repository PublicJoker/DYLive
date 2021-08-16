//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

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
