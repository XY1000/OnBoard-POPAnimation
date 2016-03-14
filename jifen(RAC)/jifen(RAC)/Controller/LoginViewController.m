//
//  LoginViewController.m
//  jifenRAC
//
//  Created by tmp on 16/3/14.
//  Copyright © 2016年 hxy. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *dotIMG;

@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
}


- (void)initData {
    
    self.userName.layer.borderColor = [UIColor flatRedColor].CGColor;
    self.password.layer.borderColor = [UIColor flatRedColor].CGColor;
    
    //无效时 边框颜色为红色
    [[self.userName.rac_textSignal
      
     filter:^BOOL(NSString* value) {
       
         return value.length >0;
         
     }]
     subscribeNext:^(NSString* x) {
       
       
         self.userName.layer.borderWidth = [self isValidUserNameWithStr:x] ? 0:1;
        
    }];
 
    [[self.password.rac_textSignal
      
        filter:^BOOL(NSString* value) {
            return value.length > 0;
        }]
     
        subscribeNext:^(NSString* x) {
           
            self.password.layer.borderWidth = [self isValidPasswordWithPass:x] ? 0:1;
            
        }];
    
    RACSignal *ValidNameSign = [self.userName.rac_textSignal
                                
                                map:^id(NSString* text) {
                                    
                                    return @([self isValidUserNameWithStr:text]);
                                }];
    
    RACSignal *ValidPassSignal = [self.password.rac_textSignal
                                  map:^id(NSString* value) {
                                      
                                      return @([self isValidPasswordWithPass:value]);
                                  }];
 
    //登录按钮是否可点击
    RAC(self.loginBtn,enabled) = [RACSignal combineLatest:@[ValidNameSign,ValidPassSignal]
                                                   reduce:^id(NSNumber* isName,NSNumber* isPassord){
        
        
        return @(isName.boolValue && isPassord.boolValue);
        
    }];
    //登陆按钮背景颜色
    RAC(self.loginBtn,backgroundColor) = [RACSignal combineLatest:@[ValidNameSign,ValidPassSignal]
                                                           reduce:^id(NSNumber* isName,NSNumber* isPassord){
        
        
                                                               return (isName.boolValue && isPassord.boolValue)?[UIColor flatRedColor]:[UIColor flatGrayColor];
        
    }];
    //登录按钮的点击事件
    [[[[self.loginBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)]
     
     doNext:^(id x) {
         
         self.loginBtn.enabled = YES;
     }]
     
    flattenMap:^RACStream *(id value) {
        
        return [self loginWithName:self.userName.text pass:self.password.text];
    }]
     subscribeNext:^(id x) {
         self.loginBtn.enabled = NO;
        NSLog(@"btnclisck = %@",x);
     }];
    
    
    
}
//验证用户名
- (BOOL)isValidUserNameWithStr:( NSString * _Nonnull )name {
    
    
    return (name.length > 1) && (name.length < 6);
}
//验证密码
- (BOOL)isValidPasswordWithPass:(NSString * _Nonnull)password {
    
    return password.length >= 6;
}
//验证密码和用户名（发送网络请求）
- (RACSignal *)loginWithName:(NSString *)name pass:(NSString *)password{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [self loginWithName:name pass:password success:^{
           
            [subscriber sendNext:@"success"];
            [subscriber sendCompleted];
        } fail:^(NSError *error) {
            
           // [subscriber sendError:error];
            NSLog(@"error = %@",error.userInfo[@"errmsg"]);
        }];
        return nil;
    }];
}
//假设的网络请求
- (void)loginWithName:(NSString *)name pass:(NSString *)password success:(void(^)())success fail:(void(^)(NSError*))fail{
    
    if ([name isEqualToString:@"hxy"]&&[password isEqualToString:@"123456"]) {
        
        success();
    }else{
        NSError *err = [NSError errorWithDomain:@"fail" code:1 userInfo:@{
                                                                          @"errmsg":@"假设的网络请求失败"
                                                                          }];
        fail(err);
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
