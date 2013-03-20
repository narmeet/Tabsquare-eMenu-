//
//  DishItem.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 14/07/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishItem : UITableViewCell
{
    NSString *DishName;
    NSString *Price;
    NSString *Discription;
    NSString *btnTag;
    NSString *btnTagInfo;
   NSString *btnTagInfo1;
}

@property(strong) NSString *DishName;
@property(strong) NSString *Price;
@property(strong) NSString *Discription;

@property(strong) NSString *btnTag;
@property(strong) NSString *btnTagInfo;
@property(strong) NSString *btnTagInfo1;

@end
