//
//  ViewController.m
//  LogInViewController
//
//  Created by TuFa on 16/7/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "SecureViewController.h"
#import "RegistrationVC.h"
#import "UIViewExt.h"
#import "WXDataService.h"

#define imageHeight KScreenWidth*(259.0/640)
#define MainURL  @"http://m.zlifan.com/"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height



@interface ViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIButton *btnLogIn;
    NSTimer *timer;
    NSString *stateString;
    NSArray *arrM;
    UIButton *midBtn;
    UIView *midV;
    UINavigationBar *navBar;
    UIScrollView *scorllV;
}


@end

@implementation ViewController

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    [navBar removeFromSuperview];
    [timer invalidate];
    timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    stateString = @"0";
    self.title = @"登录界面";
    
    scorllV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    CGFloat scrollH = KScreenHeight;
    if (KScreenHeight <= 568) {

        scrollH = 600;
    }
    [self.view addSubview:scorllV];
    scorllV.contentSize = CGSizeMake(KScreenWidth, scrollH);
    scorllV.delegate = self;
    
    [self creatSubViews];
}

-(void)creatSubViews{
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 00, KScreenWidth, imageHeight)];
    [imgV setImage:[UIImage imageNamed:@"001.jpg"]];
    [scorllV addSubview:imgV];
    
    NSArray *arr = @[@"手机号码",@"密码",@"请输入验证码"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"ResultAuthData"];
    NSString *loginState= [NSString stringWithFormat:@"%@",dic[@"loginState"]];
    NSString *phone= [NSString stringWithFormat:@"%@",dic[@"phone"]];
    NSString *secure= [NSString stringWithFormat:@"%@",dic[@"secure"]];
    NSString *loginCode = [NSString stringWithFormat:@"%@",dic[@"loginCode"]];
    
    for (int i=0; i<arr.count; i++) {
        
        UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(30, imageHeight+20+i*60, KScreenWidth-60, 50)];
        [scorllV addSubview:textF];
        textF.placeholder = arr[i];
        textF.delegate = self;
        textF.tag = 100+i;
        textF.clearButtonMode = UITextFieldViewModeWhileEditing;
        textF.borderStyle = UITextBorderStyleNone;
        textF.layer.borderWidth = 1;
        textF.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 50)];
        textF.leftView = view;
        textF.leftViewMode = UITextFieldViewModeAlways;
        
        
        if ([loginState isEqualToString:@"1"]) {
            if (i == 0) {
                textF.text = phone;
            }else if(i == 1){
                textF.text = secure;
            }
        }
        
        
        if(i == 1){
            
            textF.secureTextEntry = YES;
        }else if(i == 2){
            
            textF.width = KScreenWidth-180;
            UIButton *imgBtn = [[UIButton alloc]initWithFrame:CGRectMake(textF.right, textF.origin.y, 120, 50)];
            [imgBtn addTarget:self action:@selector(imgBtnAction) forControlEvents:UIControlEventTouchUpInside];
            imgBtn.backgroundColor = [UIColor lightGrayColor];
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 50)];
            imgV.tag = 230;
            [imgBtn addSubview:imgV];
            NSString *urlImg = [NSString stringWithFormat:@"%@api/validateCode",MainURL];
            [imgV setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImg]]]];
            [scorllV addSubview:imgBtn];
            
            if ([loginCode isEqualToString:@"dc1035Zlifan"]) {
                
                textF.text = loginCode;
            }else{
                textF.text = @"";
            }
            
            if ([loginState isEqualToString:@"1"]) {
                
                [self btnAction]; //记住密码后，自动登录
            }
        }
    }
    UITextField *textF3 = [scorllV viewWithTag:102];
    btnLogIn = [[UIButton alloc]initWithFrame:CGRectMake(30, textF3.bottom+15, KScreenWidth-60, 44)];
    btnLogIn.backgroundColor = [UIColor lightGrayColor];
    [btnLogIn setTitle:@"登录" forState:UIControlStateNormal];
    btnLogIn.layer.cornerRadius = 7;
    [btnLogIn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [scorllV addSubview:btnLogIn];
    
    UIButton *btn12 = [[UIButton alloc]initWithFrame:CGRectMake(32, btnLogIn.bottom+22, 16, 16)];
    btn12.layer.borderWidth = 1;
    btn12.layer.borderColor = [[UIColor grayColor]CGColor];
    btn12.layer.cornerRadius = 2;
    btn12.tag = 750;
    if([loginState isEqualToString:@"1"]){
        btn12.selected = YES;
        btn12.layer.borderWidth = 0;
        stateString = @"1";
    }
    [btn12 addTarget:self action:@selector(btnAction12:) forControlEvents:UIControlEventTouchUpInside];
    [btn12 setBackgroundImage:[UIImage imageNamed:@"dc.png"] forState:UIControlStateSelected];
    [scorllV addSubview:btn12];
    
    UILabel *label12 = [[UILabel alloc]initWithFrame:CGRectMake(btn12.right+7, btnLogIn.bottom+15, 120, 30)];
    label12.text = @"1周内自动登录";
    label12.textColor = [UIColor grayColor];
    [scorllV addSubview:label12];
    
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-120, btnLogIn.bottom+15, 90, 30)];
    [btn2 setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnAction2) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [scorllV addSubview:btn2];
    
    //注册装立方
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/2-60, btnLogIn.bottom+60, 120, 40)];
    [btn3 setTitle:@"用户注册" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:16];
    btn3.layer.borderWidth = 1;
    btn3.layer.borderColor = [[UIColor redColor]CGColor];
    btn3.layer.cornerRadius = 20;
    [btn3 addTarget:self action:@selector(btnAction3) forControlEvents:UIControlEventTouchUpInside];
    [scorllV addSubview:btn3];
    
}

