//
//  NotificationViewController.m
//  contentExtension
//
//  Created by 韩威 on 2016/10/9.
//  Copyright © 2016年 韩威. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = @"这是自定义的label";//notification.request.content.body;
}

@end
