

#import <Availability.h>
#undef weak_delegate
#undef __weak_delegate
#if __has_feature(objc_arc_weak) && \
(!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || \
__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
#define weak_delegate weak
#define __weak_delegate __weak
#else
#define weak_delegate unsafe_unretained
#define __weak_delegate __unsafe_unretained
#endif


#import <QuartzCore/QuartzCore.h>
#ifdef USING_CHAMELEON
#define ICAROUSEL_IOS
#elif defined __IPHONE_OS_VERSION_MAX_ALLOWED
#define ICAROUSEL_IOS
typedef CGRect NSRect;
typedef CGSize NSSize;
#else
#define ICAROUSEL_MACOS
#endif


#ifdef ICAROUSEL_IOS
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
typedef NSView UIView;
#endif


typedef enum
{
    iCarouselTypeLinear = 0,
    iCarouselTypeRotary,
    iCarouselTypeInvertedRotary,
    iCarouselTypeCylinder,
    iCarouselTypeInvertedCylinder,
    iCarouselTypeWheel,
    iCarouselTypeInvertedWheel,
    iCarouselTypeCoverFlow,
    iCarouselTypeCoverFlow2,
    iCarouselTypeTimeMachine,
    iCarouselTypeInvertedTimeMachine,
    iCarouselTypeCustom
}
iCarouselType;


typedef enum
{
    iCarouselOptionWrap = 0,
    iCarouselOptionShowBackfaces,
    iCarouselOptionOffsetMultiplier,
    iCarouselOptionVisibleItems,
    iCarouselOptionCount,
    iCarouselOptionArc,
	iCarouselOptionAngle,
    iCarouselOptionRadius,
    iCarouselOptionTilt,
    iCarouselOptionSpacing,
    iCarouselOptionFadeMin,
    iCarouselOptionFadeMax,
    iCarouselOptionFadeRange
}
iCarouselOption;


@protocol iCarouselDataSource, iCarouselDelegate;

@interface TabSquareComboScroller : UIView

//required for 32-bit Macs
#ifdef __i386__
{
	@private
	
    id<iCarouselDelegate> __weak_delegate _delegate;
    id<iCarouselDataSource> __weak_delegate _dataSource;
    iCarouselType _type;
    CGFloat _perspective;
    NSInteger _numberOfItems;
    NSInteger _numberOfPlaceholders;
	NSInteger _numberOfPlaceholdersToShow;
    NSInteger _numberOfVisibleItems;
    UIView *_contentView;
    NSMutableDictionary *_itemViews;
    NSMutableSet *_itemViewPool;
    NSMutableSet *_placeholderViewPool;
    NSInteger _previousItemIndex;
    CGFloat _itemWidth;
    CGFloat _scrollOffset;
    CGFloat _offsetMultiplier;
    CGFloat _startVelocity;
    NSTimer __unsafe_unretained *_timer;
    BOOL _decelerating;
    BOOL _scrollEnabled;
    CGFloat _decelerationRate;
    BOOL _bounces;
    CGSize _contentOffset;
    CGSize _viewpointOffset;
    CGFloat _startOffset;
    CGFloat _endOffset;
    NSTimeInterval _scrollDuration;
    NSTimeInterval _startTime;
    BOOL _scrolling;
    CGFloat _previousTranslation;
	BOOL _centerItemWhenSelected;
	BOOL _wrapEnabled;
	BOOL _dragging;
    BOOL _didDrag;
    CGFloat _scrollSpeed;
    CGFloat _bounceDistance;
    NSTimeInterval _toggleTime;
    CGFloat _toggle;
    BOOL _stopAtItemBoundary;
    BOOL _scrollToItemBoundary;
	BOOL _vertical;
    BOOL _ignorePerpendicularSwipes;
    NSInteger _animationDisableCount;
}
#endif

@property (nonatomic, weak_delegate) IBOutlet id<iCarouselDataSource> dataSource;
@property (nonatomic, weak_delegate) IBOutlet id<iCarouselDelegate> delegate;
@property (nonatomic, assign) iCarouselType type;
@property (nonatomic, assign) CGFloat perspective;
@property (nonatomic, assign) CGFloat decelerationRate;
@property (nonatomic, assign) CGFloat scrollSpeed;
@property (nonatomic, assign) CGFloat bounceDistance;
@property (nonatomic, assign, getter = isScrollEnabled) BOOL scrollEnabled;
@property (nonatomic, assign, getter = isVertical) BOOL vertical;
@property (nonatomic, readonly, getter = isWrapEnabled) BOOL wrapEnabled;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) CGFloat scrollOffset;
@property (nonatomic, readonly) CGFloat offsetMultiplier;
@property (nonatomic, assign) CGSize contentOffset;
@property (nonatomic, assign) CGSize viewpointOffset;
@property (nonatomic, readonly) NSInteger numberOfItems;
@property (nonatomic, readonly) NSInteger numberOfPlaceholders;
@property (nonatomic, assign) NSInteger currentItemIndex;
@property (nonatomic, strong, readonly) UIView *currentItemView;
@property (nonatomic, strong, readonly) NSArray *indexesForVisibleItems;
@property (nonatomic, readonly) NSInteger numberOfVisibleItems;
@property (nonatomic, strong, readonly) NSArray *visibleItemViews;
@property (nonatomic, readonly) CGFloat itemWidth;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, readonly) CGFloat toggle;
@property (nonatomic, assign) BOOL stopAtItemBoundary;
@property (nonatomic, assign) BOOL scrollToItemBoundary;
@property (nonatomic, assign) BOOL ignorePerpendicularSwipes;
@property (nonatomic, assign) BOOL centerItemWhenSelected;
@property (nonatomic, readonly, getter = isDragging) BOOL dragging;
@property (nonatomic, readonly, getter = isDecelerating) BOOL decelerating;
@property (nonatomic, readonly, getter = isScrolling) BOOL scrolling;

