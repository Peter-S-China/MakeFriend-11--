//
//  Tools.h
//  Reader
//
//  Created by liangw on 9/4/12.
//  Copyright (c) 2012 qinyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface Tools : NSObject

//在view中显示提示信息
+ (void)showSpinnerInView:(UIView *)view prompt:(NSString *)prompt;
+ (void)hideSpinnerInView:(UIView *)view;
+ (void)showPrompt:(NSString *)prompt inView:(UIView *)view delay:(NSTimeInterval)delay;



//根据文件名获取图片
+ (UIImage *)imageWithName:(NSString *)name;

//创建label
+ (UILabel *)createLabel:(NSString *)content color:(UIColor *)color font:(UIFont *)font;
+ (UILabel *)createLabel:(NSString *)content frame:(CGRect)frame color:(UIColor *)color font:(UIFont *)font aliment:(UITextAlignment)aliment;
+ (UILabel*)createLabel:(NSString *)content width:(float)contentwidth color:(UIColor *)color font:(UIFont *)font aliment:(UITextAlignment)aliment;

//创建button
+ (UIButton *)createButtonWithNormalImage:(NSString *)normal
                           highlitedImage:(NSString *)highlited
                                   target:(id)target 
                                   action:(SEL)action;

+ (UIButton *)createButtonWithNormalImage:(NSString *)normal
                            selectedImage:(NSString *)highlited
                                   target:(id)target 
                                   action:(SEL)action;
//创建navbar
+ (UIBarButtonItem *)createNavButtonItem:(NSString *)normal
                                selected:(NSString *)selected
                                  target:(id)taget
                                  action:(SEL)action;

//检查本地是不是存在输入的路径
+ (UIImage *)isExitInLocal:(NSString *)path;
+(int)isIphone5;
//获取mac地址作为唯一得标识符
+(NSString*)getUdid;
//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
