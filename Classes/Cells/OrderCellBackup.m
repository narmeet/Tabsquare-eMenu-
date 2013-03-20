//
//  OrderCell.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 17/07/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "OrderCell.h"
#import "ShareableData.h"

@implementation OrderCell

@synthesize DishName,Price,Quantity,btnTagAdd,btnTagInfo,btnTagMinus,btnTagRemove;
@synthesize IsOrderConfirm,DishCatId,unpaidIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
