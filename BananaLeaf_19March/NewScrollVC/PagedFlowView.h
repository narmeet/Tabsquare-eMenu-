//
//  PagedFlowView.h
//  taobao4iphone
//
//  Created by manoj on 5/2/13.
//  Copyright (c) 2012 geeklu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PagedFlowViewDataSource;
@protocol PagedFlowViewDelegate;


typedef enum{
    PagedFlowViewOrientationHorizontal = 0,
    PagedFlowViewOrientationVertical
}PagedFlowViewOrientation;

@interface PagedFlowView : UIView<UIScrollViewDelegate>{
    
    PagedFlowViewOrientation orientation;
    
    UIScrollView        *_scrollView;
    BOOL                _needsReload;
    CGSize              _pageSize; 
    NSInteger           _pageCount;  
    NSInteger           _currentPageIndex;
    
    NSMutableArray      *_cells;
    NSRange              _visibleRange;
    NSMutableArray      *_reusableCells;
    
    UIPageControl       *pageControl;
    CGFloat _minimumPageAlpha;
    CGFloat _minimumPageScale;
    
    
    id <PagedFlowViewDataSource> _dataSource;
    id <PagedFlowViewDelegate>   _delegate;
}
@property(nonatomic,strong)   UIScrollView        *scrollView;;

@property(nonatomic,assign)   id <PagedFlowViewDataSource> dataSource;
@property(nonatomic,assign)   id <PagedFlowViewDelegate>   delegate;
@property(nonatomic,retain)    UIPageControl       *pageControl;
@property (nonatomic, assign) CGFloat minimumPageAlpha;
@property (nonatomic, assign) CGFloat minimumPageScale;
@property (nonatomic, assign) PagedFlowViewOrientation orientation;
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;

- (void)setPageAtIndex:(NSInteger)pageIndex;
- (void)reloadData;

//获取可重复使用的Cell
- (UIView *)dequeueReusableCell;

- (void)scrollToPage:(NSUInteger)pageNumber;

@end


@protocol  PagedFlowViewDelegate<NSObject>

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView;

@optional
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView;

@end


@protocol PagedFlowViewDataSource <NSObject>

//Display the number of View
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView;

// Returns a column use the View
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index;

@end