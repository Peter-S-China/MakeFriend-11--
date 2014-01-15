//
//  Tools.m
//  Reader
//
//  Created by liangw on 9/4/12.
//  Copyright (c) 2012 qinyh. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (void)showSpinnerInView:(UIView *)view prompt:(NSString *)prompt
{
    if (view != nil) {
        [MBProgressHUD hideAllHUDsForView:view animated:NO];
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        HUD.removeFromSuperViewOnHide = YES;
        if (prompt.length > 0) {
            HUD.mode = MBProgressHUDModeIndeterminate;
            HUD.labelText = prompt;
        }
    }
}
+ (void)hideSpinnerInView:(UIView *)view
{
    if (view != nil) {
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    }
}
+ (void)showPrompt:(NSString *)prompt inView:(UIView *)view delay:(NSTimeInterval)delay
{
    if (view != nil) {
        [MBProgressHUD hideAllHUDsForView:view animated:NO];
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        HUD.removeFromSuperViewOnHide = YES;
        if (prompt.length > 0) {
            HUD.mode = MBProgressHUDModeText;
            HUD.labelText = prompt;
        }
        [HUD hide:YES afterDelay:delay];
    }
}

+ (UIImage *)imageWithName:(NSString *)name
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:NSLocalizedString(name,@"适配") ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    return [image autorelease];
}

+ (UILabel *)createLabel:(NSString *)content color:(UIColor *)color font:(UIFont *)font
{
    CGSize size = [content sizeWithFont:font];
    return [self createLabel:content frame:CGRectMake(0, 0, (int)size.width, (int)size.height) color:color font:font aliment:UITextAlignmentCenter];
}

+ (UILabel *)createLabel:(NSString *)content frame:(CGRect)frame color:(UIColor *)color font:(UIFont *)font aliment:(UITextAlignment)aliment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.text = content;
    label.textColor = color;
    label.font = font;
    label.textAlignment = aliment;
    return [label autorelease];
}

+ (UILabel*)createLabel:(NSString *)content width:(float)contentwidth color:(UIColor *)color font:(UIFont *)font aliment:(UITextAlignment)aliment
{
    CGSize size = [content sizeWithFont:font];
    float heightnum = size.width/contentwidth;
    int height = (heightnum + 1)*size.height;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentwidth, height)];
    label.numberOfLines = 1000;
    label.backgroundColor = [UIColor clearColor];
    label.text = content;
    label.textColor = color;
    label.font = font;
    label.textAlignment = aliment;
    return [label autorelease];
}

+ (UIButton *)createButtonWithNormalImage:(NSString *)normal
                           highlitedImage:(NSString *)highlited
                                   target:(id)target 
                                   action:(SEL)action
{
    
    UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    UIImage *normalImage = [self imageWithName:normal];
    UIImage *highlightImage = [self imageWithName:highlited];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    return [button autorelease];
    
}

+ (UIButton *)createButtonWithNormalImage:(NSString *)normal
                            selectedImage:(NSString *)highlited
                                   target:(id)target 
                                   action:(SEL)action
{
    UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    UIImage *normalImage = [self imageWithName:normal];
    UIImage *selectedImage = [self imageWithName:highlited];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateHighlighted];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    return [button autorelease];
}

//创建navbar
+ (UIBarButtonItem *)createNavButtonItem:(NSString *)normal
                                selected:(NSString *)selected
                                  target:(id)taget
                                  action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImg = [self imageWithName:normal];
    UIImage *selectedImg = [self imageWithName:selected];
    CGSize size = normalImg.size;
    button.frame = CGRectMake(0, 0, size.width,size.height);
    [button setImage:normalImg forState:UIControlStateNormal];
    [button setImage:selectedImg forState:UIControlStateHighlighted];
    [button addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return [item autorelease];
}


+ (UIImage *)isExitInLocal:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        return image;
    }
    else {
        return nil;
    }
}
+(int)isIphone5
{
    if ([UIScreen mainScreen].bounds.size.height > 480.0) {
        return 88;
    }
    return 0;

}
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize

{
    // Create a graphics image context
    
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    
    UIGraphicsEndImageContext();
    
    // Return the new image.
    
    return newImage;
    
}
+ (NSString *)getUdid
{
   
    CFUUIDRef puuid=CFUUIDCreate(nil);
    CFStringRef uuidString=CFUUIDCreateString(nil, puuid);
    NSString*result=(NSString*)CFStringCreateCopy(NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    return [result autorelease];
}
@end
