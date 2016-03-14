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
    
    [self injected];
}

- (void)injected {
    
    RACSignal *ValidNameSign = [self.userName.rac_textSignal
                                       map:^id(NSString* text) {
                                           
                                           return @([self isValidUserNameWithStr:text]);
                                       }];
    
    RACSignal *ValidPassSignal = [self.password.rac_textSignal
                                        map:^id(NSString* value) {
                                            
                                            return @([self isValidPasswordWithPass:value]);
                                        }];
    
    RAC(self.loginBtn,enabled) = [RACSignal combineLatest:@[ValidNameSign,ValidPassSignal] reduce:^id(NSNumber* isName,NSNumber* isPassord){
        
        
        return @(isName.boolValue && isPassord.boolValue);
        
    }];
    
    
}

- (void)initData {
    
    
    
    
}

- (BOOL)isValidUserNameWithStr:( NSString * _Nonnull )name {
    
    
    return (name.length > 1) && (name.length < 6);
}

- (BOOL)isValidPasswordWithPass:(NSString * _Nonnull)password {
    
    return password.length >= 6;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
