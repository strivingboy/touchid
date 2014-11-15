//
//  TouchIdUtil.h
//  testTouchId
//
//  Created by hailong on 14-9-25.
//  Copyright (c) 2014年 hailong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TouchIdEvaluateResult)
{
    kTouchIdEvaluateResultSuccess,   // 验证成功
    kTouchIdEvaluateResultFailed,    // 验证失败
    kTouchIdEvaluateResultCancel,    // 点击取消按钮
    kTouchIdEvaluateResultFallback,  // 点击回退按钮
    kTouchIdEvaluateResultOther      // 未知结果
};

@interface TouchIdUtil : NSObject


typedef void(^TouchIdEvaluateCallback)(TouchIdEvaluateResult result);

+ (instancetype)sharedInstance;

// touch id 是否开启或设置
- (BOOL)canEvaluatePolicy;

// touch id 验证 callback回调已经抛到了主线程
- (void)evaluatePolicy:(NSString *)localizedReasion
         fallbackTitle:(NSString *)title
              callback:(TouchIdEvaluateCallback)cb;

@end
