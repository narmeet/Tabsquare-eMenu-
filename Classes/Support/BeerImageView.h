//
//  BeerImageView.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/24/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeerImageView : UIView
{
     UIImageView *_imageView;
}

@property (nonatomic, weak) UIImage *image;
@end
