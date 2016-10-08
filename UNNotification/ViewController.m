//
//  ViewController.m
//  UNNotification
//
//  Created by 韩威 on 2016/9/29.
//  Copyright © 2016年 韩威. All rights reserved.
//

#import "ViewController.h"
@import UserNotifications;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%s, %d", __func__ ,__LINE__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    // 创建通知
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"这是一条通知的标题";
    content.body = @"这是一条通知的内容";
    content.categoryIdentifier = @"ceshi";
    
    // 创建发送触发
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    // 发送请求标识符
    NSString *identifier = @"com.hanwei.firstNotificationIndentifier";
    
    // 创建一个通知请求
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    
    // 将请求添加到通知中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"通知添加成功");
        }
    }];
    
//    // 不管通知是否已经展示过，都可以根据标示进行通知的更新
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
////        NSLog(@"两秒钟后更新通知内容");
//        
//        // 创建发送触发
//        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
//        
//        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//        content.title = @"这是一条通知的标题";
//        content.body = @"这是新的内容😀";
//        content.categoryIdentifier = @"ceshi";
//        
//        // 创建一个通知请求
//        // 同一个标示的话就会覆盖之前的通知
//        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
//        
//        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
//            if (!error) {
//                NSLog(@"新的通知添加成功");
//            }
//        }];
//    });
    
    
//    // 移除展示过的通知
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[identifier]];
//        
//    });
//    
//     //移除还未展示的通知
//    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[identifier]];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
