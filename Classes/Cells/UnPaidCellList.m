//
//  UnPaidCellList.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/6/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "UnPaidCellList.h"


@implementation UnPaidCellList


-(void)setOptionName:(NSString *)newoptionName
{
    [super setOptionName:newoptionName];
    lblOptionName.text=newoptionName;
}

-(void)setImageTag:(NSString *)newimageTag
{
    [super setImageTag:newimageTag];
    checkImage.tag=[newimageTag intValue];
}

-(void)setBtnTag:(NSString *)newbtnTag
{
    [super setBtnTag:newbtnTag];
    selectBtn.tag=[newbtnTag intValue];
}

-(void)setImageSelection:(NSString *)newimageSelection
{
    [super setImageSelection:newimageSelection];
    if([newimageSelection intValue]==0)
    {
        checkImage.hidden=YES;
    }
    else 
    {
        checkImage.hidden=NO;
    }
}

@end
