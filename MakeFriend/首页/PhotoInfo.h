//
//  PhotoInfo.h
//  WaterFlowDemo
//
//  Created by Jerry Xu on 7/9/13.
//  Copyright (c) 2013 Jerry Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
//Data model of picture

@interface PhotoInfo : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;//昵称
@property (nonatomic, strong) NSString *userAddress;
@property (nonatomic, strong) NSString *userSignature;//签名
@property (nonatomic, strong) NSString *userRegestName;//注册手机号码
@property (nonatomic, strong) NSString *useraLargeImageURL;
@property (nonatomic, strong) NSString *useraLitleImageURL;
@property (nonatomic, strong) NSString *userwishAdderess;
@property (nonatomic, strong) NSString *userwishTime;
@property (nonatomic, strong) NSString *userWish;
@property (nonatomic, strong) NSString *userSex;
@property (nonatomic, strong) NSString *userBirth;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;

@end
