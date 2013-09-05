//
//  LoginModel.h
//  MakeFriend
//
//  Created by dianji on 13-8-20.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;//用户手机号码
@property (nonatomic, strong) NSString *userImageURL;
@property (nonatomic, strong) NSString *usernickName;//用户昵称
@end
