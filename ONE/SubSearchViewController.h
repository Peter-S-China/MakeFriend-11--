//
//  SubSearchViewController.h
//  ONE
//
//  Created by Liang Wei on 12/23/12.
//  Copyright (c) 2012 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "subSearchCell.h"
#import "JUJUViewController.h"
#import "EGORefreshTableFooterView.h"
@interface SubSearchViewController : JUJUViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableFooterDelegate,subSearchCellDelegate>
{
    UISearchBar *_searchBar;
    UITableView *_tableView;
    
    NSMutableArray *_searschInfos;//保存搜索的信息
    //下拉加载更多
    EGORefreshTableFooterView *_footerView;
    BOOL _loadMore;
    BOOL _isHiddenTabbar;
    UIView *navView;
    UIScrollView *navScorllview;
}
@property(nonatomic, retain) NSMutableArray *_searschInfos;
@end
