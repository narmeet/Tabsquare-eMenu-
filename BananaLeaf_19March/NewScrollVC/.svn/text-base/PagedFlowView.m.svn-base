//
//  PagedFlowView.m
//  taobao4iphone
//
//  Created by manoj on 5/2/13.
//  Copyright (c) 2012 geeklu.com. All rights reserved.
//

#import "PagedFlowView.h"

@interface PagedFlowView ()
@property (nonatomic, assign, readwrite) NSInteger currentPageIndex;
@end

@implementation PagedFlowView
@synthesize dataSource;// = dataSource;
@synthesize delegate;// = delegate;
@synthesize pageControl;
@synthesize minimumPageAlpha = _minimumPageAlpha;
@synthesize minimumPageScale = _minimumPageScale;
@synthesize orientation;
@synthesize currentPageIndex = _currentPageIndex;
@synthesize  scrollView =_scrollView;
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

- (void)initialize{
    self.clipsToBounds = YES;
    
    _needsReload = YES;
    _pageSize = self.bounds.size;
    _pageCount = 0;
    _currentPageIndex = 0;
    
    _minimumPageAlpha = 1.0;
    _minimumPageScale = 1.0;
    
    _visibleRange = NSMakeRange(0, 0);
    
    _reusableCells = [[NSMutableArray alloc] init];
    _cells = [[NSMutableArray alloc] init];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 10, 400, 350)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor=[UIColor clearColor];
    
    /* Due UIScrollView scroll after call to own layoutSubviews as well as the parent View the layoutSubviews,
     Here iin order to avoid the the scrollview Scroll to bring own layoutSubviews call, add a layer of parent View to scrollView
     */
    
    UIView *superViewOfScrollView = [[UIView alloc] initWithFrame:CGRectMake(80, 10, 400, 350)];
    [superViewOfScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [superViewOfScrollView setBackgroundColor:[UIColor clearColor]];
    [superViewOfScrollView addSubview:_scrollView];
    [self addSubview:superViewOfScrollView];
    //[self addSubview:superViewOfScrollView];
}


- (void)queueReusableCell:(UIView *)cell{
    [_reusableCells addObject:cell];
}

- (void)removeCellAtIndex:(NSInteger)index{
    UIView *cell = [_cells objectAtIndex:index];
    if ((NSObject *)cell == [NSNull null]) {
        return;
    }
    
    [self queueReusableCell:cell];
    
    if (cell.superview) {
        [cell removeFromSuperview];
    }
    
    [_cells replaceObjectAtIndex:index withObject:[NSNull null]];
}

- (void)refreshVisibleCellAppearance{
    
    if (_minimumPageAlpha == 1.0 && _minimumPageScale == 1.0) {
        return;
    }
    switch (orientation) {
        case PagedFlowViewOrientationHorizontal:{
            CGFloat offset = _scrollView.contentOffset.x;
            
            for (int i = _visibleRange.location; i < _visibleRange.location + _visibleRange.length; i++) {
                UIView *cell = [_cells objectAtIndex:i];
                CGFloat origin = cell.frame.origin.x;
                CGFloat delta = fabs(origin - offset);
                
                CGRect originCellFrame = CGRectMake(_pageSize.width * i, 0, _pageSize.width, _pageSize.height);
                
                [UIView beginAnimations:@"CellAnimation" context:nil];
                if (delta < _pageSize.width) {
                    cell.alpha = 1 - (delta / _pageSize.width) * (1 - _minimumPageAlpha);
                    
                    CGFloat inset = (_pageSize.width * (1 - _minimumPageScale)) * (delta / _pageSize.width)/2.0;
                    cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
                } else {
                    cell.alpha = 1;////previous value was _minimumPageAlpha
                    CGFloat inset = _pageSize.width * (1 - _minimumPageScale) / 2.0 ;
                    cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
                }
                [UIView commitAnimations];
            }
            break;
        }
                    default:
            break;
    }
    
}

- (void)setPageAtIndex:(NSInteger)pageIndex{
    
    NSParameterAssert(pageIndex >= 0 && pageIndex < [_cells count]);
    
    UIView *cell = [_cells objectAtIndex:pageIndex];
    
    if ((NSObject *)cell == [NSNull null]) {
        cell = [dataSource flowView:self cellForPageAtIndex:pageIndex];
        NSAssert(cell!=nil, @"datasource must not return nil");
        [_cells replaceObjectAtIndex:pageIndex withObject:cell];
        
        
        switch (orientation) {
            case PagedFlowViewOrientationHorizontal:
                cell.frame = CGRectMake(_pageSize.width * pageIndex, 0, _pageSize.width, _pageSize.height);
                break;
            case PagedFlowViewOrientationVertical:
                cell.frame = CGRectMake(0, _pageSize.height * pageIndex, _pageSize.width, _pageSize.height);
                break;
            default:
                break;
        }
        
        if (!cell.superview) {
            [_scrollView addSubview:cell];
        }
        else{
            cell=nil;
        }
    }
}