- (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
- (void)scrollToOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
- (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (UIView *)itemViewAtIndex:(NSInteger)index;
- (NSInteger)indexOfItemView:(UIView *)view;
- (NSInteger)indexOfItemViewOrSubview:(UIView *)view;
- (CGFloat)offsetForItemAtIndex:(NSInteger)index;

- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)reloadData;

@end


@protocol iCarouselDataSource <NSObject>

- (NSUInteger)numberOfItemsInCarousel:(TabSquareComboScroller *)carousel;
- (UIView *)carousel:(TabSquareComboScroller *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view;

@optional

- (NSUInteger)numberOfPlaceholdersInCarousel:(TabSquareComboScroller *)carousel;
- (UIView *)carousel:(TabSquareComboScroller *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view;

@end


@protocol iCarouselDelegate <NSObject>
@optional

- (void)carouselWillBeginScrollingAnimation:(TabSquareComboScroller *)carousel;
- (void)carouselDidEndScrollingAnimation:(TabSquareComboScroller *)carousel;
- (void)carouselDidScroll:(TabSquareComboScroller *)carousel;
- (void)carouselCurrentItemIndexDidChange:(TabSquareComboScroller *)carousel;
- (void)carouselWillBeginDragging:(TabSquareComboScroller *)carousel;
- (void)carouselDidEndDragging:(TabSquareComboScroller *)carousel willDecelerate:(BOOL)decelerate;
- (void)carouselWillBeginDecelerating:(TabSquareComboScroller *)carousel;
- (void)carouselDidEndDecelerating:(TabSquareComboScroller *)carousel;

- (BOOL)carousel:(TabSquareComboScroller *)carousel shouldSelectItemAtIndex:(NSInteger)index;
- (void)carousel:(TabSquareComboScroller *)carousel didSelectItemAtIndex:(NSInteger)index;

- (CGFloat)carouselItemWidth:(TabSquareComboScroller *)carousel;
- (CATransform3D)carousel:(TabSquareComboScroller *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform;
- (CGFloat)carousel:(TabSquareComboScroller *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value;

@end


@protocol iCarouselDeprecated
@optional

//deprecated delegate and datasource methods
//use carousel:valueForOption:withDefault: instead

- (NSUInteger)numberOfVisibleItemsInCarousel:(TabSquareComboScroller *)carousel;
- (void)carouselCurrentItemIndexUpdated:(TabSquareComboScroller *)carousel __attribute__((deprecated));
- (BOOL)carouselShouldWrap:(TabSquareComboScroller *)carousel __attribute__((deprecated));
- (CGFloat)carouselOffsetMultiplier:(TabSquareComboScroller *)carousel __attribute__((deprecated));
- (CGFloat)carousel:(TabSquareComboScroller *)carousel itemAlphaForOffset:(CGFloat)offset __attribute__((deprecated));
- (CGFloat)carousel:(TabSquareComboScroller *)carousel valueForTransformOption:(iCarouselOption)option withDefault:(CGFloat)value __attribute__((deprecated));

@end