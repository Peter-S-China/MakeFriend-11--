//
//  EGORefreshTableFooterView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	EGOOPullRefreshPulling1 = 0,
	EGOOPullRefreshNormal1,
	EGOOPullRefreshLoading1,	
} EGOPullRefreshState1;

@protocol EGORefreshTableFooterDelegate;
@interface EGORefreshTableFooterView : UIView {
	
	id _delegate;
	EGOPullRefreshState1 _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
    NSString *_dateFlag;//对于不同的Footer，用它来标记时间的key


}

@property(nonatomic,assign) id <EGORefreshTableFooterDelegate> delegate;

- (id)init __attribute__((deprecated));
- (id)initWithFrame:(CGRect)frame __attribute__((deprecated));
- (id)initWithFrame:(CGRect)frame footerName:(NSString *)name;
- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
@protocol EGORefreshTableFooterDelegate
- (void)EGORefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)view;
- (BOOL)EGORefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view;
@optional
- (NSDate*)EGORefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView*)view;
@end