- (void)setPagesAtContentOffset:(CGPoint)offset{
    //_visibleRange
    CGPoint startPoint = CGPointMake(offset.x - _scrollView.frame.origin.x, offset.y - _scrollView.frame.origin.y);
    CGPoint endPoint = CGPointMake(startPoint.x + self.bounds.size.width, startPoint.y + self.bounds.size.height);
    
    
    switch (orientation) {
        case PagedFlowViewOrientationHorizontal:{
            NSInteger startIndex = 0;
            for (int i =0; i < [_cells count]; i++) {
                if (_pageSize.width * (i +1) > startPoint.x) {
                    startIndex = i;
                    break;
                }
            }
            
            NSInteger endIndex = startIndex;
            for (int i = startIndex; i < [_cells count]; i++) {
                
                //If not more than the last
                if ((_pageSize.width * (i + 1) < endPoint.x && _pageSize.width * (i + 2) >= endPoint.x) || i+ 2 == [_cells count]) {
                    endIndex = i + 1; //i +2 is a number, so its index needs to subtract 1
                    break;
                }
            }
            
            // Visible pages, respectively, extending a forward and backward, improve efficiency
            startIndex = MAX(startIndex - 1, 0);
            endIndex = MIN(endIndex + 1, [_cells count] - 1);
            
            _visibleRange.location = startIndex;
            _visibleRange.length = endIndex - startIndex + 1;
            
            for (int i = startIndex; i <= endIndex; i++) {
                [self setPageAtIndex:i];
            }
            
            for (int i = 0; i < startIndex; i ++) {
                [self removeCellAtIndex:i];
            }
            
            for (int i = endIndex + 1; i < [_cells count]; i ++) {
                [self removeCellAtIndex:i];
            }
            break;
        }
                    default:
            break;
    }
    
    
    
}




////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Override Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_needsReload) {
        
        
        //pageCount
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfPagesInFlowView:)]) {
            _pageCount = [dataSource numberOfPagesInFlowView:self];
            
            if (pageControl && [pageControl respondsToSelector:@selector(setNumberOfPages:)]) {
                [pageControl setNumberOfPages:_pageCount];
            }
        }
        
        //pageWidth
        if (delegate && [delegate respondsToSelector:@selector(sizeForPageInFlowView:)]) {
            _pageSize = [delegate sizeForPageInFlowView:self];
        }
        
        [_reusableCells removeAllObjects];
        _visibleRange = NSMakeRange(0, 0);
        
        [_cells removeAllObjects];
        for (NSInteger index=0; index<_pageCount; index++)
        {
            [_cells addObject:[NSNull null]];
        }
        
        // _scrollView的contentSize
        switch (orientation) {
            case PagedFlowViewOrientationHorizontal:
                _scrollView.frame = CGRectMake(10, 20, _pageSize.width, _pageSize.height);
                _scrollView.contentSize = CGSizeMake(_pageSize.width * _pageCount,_pageSize.height);
                //CGPoint theCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
                // _scrollView.center = theCenter;
                [_scrollView scrollRectToVisible:CGRectMake(_pageSize.width*selectedImageAtMenu, 0, _pageSize.width , _pageSize.height) animated:NO];
                
                
                break;
               
            default:
                break;
        }
    }
    
    
    [self setPagesAtContentOffset:_scrollView.contentOffset];
    
    [self refreshVisibleCellAppearance];
    
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView API

- (void)reloadData
{
    //[self initialize];
    _needsReload = YES;
    
    [self setNeedsLayout];
}


- (UIView *)dequeueReusableCell{


    UIView *cell = [_reusableCells lastObject];
    if (cell)
    {
        [_reusableCells removeLastObject];
    }
    
    return cell;
}

- (void)scrollToPage:(NSUInteger)pageNumber {
    if (pageNumber < _pageCount) {
        switch (orientation) {
            case PagedFlowViewOrientationHorizontal:
                [_scrollView setContentOffset:CGPointMake(_pageSize.width * pageNumber, 0) animated:YES];
                break;
            case PagedFlowViewOrientationVertical:
                [_scrollView setContentOffset:CGPointMake(0, _pageSize.height * pageNumber) animated:YES];
                break;
        }
        [self setPagesAtContentOffset:_scrollView.contentOffset];
        [self refreshVisibleCellAppearance];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark hitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        CGPoint newPoint = CGPointZero;
        newPoint.x = point.x - _scrollView.frame.origin.x + _scrollView.contentOffset.x;
        newPoint.y = point.y - _scrollView.frame.origin.y + _scrollView.contentOffset.y;
        if ([_scrollView pointInside:newPoint withEvent:event]) {
            return [_scrollView hitTest:newPoint withEvent:event];
        }
        
        return _scrollView;
    }
    
    return nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self setPagesAtContentOffset:scrollView.contentOffset];
    [self refreshVisibleCellAppearance];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int pageIndex=0;
    
    switch (orientation) {
        case PagedFlowViewOrientationHorizontal:
            pageIndex = floor(_scrollView.contentOffset.x / _pageSize.width);
            break;
        case PagedFlowViewOrientationVertical:
            pageIndex = floor(_scrollView.contentOffset.y / _pageSize.height);
            break;
        default:
            break;
    }
    
    if (pageControl && [pageControl respondsToSelector:@selector(setCurrentPage:)]) {
        [pageControl setCurrentPage:pageIndex];
    }
    
    if ([delegate respondsToSelector:@selector(didScrollToPage:inFlowView:)] && _currentPageIndex != pageIndex) {
        [delegate didScrollToPage:pageIndex inFlowView:self];
    }
    
    _currentPageIndex = pageIndex;
}
@end

