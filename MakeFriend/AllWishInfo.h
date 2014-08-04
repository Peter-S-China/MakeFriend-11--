//
//  AllWishInfo.h
//  MakeFriend
//
//  Created by dianji on 13-8-29.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConmentInfo.h"
@interface AllWishInfo : NSObject

@property (nonatomic, copy) NSString *wishId;
@property (nonatomic, copy) NSString *wishContent;
@property (nonatomic, copy) NSString *wishTime;
@property (nonatomic, copy) NSString *wishLittelImageUrl;
@property (nonatomic, strong)NSMutableArray *allCommentInfos;

@end
