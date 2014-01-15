//
//  TimeView.h
//  ONE
//
//  Created by dianji on 12-12-20.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeView ;

//把选中的button的title传回controller的label
@protocol TimeViewDelegate <NSObject>

- (void)timelView:(TimeView *)view withTime:(NSString*)time withClass:(NSString *)clases withArea:(NSString *)area ;

@end



@interface TimeView : UIView
{
    NSDictionary *_titleDic;
    id<TimeViewDelegate> _delegate;
    //记录选择的内容
    NSString *_selectedTime;
    NSString *_selectedClass;
    NSString *_selectedArea;
    //放置button的view
    UIView *_timeView;
    UIView *_classView;
    UIView *_areaView;
    
}


-(id)initWithFrame:(CGRect)frame infoDic:(NSDictionary *)infoDic delegate:(id)delegate_;

@end
