//
//  ViewController.m
//  jifen(RAC)
//
//  Created by tmp on 16/3/10.
//  Copyright © 2016年 hxy. All rights reserved.
//

#import "ViewController.h"
#import "OnboardingViewController.h"
#import "pop.h"


#define AnimaDurtion 1

@interface ViewController ()

@end

@implementation ViewController
{
    OnboardingViewController *_animaVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self initWelcomeView];
    
}

- (void)initWelcomeView {
    
    
   
//第一页
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"Onboard" body:@"先试试好不好用吧！哈哈" image:[UIImage imageNamed:@"活动页面_分享弹窗_03"] buttonText:nil action:^{
        
    }];
    
    
    
    
//第二页
    OnboardingContentViewController *sencondPage = [OnboardingContentViewController contentWithTitle:@"RAC" body:@"ReactiveCocoa 尝试使用！" image:[UIImage imageNamed:@"活动页面_分享弹窗_07"] buttonText:nil action:^{
        
        
    }];
    
    
    
//第三页
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"MVVM" body:@"ReactiveCocoa 结合 MVVM 使用！" image:[UIImage imageNamed:@"活动页面_分享弹窗_12"] buttonText:@"start Go" action:^{
        
        [self transitionAninmation];
        
    }];

    thirdPage.buttonFontSize = 20;
    thirdPage.buttonTextColor = [UIColor flatBlueColor];
   // thirdPage.ClickBtn.backgroundColor = [UIColor flatOrangeColor];
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
    
    _animaVC = backgroundVC;
    //调整位置
    backgroundVC.topPadding = 200;
    
    [self.view addSubview:backgroundVC.view];
    
}
/**
 *  @author hxy
 *
 *  跳转动画
 *  将视图分成四部分
 */
- (void)transitionAninmation {
    
    CGFloat splitWidth =  self.view.bounds.size.width / 2.0;
    CGFloat splitHeight = self.view.bounds.size.height / 2.0;
    
    
    //将整个视图转成image(为了裁剪)
    UIImage *wholeImg = [self getImageFromView:self.view];
    
    
    UIImageView *leftView = [UIImageView new];
    leftView.frame = CGRectMake(0, 0,splitWidth, splitHeight);
    leftView.image = [UIImage imageWithCGImage:[self cutImageWithImage:wholeImg rect:leftView.frame]];
    
    
    UIImageView *rightView = [UIImageView new];
    rightView.frame = CGRectMake(splitWidth, 0, splitWidth, splitHeight);
    rightView.image = [UIImage imageWithCGImage:[self cutImageWithImage:wholeImg rect:rightView.frame]];
    
    
    UIImageView *leftBottomView = [UIImageView new];
    leftBottomView.frame = CGRectMake(0, splitHeight, splitWidth, splitHeight);
    leftBottomView.image = [UIImage imageWithCGImage:[self cutImageWithImage:wholeImg rect:leftBottomView.frame]];
   

    
    UIImageView *rightBottomView = [UIImageView new];
    rightBottomView.frame = CGRectMake(splitWidth, splitHeight, splitWidth, splitHeight);
    rightBottomView.image = [UIImage imageWithCGImage:[self cutImageWithImage:wholeImg rect:rightBottomView.frame]];
   
    UIViewController *MainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:StoryID_MainController];
//    MainVC.view.bounds = CGRectMake(0, 0, 0, 0);
    MainVC.view.alpha = 0;
    
    [self.view addSubview:MainVC.view];
    [self.view addSubview:leftView];
    [self.view addSubview:leftBottomView];
    [self.view addSubview:rightView];
    [self.view addSubview:rightBottomView];
    
    [_animaVC.view removeFromSuperview];
    [_animaVC removeFromParentViewController];
    
    POPBasicAnimation *leftAnima = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    leftAnima.toValue = [NSValue valueWithCGPoint:CGPointMake(-splitWidth/2.0,-splitHeight/2.0)];
    leftAnima.duration = AnimaDurtion;
    leftAnima.completionBlock = ^(POPAnimation *anim, BOOL finished){
        
        if (finished) {
            
            [leftView removeFromSuperview];
        }
        
    };
    
    
    POPBasicAnimation *leftBottomAnima = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    leftBottomAnima.toValue = [NSValue valueWithCGPoint:CGPointMake(- splitWidth/2.0, [UIScreen mainScreen].bounds.size.height + splitHeight /2.0)];
    leftBottomAnima.duration = AnimaDurtion;
    leftBottomAnima.completionBlock = ^(POPAnimation *anim, BOOL finished){
        
        if (finished) {
            
            [leftBottomView removeFromSuperview];
        }
        
    };
    
    
    POPBasicAnimation *rightAnima = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    rightAnima.toValue = [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width + splitWidth / 2.0,-splitHeight/2.0)];
    rightAnima.duration = AnimaDurtion;
    rightAnima.completionBlock = ^(POPAnimation *anim, BOOL finished){
        
        if (finished) {
            
            [rightView removeFromSuperview];
        }
        
    };
    
    
    POPBasicAnimation *rightBottomAnima = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    rightBottomAnima.toValue = [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width + splitWidth / 2.0,[UIScreen mainScreen].bounds.size.height + splitHeight / 2.0)];
    rightBottomAnima.duration = AnimaDurtion;
    rightBottomAnima.completionBlock = ^(POPAnimation *anim, BOOL finished){
        
        if (finished) {
            
            [rightBottomView removeFromSuperview];
        }
        
    };
    
    
    POPBasicAnimation *MainAnima = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    MainAnima.toValue = @(1);
    MainAnima.duration = AnimaDurtion;
    MainAnima.completionBlock = ^(POPAnimation *anim, BOOL finished){
        
        if (finished) {
            
            [anim pop_removeAllAnimations];
        }
        
    };
    
    
    [MainVC.view pop_addAnimation:MainAnima forKey:@"mainAnima"];
    [leftView pop_addAnimation:leftAnima forKey:@"left"];
    [leftBottomView pop_addAnimation:leftBottomAnima forKey:@"leftBottom"];
    [rightView pop_addAnimation:rightAnima forKey:@"right"];
    [rightBottomView pop_addAnimation:rightBottomAnima forKey:@"rightBottom"];

    
    
}


//将UIView转成UIImage
-(UIImage *)getImageFromView:(UIView *)theView
{
    
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//裁剪多大的图片
- (CGImageRef )cutImageWithImage:(UIImage *)wholeImg rect:(CGRect)rect{
    
    CGImageRef ref = CGImageCreateWithImageInRect(wholeImg.CGImage, rect);
    
    return ref;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
