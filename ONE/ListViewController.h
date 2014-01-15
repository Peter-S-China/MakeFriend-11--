//
//  ListViewController.h
//  ONE
//
//  Created by dianji on 13-1-11.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : JUJUViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView*listTableView;
    UIButton*left;
}

@property (nonatomic, retain) NSMutableArray *listInfos;

@end