//获取验证码
-(void)imgBtnAction{
    
    UIImageView *imgV = [scorllV viewWithTag:230];
    NSString *urlImg = [NSString stringWithFormat:@"%@api/validateCode",MainURL];
    [imgV setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImg]]]];
}

-(void)btnAction12:(UIButton *)btn12{
    
    btn12.selected = !btn12.selected;
    if (btn12.selected) {
        btn12.layer.borderWidth = 0;
        stateString = @"1";
    }else{
        btn12.layer.borderWidth = 1;
        stateString = @"0";
    }
}

-(void)btnAction{
    
    UITextField *textF1 = [scorllV viewWithTag:100];
    UITextField *textF2 = [scorllV viewWithTag:101];
    UITextField *textF3 = [scorllV viewWithTag:102];
    
    if (btnLogIn.backgroundColor != [UIColor lightGrayColor]) {
        
        if (textF1.text.length != 11) {
            
            if (textF1.text) {
                
                textF1.text = @"";
                textF2.text = @"";
            }
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"手机号码格式有误,请重新填写";
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            // 1秒之后再消失
            [hud hide:YES afterDelay:1.5];
        }else{
            
            // 参数 phone手机号码 password密码 vcode验证码
//            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//            NSString *urlString = @"请输入登录时的网址";
//            manager.requestSerializer = [AFHTTPRequestSerializer serializer];//默认的方式
//            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//            
//            
//            [manager GET:urlString parameters:@{@"phone":textF1.text,@"password":textF2.text,@"vcode":textF3.text} success:^(NSURLSessionDataTask *task, id responseObject) {
//                //数据加载完后回调.
//                NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
//                NSLog(@"登录成功 result:%@",result);
            
            //假设返回结果为 result= @"0";
            NSString *result = @"0";
            
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                if([result isEqualToString:@"-1"]){
                    
                    hud.labelText = @"验证码不正确";
                    textF3.text = @"";
                    [self imgBtnAction];
                }else if([result isEqualToString:@"0"]){
                    
                    hud.labelText = @"手机或密码错误";
                    textF3.text = @"";
                    [self imgBtnAction];
                }else{
                    
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES];
                    
                    UIButton *btn12 = [scorllV viewWithTag:750];
                    
                    //记住密码，下次自动登录
                    if (btn12.selected) {
                        
                        NSDictionary *resultDiction = [NSDictionary dictionaryWithObjectsAndKeys:stateString,@"loginState",
                                                       textF1.text,@"phone",
                                                       textF2.text,@"secure",
                                                       @"dc1035Zlifan",@"loginCode", nil];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:resultDiction forKey:@"ResultAuthData"];
                        //保存数据，实现持久化存储
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    
                    
                    [self.navigationController popViewControllerAnimated:NO];
                    
                };
                // 隐藏时候从父控件中移除
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1.5];
                
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                //数据加载失败回调.
//                NSLog(@"登录失败: %@",error);
//                textF3.text = @"";
//            }];
            
        }
        NSLog(@"可以登录");
    }else{
        
        NSLog(@"登录NO");
    }
}


