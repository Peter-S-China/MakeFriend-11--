//
//  FriendTableCell.m
//  MakeFriend
//
//  Created by dianji on 13-9-11.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "FriendTableCell.h"

@implementation FriendTableCell
-(UIImage*)chooseSexImage:(NSString*)sexStr
{
    switch ([sexStr intValue]) {
        case 0://男性
        {
            return [UIImage imageNamed:@"man.png"];
            break;
        }
        case 1://女性
        {
            return [UIImage imageNamed:@"woman.png"];
            break;
        }
        default:
            break;
    }
    return nil;
    
}
-(void)friendCellButtonclicked:(UIButton*)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(FriendTableCell:detalWithInfo:)]) {
        [_delegate FriendTableCell:self detalWithInfo:_info];
    }
    


}
-(void)cancelButtonClicked:(UIButton*)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(FriendTableCell:moveWithInfo:)]) {
        [_delegate FriendTableCell:self moveWithInfo:_info];
    }

}
-(void)creatRemoveView:(NSNotification *)notification
{
    cancelButton.hidden=NO;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(PhotoInfo *)finfo delegate:(id)delegate_
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        //最底层是两个view。一个放图片，一个放文字，为了有隔页的效果
        _info=[finfo retain];
        _delegate = delegate_;
        
        friendCellbackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 72)];
        friendCellbackView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"friendCellbackView.png"]];
        [self addSubview:friendCellbackView];
        [friendCellbackView release];
        
        friendCellImageview=[[UIImageView alloc]init];
        NSData  *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:finfo.useraLitleImageURL]];
        friendCellImageview.image=[[UIImage alloc] initWithData:data];
        
        friendCellImageview.layer.cornerRadius=4;
        friendCellImageview.layer.masksToBounds = YES;
        friendCellImageview.frame=CGRectMake(5, 10, 52, 52);
        [friendCellImageview.layer setBorderWidth:1];
        [friendCellImageview.layer setBorderColor:[UIColor grayColor].CGColor];
        //imageview.contentMode=UIViewContentModeScaleAspectFit;
        [friendCellbackView addSubview:friendCellImageview];
        [friendCellImageview release];
       
        // 昵称
        fnickName=[[UILabel alloc]initWithFrame:CGRectMake(75,5, 50, 20)];
        fnickName.text=finfo.userName;
        fnickName.font=[UIFont fontWithName:@"Arial-BoldMT" size:12];
        fnickName.textAlignment=NSTextAlignmentLeft;
        fnickName.textColor=[UIColor whiteColor];
        fnickName.backgroundColor=[UIColor clearColor];
        [friendCellbackView addSubview:fnickName];
        [fnickName release];
        
    
        //性别
        fsex=[[UIImageView alloc]initWithFrame:CGRectMake(75, 25, 10, 10)];
        fsex.image=[self chooseSexImage:finfo.userSex];
        fsex.backgroundColor=[UIColor clearColor];
        [friendCellbackView addSubview:fsex];
        [fsex release];
        //最新愿望
        fwish=[[UILabel alloc]initWithFrame:CGRectMake(75,35,180,36)];
        fwish.textAlignment=NSTextAlignmentLeft;
        fwish.font=[UIFont fontWithName:@"Arial-BoldMT" size:10];
        fwish.text=finfo.userWish;
        fwish.textColor=[UIColor whiteColor];
        fwish.numberOfLines=2;
        fwish.backgroundColor=[UIColor clearColor];
        [friendCellbackView addSubview:fwish];
        [fwish release];
        
        UIButton *friendCellButton=[UIButton buttonWithType:UIButtonTypeCustom];
        friendCellButton.frame=CGRectMake(0,0,120,70);
        friendCellButton.backgroundColor=[UIColor clearColor];
        [friendCellButton addTarget:self action:@selector(friendCellButtonclicked:) forControlEvents:UIControlEventTouchUpInside];
        [friendCellbackView addSubview:friendCellButton];
        
        cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(248, 20, 60, 25);
        [cancelButton setTitle:@"删除" forState:UIControlStateNormal];
        cancelButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.hidden=YES;
        [friendCellbackView addSubview:cancelButton];
        

        
        //注册通知出现删除按钮
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatRemoveView:) name:@"editData" object:nil];
    }
    return self;
    
    
    



}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
