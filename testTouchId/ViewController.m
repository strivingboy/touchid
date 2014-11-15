//
//  ViewController.m
//  testTouchId
//
//  Created by hailong on 14-8-14.
//  Copyright (c) 2014年 hailong. All rights reserved.
//

#import "ViewController.h"
#import "TouchIdUtil.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UILabel *testLable;
@property (nonatomic) NSInteger number;

- (IBAction)clickTestButton:(id)sender;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    _number = 0;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickTestButton:(id)sender
{
    [self touchIdTest];
}

- (void)resetLable:(NSString *)text
{
    [_testLable setText:text];
}

- (void)performOnUI:(NSString *)text
{
    [self performSelectorOnMainThread:@selector(resetLable:) withObject:text waitUntilDone:NO];

}

- (void)touchIdTest
{
    if ([[TouchIdUtil sharedInstance] canEvaluatePolicy]) {
        [[TouchIdUtil sharedInstance] evaluatePolicy:@"test" fallbackTitle:@"cancel" callback:^(TouchIdEvaluateResult result) {
            if (result == kTouchIdEvaluateResultSuccess) {
                NSLog(@"success!");
            } else {
                NSLog(@"failed");
            }
        }];
    }
}
@end
