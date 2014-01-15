//
//  Comment.h
//  ONE
//
//  Created by dianji on 13-1-21.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property(nonatomic, copy) NSString *userName;//用户名
@property(nonatomic, copy) NSString *commentTime;//评论时间
@property(nonatomic, copy) NSString *eventId;//事件名
@property(nonatomic, copy) NSString *contents;//评论内容

@end
