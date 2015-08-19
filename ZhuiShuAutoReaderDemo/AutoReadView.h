//
//  AutoReadView.h
//  ZhuiShuAutoReaderDemo
//
//  Created by JC_CP3 on 15/8/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@protocol AutoReadViewDelegate <NSObject>

@end

@interface AutoReadView : UIView

@property (nonatomic, weak) id<AutoReadViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)rect autoReadContent:(NSString *)content index:(NSInteger)index;

- (void)reloadAutoReadContent:(NSString *)content index:(NSInteger)index;

- (void)beginAutoRead;

- (void)endAutoRead;

- (void)updateTimerSpeed:(CGFloat)speed;

@end
