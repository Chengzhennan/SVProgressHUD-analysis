//
//  ViewController.m
//  SVProgress源码解析
//
//  Created by Mac on 2017/8/7.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ViewController.h"
#import <SVProgressHUD.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
 
    [super viewDidLoad];

//    [SVProgressHUD setFadeOutAnimationDuration:8.0];
    
    //在源码中添加了  [_backgroundRadialGradientLayer setNeedsDisplay];
    //如果不添加 设置了SVProgressHUDMaskTypeGradient 之后没有效果
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD show];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [SVProgressHUD dismissWithDelay:3.0];
}

@end
