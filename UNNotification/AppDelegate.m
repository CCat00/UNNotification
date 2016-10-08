//
//  AppDelegate.m
//  UNNotification
//
//  Created by 韩威 on 2016/9/29.
//  Copyright © 2016年 韩威. All rights reserved.
//

#import "AppDelegate.h"

@import UserNotifications;

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 请求使用通知
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //用户同意使用通知
        }
    }];
    
    //向APNS请求token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
    }];
    
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
}

#pragma mark - UNUserNotificationCenterDelegate

// The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
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

@end
