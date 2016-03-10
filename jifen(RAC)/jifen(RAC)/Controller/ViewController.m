//
//  ViewController.m
//  jifen(RAC)
//
//  Created by tmp on 16/3/10.
//  Copyright © 2016年 hxy. All rights reserved.
//

#import "ViewController.h"
#import "OnboardingViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initView];
    
}

- (void)initView {
    
   
//第一页
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"Onboard" body:@"先试试好不好用吧！哈哈" image:[UIImage imageNamed:@"活动页面_分享弹窗_03"] buttonText:nil action:^{
        
    }];
    
    
    
    
//第二页
    OnboardingContentViewController *sencondPage = [OnboardingContentViewController contentWithTitle:@"RAC" body:@"ReactiveCocoa 尝试使用！" image:[UIImage imageNamed:@"活动页面_分享弹窗_07"] buttonText:nil action:^{
        
        
    }];
    
    
    
//第三页
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"MVVM" body:@"ReactiveCocoa 结合 MVVM 使用！" image:[UIImage imageNamed:@"活动页面_分享弹窗_12"] buttonText:@"start Go" action:^{
        
       
    }];

    thirdPage.buttonFontSize = 20;
    thirdPage.buttonTextColor = [UIColor flatBlueColor];
    
//底部视图
   NSString *path = [[NSBundle mainBundle] pathForResource:@"video1" ofType:@"mp4"];
    NSURL *moveUrl = [NSURL fileURLWithPath:path];
    
    OnboardingViewController *backgroundVC = [OnboardingViewController onboardWithBackgroundVideoURL:moveUrl contents:@[firstPage,sencondPage,thirdPage]];
    
    
    backgroundVC.allowSkipping = YES;
    
    
    @weakify(backgroundVC);
    backgroundVC.skipHandler = ^{
        
        @strongify(backgroundVC);
        [backgroundVC moveToLastPage];
        
        
    };
    
    
    //调整位置
    backgroundVC.topPadding = 200;
//    backgroundVC.underIconPadding = 20;
//    backgroundVC.underTitlePadding = 50;
    
    
    
    [self.view addSubview:backgroundVC.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
