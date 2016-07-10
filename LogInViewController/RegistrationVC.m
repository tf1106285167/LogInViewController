//
//  RegistrationVC.m
//
//  Created by 广州动创 on 16/4/20.
//  Copyright © 2016年 广州动创. All rights reserved.
//

#import "RegistrationVC.h"
#import "UIViewExt.h"
#import "MBProgressHUD.h"
#import "WXDataService.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@interface RegistrationVC ()<UITextFieldDelegate>
{
    UIButton *btn;
    NSTimer *timer;
    NSTimer *timer2;
    NSInteger timeCount;
    UIButton *registeBtn;
}
@end

@implementation RegistrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatRegistSubviews];
    
}

-(void)creatRegistSubviews{
    
    NSArray *arr = @[@"手机号码",@"密码",@"验证码",@"推荐人手机(可选)"];
    for (int i=0; i<arr.count; i++) {
        
        UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(30, 80+i*60, KScreenWidth-60, 50)];
        [self.view addSubview:textF];
        textF.placeholder = arr[i];
        textF.delegate = self;
        textF.tag = 100+i;
        textF.clearButtonMode = UITextFieldViewModeWhileEditing;
//        textF.borderStyle = UITextBorderStyleRoundedRect;
        textF.borderStyle = UITextBorderStyleNone;
        textF.layer.borderWidth = 1;
        textF.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 50)];
        textF.leftView = view;
        textF.leftViewMode = UITextFieldViewModeAlways;
        
        if (i == 2) {
            
            btn = [[UIButton alloc]initWithFrame:CGRectMake(textF.right-170, textF.origin.y+7, 160, 36)];
            btn.layer.cornerRadius = 18;
            [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor colorWithRed:0.957 green:0.306 blue:0.235 alpha:1.000];
            [self.view addSubview:btn];
        }else if(i == 1){
            textF.secureTextEntry = YES;
        }
    }
    
    UITextField *textF = [self.view viewWithTag:100+arr.count-1];
    registeBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, textF.bottom+30, textF.width, 44)];
    [registeBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registeBtn.backgroundColor = [UIColor lightGrayColor];
    registeBtn.layer.cornerRadius = 7;
    [registeBtn addTarget:self action:@selector(registeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registeBtn];
    
}

-(void)registeBtnAction{
    
    if (registeBtn.backgroundColor != [UIColor lightGrayColor]) {
        
        NSLog(@"注册Yes");
        UITextField *textF = [self.view viewWithTag:100];
        UITextField *textF2 = [self.view viewWithTag:101];
        UITextField *textF3 = [self.view viewWithTag:102];
        UITextField *textF4 = [self.view viewWithTag:103];
        
        if (textF.text.length != 11) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"手机号码格式有误,请重新填写";
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            // 1秒之后再消失
            [hud hide:YES afterDelay:1.5];
        }else if(textF2.text.length < 6){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请输入不少于6位数的密码";
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            // 1秒之后再消失
            [hud hide:YES afterDelay:1.5];

        }else{
            
//            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
#warning 请输入注册调用的网址
            
//            NSString *urlString = @"注册调用的网址";
//            
//            manager.requestSerializer = [AFHTTPRequestSerializer serializer];//默认的方式
//            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//            
//            //vcode:验证码       frecommendCode：推荐人手机(可选)
//            NSDictionary *params;
//            if (textF4.text == nil) {
//                params = @{@"fphone":textF.text,@"fpassword":textF2.text,@"vcode":textF3.text};
//            }
//            else{
//                params = @{@"fphone":textF.text,@"fpassword":textF2.text,@"frecommendCode":textF4.text,@"vcode":textF3.text};
//            }
//
//            [manager GET:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//                //数据加载完后回调.
//                NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
            
            //发送网络请求，假如返回结果为 result = @"1";
            NSString *result = @"1";
            
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                if ([result isEqualToString:@"-1"]) {
                    hud.labelText = @"验证码不正确";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1.5];
                }else if([result isEqualToString:@"0"]){
                    hud.labelText = @"该手机号已被注册";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1.5];
                }else{

                    [self registerSuccess];//注册成功后调用
                }
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                //数据加载失败回调.
//                NSLog(@"发送验证码失败: %@",error);
//            }];
        }
    

    
        
    }else{
        NSLog(@"注册NO");
    }
}

//注册成功
-(void)registerSuccess{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"注册成功!";
    hud.detailsLabelText = @"正在为您登录...";
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hide:YES afterDelay:4];
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
}

-(void)delayMethod{
    
    NSDictionary *resultDiction = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"loginState", nil];
    [[NSUserDefaults standardUserDefaults] setObject:resultDiction forKey:@"ResultAuthData"];
    //保存数据，实现持久化存储
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)btnAction{
    
    UITextField *textF = [self.view viewWithTag:100];
    if (textF.text.length != 11) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确的手机号";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 1秒之后再消失
        [hud hide:YES afterDelay:1.5];
    }else{
        
        //发送网络请求，假如返回为1：
        NSString *result = @"1";
        
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            if([result isEqualToString:@"1"]){
                hud.labelText = @"短信已发至你手机，请注意查收！";
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:nil repeats:YES];
                timeCount = 90;
            }else if([result isEqualToString:@"0"]){
                
                hud.labelText = @"该手机未注册";
            }else{
                hud.labelFont = [UIFont systemFontOfSize:16];
                hud.labelText = @"该手机无法接收到短信,请改天再试";
            }
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            // 1秒之后再消失
            [hud hide:YES afterDelay:1.5];
    
    }
    
}


- (void)reduceTime:(NSTimer *)codeTimer {
    timeCount--;
    if (timeCount == 0) {
        [btn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *info = codeTimer.userInfo;
        info.enabled = YES;
        btn.userInteractionEnabled = YES;
        [timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%lu秒后重新获取", (long)timeCount];
        [btn setTitle:str forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(textFTime1) userInfo:nil repeats:YES];
    
}

-(void)textFTime1{
    
    UITextField *textF = [self.view viewWithTag:100];
    UITextField *textF2 = [self.view viewWithTag:101];
    UITextField *textF3 = [self.view viewWithTag:102];
    
    if (textF.text.length > 0 && textF2.text.length > 0 && textF3.text.length > 0) {
        
        registeBtn.backgroundColor = [UIColor colorWithRed:0.002 green:0.774 blue:0.003 alpha:1.000];
        [timer2 invalidate];
        
    }else{
        registeBtn.backgroundColor = [UIColor lightGrayColor];
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
