//
//  LargeImageViewController.m
//  ONE
//
//  Created by dianji on 13-2-26.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "LargeImageViewController.h"
#import "Tools.h"
@interface LargeImageViewController ()

@end

@implementation LargeImageViewController
@synthesize largeImageView;


-(void)backButtonClicked:(UIButton*)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)saveToLocalClicked:(UIButton*)button
{
  UIImageWriteToSavedPhotosAlbum( self.largeImageView.image, self, @selector ( image:didFinishSavingWithError:contextInfo:) , nil ) ;
}
#pragma mark-SAVEIMAGE-delegate
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        NSLog(@"%@",error);
        
    }
    else  
    {
        [Tools showPrompt:@"图片保存成功!可以去相册看看啦!"inView:self.view delay:0.7];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加上返回按钮
    
    UIButton*left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setBackgroundImage:[UIImage imageNamed:@"back_norm.png"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 8, 60,30);
    [left setTitle:@"返回" forState:UIControlStateNormal];
    [left setTitle:@"返回" forState:UIControlStateHighlighted];
    left.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [left addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    self.navigationItem.leftBarButtonItem = item1;
    [item1 autorelease];
    UIButton* right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setBackgroundImage:[UIImage imageNamed:@"editeNorm.png"] forState:UIControlStateNormal];
    right.frame = CGRectMake(0, 8, 50,30);
    [right setTitle:@"保存" forState:UIControlStateNormal];
    [right setTitle:@"保存" forState:UIControlStateHighlighted];
    right.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [right addTarget:self action:@selector(saveToLocalClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    self.navigationItem.rightBarButtonItem = item;
    [item autorelease];
    
    UIImageView*imageview=[[UIImageView alloc]initWithImage:self.largeImageView.image];
    imageview.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:imageview];
    [imageview release];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
