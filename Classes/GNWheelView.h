
#import <UIKit/UIKit.h>

@protocol GNWheelViewDelegate;

@interface GNWheelView : UIView <UIGestureRecognizerDelegate>{
    
    NSMutableArray *_views;
    NSMutableArray *_viewsAngles;
    NSMutableArray *_originalPositionedViews;
    unsigned int viewsNum;
    
    UIView *idleView;
    BOOL idleViewAnimated;
    
    BOOL toDescelerate;
    
    BOOL toRearrange;
}

@property (nonatomic,assign) NSObject<GNWheelViewDelegate> *delegate;
@property (nonatomic,readwrite) int idleDuration;


- (void)reloadData;

@end

@protocol GNWheelViewDelegate

@required

- (unsigned int)numberOfRowsOfWheelView:(GNWheelView *)wheelView;
- (UIView *)wheelView:(GNWheelView *)wheelView viewForRowAtIndex:(unsigned int)index;
- (float)rowWidthInWheelView:(GNWheelView *)wheelView;
- (float)rowHeightInWheelView:(GNWheelView *)wheelView;

@optional

- (void)wheelView:(GNWheelView *)wheelView didSelectedRowAtIndex:(unsigned int)index;
- (BOOL)wheelView:(GNWheelView *)wheelView shouldEnterIdleStateForRowAtIndex:(unsigned int)index animated:(BOOL*)animated;
- (UIView *)wheelView:(GNWheelView *)wheelView idleStateViewForRowAtIndex:(unsigned int)index;
- (void)wheelView:(GNWheelView *)wheelView didStartIdleStateForRowAtIndex:(unsigned int)index;


@end