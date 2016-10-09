//
//  AppDelegate.m
//  UNNotification
//
//  Created by 韩威 on 2016/9/29.
//  Copyright © 2016年 韩威. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>

@import UserNotifications;

@interface AppDelegate () <UNUserNotificationCenterDelegate, JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //MARK:集成激光推送-测试APNs
    
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    //Required
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
//        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//    }
//    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
//    }
//    else {
//        //categories 必须为nil
//        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                          UIRemoteNotificationTypeSound |
//                                                          UIRemoteNotificationTypeAlert)
//                                              categories:nil];
//    }
    
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
//    [JPUSHService setupWithOption:launchOptions appKey:@"ec8c0504fcc110ad63ab206a"
//                          channel:@"channel"
//                 apsForProduction:NO
//            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
//    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        if(resCode == 0){
//            NSLog(@"registrationID获取成功：%@",registrationID);
//            
//        }
//        else{
//            NSLog(@"registrationID获取失败，code：%d",resCode);
//        }
//    }];


    
    // 请求使用通知
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //用户同意使用通知
        }
    }];
    
//    //向APNS请求token
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//    
//    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//    }];
    
    // 设置代理
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
    
    /**
     设置通知上面的交互按钮
     UNNotificationActionOptionAuthenticationRequired //操作这个按钮会先检查iPhone是否解锁
     UNNotificationActionOptionDestructive //按钮会被高亮标记（红色）
     UNNotificationActionOptionForeground // 点击按钮会将APP唤起
     */
    
    UNNotificationAction *unlocking = [UNNotificationAction actionWithIdentifier:@"unlocking"
                                                                           title:@"unlocking"
                                                                         options:UNNotificationActionOptionAuthenticationRequired];
    UNNotificationAction *destructive = [UNNotificationAction actionWithIdentifier:@"destructive"
                                                                             title:@"destructive"
                                                                           options:UNNotificationActionOptionDestructive];
    UNNotificationAction *foreground = [UNNotificationAction actionWithIdentifier:@"foreground"
                                                                            title:@"foreground"
                                                                          options:UNNotificationActionOptionForeground];
    UNTextInputNotificationAction *input = [UNTextInputNotificationAction actionWithIdentifier:@"text" title:@"text" options:UNNotificationActionOptionAuthenticationRequired textInputButtonTitle:@"text_btn" textInputPlaceholder:@"placeholder"];
    // 注意：这里的category的标示如果和发送通知时，写的category标示不一样的时候，发过来的通知不会显示action！！！发送通知的时候可以不写标示。
    // 我这里是，两边都写得 “ceshi”
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"ceshi"
                                                                              actions:@[unlocking, destructive, foreground, input] intentIdentifiers:@[@""]
                                                                              options:UNNotificationCategoryOptionNone];
    
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObject:category]];
     
    
    return YES;
}

//请求token成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];

}

#pragma mark -
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    // 用户在前台使用APP的时候，收到通知，会调用此方法.
    // 写这个回调代表，会在APP打开的情况下，弹出通知。
    // 如果不复写次方法，或者`completionHandler();`，APP在前台收到通知将不会弹出提示。
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    //当用户是通过和通知的交互进入app的时候，拿到通知对象。
    UNNotificationContent *content = response.notification.request.content;
    
    if ([content.categoryIdentifier isEqualToString:@"ceshi"]) {
        
        if ([response.actionIdentifier isEqualToString:@"text"]) {
            UNTextInputNotificationResponse *textResp = (UNTextInputNotificationResponse *)response;
            NSLog(@"输入文字的内容是%@", textResp.userText);
        }
        else if ([response.actionIdentifier isEqualToString:@"unlocking"]) {
            NSLog(@"unlocking");
        }
        else if ([response.actionIdentifier isEqualToString:@"destructive"]) {
            NSLog(@"destructive");
        }
        else if ([response.actionIdentifier isEqualToString:@"foreground"]) {
            NSLog(@"foreground");
        }
    }
    
    completionHandler();
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
        
        /*iOS10 收到远程通知:{
            "_j_msgid" = 1668454052;
            aps =     {
                alert =         {
                    body = "this is body";
                    subtitle = "this is subtitle";
                    title = "this is title";
                };
                badge = 1;
                category = ceshi;
                sound = default;
            };
            key1 = value1;
            key2 = value2;
        }*/
        
        /*
        2016-10-09 11:46:42.993689 UNNotification[935:284200] iOS10 前台收到远程通知:{
            "_j_msgid" = 2563223881;
            aps =     {
                alert =         {
                    body = "this is body";
                    subtitle = "this is subtitle";
                    title = "this is title";
                };
                badge = 1;
                category = ceshi;
                "mutable-content" = 1;
                sound = default;
            };
            image = "attachment_pic";
            key1 = value1;
            key2 = value2;
        }
        */
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


@end
