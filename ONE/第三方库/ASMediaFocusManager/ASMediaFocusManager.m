//
//  ASMediaFocusManager.m
//  ASMediaFocusManager
//
//  Created by Philippe Converset on 11/12/12.
//  Copyright (c) 2012 AutreSphere. All rights reserved.
//

#import "ASMediaFocusManager.h"
#import "ASMediaFocusController.h"

static CGFloat const kAnimateElasticSizeRatio = 0.03;
static CGFloat const kAnimateElasticDurationRatio = 0.6;
static CGFloat const kAnimationDuration = 0.5;

@interface ASMediaFocusManager ()
// The media view being focused.
@property (nonatomic, strong) UIView *mediaView;
@property (nonatomic, strong) ASMediaFocusController *focusViewController;
@end

@implementation ASMediaFocusManager

// Taken from https://github.com/rs/SDWebImage/blob/master/SDWebImage/SDWebImageDecoder.m
- (UIImage *)decodedImageWithImage:(UIImage *)image
{
    CGImageRef imageRef = image.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, imageSize.width, imageSize.height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpace, CGImageGetBitmapInfo(imageRef));
    CGColorSpaceRelease(colorSpace);
    
    // If failed, return undecompressed image
    if (!context) return image;
    
    CGContextDrawImage(context, imageRect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.animationDuration = kAnimationDuration;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.elasticAnimation = NO;
        self.zoomEnabled = YES;
    }
    
    return self;
}

- (void)installOnViews:(NSArray *)views
{
    for(UIView *view in views)
    {
        [self installOnView:view];
    }
}

- (void)installOnView:(UIView *)view
{
    UITapGestureRecognizer *tapGesture;
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFocusGesture:)];
    [view addGestureRecognizer:tapGesture];
    view.userInteractionEnabled = YES;
    [self handleFocusGesture:tapGesture];
}

- (ASMediaFocusController *)focusViewControllerForView:(UIView *)mediaView
{
    ASMediaFocusController *viewController;
    UITapGestureRecognizer *tapGesture;
    UIImage *image;
    
    image = [self.delegate mediaFocusManager:self imageForView:mediaView];
    if(image == nil)
        return nil;
    
    viewController = [[ASMediaFocusController alloc] initWithNibName:nil bundle:nil];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDefocusGesture:)];
    [viewController.view addGestureRecognizer:tapGesture];
    viewController.mainImageView.image = image;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image;
        image = [self.delegate mediaFocusManager:self imageForView:mediaView];
        image = [self decodedImageWithImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            viewController.mainImageView.image = image;
        });
    });
    
    return viewController;
}

- (CGRect)rectInsetsForRect:(CGRect)frame ratio:(CGFloat)ratio
{
    CGFloat dx;
    CGFloat dy;
    
    dx = frame.size.width*ratio;
    dy = frame.size.height*ratio;
    
    return CGRectInset(frame, dx, dy);
}

- (void)handleFocusGesture:(UIGestureRecognizer *)gesture
{
    UIViewController *parentViewController;
    ASMediaFocusController *focusViewController;
    CGPoint center;
    UIView *mediaView;
    UIView *imageView;
    
    mediaView = gesture.view;
    focusViewController = [self focusViewControllerForView:mediaView];
    if(focusViewController == nil)
        return;
    
    self.focusViewController = focusViewController;
    self.mediaView = mediaView;
    parentViewController = [self.delegate parentViewControllerForMediaFocusManager:self];
    [parentViewController addChildViewController:focusViewController];
    [parentViewController.view addSubview:focusViewController.view];
    focusViewController.view.frame = parentViewController.view.bounds;
    mediaView.hidden = NO;
    
    imageView = focusViewController.mainImageView;
    center = [imageView.superview convertPoint:mediaView.center fromView:mediaView.superview];
    imageView.center = center;
    imageView.transform = mediaView.transform;
    imageView.bounds = self.mediaView.bounds;
    imageView.alpha = 0;
    NSLog(@"=== %@ ===",NSStringFromCGRect(imageView.frame));
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         CGRect frame;
                         
                         frame = [self.delegate mediaFocusManager:self finalFrameforView:mediaView];
                         
                         imageView.transform = CGAffineTransformIdentity;
                         imageView.frame = frame;
                         
                         imageView.alpha = 1;
                         
                         focusViewController.view.backgroundColor = self.backgroundColor;
                     }
                     completion:^(BOOL finished) {
                         if(self.elasticAnimation)
                         {
                             [UIView animateWithDuration:self.animationDuration*kAnimateElasticDurationRatio
                                              animations:^{
                                                  imageView.frame = focusViewController.contentView.bounds;
                                              }
                                              completion:^(BOOL finished) {
                                                  [self installZoomView];
                                              }];
                         }
                         else
                         {
                             imageView.frame = [self.delegate mediaFocusManager:self finalFrameforView:mediaView];
                             [self installZoomView];
                         }
                     }];
    
}

- (void)installZoomView
{
    ASImageScrollView *scrollView;
    
    if(!self.zoomEnabled)
        return;
    
    scrollView = [[ASImageScrollView alloc] initWithFrame:[self.delegate mediaFocusManager:self finalFrameforView:self.mediaView]];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.focusViewController.scrollView = scrollView;
    [self.focusViewController.contentView addSubview:scrollView];
    [scrollView displayImage:self.focusViewController.mainImageView.image];
    self.focusViewController.mainImageView.hidden = YES;
    [scrollView release];
}

- (void)uninstallZoomView
{
    CGRect frame;
    
    if(!self.zoomEnabled)
        return;
    
    frame = [self.focusViewController.contentView convertRect:self.focusViewController.scrollView.zoomImageView.frame fromView:self.focusViewController.scrollView];
    self.focusViewController.scrollView.hidden = YES;
    self.focusViewController.mainImageView.hidden = NO;
    self.focusViewController.mainImageView.frame = frame;
}

- (void)handleDefocusGesture:(UIGestureRecognizer *)gesture
{
    UIView *contentView;
    CGRect __block bounds;
  
    [self uninstallZoomView];
    contentView = self.focusViewController.mainImageView;
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         self.focusViewController.contentView.transform = CGAffineTransformIdentity;
                         contentView.center = [contentView.superview convertPoint:self.mediaView.center fromView:self.mediaView.superview];
                         contentView.transform = self.mediaView.transform;
                         bounds = self.mediaView.bounds;
                         contentView.bounds = (self.elasticAnimation?[self rectInsetsForRect:bounds ratio:kAnimateElasticSizeRatio]:bounds);
                         gesture.view.backgroundColor = [UIColor clearColor];
                         contentView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         contentView.bounds = bounds;
                         self.mediaView.hidden = NO;
                         [self.focusViewController.view removeFromSuperview];
                         [self.focusViewController removeFromParentViewController];
                         self.focusViewController = nil;
                     }];
    
    if ((_delegate && [_delegate respondsToSelector:@selector(mediaFocusManager:finishedClickedForView:)])) {
        [_delegate mediaFocusManager:self finishedClickedForView:contentView];
    }
}
@end
