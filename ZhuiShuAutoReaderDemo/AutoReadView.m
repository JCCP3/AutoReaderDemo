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
    timerSpeed = 0.05;
}


- (void)reloadData
{
    
    viewsInPageArray = [NSMutableArray array];
    
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(numberOfPageInAutoReadView:)] || ![self.delegate respondsToSelector:@selector(autoReadView:viewForPageAtIndex:)]) {
        return;
    }
    
    pageCount = [self.delegate numberOfPageInAutoReadView:self];
    
    for (int i = 0; i < pageCount; i++) {
        UIView *pageView = [self.delegate autoReadView:self viewForPageAtIndex:i];
        [self addSubview:pageView];
        [viewsInPageArray addObject:pageView];
    }
    
}



- (void)beginAutoRead
{
    nextShowView = [viewsInPageArray objectAtIndex:currentPage];
   
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
            [self beginAutoRead];
        }
    } else {
        [nextShowView setFrame:CGRectMake(0, CGRectGetMinY(nextShowView.frame), [[UIScreen mainScreen] bounds].size.width, CGRectGetHeight(nextShowView.bounds)+1)];
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
