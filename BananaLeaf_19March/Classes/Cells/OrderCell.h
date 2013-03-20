//
//  OrderCell.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 17/07/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell
{
    NSString *DishName;
    NSString *Price;
     NSString *Price2;
     NSString *Srl;
    NSString *Quantity;
    NSString *btnTagRemove;
    NSString *btnTagInfo;
    NSString *btnTagAdd;
    NSString *btnTagMinus;
    NSString *unpaidIndicator;
}

@property(strong)NSString *unpaidIndicator;
@property(strong) NSString *DishName;
@property(strong) NSString *Price;
@property(strong) NSString *Quantity;

@property(strong) NSString *btnTagRemove;
@property(strong) NSString *btnTagInfo;
@property(strong) NSString *btnTagAdd;
@property(strong) NSString *btnTagMinus;
@property(strong)NSString *IsOrderConfirm;
@property(strong)NSString *DishCatId;
@property(strong)NSString *Price2;
@property(strong) NSString *Srl;
@end
