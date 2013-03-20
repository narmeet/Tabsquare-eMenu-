
#import "ComboSetDishIcon.h"
#import <QuartzCore/QuartzCore.h>

@implementation ComboSetDishIcon


@synthesize dishTitle, dishHeader, dishType, dishImage, preSelected, isSelected, dishID, groupId, groupDishItem, maxSelection, groupName, selectionHeader;


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        self.preSelected   = @"0";
        self.isSelected    = @"0";
        self.dishID        = @"-1";
        self.groupDishItem = @"0";
        
        gradient_status = FALSE;
        [self setExclusiveTouch:TRUE];
    }
    
    return self;
}


-(void)customizeIcon
{
    [self setTitle:self.dishTitle forState:UIControlStateNormal];
    [self setBackgroundImage:self.dishImage forState:UIControlStateNormal];
    [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    if([self.dishType isEqualToString:@"0"]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont fontWithName:@"Copperplate-Light" size:25.0]];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(100, 6, 100, 6)];
    }
    else {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont fontWithName:@"Copperplate-Bold" size:15.0]];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(23, -9, 150, 8)];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        
        if(!gradient_status)
            [self addGradient:self];
        
        gradient_status = TRUE;
    }
}



-(void)addGradient:(UIButton *)_button
{
     for(UIView *sub_view in _button.subviews)
     {
         if([sub_view isMemberOfClass:[UIImageView class]])
         {
             UIImageView *img_view = (UIImageView *)sub_view;
     
             //UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
             //[overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
             UIImageView *img_view1 = [[UIImageView alloc] initWithFrame:self.bounds];
             [img_view1 setImage:[UIImage imageNamed:@"Gradient.png"]];
             
             
             [img_view addSubview:img_view1];
         }
     }
    
    return;
    
    // Add Border
    CALayer *layer = _button.layer;
    //layer.cornerRadius = 8.0f;
    //layer.masksToBounds = YES;
    //layer.borderWidth = 1.0f;
    //layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
    
    // Add Shine
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = CGRectMake(0, 0, self.layer.frame.size.width, 35.0);
    
    UIColor *clr  = [UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:0.7];
    UIColor *clr1 = [UIColor colorWithRed:176.0/255.0 green:176.0/255.0 blue:176.0/255.0 alpha:0.5];
    UIColor *clr2 = [UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:0.3];
    UIColor *clr3 = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:0.2];
    
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)clr.CGColor,
                         (id)clr1.CGColor,
                         (id)clr2.CGColor,
                         (id)clr2.CGColor,
                         (id)clr3.CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.9f],
                            [NSNumber numberWithFloat:0.6f],
                            [NSNumber numberWithFloat:0.3f],
                            [NSNumber numberWithFloat:0.2f],
                            [NSNumber numberWithFloat:0.1f],
                            nil];
    [layer addSublayer:shineLayer];

}

@end


