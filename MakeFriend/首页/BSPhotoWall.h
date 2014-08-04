//
//  BSPhotoWall.h
//  WaterFlowDemo
//
//  Created by Jerry Xu on 7/9/13.
//  Copyright (c) 2013 Jerry Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSPhotoView.h"

@protocol BSWaterViewDataSourse;

@interface BSPhotoWall : UIScrollView

@property (nonatomic, assign, readonly) CGFloat colWidth;
@property (nonatomic, assign, readonly) NSInteger numCols;
@property (nonatomic, assign) id <BSWaterViewDataSourse> bsWaterViewDataSource;

#pragma mark - Public Methods

- (void)reloadData;
- (void)insertAtEnd:(BOOL)end;
- (UIView *)dequeueReusableView;
- (void)removeAndAddCellsIfNecessary;
- (void)showVisiblePhotos;

@end

#pragma mark - DataSource

@protocol BSWaterViewDataSourse <NSObject>

@required
- (NSInteger)numberOfViewsInCollectionView:(BSPhotoWall *)collectionView;
- (BSPhotoView *)collectionView:(BSPhotoWall *)collectionView viewAtIndex:(NSInteger)index;
- (CGFloat)heightForViewAtIndex:(NSInteger)index;

@end