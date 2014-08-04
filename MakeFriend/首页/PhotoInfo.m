//
//  PhotoInfo.m
//  WaterFlowDemo
//
//  Created by Jerry Xu on 7/9/13.
//  Copyright (c) 2013 Jerry Xu. All rights reserved.
//

#import "PhotoInfo.h"

@implementation PhotoInfo
@synthesize userAddress,useraLargeImageURL,useraLitleImageURL,userBirth,userID,userName,userRegestName,userSex,userSignature,userWish,userwishAdderess,userwishTime;
-(void)dealloc
{
    userAddress=nil;
    useraLargeImageURL=nil;
    useraLitleImageURL=nil;
    userBirth=nil;
    userID=nil;
    userName=nil;
    userRegestName=nil;
    userSex=nil;
    userSignature=nil;
    userWish=nil;
    userwishAdderess=nil;
    userwishTime=nil;
    [super dealloc];
}
@end
