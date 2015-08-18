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
    
    autoReadView = [[AutoReadView alloc] init];
    autoReadView.delegate = self;
    [autoReadView reloadData:@"1\n\n\n\n 2\n\n\n 3,4\n\n\n\n 5\n\n\n 6,7\n\n\n\n 8\n\n\n 9,10\n\n\n\n 11\n\n\n 12"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panWithTouchEvent:)];
    [self.view addGestureRecognizer:pan];
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
    
    [self loadAllPageData];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)loadAllPageData
{
    for (int i = 0; i < [bookContentArray count]; i++) {
        
        NSString *content = [bookContentArray objectAtIndex:i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        view.clipsToBounds = YES;
        view.tag = i+1;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds))];
        textView.font = [UIFont systemFontOfSize:18];
        textView.scrollEnabled = NO;
        textView.text = content;
        textView.editable = NO;
        if (i == 0) {
            textView.backgroundColor = [UIColor clearColor];
        } else {
            textView.backgroundColor = [UIColor whiteColor];
            view.frame = CGRectMake(0, 0, 0, 0);
        }
        [view addSubview:textView];
        [viewArray addObject:view];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIGestureAction
- (void)tapEvent:(UITapGestureRecognizer *)tap
{
    isStop = !isStop;
    if (isStop) {
        [autoReadView endAutoRead];
    } else {
        [autoReadView beginAutoRead];
    }
}

- (void)panWithTouchEvent:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer translationInView:self.view];
    
    [autoReadView panWithCurrentView:recognizer point:point];
}

#pragma mark - AutoReadViewDelegate
- (NSInteger)numberOfPageInAutoReadView:(AutoReadView *)autoReadView
{
    return [viewArray count];
}

- (UIView *)autoReadView:(AutoReadView *)view viewForPageAtIndex:(NSInteger)index
{
    return viewArray[index];
}

- (void)setTranslationZeroWithGesture:(UIPanGestureRecognizer *)recognizer
{
    [recognizer setTranslation:CGPointZero inView:self.view];
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
