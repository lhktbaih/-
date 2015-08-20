//
//  ViewController.m
//  串口调试
//
//  Created by SUNFLOWER on 15/8/19.
//  Copyright (c) 2015年 Laishuangquan. All rights reserved.
//

#import "ViewController.h"
#import "Command.h"
@interface ViewController ()<CommandDelegate>{
    Command *socketTo;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(100, 200, 120, 30);
    btn.center=self.view.center;
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.backgroundColor=[UIColor redColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    //初始化

    socketTo=[[Command alloc]init];
    [socketTo setDelegate:self];
    socketTo.sockaddr=@"192.168.11.123";  //根据实际给的传
    socketTo.sockport=2001;               //根据实际给的传
    [socketTo connectedToServer];         //建立连接
    
}
-(void)sendMessage:(id)sender{
    
    //比如发50和100给服务器
    NSMutableArray *dataArr=[[NSMutableArray alloc]init];
    NSArray *arr=@[@"50",@"100"];
    [dataArr addObjectsFromArray:arr];
    [socketTo sendCommand:dataArr];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
