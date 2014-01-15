//
//  ListCell.m
//  ONE
//
//  Created by dianji on 13-1-11.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      //加一个小图标
        UIImageView*imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FAN2.png"]];
        imageview.frame=CGRectMake(20, 5, 40, 40);
        [self addSubview:imageview];
        [imageview release];
        
        UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(85, 10, 150, 30)];
        nameLabel.text=@"查看我周边的活动位置信息";
        nameLabel.font=[UIFont systemFontOfSize:18];
        //设置字的颜色
        nameLabel.textColor=[UIColor colorWithRed:207.12/225 green:137.77/255 blue:0/255 alpha:1];
        nameLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:nameLabel];
        [nameLabel release];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
