//
//  CustomizationUnPaidCell.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/6/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "CustomizationUnPaidCell.h"

@implementation CustomizationUnPaidCell

@synthesize optionName,imageTag,btnTag,imageSelection;

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
