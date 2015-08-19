//
//  AutoReadViewController.m
//  ZhuiShuAutoReaderDemo
//
//  Created by JC_CP3 on 15/8/17.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "AutoReadViewController.h"

@interface AutoReadViewController ()<UIGestureRecognizerDelegate>{
    NSMutableArray *bookContentArray;
    NSMutableArray *viewArray;
    
    BOOL isStop;
    BOOL autoReadEnable;
    
    CGFloat timerSpeed;
    
    NSInteger currentIndex;
}

@end

@implementation AutoReadViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen  mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    timerSpeed = 0.05;
    bookContentArray = [@[] mutableCopy];
    viewArray = [NSMutableArray array];
    
    currentIndex = 0;
    autoReadView = [[AutoReadView alloc] initWithFrame:self.view.frame autoReadContent:@"1\n\n\n\n 2\n\n\n 3,4\n\n\n\n 5\n\n\n 6,7\n\n\n\n 8\n\n\n 9,10\n\n\n\n 11\n\n\n 12" index:currentIndex];
    autoReadView.delegate = self;
    [self.view addSubview:autoReadView];
    
    UIView *footerView = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-45, [UIScreen mainScreen].bounds.size.width, 45)];
    [footerView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:footerView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, footerView.bounds.size.width, 21)];
    label.text = @"自动阅读";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:21.f];
    [footerView addSubview:label];
    
    UIButton *autoReadBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 0, 100, 45)];
    [autoReadBtn addTarget:self action:@selector(onClickAutoRead) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:autoReadBtn];
    
    UIButton *slowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [slowBtn setTitle:@"减速" forState:UIControlStateNormal];
    [slowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [slowBtn addTarget:self action:@selector(onClickMoreSlow) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:slowBtn];
    
    UIButton *fastBtn = [[UIButton alloc] initWithFrame:CGRectMake(footerView.bounds.size.width-45, 0, 45, 45)];
    [fastBtn setTitle:@"加速" forState:UIControlStateNormal];
    [fastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fastBtn addTarget:self action:@selector(onClickMoreFast) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:fastBtn];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(onClickAddContent) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickAddContent
{
    currentIndex ++;
    [autoReadView reloadAutoReadContent:[NSString stringWithFormat:@"第%ld章1\n\n\n\n 第%ld章2\n\n\n 第%ld章3,第%ld章4\n\n\n\n 第%ld5章\n\n\n 第%ld章6,第%ld章7\n\n\n\n 第%ld章8\n\n\n 第%ld章9,第%ld章10\n\n\n\n 第%ld章11\n\n\n 第%ld章12",currentIndex+1,currentIndex+1,currentIndex+1,currentIndex+1,currentIndex+1,currentIndex+1,currentIndex+1,currentIndex+1,currentIndex+1,currentIndex+1,currentIndex+1,currentIndex+1] index:currentIndex];
}

#pragma mark - BtnAction
- (void)onClickAutoRead
{
    autoReadEnable = !autoReadEnable;
    if (autoReadEnable) {
        timerSpeed = 0.12;
        [autoReadView beginAutoRead];
    } else {
        [autoReadView endAutoRead];
    }
}

- (void)onClickMoreSlow
{
    if (autoReadEnable) {
        if (timerSpeed + 0.05 < 0.24) {
            timerSpeed += 0.05;
        }
        [autoReadView updateTimerSpeed:timerSpeed];
    }
}

- (void)onClickMoreFast
{
    if (autoReadEnable) {
        if (timerSpeed - 0.05 > 0) {
            timerSpeed -= 0.05;
        }
        [autoReadView updateTimerSpeed:timerSpeed];
    }
}

@end
