//
//  AutoReadView.h
//  ZhuiShuAutoReaderDemo
//
//  Created by JC_CP3 on 15/8/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@class AutoReadView;
@protocol AutoReadViewDelegate <NSObject>

@required
- (NSInteger)numberOfPageInAutoReadView:(AutoReadView *)autoReadView;

- (UIView *)autoReadView:(AutoReadView *)view viewForPageAtIndex:(NSInteger)index;

@optional
- (CGSize)sizePageForAutoReadView:(AutoReadView *)autoReadView;

- (void)setTranslationZeroWithGesture:(UIPanGestureRecognizer *)recognizer;

@end

@interface AutoReadView : UIView

@property (nonatomic, weak) id<AutoReadViewDelegate> delegate;

- (void)reloadData;

- (void)beginAutoRead;

- (void)endAutoRead;

- (void)finishAutoRead;

- (void)panWithCurrentView:(UIPanGestureRecognizer *)recognizer point:(CGPoint)point;

- (void)updateTimerSpeed:(CGFloat)speed;

@end
