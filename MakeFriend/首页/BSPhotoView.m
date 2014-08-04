//
//  BSPhotoView.m
//  WaterFlowDemo
//
//  Created by Jerry Xu on 7/9/13.
//  Copyright (c) 2013 Jerry Xu. All rights reserved.
//

#import "BSPhotoView.h"
#import "UIButton+WebCache.h"
//缓存路径
#define PATH_TO_STORE_IMAGE [[NSHomeDirectory() stringByAppendingPathComponent:@"/Library"] stringByAppendingPathComponent:@"/Caches"]

@implementation BSPhotoView

- (void)dealloc
{
    [_request clearDelegatesAndCancel];
    [super dealloc];
}

#pragma mark - Customs Methods
- (void)photoButtonPressed:(id)sender
{
    if (_delegate || [_delegate respondsToSelector:@selector(BSPhotoView:handleWithInfo:)]) {
        [_delegate BSPhotoView:self handleWithInfo:_info];
    }
}
-(void)litlePhotoButtonPressed:(id)sender
{


}
#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.945 alpha:1.0];
        
        infoBackImage=[[UIImageView alloc]initWithFrame:CGRectZero];
        infoBackImage.image=[[UIImage imageNamed:@"infoBackImage.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:6];
        infoBackImage.userInteractionEnabled=YES;
        [self addSubview:infoBackImage];
        [infoBackImage release];
        
       //初始化button和button上面的地址和时间
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoButton.exclusiveTouch = YES;
        [_photoButton addTarget:self action:@selector(photoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _photoButton.alpha = 1;
        [infoBackImage addSubview:_photoButton];
        
        _addressAndTime=[[UIImageView alloc]initWithFrame:CGRectZero];
        _addressAndTime.image=[UIImage imageNamed:@"addressAndTime.png"];
        [_photoButton addSubview:_addressAndTime];
        [_addressAndTime release];
        
       //加载在_addressAndTime上面得时间和地点
        _wishAddress=[[UILabel alloc]initWithFrame:CGRectZero];
        _wishAddress.backgroundColor = [UIColor clearColor];
        _wishAddress.font = [UIFont systemFontOfSize:10];
        _wishAddress.textColor = [UIColor whiteColor];
        [_addressAndTime addSubview:_wishAddress];
        [_wishAddress release];
        _wishTime=[[UILabel alloc]initWithFrame:CGRectZero];
        _wishTime.backgroundColor = [UIColor clearColor];
        _wishTime.font = [UIFont systemFontOfSize:10];
        _wishTime.textAlignment=NSTextAlignmentLeft;
        _wishTime.textColor = [UIColor whiteColor];
        [_addressAndTime addSubview:_wishTime];
        [_wishTime release];
        
        
       //下面是一个固定高度承载label的view
        
        _wishContentView=[[UIView alloc]initWithFrame:CGRectZero];
        _wishContentView.backgroundColor=[UIColor clearColor];
        [infoBackImage addSubview:_wishContentView];
        [_wishContentView release];
        
        _momentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _momentLabel.backgroundColor = [UIColor clearColor];
        _momentLabel.font = [UIFont systemFontOfSize:12];
        _momentLabel.textColor = [UIColor whiteColor];
        _momentLabel.numberOfLines = 0;
        [_wishContentView addSubview:_momentLabel];
        [_momentLabel release];
       
        _litlePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _litlePhotoButton.exclusiveTouch = YES;
        [_litlePhotoButton addTarget:self action:@selector(litlePhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _litlePhotoButton.alpha = 1;
        [_wishContentView addSubview:_litlePhotoButton];
      
        _userName=[[UILabel alloc]initWithFrame:CGRectZero];
        _userName.backgroundColor = [UIColor clearColor];
        _userName.font = [UIFont fontWithName:@"Arial-BoldMT" size:10];
        _userName.textColor = [UIColor whiteColor];
        _userName.textAlignment=NSTextAlignmentCenter;
        _userName.numberOfLines = 0;
        [_wishContentView addSubview:_userName];
        [_userName release];

        
        
    }
    return self;
}

- (void)appear
{
    if (_status == PhotoStatusNormal || _status == PhotoStatusDownloadFailed) {
        if (!_info.useraLargeImageURL || [_photoButton imageForState:UIControlStateNormal] != nil) {
            return;
        }
        _status = PhotoStatusDownloading;
        dispatch_async(_queue, ^{
            //do something
            @autoreleasepool {
                NSString *path = [PATH_TO_STORE_IMAGE stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[NSURL URLWithString:_info.useraLargeImageURL] lastPathComponent]]];
                UIImage *img = [UIImage imageWithContentsOfFile:path];//[[UIImage alloc] initWithContentsOfFile:path];
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    //回到主线程
                    if (img) {
                        _status = PhotoStatusDownloadFinished;
                        [_photoButton setImage:img forState:UIControlStateNormal];
                        _photoButton.alpha = 1;
                    }
                    else {
                        //开始下载图片                        
                        [_request clearDelegatesAndCancel];
                        _request = nil;
                        _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:_info.useraLargeImageURL]];
                        [_request setDelegate:self];
                        [_request setDidFailSelector:@selector(loadFailed:)];
                        [_request setDidFinishSelector:@selector(loadFinish:)];
                        [_request startAsynchronous];
                    }
                });
                
            }
            
        });
    }
}

