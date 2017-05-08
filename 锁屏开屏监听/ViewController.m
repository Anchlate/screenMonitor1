//
//  ViewController.m
//  锁屏开屏监听
//
//  Created by Qianrun on 16/7/7.
//  Copyright © 2016年 qianrun. All rights reserved.
//

#import "ViewController.h"

#include <notify.h>


bool screenLocked;
bool isScreenLocked;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //锁屏
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, handleLockStateNotification, CFSTR("com.apple.springboard.lockstate"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, handleDisplayStatusNotification, CFSTR("com.apple.iokit.hid.displayStatus"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

static void handleLockStateNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    uint64_t state;
    int token;
    notify_register_check("com.apple.springboard.lockstate", &token);
    notify_get_state(token, &state);
    notify_cancel(token);
    if ((uint64_t)1 == state)
    {
        isScreenLocked = true;
    }
    else
    {
        screenLocked = false;
        isScreenLocked = false;
    }
}

static void handleDisplayStatusNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    if (userInfo)
    {
        CFShow(userInfo);
    }
    uint64_t state;
    int token;
    notify_register_check("com.apple.iokit.hid.displayStatus", &token);
    notify_get_state(token, &state);
    notify_cancel(token);
    if ((uint64_t)1 == state)
    {
        screenLocked = true;
    }
    else
    {
        screenLocked = false;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
