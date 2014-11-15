//
//  TouchIdUtil.m
//  testTouchId
//
//  Created by hailong on 14-9-25.
//  Copyright (c) 2014年 hailong. All rights reserved.
//

#import "TouchIdUtil.h"
#import <LocalAuthentication/LocalAuthentication.h>


@implementation TouchIdUtil

+ (instancetype)sharedInstance
{
    static TouchIdUtil* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TouchIdUtil alloc] init];
    });
    return instance;
}

- (BOOL)canEvaluatePolicy
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    return [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
}

- (void)evaluatePolicy:(NSString *)localizedReasion
         fallbackTitle:(NSString *)title
              callback:(TouchIdEvaluateCallback)cb
{
    LAContext *context = [[LAContext alloc] init];
    if (title) {
        context.localizedFallbackTitle = title;
    }
    
    NSString *myLocalizedReasonString = localizedReasion;
    __weak typeof (self) weakSelf = self;
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
             localizedReason:myLocalizedReasonString
                       reply:
     ^(BOOL succes, NSError *error) {
         if (succes) {
             [[weakSelf class] reportResultOnUI:kTouchIdEvaluateResultSuccess callback:cb];
         } else {
             switch (error.code) {
                 case LAErrorAuthenticationFailed:
                     [[weakSelf class] reportResultOnUI:kTouchIdEvaluateResultFailed callback:cb];
                     break;
                 case LAErrorUserCancel:
                     [[weakSelf class] reportResultOnUI:kTouchIdEvaluateResultCancel callback:cb];
                     break;
                 case LAErrorUserFallback:
                     [[weakSelf class] reportResultOnUI:kTouchIdEvaluateResultFallback callback:cb];
                     break;
                 default:
                     [[weakSelf class] reportResultOnUI:kTouchIdEvaluateResultOther callback:cb];
                     break;
             }
         }
     }];
}

+ (void)reportResultOnUI:(TouchIdEvaluateResult)result callback:(TouchIdEvaluateCallback)cb
{
    dispatch_async(dispatch_get_main_queue(), ^{
        cb(result);
    });
}

@end