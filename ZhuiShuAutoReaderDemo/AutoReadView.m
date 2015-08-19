//
//  AutoReadView.m
//  ZhuiShuAutoReaderDemo
//
//  Created by JC_CP3 on 15/8/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "AutoReadView.h"

@interface AutoReadView ()<UIGestureRecognizerDelegate> {
    
    UIView *currentView;
    UIView *nextShowView;
    
    BOOL isStop;
    BOOL isCurrentViewFirst;
    
    NSMutableArray *contentIndexArray;
    
    NSTimer *timer;
    
    NSInteger currentIndex;
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

- (instancetype)initWithFrame:(CGRect)rect autoReadContent:(NSString *)content index:(NSInteger)index
{
    self = [super initWithFrame:rect];
    if (self) {
        [self initWithContent:content index:index]; //初始化
    }
    return self;
}

- (void)initWithContent:(NSString *)content index:(NSInteger)index
{
    currentIndex = index;
    currentPage = 0;
    
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
    
    contentIndexArray = [NSMutableArray array];
    
    [self addDataIntoArray:content index:index];
    
    [self createView];

}

- (void)reloadAutoReadContent:(NSString *)content index:(NSInteger)index
{
    [self addDataIntoArray:content index:index];
}

- (void)addDataIntoArray:(NSString *)content index:(NSInteger)index
{
    NSArray *contentArray = [content componentsSeparatedByString:@","];
    NSDictionary *contentIndexDic = [[NSDictionary alloc] initWithObjectsAndKeys:contentArray,[NSString stringWithFormat:@"%ld",(long)index], nil];
    [contentIndexArray addObject:contentIndexDic];
}

- (NSString *)getCurrentContentAtIndexPage
{
    NSDictionary *dic = [contentIndexArray objectAtIndex:currentIndex];
    NSArray *array = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)currentIndex]];
    NSString *content = [array objectAtIndex:currentPage];
    return content;
}