- (void)disappear
{
    _status = PhotoStatusNormal;
    [_photoButton setImage:nil forState:UIControlStateNormal];
    _photoButton.alpha = 0;
}

#pragma mark - ASIHTTPRequest Delegate
- (void)loadFinish:(ASIHTTPRequest *)request
{
    if (_status != PhotoStatusDownloading) {
        return;
    }
    _photoButton.alpha = 0;
    UIImage *image = [[UIImage alloc] initWithData:request.responseData];
    if (image) {
        NSString *path = [PATH_TO_STORE_IMAGE stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[NSURL URLWithString:_info.useraLargeImageURL] lastPathComponent]]];
        [request.responseData writeToFile:path atomically:NO];
        [_photoButton setImage:image forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void) {
                             _photoButton.alpha = 1;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    _status = PhotoStatusDownloadFinished;
}

- (void)loadFailed:(ASIHTTPRequest *)request
{
    NSLog(@"下载图片失败, %@  %@", request.error,request.url);
    _status = PhotoStatusDownloadFailed;
}

#pragma mark - Methods For Reuse
- (void)prepareForReuse
{
    if (_queue != NULL) {
        _queue = NULL;
    }
    [_request clearDelegatesAndCancel];
    [_photoButton setImage:nil forState:UIControlStateNormal];
    _momentLabel.text = nil;
    _status = PhotoStatusNormal;
    _info = nil;
}

- (void)fillViewWithObject:(PhotoInfo *)object
{
    _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _info = object;
    int image_h = 0;
    if (_info.height != 0) {
        image_h = (int)_info.height * 150/_info.width;
    }
    //背景高度是图片高度加上固定的label高度
    self.backgroundColor=[UIColor clearColor];
    infoBackImage.frame=CGRectMake(0, 0, 156, image_h+55);

    _photoButton.frame = CGRectMake(3.5, 3.5, 148, image_h-7);
    _addressAndTime.frame=CGRectMake(0, CGRectGetMaxY(_photoButton.frame)-25, 148, 25);
    _wishAddress.frame=CGRectMake(15, 5, 50, 15);
    _wishAddress.text=_info.userwishAdderess;
    _wishTime.frame=CGRectMake(90, 5, 65, 15);
    _wishTime.text=_info.userwishTime;
    
    _wishContentView.frame=CGRectMake(4.5, CGRectGetMaxY(_photoButton.frame) + 5, 145, 45);
    _momentLabel.frame = CGRectMake(2,0, 100, 45);
    _momentLabel.text = _info.userWish;
    _litlePhotoButton.frame=CGRectMake(108,5, 32, 32);
    [_litlePhotoButton setImageWithURL:[NSURL URLWithString:_info.useraLitleImageURL] success:^(UIImage*image){
        
    } failure:^(NSError *error) {
        
    }];

    _userName.frame=CGRectMake(105,CGRectGetMaxY(_litlePhotoButton.frame)+1, 40, 12);
    _userName.text=_info.userName;
    if (_status != PhotoStatusDownloading) {
        [self appear];
    }
}

+ (CGFloat)heightForViewWithObject:(PhotoInfo *)object inColumnWidth:(CGFloat)columnWidth
{
    int image_h = 0;
    if (object.height != 0) {
        image_h = (int)object.height * 150/object.width;
    }
 /*   CGSize contentSize = [object.userDescription sizeWithFont: [UIFont systemFontOfSize:12]
                                           constrainedToSize: CGSizeMake(140,MAXFLOAT)                                                                lineBreakMode: NSLineBreakByWordWrapping];*/
    //喜欢按钮的最低高度
    float content_h = 50.0;
    
    float view_h = 3 + image_h + content_h;
    return view_h;
}

@end
