//
//  AutoReadView.m
//  ZhuiShuAutoReaderDemo
//
//  Created by JC_CP3 on 15/8/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "AutoReadView.h"

@interface AutoReadView ()<UIGestureRecognizerDelegate> {
    
    NSInteger pageCount;
    
    UIView *currentView;
    UIView *nextShowView;
    
    BOOL isStop;

    NSMutableArray *viewsInPageArray;
    
    NSTimer *timer;
    
    NSInteger currentPage;
    
    CGFloat timerSpeed;
    
    UIView *shadowView;
}

@end

@implementation AutoReadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initial];
    }
    return self;
}


- (void)initial
{
    currentPage = 0; //初始化显示第一页
    timerSpeed = 0.01;
    
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 1)];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(4, 4);
    shadowView.layer.shadowOpacity = 0.8;
    shadowView.layer.shadowRadius = 4;
    [self addSubview:shadowView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panWithTouchEvent:)];
    [self addGestureRecognizer:panGesture];
}

- (void)reloadData:(NSString *)content
{
    viewsInPageArray = [NSMutableArray array];
    viewsInPageArray = [[content componentsSeparatedByString:@","] mutableCopy];
    pageCount = [viewsInPageArray count];
    [self createView];
}

- (void)createView
{
    for (int i=0; i<2; i++) {
        NSString *content = [viewsInPageArray objectAtIndex:i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        view.backgroundColor = [UIColor whiteColor];
        view.clipsToBounds = YES;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds))];
        textView.font = [UIFont systemFontOfSize:18];
        textView.scrollEnabled = NO;
        textView.text = content;
        textView.tag = 100;
        textView.editable = NO;
        [view addSubview:textView];
        [self addSubview:view];
        if (i == 0) {
            textView.backgroundColor = [UIColor clearColor];
            currentView = view;
            currentView.backgroundColor = [UIColor yellowColor];
        } else {
            textView.backgroundColor = [UIColor clearColor];
            view.frame = CGRectMake(0, 0, 0, 0);
            nextShowView = view;
            nextShowView.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)beginAutoRead
{
    if (currentPage != 0) {
        if (currentPage %2 == 0) {
           
            ((UITextView *)[currentView viewWithTag:100]).text = [viewsInPageArray objectAtIndex:currentPage];
            [currentView setFrame:CGRectMake(0, 0, CGRectGetWidth(currentView.bounds), 0)];
            [self addSubview:currentView];
        } else {
           
            ((UITextView *)[nextShowView viewWithTag:100]).text = [viewsInPageArray objectAtIndex:currentPage];
            [nextShowView setFrame:CGRectMake(0, 0, CGRectGetWidth(nextShowView.bounds), 0)];
            [self addSubview:nextShowView];
        }
       
    } else {
        currentPage ++;
        ((UITextView *)[nextShowView viewWithTag:100]).text = [viewsInPageArray objectAtIndex:currentPage];
    }
    
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:timerSpeed target:self selector:@selector(changeCurrentViewFrame:) userInfo:nil repeats:YES];
        [timer fire];
    }
}

- (void)endAutoRead
{
    [self invalidateTimer];
}

#pragma mark UIGestureAction
- (void)tapEvent:(UITapGestureRecognizer *)recognizer
{
    isStop = !isStop;
    if (isStop) {
        [self endAutoRead];
    } else {
        if (!timer) {
            timer = [NSTimer scheduledTimerWithTimeInterval:timerSpeed target:self selector:@selector(changeCurrentViewFrame:) userInfo:nil repeats:YES];
            [timer fire];
        }
    }
}

- (void)panWithTouchEvent:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer translationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self invalidateTimer];
    }
    
    if (currentPage != 0) {
        if (currentPage %2 == 0) {
            currentView.frame = CGRectMake(0, 0, currentView.bounds.size.width, currentView.bounds.size.height+point.y);
            [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(currentView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
        } else {
            nextShowView.frame = CGRectMake(0, 0, nextShowView.bounds.size.width, nextShowView.bounds.size.height+point.y);
            [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(nextShowView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
        }
    } else {
        nextShowView.frame = CGRectMake(0, 0, nextShowView.bounds.size.width, nextShowView.bounds.size.height+point.y);
        [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(nextShowView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
        
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        timer = [NSTimer scheduledTimerWithTimeInterval:timerSpeed target:self selector:@selector(changeCurrentViewFrame:) userInfo:nil repeats:YES];
        [timer fire];
    }
    
    [recognizer setTranslation:CGPointZero inView:self];
}

#pragma mark - NSTimer Action
- (void)changeCurrentViewFrame:(NSTimer *)timer
{
    CGFloat currentHeight = 0;
    if (currentPage != 0) {
        if (currentPage %2 == 0) {
            currentHeight = CGRectGetHeight(currentView.bounds);
        } else {
            currentHeight = CGRectGetHeight(nextShowView.bounds);
        }
    } else {
        currentHeight = CGRectGetHeight(nextShowView.bounds);
    }
    
    if (currentHeight >= [UIScreen mainScreen].bounds.size.height) {
        if (currentPage >= [viewsInPageArray count]-1) {
            //结束
            [self invalidateTimer];
        } else {
            [self invalidateTimer];
            currentPage ++;
            [self beginAutoRead];
        }
    } else {
        [self bringSubviewToFront:shadowView];
        if (currentPage != 0) {
            if (currentPage %2 == 0) {
                [currentView setFrame:CGRectMake(0, CGRectGetMinY(currentView.frame), [[UIScreen mainScreen] bounds].size.width, CGRectGetHeight(currentView.bounds)+1)];
                [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(currentView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
            } else {
                [nextShowView setFrame:CGRectMake(0, CGRectGetMinY(nextShowView.frame), [[UIScreen mainScreen] bounds].size.width, CGRectGetHeight(nextShowView.bounds)+1)];
                [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(nextShowView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
            }
        } else {
            [nextShowView setFrame:CGRectMake(0, CGRectGetMinY(nextShowView.frame), [[UIScreen mainScreen] bounds].size.width, CGRectGetHeight(nextShowView.bounds)+1)];
            [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(nextShowView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
        }
    }
}

- (void)invalidateTimer
{
    [timer invalidate];
    timer = nil;
}

- (void)updateTimerSpeed:(CGFloat)speed
{
    timerSpeed = speed;
    if (timer) {
        [self invalidateTimer];
        timer = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(changeCurrentViewFrame:) userInfo:nil repeats:YES];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return self;
}

@end
