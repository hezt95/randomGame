//
//  BeginViewController.m
//  randomGameDeom
//
//  Created by HeZitong on 14/12/8.
//  Copyright (c) 2014年 HeZitong. All rights reserved.
//

#import "BeginViewController.h"
#import "ChoiceTableViewController.h"
#import "testViewController.h"

@implementation BeginViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupContraints];
    
}
-(void)setupViews
{
    self.textField = [[UITextField alloc] init];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.placeholder = @"Init:Please input the number of players";
    self.textField.clearButtonMode = YES;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.textField];
    
    self.button = [[UIButton alloc] init];
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button setTitle:@"OK" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithRed:21.0/255 green:125.0/255 blue:251.0/255 alpha:1.0] forState:UIControlStateNormal];
    self.button.showsTouchWhenHighlighted = YES;
    [self.button addTarget:self action:@selector(initBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    self.buttonJoin = [[UIButton alloc] init];
    self.buttonJoin.translatesAutoresizingMaskIntoConstraints = NO;
    [self.buttonJoin setTitle:@"Start" forState:UIControlStateNormal];
    [self.buttonJoin setTitleColor:[UIColor colorWithRed:21.0/255 green:125.0/255 blue:251.0/255 alpha:1.0] forState:UIControlStateNormal];
    self.buttonJoin.showsTouchWhenHighlighted = YES;
    [self.buttonJoin addTarget:self action:@selector(startBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonJoin];
    
    self.testBtn = [[UIButton alloc] init];
    self.testBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.testBtn setTitle:@"reset" forState:UIControlStateNormal];
    [self.testBtn setTitleColor:[UIColor colorWithRed:21.0/255 green:125.0/255 blue:251.0/255 alpha:1.0] forState:UIControlStateNormal];
    self.testBtn.showsTouchWhenHighlighted = YES;
    [self.testBtn addTarget:self action:@selector(testBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.testBtn];

}

-(void)setupContraints
{
    NSDictionary *viewDictionary = @{@"textField":self.textField,@"button":self.button,@"buttonJoin":self.buttonJoin,@"testBtn":self.testBtn};
    NSArray *textContraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[textField(30)]" options:0 metrics:nil views: viewDictionary];
    [self.textField addConstraints:textContraintV];
    NSArray *contraintPosV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[textField]-30-[button]-30-[buttonJoin]-20-[testBtn]" options:0 metrics:nil views:viewDictionary];
    NSArray *contraintPosH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[textField]-20-|" options:0 metrics:nil views:viewDictionary];
    [self.view addConstraints:contraintPosH];
    [self.view addConstraints:contraintPosV];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonJoin attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.testBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

-(void)initBtnPressed
{
    NSString *numStr = self.textField.text;
    NSURL *initgGameURL = [NSURL URLWithString:@"http://blog.chenzhangyu.com:8888/demo/init_game"];
    NSMutableURLRequest *initgGameReq = [[NSMutableURLRequest alloc] initWithURL:initgGameURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [initgGameReq setHTTPMethod:@"POST"];
    NSString *initGameStr = [NSString stringWithFormat:@"total=%@",numStr];
    NSData *initGameData = [initGameStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *initGameStrLength = [NSString stringWithFormat:@"%d",[initGameData length]];
    [initgGameReq setValue:initGameStrLength forHTTPHeaderField:@"Content-Length"];
    [initgGameReq setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [initgGameReq setHTTPBody:initGameData];
    [NSURLConnection sendAsynchronousRequest:initgGameReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"%@",connectionError);
            UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"Internet Error" message:@"Can't connect with server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [aleart show];
        }
        else{
            NSError *convertError;
            NSDictionary *recieveDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&convertError];
            BOOL status = [[recieveDic objectForKey:@"status"] boolValue];
            if (status) {
                //init success
                NSInteger total = [[recieveDic objectForKey:@"total"] integerValue];
                NSArray *selected = [recieveDic objectForKey:@"selected"];
                NSLog(@"/demo/start:total:%d",total);
                NSLog(@"/demo/start:selected:%@",selected);
                [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"total"];
                [[NSUserDefaults standardUserDefaults] setObject:selected forKey:@"selected"];
                ChoiceTableViewController *choiceTableViewCtrl = [[ChoiceTableViewController alloc] initWithStyle:UITableViewStylePlain];
                [self.navigationController pushViewController:choiceTableViewCtrl animated:YES];
            }
            else{
                //init fail
                UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There is a game" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [aleart show];
            }
        }
    }];
}
    
//GET方法 阻塞线程
//    NSMutableURLRequest *startRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:5000/test"]];
//    [startRequest setHTTPMethod:@"GET"];
//    NSData *returnData;
//    while (!(returnData = [NSURLConnection sendSynchronousRequest:startRequest returningResponse:nil error:nil])) {
//        NSLog(@"waiting");
//    }
//    NSLog(@"%@",[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]);
//    NSURLConnection *startConnection = [[NSURLConnection alloc] initWithRequest:startRequest delegate:self];

    
//多线程的GET方法
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *userAPI = [NSString stringWithFormat:@"http://blog.chenzhangyu.com:8888/test"];
//        NSURL *userURL = [NSURL URLWithString:userAPI];
//        NSMutableURLRequest *userRequest = [NSMutableURLRequest requestWithURL:userURL];
//        NSData *userData = [NSURLConnection sendSynchronousRequest:userRequest returningResponse:nil error:nil];
//        NSString *userStr = [[NSString alloc]initWithData:userData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",userStr);
//    });

-(void)startBtnPressed{
    NSURL *startUrl = [NSURL URLWithString:@"http://blog.chenzhangyu.com:8888/demo/start"];
    NSMutableURLRequest *startReq = [[NSMutableURLRequest alloc] initWithURL:startUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [startReq setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:startReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [aleart show];
        }
        else{
            NSError *convertError;
            NSDictionary *recieveDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&convertError];
            BOOL status = [[recieveDic objectForKey:@"status"] boolValue];
            if (status) {
                //可以加入
                BOOL is_full = [[recieveDic objectForKey:@"is_full"] boolValue];
                if (is_full) {
                    //full
                    UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"Full" message:@"Enough player in this game" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [aleart show];
                }
                else{
                    //not full
                    NSInteger total = [[recieveDic objectForKey:@"total"] integerValue];
                    NSArray *selected = [recieveDic objectForKey:@"selected"];
                    NSLog(@"/demo/start:total:%d",total);
                    NSLog(@"/demo/start:selected:%@",selected);
                    [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"total"];
                    [[NSUserDefaults standardUserDefaults] setObject:selected forKey:@"selected"];
                    ChoiceTableViewController *choiceTableViewCtrl = [[ChoiceTableViewController alloc] initWithStyle:UITableViewStylePlain];
                    [self.navigationController pushViewController:choiceTableViewCtrl animated:YES];
                }
            }
            else{
                UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"No host" message:@"You can init a game" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [aleart show];
            }
        }
    }];
    
}

-(void)testBtnPressed{
    NSURL *URL = [NSURL URLWithString:@"http://blog.chenzhangyu.com:8888/demo/reset"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"%@",connectionError);
        }
        else{
            NSError *convertError;
            NSDictionary *recieveDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&convertError];
            BOOL status = [[recieveDic objectForKey:@"status"] boolValue];
            if (status) {
                NSLog(@"Reset Success");
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"status"];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"total"];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"selected"];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"result"];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"selfSelected"];
                UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"Success" message:@"The sever has been reset" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [aleart show];
            }
        }
    }];

}


-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