-(void)btnAction2{
    
    SecureViewController *secureVC = [[SecureViewController alloc]init];
    [self.navigationController pushViewController:secureVC animated:YES];
    NSLog(@"忘记密码");
}

-(void)btnAction3{
    
    NSLog(@"用户注册");
    RegistrationVC *registeVC = [[RegistrationVC alloc]init];
    [self.navigationController pushViewController:registeVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    UITextField *textF1 = [scorllV viewWithTag:100];
    UITextField *textF2 = [scorllV viewWithTag:101];
    UITextField *textF3 = [scorllV viewWithTag:102];
    if (textF1.text.length >= 1 && textF2.text.length >= 1 && textF3.text.length >= 1) {
        btnLogIn.backgroundColor = [UIColor colorWithRed:0.002 green:0.774 blue:0.003 alpha:1.000];
    }else{
        btnLogIn.backgroundColor = [UIColor lightGrayColor];
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    UITextField *textF1 = [scorllV viewWithTag:100];
    UITextField *textF2 = [scorllV viewWithTag:101];
    if (textF1.text.length >= 1 | textF2.text.length >= 1) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(textFTime) userInfo:nil repeats:YES];
    }
    
    UITextField *textF02 = [scorllV viewWithTag:102];
    
    if (textField == textF02) {
        
        //键盘将要出现 发出通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
        
        //键盘将要隐藏
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    UITextField *textF1 = [scorllV viewWithTag:100];
    UITextField *textF2 = [scorllV viewWithTag:101];
    if (textF1.text.length >= 1 && textF2.text.length >= 1) {
        btnLogIn.backgroundColor = [UIColor colorWithRed:0.002 green:0.774 blue:0.003 alpha:1.000];
        //取消定时器
        [timer invalidate];
    }else{
        btnLogIn.backgroundColor = [UIColor lightGrayColor];
    }
    
}

-(void)textFTime{
    
    NSLog(@"定时器");
    UITextField *textF1 = [scorllV viewWithTag:100];
    UITextField *textF2 = [scorllV viewWithTag:101];
    if (textF1.text.length >= 1 && textF2.text.length >= 1) {
        btnLogIn.backgroundColor = [UIColor colorWithRed:0.002 green:0.774 blue:0.003 alpha:1.000];
        //取消定时器
        [timer invalidate];
    }else{
        btnLogIn.backgroundColor = [UIColor lightGrayColor];
    }
}

//在一个VIewController收起键盘的方法如下:
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - 键盘通知调用方法
-(void)keyBoardShow:(NSNotification *)notif{
    
    //根据通知名获取通知
    if ([notif.name isEqualToString:@"UIKeyboardWillShowNotification"]) {
        
        scorllV.transform = CGAffineTransformMakeTranslation(0, -150);
        
    }else if ([notif.name isEqualToString:@"UIKeyboardWillHideNotification"]){
        
        scorllV.transform = CGAffineTransformMakeTranslation(0, 0);
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    if (self.isViewLoaded && !self.view.window) {
        
        self.view = nil;
    }
}

@end
