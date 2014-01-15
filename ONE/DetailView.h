//
//  DetailView.h
//  ONE
//
//  Created by dianji on 12-12-13.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"

@class DetailView;

@protocol DetailViewDelegate <NSObject>

- (void)detailView:(DetailView *)view addToFav:(MessageInfo *)info;
- (void)detailView:(DetailView *)view joined:(MessageInfo *)info;
- (void)detailView:(DetailView *)view detail:(MessageInfo *)info;
- (void)detailView:(DetailView *)view;
- (void)detailView:(DetailView *)view largeImageClicked:(UIImageView *)imageView;
@end

@interface DetailView : UIView<UIAlertViewDelegate>
{
    UILabel *_lastTime;//顶部的显示剩余时间
    UIImageView *_imageVIew;//显示大的图片
    MessageInfo *_info;
    //关注度
    UIImageView*attentionImage;
    UILabel*attentionLabel;
    UILabel*joinedLabel1;
    //距离现在的位置多远
    UIImageView*destanceImage;
    UILabel*destanceLabel;
    id<DetailViewDelegate> _delegate;
    //
    UIButton *addToFav;
    UIButton *join;
    //半透明图片
    UIImageView * view;
    UIActivityIndicatorView *_indictorView;
    //放大镜button，
    UIButton* largeButton;
}
@property(nonatomic , strong) UIImageView *_imageVIew;


- (id)initWithFrame:(CGRect)frame messageInfo:(MessageInfo *)info delegate:(id)delegate_;
-(void)detailappear;
@end
