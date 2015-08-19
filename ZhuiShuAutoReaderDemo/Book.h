//
//  Book.h
//  ZhuiShuAutoReaderDemo
//
//  Created by JC_CP3 on 15/8/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSString *bookAuthor;
@property (nonatomic, strong) NSString *bookName;
@property (nonatomic, strong) NSString *bookContent;
@property (nonatomic, strong) NSString *bookAtIndex; //章

@end
