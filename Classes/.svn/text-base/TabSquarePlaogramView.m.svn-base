
#import "TabSquarePlaogramView.h"
#import "TabSquareCommonClass.h"


@implementation TabSquarePlaogramView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)img
{
    self = [super initWithFrame:frame];
    
    BOOL hd_device = [TabSquareCommonClass isHDDevice];
    
    if (self)
    {
        float width  = img.size.width;
        float height = img.size.height;

        if(hd_device) {
            width /= 2;
            height /= 2;
        }
        
        if(width > self.frame.size.width)
            width = self.frame.size.width;
        
        if(height > self.frame.size.height)
            height = self.frame.size.height;
        
        myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [myScrollView setDelegate:self];
        [myScrollView setBackgroundColor:[UIColor whiteColor]];
        myScrollView.contentSize = CGSizeMake(imageView.frame.size.width , imageView.frame.size.height);
        myScrollView.maximumZoomScale = 2.0;
        myScrollView.minimumZoomScale = .50;
        myScrollView.clipsToBounds = YES;
        myScrollView.delegate = self;
        [myScrollView addSubview:imageView];
        myScrollView.zoomScale = .50;

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [imageView setImage:img];
        [imageView setCenter:[myScrollView center]];
        [myScrollView addSubview:imageView];
        [self addSubview:myScrollView];
        
        [self addTapEvent];
        
    }
    
    return self;
}


#pragma mark - Scroll View Delegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}


-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if(imageView.frame.size.width < self.frame.size.width) {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.4];
        [imageView setCenter:[myScrollView center]];
        [UIView commitAnimations];
    }
}

/*==========================================================================*/

-(void)addTapEvent
{
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
																					action:@selector(didTapAnywhere:)];
	[self addGestureRecognizer:tapRecognizer];
	tapRecognizer.cancelsTouchesInView = NO;
}


-(void)didTapAnywhere:(UIGestureRecognizer *) gestureRecognizer
{
    [self removeFromSuperview];
}


@end




