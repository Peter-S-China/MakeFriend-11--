//
//  CommentInfoCell.m
//  MakeFriend
//
//  Created by dianji on 13-8-26.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "CommentInfoCell.h"
#import "UIButton+WebCache.h"
@implementation CommentInfoCell

-(void)littleImageClicked:(UIButton*)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(commentInfoCell:checkWithInfo:)]) {
        [_delegate commentInfoCell:self checkWithInfo:_info];
    }


}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(ConmentInfo *)info delegate:(id)delegate_
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        _info=[info retain];
        _delegate = delegate_;
        self.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
        self.userInteractionEnabled=YES;
     //创建tablecell，一个承载小图的button，一个昵称的label，一个内容label
        littleImageButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        littleImageButton.frame=CGRectMake(10, 3, 35, 35);
        [littleImageButton addTarget:self action:@selector(littleImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [littleImageButton setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_info.commenterLittelImageUrl]]];
        [self addSubview:littleImageButton];
        
        commenterName=[[UILabel alloc]initWithFrame:CGRectMake(55, 3, 100, 15)];
        commenterName.text=[NSString stringWithFormat:@"%@",_info.commenterNickName];
        commenterName.textColor=[UIColor blackColor];
        commenterName.backgroundColor=[UIColor clearColor];
        commenterName.font=[UIFont fontWithName:@"Arial-BoldMT" size:12];
        [self addSubview:commenterName];
        [commenterName release];
        
        commetStr=[[UILabel alloc]initWithFrame:CGRectMake(55, 18, 230, 25)];
        commetStr.text=[NSString stringWithFormat:@"%@",_info.commentStr];
        commetStr.textColor=[UIColor blackColor];
        commetStr.backgroundColor=[UIColor clearColor];
        commetStr.numberOfLines=0;
        commetStr.font=[UIFont fontWithName:@"Arial-BoldMT" size:10];
        [self addSubview:commetStr];
        [commetStr release];
        //加一条黑线
        UIView*blackLine=[[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-2, self.bounds.size.width, 2)];
        blackLine.backgroundColor=[UIColor blackColor];
        [self addSubview:blackLine];
        [blackLine release];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
