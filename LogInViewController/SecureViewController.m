//
//  SecureViewController.m
//
//  Created by 广州动创 on 16/4/19.
//  Copyright © 2016年 广州动创. All rights reserved.
//

#import "SecureViewController.h"
#import "Secure2ViewController.h"
#import "UIViewExt.h"
#import "MBProgressHUD.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@interface SecureViewController ()<UITextFieldDelegate>
{
    UITextField *textF;
    UITextField *textF2;
    UIButton *nextBtn;
    NSTimer *timer;
    
    NSTimer *timer2;
    NSInteger timeCount;
    UIButton *btnMsg;
}
@end

@implementation SecureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";

    self.view.backgroundColor =[UIColor whiteColor];
    
    [self creatSubViews];
}

-(void)creatSubViews{
    
    textF = [[UITextField alloc]initWithFrame:CGRectMake(30, 80, KScreenWidth-60, 50)];
    [self.view addSubview:textF];
    textF.placeholder = @"请输入手机号码";
    textF.delegate = self;
    textF.clearButtonMode = UITextFieldViewModeWhileEditing;
    textF.borderStyle = UITextBorderStyleNone;
    textF.layer.borderWidth = 1;
    textF.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 50)];
    textF.leftView = view;
    textF.leftViewMode = UITextFieldViewModeAlways;
    
    
    textF2 = [[UITextField alloc]initWithFrame:CGRectMake(30, 140, KScreenWidth-60, 50)];
    [self.view addSubview:textF2];
    textF2.placeholder = @"请输入手机号码";
    textF2.delegate = self;
    textF2.clearButtonMode = UITextFieldViewModeWhileEditing;
    textF2.borderStyle = UITextBorderStyleNone;
    textF2.layer.borderWidth = 1;
    textF2.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 50)];
    textF2.leftView = view2;
    textF2.leftViewMode = UITextFieldViewModeAlways;
    
    btnMsg = [[UIButton alloc]initWithFrame:CGRectMake(textF2.right-170, textF2.origin.y+7, 160, 36)];
    btnMsg.layer.cornerRadius = 18;
    [btnMsg setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btnMsg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMsg addTarget:self action:@selector(btnsecu1Action) forControlEvents:UIControlEventTouchUpInside];
    btnMsg.backgroundColor = [UIColor colorWithRed:0.957 green:0.306 blue:0.235 alpha:1.000];
    [self.view addSubview:btnMsg];
        

    
    nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, textF2.bottom+30, textF2.width, 44)];
    //    btn.backgroundColor = [UIColor colorWithRed:0.002 green:0.774 blue:0.003 alpha:1.000];
    nextBtn.backgroundColor = [UIColor lightGrayColor];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 7;
    [nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

}

-(void)btnsecu1Action{
    
    if (textF.text.length != 11) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确的手机号";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
    }else{
        
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        NSString *urlString = @"找回密码的网址";
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];//默认的方式
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [manager GET:urlString parameters:@{@"phone":textF.text} success:^(NSURLSessionDataTask *task, id responseObject) {
//            //数据加载完后回调.
//            NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
//                    NSLog(@"发送成功 result:%@",result);
        
        //发送网络请求，假如返回结果为1：
        
        NSString *result = @"1";
        
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            if([result isEqualToString:@"1"]){
        
                hud.labelText = @"短信已发至你手机，请注意查收！";
                timeCount = 90;
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime1:) userInfo:nil repeats:YES];
            }else if([result isEqualToString:@"0"]){
                
                hud.labelText = @"该手机未注册";
            }else
            {
                hud.labelText = @"该手机无法接收到短信,请改天再试";
            }
        
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.5];
         
//         } failure:^(NSURLSessionDataTask *task, NSError *error) {
//             //数据加载失败回调.
//             NSLog(@"发送验证失败: %@",error);
//         }];
        
    }
}

- (void)reduceTime1:(NSTimer *)codeTimer {
    timeCount--;
    if (timeCount == 0) {
        [btnMsg setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [btnMsg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *info = codeTimer.userInfo;
        info.enabled = YES;
        btnMsg.userInteractionEnabled = YES;
        [timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%lu秒后重新获取", (long)timeCount];
        [btnMsg setTitle:str forState:UIControlStateNormal];
        btnMsg.userInteractionEnabled = NO;
        
    }
}


-(void)nextBtnAction{
    
    if (nextBtn.backgroundColor != [UIColor lightGrayColor]) {
        

        //发送网络请求，假如正确比如result = @"1"
        
        NSString *result = @"1";
        
            if([result isEqualToString:@"0"]){

                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"验证码错误";
                // 隐藏时候从父控件中移除
                hud.removeFromSuperViewOnHide = YES;
                // 1秒之后再消失
                [hud hide:YES afterDelay:1.5];
            }else{
                
                Secure2ViewController *secure2VC = [[Secure2ViewController alloc]init];
                secure2VC.phone = textF.text;
                secure2VC.token = result;
                [self.navigationController pushViewController:secure2VC animated:YES];
                
            }
            
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            //数据加载失败回调.
//            NSLog(@"发送验证失败: %@",error);
//        }];
 
    }else{

        if (textF.text.length != 11) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请输入11位手机号";
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            // 1秒之后再消失
            [hud hide:YES afterDelay:1.5];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    NSLog(@"3333");
    timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(textFTime1) userInfo:nil repeats:YES];
}

-(void)textFTime1{
    if (textF.text.length > 0 && textF2.text.length > 0) {
        
        nextBtn.backgroundColor = [UIColor colorWithRed:0.002 green:0.774 blue:0.003 alpha:1.000];
        [timer2 invalidate];
    }else{
        nextBtn.backgroundColor = [UIColor lightGrayColor];
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
