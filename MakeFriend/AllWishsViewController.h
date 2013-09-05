//
//  AllWishsViewController.h
//  MakeFriend
//
//  Created by dianji on 13-8-29.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoInfo.h"
#import "AllWishTableCell.h"
@interface AllWishsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIView *navView;
    UILabel *titleLabel;
    UIButton *leftButton;
    UITableView *allWishTable;
}
@property(nonatomic,strong)PhotoInfo *info;
@property(nonatomic,strong)NSMutableArray *allWishArray;
@property(nonatomic,strong) AllWishTableCell*cell;
@end
