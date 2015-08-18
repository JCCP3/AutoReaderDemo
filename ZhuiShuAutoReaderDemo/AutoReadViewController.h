//
//  AutoReadViewController.h
//  ZhuiShuAutoReaderDemo
//
//  Created by JC_CP3 on 15/8/17.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoReadView.h"

@interface AutoReadViewController : UIViewController<AutoReadViewDelegate>{
    
    AutoReadView *autoReadView;

}


@end
