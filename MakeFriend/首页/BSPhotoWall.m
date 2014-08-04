//
//  BSPhotoWall.m
//  WaterFlowDemo
//
//  Created by Jerry Xu on 7/9/13.
//  Copyright (c) 2013 Jerry Xu. All rights reserved.
//

#import "BSPhotoWall.h"

#define kMargin 12.0

static inline NSString *WaterFlowKeyForIndex(NSInteger index)
{
    return [NSString stringWithFormat:@"%d",index];
}

static inline NSInteger WaterFlowIndexForKey(NSString *key)
{
    return [key integerValue];
}

#pragma mark - UIView的分类

@interface UIView (AOWaterView)

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, readonly) CGFloat right;
@property (nonatomic, readonly) CGFloat bottom;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

@implementation UIView (LMKBWaterFlowView)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame =frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end

#pragma mark - 图片墙的一些私有方法和属性
@interface BSPhotoWall ()

@property (nonatomic, assign, readwrite) CGFloat colWidth;
@property (nonatomic, assign, readwrite) NSInteger numCols;

@property (nonatomic, assign) CGRect lastFrame;
@property (nonatomic, retain) NSMutableSet *reuseableViews;
@property (nonatomic, retain) NSMutableDictionary *visibleViews;
@property (nonatomic, retain) NSMutableArray *viewKeysToRemove;
@property (nonatomic, retain) NSMutableDictionary *indexToRectMap;

- (void)relayoutViews;
- (void)enqueueReusableView:(BSPhotoView *)view;

@end

@implementation BSPhotoWall

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alwaysBounceVertical = YES;
        _colWidth = 0;
        _numCols = 0;        
        self.reuseableViews = [NSMutableSet set];
        self.visibleViews = [NSMutableDictionary dictionary];
        self.viewKeysToRemove = [NSMutableArray array];
        self.indexToRectMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)reloadData
{
    [self relayoutViews];
}

- (void)insertAtEnd:(BOOL)end
{
    self.numCols = 2;
    
    [_viewKeysToRemove removeAllObjects];
    [_indexToRectMap removeAllObjects];
    
    NSInteger numViews = [_bsWaterViewDataSource numberOfViewsInCollectionView:self];
    CGFloat totleHeight = 0.0;
    CGFloat top = 2;
    
    if (numViews > 0) {
        //初始化开始的高度
        NSMutableArray *colOffsets = [NSMutableArray arrayWithCapacity:self.numCols];
        for (int i = 0; i < self.numCols; i++) {
            [colOffsets addObject:[NSNumber numberWithFloat:top]];
        }
        
        // 计算一个商品的frame
        self.colWidth = 156;
        for (NSInteger i = 0; i < numViews; i++) {
            NSString *key = WaterFlowKeyForIndex(i);
            //找到最短的一列
            NSInteger col = 0;
            CGFloat minHeight = [[colOffsets objectAtIndex:col] floatValue];
            for (int i = 1; i < [colOffsets count]; i++) {
                CGFloat colHeight = [[colOffsets objectAtIndex:i] floatValue];
                
                if (colHeight < minHeight) {
                    col = i;
                    minHeight = colHeight;
                }
            }
            
            CGFloat left = 2 + (col * 2) + (col * self.colWidth);
            CGFloat top = [[colOffsets objectAtIndex:col] floatValue];
            CGFloat colHeight = [_bsWaterViewDataSource heightForViewAtIndex:i];
            if (colHeight == 0) {
                colHeight = self.colWidth;
            }
            
            if (top != top) {
                // NaN
            }
            
            CGRect viewRect = CGRectMake(left, top, self.colWidth, colHeight);
            
            [self.indexToRectMap setObject:NSStringFromCGRect(viewRect) forKey:key];
            
            CGFloat test = top + colHeight + 4;
            
            if (test != test) {
                // NaN
            }
            [colOffsets replaceObjectAtIndex:col withObject:[NSNumber numberWithFloat:test]];
        }
        
        for (NSNumber *colHeight in colOffsets) {
            totleHeight = (totleHeight < [colHeight floatValue]) ? [colHeight floatValue] : totleHeight;
        }
        //        totleHeight += kMargin;
        self.contentSize = CGSizeMake(self.width, totleHeight);
        
    }
    if (self.contentSize.height < CGRectGetHeight(self.frame)) {
        self.contentSize = CGSizeMake(self.width, CGRectGetHeight(self.frame));
    }
    
    [self removeAndAddCellsIfNecessary];
    
}

