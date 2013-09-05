//
//  AllWishTableCell.m
//  MakeFriend
//
//  Created by dianji on 13-8-29.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "AllWishTableCell.h"
#import "UIButton+WebCache.h"
#import "QuartzCore/QuartzCore.h"
@implementation AllWishTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(AllWishInfo *)info commentCount:(NSString*)count delegate:(id)delegate_
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        _info=[info retain];
        _delegate = delegate_;
        commentCount=[count copy];
        //最底层是两个view。一个放图片，一个放文字，为了有隔页的效果
        
        backGroundView=[[UIView alloc]initWithFrame:CGRectMake(4, 0, 311, 129)];
        backGroundView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"allWishBack.png"]];
        [self addSubview:backGroundView];
        [backGroundView release];
        
        allWishContent=[[UILabel alloc]initWithFrame:CGRectMake(5, 15, 240, 20)];
        allWishContent.text=info.wishContent;
        allWishContent.font=[UIFont fontWithName:@"Arial-BoldMT" size:14];
        allWishContent.textAlignment=NSTextAlignmentLeft;
        allWishContent.textColor=[UIColor blackColor];
        allWishContent.backgroundColor=[UIColor clearColor];
        [backGroundView addSubview:allWishContent];
        [allWishContent release];
        
        imageview=[[UIImageView alloc]init];
        NSData  *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:info.wishLittelImageUrl]];
        imageview.image=[[UIImage alloc] initWithData:data];

        imageview.layer.cornerRadius=6;
        imageview.layer.masksToBounds = YES;
         imageview.frame=CGRectMake(5, 40, 85, 85);
        [imageview.layer setBorderWidth:1];
        [imageview.layer setBorderColor:[UIColor blackColor].CGColor];
      //imageview.contentMode=UIViewContentModeScaleAspectFit;
        [backGroundView addSubview:imageview];
        [imageview release];
 //布置时间和查看评论按钮
        UILabel*time=[[UILabel alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width-60, 5, 60, 20)];
        time.text=info.wishTime;
        time.textAlignment=NSTextAlignmentLeft;
        time.textColor=[UIColor blackColor];
        time.backgroundColor=[UIColor clearColor];
        time.font=[UIFont fontWithName:@"Arial-BoldMT" size:12];
        [backGroundView addSubview:time];
        [time release];
        
        UIImageView *commentView=[[UIImageView alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width-40, backGroundView.frame.size.height-25, 15,15)];
        commentView.image=[UIImage imageNamed:@"commentView.png"];
        [backGroundView addSubview:commentView];
        [commentView release];
        
        UILabel *commentCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width-25, backGroundView.frame.size.height-25, 22,15)];
        commentCountLabel.textAlignment=NSTextAlignmentLeft;
        commentCountLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:12];
        commentCountLabel.text=count;
        commentCountLabel.textColor=[UIColor blackColor];
        [backGroundView addSubview:commentCountLabel];
        [commentCountLabel release];
  }
    return self;




}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
