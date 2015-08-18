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
    
    UIPanGestureRecognizer *pan;
    UITapGestureRecognizer *tap;

    NSMutableArray *viewsInPageArray;
    
    NSTimer *timer;
    
    NSInteger currentPage;
    
    CGFloat timerSpeed;
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
        } else {
            textView.backgroundColor = [UIColor whiteColor];
            view.frame = CGRectMake(0, 0, 0, 0);
            nextShowView = view;
        }
    }
}


- (void)beginAutoRead
{
    if (currentPage != 0) {
//        if (currentPage %2 == 0) {
//           
//            ((UITextView *)[currentView viewWithTag:100]).text = [viewsInPageArray objectAtIndex:currentPage];
//            [currentView setFrame:CGRectMake(0, 0, CGRectGetWidth(currentView.bounds), 0)];
//            [self addSubview:currentView];
//        } else {
//           
//            ((UITextView *)[nextShowView viewWithTag:100]).text = [viewsInPageArray objectAtIndex:currentPage];
//            [nextShowView setFrame:CGRectMake(0, 0, CGRectGetWidth(nextShowView.bounds), 0)];
//            [self addSubview:nextShowView];
//        }
        [self addSubview:currentView];
        
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

- (void)panWithCurrentView:(UIPanGestureRecognizer *)recognizer point:(CGPoint)point
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self invalidateTimer];
    }
    
    nextShowView.frame = CGRectMake(0, 0, nextShowView.bounds.size.width, nextShowView.bounds.size.height+point.y);
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        timer = [NSTimer scheduledTimerWithTimeInterval:timerSpeed target:self selector:@selector(changeCurrentViewFrame:) userInfo:nil repeats:YES];
        [timer fire];
    }
    
    [self.delegate setTranslationZeroWithGesture:recognizer];
}

#pragma mark - NSTimer Action
- (void)changeCurrentViewFrame:(NSTimer *)timer
{
    if (CGRectGetHeight(nextShowView.bounds) >= [UIScreen mainScreen].bounds.size.height) {
        if (currentPage >= [viewsInPageArray count]-1) {
            //结束
            [self invalidateTimer];
        } else {
            [self invalidateTimer];
            currentPage ++;
            nextShowView = currentView;
            [self beginAutoRead];
        }
    } else {
        
        if (currentPage != 0) {
            if (currentPage %2 == 0) {
                [currentView setFrame:CGRectMake(0, CGRectGetMinY(currentView.frame), [[UIScreen mainScreen] bounds].size.width, CGRectGetHeight(currentView.bounds)+1)];
            } else {
                [nextShowView setFrame:CGRectMake(0, CGRectGetMinY(nextShowView.frame), [[UIScreen mainScreen] bounds].size.width, CGRectGetHeight(nextShowView.bounds)+1)];
            }
            
        } else {
            [nextShowView setFrame:CGRectMake(0, CGRectGetMinY(nextShowView.frame), [[UIScreen mainScreen] bounds].size.width, CGRectGetHeight(nextShowView.bounds)+1)];
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

@end
