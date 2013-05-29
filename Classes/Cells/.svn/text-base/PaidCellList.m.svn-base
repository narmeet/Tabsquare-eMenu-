//
//  PaidCellList.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/6/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "PaidCellList.h"
#import <QuartzCore/QuartzCore.h>

@interface PaidCellList ()

@end

@implementation PaidCellList

-(void)setOptionName:(NSString *)newoptionName
{
    [super setOptionName:newoptionName];
    lblOptionName.text=newoptionName;
}

-(void)setOptionPrice:(NSString *)newoptionPrice
{
    [super setOptionPrice:newoptionPrice];
    lblOptionPrice.text=newoptionPrice;
}

-(void)setQuantity:(NSString *)newQuantity
{
    [super setQuantity:newQuantity];
    lblOptionQuantity.layer.borderWidth=1.0;
    lblOptionQuantity.layer.borderColor=[UIColor colorWithRed:242.0f/255.0f green:143.0f/255.0f blue:15.0f/255.0f alpha:1.0].CGColor;
    lblOptionQuantity.text=newQuantity;
}

-(void)setBtnTagAdd:(NSString *)newbtnTagAdd
{
    [super setBtnTagAdd:newbtnTagAdd];
    plusBtn.tag=[newbtnTagAdd intValue];
}

-(void)setBtnTagMinus:(NSString *)newbtnTagMinus
{
    [super setBtnTagMinus:newbtnTagMinus];
    minusBtn.tag=[newbtnTagMinus intValue];
}

@end
