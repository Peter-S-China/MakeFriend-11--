//
//  MyWishViewController.h
//  MakeFriend
//
//  Created by dianji on 13-8-23.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoInfo.h"
#import "CommentInfoCell.h"
@interface MyWishViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UIView *myWishNavView;
    UILabel *myWishTitle;
    UIButton *myWishRightButton;
    UIButton *myWishBackButton;
    NSMutableArray *conmmtArray;
    UITableView *_commentTale;
    NSString *constellatory;//暂时存星座
    UIView *rightNavBarClickedView;//点击右导航出现的view
    UITextView*commenttextView;
    UIButton *sendButton;
    UIView* conmmetBackView;
}
@property(nonatomic,strong)PhotoInfo *wishInfo;
@property(nonatomic,strong) CommentInfoCell*cell;
@property(nonatomic,copy)NSString *constellatory;
@property(nonatomic,strong)NSMutableArray *conmmtArray;
@end
