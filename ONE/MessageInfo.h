//
//  MessageInfo.h
//  ONE
//
//  Created by dianji on 12-11-29.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageInfo : NSObject
//每张图片的标题
@property(nonatomic, copy) NSString *buttonTitle;
//图片的地址
@property(nonatomic, copy) NSString *photoURL;
@property(nonatomic, copy) NSString *detailPhotoURL;

//发布时间
@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;
//关注度（人数）
@property(nonatomic, copy) NSString *attention;
//参与（人数）
@property(nonatomic, copy) NSString *joinedNumber;
//地点，目的地
@property(nonatomic, copy) NSString *dest;
//摘要
@property(nonatomic, copy) NSString *abstract;
//类别
@property(nonatomic, copy) NSString *className;
@property(nonatomic, copy) NSString *tel;
@property(nonatomic, copy) NSString * location;
//存下时间的id号
@property(nonatomic,copy) NSString * idNumber;

@end
