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
    bookContentArray = [@[@"故事的小黄花 \n\n从出生的那年就飘着\n童年的荡秋千 随记忆一直晃到现在\n\n 吹着前奏望着天空的我想起花瓣试着掉落 为你翘课的那一天 \n\n花落的那一天教室的那一间 我怎么看不见消失的下雨天 \n\n我好想再淋一遍每想到失去的勇气我还留着好想再问一遍 你会等待还是离开\n\n刮风这天 我试过握着你手但偏偏 雨渐渐 大到我看你不见 还有多久 \n\n我才能在你身边 等到放晴的那天 也许我会比较好一点 从前从前 有个人爱你很久 但偏偏 风渐渐 把距离吹得好远 好不容易 又能再多爱一天 \n\n但故事的最后你好像还是说了拜拜 \n\n 为你翘课的那一天 花落的那一天 教室的那一间 我怎么看不见 \n消失的下雨天 我好想再淋一遍", @"一盏离愁孤单伫立在窗口 我在门后假装你人还没走 旧地如重游月圆更寂寞 夜半清醒的烛火不忍苛责我 一壶漂泊浪迹天涯难入喉 你走之后酒暖回忆\n\n刮风这天 \n\n 我试过握着你手但偏偏 雨渐渐 大到我看你不见 还有多久 我才能在你身边 \n等到放晴的那天 也许我会比较好一点 从前从前 \n\n有个人爱你很久\n\n 但偏偏 风渐渐 把距离吹得好远 好不容易 又能再多爱一天 但故事的最后你好像还是说了拜拜 \n\n 为你翘课的那一天 花落的那一天 教室的那一间 \n\n我怎么看不见 消失的下雨天 我好想再淋一遍", @"青花瓷 素胚勾勒出青花笔锋浓转淡 瓶身描绘的牡丹一如你初妆 冉冉檀香透过窗心事我了然 \n\n宣纸上走笔至此搁...", @"故事的小黄花 从出生的那年就飘着\n童年的荡秋千 随记忆一直晃到现在\n\n 吹着前奏望着天空的我想起花瓣试着掉落 \n\n为你翘课的那一天 花落的那一天教室的那一间 \n我怎么看不见消失的下雨天 我好想再淋一遍每想到失去的勇气我还留着好想再问一遍 你会等待还是离开\n刮风这天 我试过握着你手但偏偏 雨渐渐 大到我看你不见 还有多久 我才能在你身边 等到放晴的那天 也许我会比较好一点 \n\n从前从前 有个人爱你很久 但偏偏 风渐渐 \n把距离吹得好远 好不容易 又能再多爱一天 \n\n但故事的最后你好像还是说了拜拜\n\n 为你翘课的那一天 花落的那一天 教室的那一间 我怎么看不见 消失的下雨天 我好想再淋一遍"] mutableCopy];
    viewArray = [NSMutableArray array];
    
    autoReadView = [[AutoReadView alloc] init];
    autoReadView.delegate = self;
    
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
    
    [autoReadView reloadData];
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