- (void)relayoutViews
{
    self.numCols = 2;
    _lastFrame = CGRectZero;
    [self.visibleViews enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        BSPhotoView *view = (BSPhotoView *)obj;
        [self enqueueReusableView:view];
    }];
    [self.visibleViews removeAllObjects];
    [self insertAtEnd:NO];
}

- (void)removeAndAddCellsIfNecessary
{
    @autoreleasepool {
        static NSInteger bufferViewFactor = 3;
        static NSInteger topIndex = 0;
        static NSInteger bottomIndex = 0;
        
        NSInteger numViews = [_bsWaterViewDataSource numberOfViewsInCollectionView:self];
        if (numViews == 0) {
            return;
        }
        
        CGRect visibleRect1 = CGRectMake(self.contentOffset.x, self.contentOffset.y, self.width, self.height);
        [self.visibleViews enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            BSPhotoView *view = (BSPhotoView *)obj;
            CGRect viewRect = view.frame;
            if (!CGRectIntersectsRect(visibleRect1, viewRect)) {
                [self enqueueReusableView:view];
                [self.viewKeysToRemove addObject:key];
            }
        }];
        
        [self.visibleViews removeObjectsForKeys:self.viewKeysToRemove];
        [_viewKeysToRemove removeAllObjects];
        
        if ([_visibleViews count] == 0) {
            topIndex = 0;
            bottomIndex = numViews;
        }
        else {
            NSArray *sortKeys = [[_visibleViews allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                else if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                else {
                    return (NSComparisonResult)NSOrderedSame;
                }
            }];
            
            topIndex = [[sortKeys objectAtIndex:0] integerValue];
            bottomIndex = [[sortKeys lastObject] integerValue];
            topIndex = MAX(0, topIndex - (bufferViewFactor * self.numCols));
            bottomIndex = MIN(numViews, bottomIndex + (bufferViewFactor * self.numCols));
        }
        
        for (NSInteger i = topIndex; i < bottomIndex; i ++) {
            NSString *key = WaterFlowKeyForIndex(i);
            CGRect rect = CGRectFromString([self.indexToRectMap objectForKey:key]);
            if (CGRectIntersectsRect(_lastFrame, rect) && [self.visibleViews objectForKey:key] != nil) {
                continue;
            }
            if (CGRectIntersectsRect(visibleRect1, rect)) {
                if (![self.visibleViews objectForKey:key]) {
                    BSPhotoView *newView = [_bsWaterViewDataSource collectionView:self viewAtIndex:i];
                    newView.frame = rect;
                    newView.delegate = _bsWaterViewDataSource;
                    [self.visibleViews setObject:newView forKey:key];
                    [self addSubview:newView];
                }
                else {
                    BSPhotoView *newView = [self.visibleViews objectForKey:key];
                    newView.frame = rect;
                    newView.delegate = _bsWaterViewDataSource;
                    [self addSubview:newView];
                }
            }
        }
        self.lastFrame = visibleRect1;

    }
}

#pragma mark - Reusing Views
- (BSPhotoView *)dequeueReusableView
{
    __autoreleasing BSPhotoView *view = [self.reuseableViews anyObject];
    if (view) {
        [self.reuseableViews removeObject:view];
     }
    
    return view;
}

- (void)enqueueReusableView:(BSPhotoView *)view
{
    if ([view respondsToSelector:@selector(prepareForReuse)]) {
        [view performSelector:@selector(prepareForReuse)];
    }
    view.frame = CGRectZero;
    [self.reuseableViews addObject:view];
    [view removeFromSuperview];
}


@end