- (void)createView
{
    NSArray *firstIndexContentArray = [[contentIndexArray objectAtIndex:0] objectForKey:[[[contentIndexArray objectAtIndex:0] allKeys] objectAtIndex:0]];
    
    for (int i=0; i<2; i++) {
        NSString *content = [firstIndexContentArray objectAtIndex:i];
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
//        [view addSubview:[self getImageByContent:content]];
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

- (void)changeCurrentIndex
{
    currentIndex ++;
    currentPage = 0;
    [self beginAutoRead];
}

- (void)beginAutoRead
{
    if (currentIndex == 0) {
        if (currentPage == 0) {
            currentPage ++;
            ((UITextView *)[nextShowView viewWithTag:100]).text = [self getCurrentContentAtIndexPage];
//            UIImageView *imageView = ((UIImageView *)[nextShowView viewWithTag:100]) ;
//            imageView = [self getImageByContent:[self getCurrentContentAtIndexPage]];
        } else {
            if (currentPage % 2 == 0) {
                ((UITextView *)[currentView viewWithTag:100]).text = [self getCurrentContentAtIndexPage];
//                UIImageView *imageView = ((UIImageView *)[currentView viewWithTag:100]) ;
//                imageView = [self getImageByContent:[self getCurrentContentAtIndexPage]];
                [currentView setFrame:CGRectMake(0, 0, CGRectGetWidth(currentView.bounds), 0)];
                [self addSubview:currentView];
            } else {
                ((UITextView *)[nextShowView viewWithTag:100]).text = [self getCurrentContentAtIndexPage];
//                UIImageView *imageView = ((UIImageView *)[nextShowView viewWithTag:100]) ;
//                imageView = [self getImageByContent:[self getCurrentContentAtIndexPage]];
                [nextShowView setFrame:CGRectMake(0, 0, CGRectGetWidth(nextShowView.bounds), 0)];
                [self addSubview:nextShowView];
            }
        }
    } else {
        if (isCurrentViewFirst) {
            if (currentPage % 2 == 0) {
                ((UITextView *)[currentView viewWithTag:100]).text = [self getCurrentContentAtIndexPage];
//                UIImageView *imageView = ((UIImageView *)[currentView viewWithTag:100]) ;
//                imageView = [self getImageByContent:[self getCurrentContentAtIndexPage]];
                [currentView setFrame:CGRectMake(0, 0, CGRectGetWidth(currentView.bounds), 0)];
                [self addSubview:currentView];
            } else {
                ((UITextView *)[nextShowView viewWithTag:100]).text = [self getCurrentContentAtIndexPage];
//                UIImageView *imageView = ((UIImageView *)[nextShowView viewWithTag:100]) ;
//                imageView = [self getImageByContent:[self getCurrentContentAtIndexPage]];
                [nextShowView setFrame:CGRectMake(0, 0, CGRectGetWidth(nextShowView.bounds), 0)];
                [self addSubview:nextShowView];
            }
        } else {
            if (currentPage % 2 == 0) {
                ((UITextView *)[nextShowView viewWithTag:100]).text = [self getCurrentContentAtIndexPage];
//                UIImageView *imageView = ((UIImageView *)[nextShowView viewWithTag:100]) ;
//                imageView = [self getImageByContent:[self getCurrentContentAtIndexPage]];
                [nextShowView setFrame:CGRectMake(0, 0, CGRectGetWidth(nextShowView.bounds), 0)];
                [self addSubview:nextShowView];
            } else {
//                UIImageView *imageView = ((UIImageView *)[currentView viewWithTag:100]) ;
//                imageView = [self getImageByContent:[self getCurrentContentAtIndexPage]];
                ((UITextView *)[currentView viewWithTag:100]).text = [self getCurrentContentAtIndexPage];
                [currentView setFrame:CGRectMake(0, 0, CGRectGetWidth(currentView.bounds), 0)];
                [self addSubview:currentView];
            }
        }
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
    
    if (currentIndex == 0) {
        if (currentPage % 2 == 0) {
            currentView.frame = CGRectMake(0, 0, currentView.bounds.size.width, currentView.bounds.size.height+point.y);
            [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(currentView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
        } else {
            nextShowView.frame = CGRectMake(0, 0, nextShowView.bounds.size.width, nextShowView.bounds.size.height+point.y);
            [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(nextShowView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
        }
    } else {
        if (isCurrentViewFirst) {
            if (currentPage %2 == 0) {
                currentView.frame = CGRectMake(0, 0, currentView.bounds.size.width, currentView.bounds.size.height+point.y);
                [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(currentView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
            } else {
                nextShowView.frame = CGRectMake(0, 0, nextShowView.bounds.size.width, nextShowView.bounds.size.height+point.y);
                [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(nextShowView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
            }
        } else {
            if (currentPage %2 == 0) {
                nextShowView.frame = CGRectMake(0, 0, nextShowView.bounds.size.width, nextShowView.bounds.size.height+point.y);
                [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(nextShowView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
            } else {
                currentView.frame = CGRectMake(0, 0, currentView.bounds.size.width, currentView.bounds.size.height+point.y);
                [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(currentView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
            }
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        timer = [NSTimer scheduledTimerWithTimeInterval:timerSpeed target:self selector:@selector(changeCurrentViewFrame:) userInfo:nil repeats:YES];
        [timer fire];
    }
    
    [recognizer setTranslation:CGPointZero inView:self];
}

#pragma mark - changeToImageView
- (UIImageView *)getImageByContent:(NSString *)content
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    imageView.tag = 100;
    imageView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(imageView.bounds), 0)];
    label.text = content;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:21];
    [label sizeToFit];
    [imageView addSubview:label];
    return imageView;
}

#pragma mark - NSTimer Action
- (void)changeCurrentViewFrame:(NSTimer *)timer
{
    CGFloat currentHeight = 0;
    
    if (currentIndex == 0) {
        if (currentPage % 2 == 0) {
            currentHeight = CGRectGetHeight(currentView.bounds);
        } else {
            currentHeight = CGRectGetHeight(nextShowView.bounds);
        }
    } else {
        if (isCurrentViewFirst) {
            if (currentPage % 2 == 0) {
                currentHeight = CGRectGetHeight(currentView.bounds);
            } else {
                currentHeight = CGRectGetHeight(nextShowView.bounds);
            }
        } else {
            if (currentPage % 2 == 0) {
                currentHeight = CGRectGetHeight(nextShowView.bounds);
            } else {
                currentHeight = CGRectGetHeight(currentView.bounds);
            }
        }
    }
    
    if (currentHeight >= [UIScreen mainScreen].bounds.size.height) {
        if (currentPage >= [[[contentIndexArray objectAtIndex:currentIndex] objectForKey:[NSString stringWithFormat:@"%ld",currentIndex]] count]-1) {
            if (currentPage % 2 == 0) {
                isCurrentViewFirst = NO;
            } else {
                isCurrentViewFirst = YES;
            }
            //结束
            [self invalidateTimer];
            if ([contentIndexArray count] - 1 > currentIndex) {
                [self changeCurrentIndex]; //换章
            }
        } else {
            [self invalidateTimer];
            currentPage ++;
            [self beginAutoRead];
        }
    } else {
        [self bringSubviewToFront:shadowView];
        
        if (currentIndex == 0) {
            if (currentPage % 2 == 0){
                [currentView setFrame:CGRectMake(0, CGRectGetMinY(currentView.frame), [[UIScreen mainScreen] bounds].size.width, CGRectGetHeight(currentView.bounds)+1)];
                [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(currentView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
            } else {
                [nextShowView setFrame:CGRectMake(0, CGRectGetMinY(nextShowView.frame), [[UIScreen mainScreen] bounds].size.width, CGRectGetHeight(nextShowView.bounds)+1)];
                [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(nextShowView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
            }
        } else {
            if (isCurrentViewFirst) {
                if (currentPage % 2 == 0){
                    [currentView setFrame:CGRectMake(0, CGRectGetMinY(currentView.frame), [[UIScreen mainScreen] bounds].size.width, CGRectGetHeight(currentView.bounds)+1)];
                    [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(currentView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
                } else {
                    [nextShowView setFrame:CGRectMake(0, CGRectGetMinY(nextShowView.frame), [[UIScreen mainScreen] bounds].size.width, CGRectGetHeight(nextShowView.bounds)+1)];
                    [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(nextShowView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
                }
            } else {
                if (currentPage % 2 == 0){
                    [nextShowView setFrame:CGRectMake(0, CGRectGetMinY(nextShowView.frame), [[UIScreen mainScreen] bounds].size.width, CGRectGetHeight(nextShowView.bounds)+1)];
                    [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(nextShowView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
                } else {
                    [currentView setFrame:CGRectMake(0, CGRectGetMinY(currentView.frame), [[UIScreen mainScreen] bounds].size.width, CGRectGetHeight(currentView.bounds)+1)];
                    [shadowView setFrame:CGRectMake(0, CGRectGetMaxY(currentView.bounds)-1, CGRectGetWidth(shadowView.bounds), CGRectGetHeight(shadowView.bounds))];
                }
            }
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
