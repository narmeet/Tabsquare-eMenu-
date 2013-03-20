//
//  DishItemCell.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 14/07/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishItem.h"


@interface DishItemCell : DishItem
{
    IBOutlet UILabel *lblDishName;
    IBOutlet UILabel *lblPrice;
    IBOutlet UILabel *lblDiscription;  
    IBOutlet UIButton *b1,*b2;
    IBOutlet UIButton *ItemBtn;   
    
}


@property(nonatomic, retain) IBOutlet UIImageView *cellBackgroundImage;


@end
