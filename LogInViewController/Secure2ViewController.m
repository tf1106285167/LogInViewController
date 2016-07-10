//
//  Secure2ViewController.m
//
//  Created by 广州动创 on 16/4/19.
//  Copyright © 2016年 广州动创. All rights reserved.
//

#import "Secure2ViewController.h"
#import "UIViewExt.h"
#import "WXDataService.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@interface Secure2ViewController ()<UITextFieldDelegate>
{
    UIButton *btn;
    NSTimer *timer2;
    UIButton *confineBtn;
}
@end

@implementation Secure2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatSubviews];
}

-(void)creatSubviews{
    
//    NSArray *arr = @[@"验证码",@"输入新密码",@"确认密码"];
     NSArray *arr = @[@"输入新密码",@"确认密码"];
    for (int i=0; i<arr.count; i++) {
        
        UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(30, 80+i*70, KScreenWidth-60, 50)];
        [self.view addSubview:textF];
        textF.placeholder = arr[i];
        textF.delegate = self;
        textF.tag = 100+i;
        textF.clearButtonMode = UITextFieldViewModeWhileEditing;
        textF.secureTextEntry = YES;
//        textF.borderStyle = UITextBorderStyleRoundedRect;
        textF.borderStyle = UITextBorderStyleNone;
        textF.layer.borderWidth = 1;
        textF.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 50)];
        textF.leftView = view;
        textF.leftViewMode = UITextFieldViewModeAlways;
    }
    
    UITextField *textF = [self.view viewWithTag:100+arr.count-1];
    confineBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, textF.bottom+30, textF.width, 44)];
    [confineBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [confineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confineBtn.backgroundColor = [UIColor lightGrayColor];
    confineBtn.layer.cornerRadius = 7;
    [confineBtn addTarget:self action:@selector(confineAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confineBtn];
    
}

-(void)confineAction{
    
    
    if (confineBtn.backgroundColor != [UIColor lightGrayColor]) {
        
        UITextField *textF1 = [self.view viewWithTag:100];
        UITextField *textF2 = [self.view viewWithTag:101];
//        UITextField *textF3 = [self.view viewWithTag:102];
#pragma mark - 密码
        if ([textF2.text isEqualToString:textF1.text]) {
            //发送请求
//            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//            NSString *urlString = @"修改密码调用的网址";
//            manager.requestSerializer = [AFHTTPRequestSerializer serializer];//默认的方式
//            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//            
//            [manager GET:urlString parameters:@{@"phone":_phone,@"password":textF2.text,@"token":_token} success:^(NSURLSessionDataTask *task, id responseObject) {
//                //数据加载完后回调.
//                NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
//                NSLog(@"登录成功 result:%@",result);
            
            //发送网络请求，假设返回结果为result = @"1"
            
                NSString *result = @"1";
            
                if([result isEqualToString:@"1"]){
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"密码修改成功";
                    // 隐藏时候从父控件中移除
                    hud.removeFromSuperViewOnHide = YES;
                    // 1秒之后再消失
                    [hud hide:YES afterDelay:1.5];
                    
                    [self performSelector:@selector(delaySecureAction) withObject:nil afterDelay:2];
                };
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                //数据加载失败回调.
//                NSLog(@"密码修改失败: %@",error);
//            }];

            
        }else{
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"两次密码输入不一致";
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            // 1秒之后再消失
            [hud hide:YES afterDelay:1.5];
        }
        
        NSLog(@"确认修改Yes");
    }else{
         NSLog(@"确认修改NO");
    }
}

-(void)delaySecureAction{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"6666");
    
    timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(textFTime1) userInfo:nil repeats:YES];
   
}

-(void)textFTime1{
    
    UITextField *textF = [self.view viewWithTag:100];
    UITextField *textF2 = [self.view viewWithTag:101];
    
    if (textF.text.length > 0 && textF2.text.length > 0) {
        
        confineBtn.backgroundColor = [UIColor colorWithRed:0.002 green:0.774 blue:0.003 alpha:1.000];
        [timer2 invalidate];
        
    }else{
        confineBtn.backgroundColor = [UIColor lightGrayColor];
    }

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    if (self.isViewLoaded && !self.view.window) {
        
        self.view = nil;
    }
}

@end
