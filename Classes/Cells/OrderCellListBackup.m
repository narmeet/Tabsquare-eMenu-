//
//  OrderCellList.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 17/07/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "OrderCellList.h"
#import "TabSquareCommonClass.h"
#import <QuartzCore/QuartzCore.h>

@interface OrderCellList ()
 @end

@implementation OrderCellList
int orderSubmit = 0;

-(void)setPrice:(NSString *)newPrice
{
    [super setPrice:newPrice];
    lblPrice.text=newPrice;
    lblPrice.font=[UIFont fontWithName:@"Century Gothic" size:20];
}

-(void)setIsOrderConfirm:(NSString *)newIsOrderConfirm
{
    [super setIsOrderConfirm:newIsOrderConfirm];
    if([newIsOrderConfirm isEqualToString:@"0"])
    {
        //lblQuantity.hidden=NO;
        orderSubmit = 0;
        b2.hidden=NO;
        b3.hidden=NO;
        b4.hidden=NO;
    }
    else
    {
       // lblQuantity.hidden=YES;
        orderSubmit = 1;
        b2.hidden=YES;
        b3.hidden=YES;
        b4.hidden=YES;
    }
}


-(void)setQuantity:(NSString *)newQuantity
{
    [super setQuantity:newQuantity];
    lblQuantity.text=newQuantity;
    lblQuantity.font=[UIFont fontWithName:@"Century Gothic" size:18];
    //lblQuantity.layer.borderColor=[UIColor colorWithRed:242.0f/255.0f green:143.0f/255.0f blue:15.0f/255.0f alpha:1.0].CGColor;
    if (orderSubmit == 0){
        //lblQuantity.layer.borderColor=[UIColor colorWithRed:242.0f/255.0f green:143.0f/255.0f blue:15.0f/255.0f alpha:1.0].CGColor;
        //lblQuantity.layer.backgroundColor=[UIColor colorWithRed:246.0f/255.0f green:208.0f/255.0f blue:161.0f/255.0f alpha:1.0].CGColor;
    }else{
        //lblQuantity.layer.borderColor=[UIColor clearColor].CGColor;
        //lblQuantity.layer.backgroundColor=[UIColor colorWithRed:246.0f/255.0f green:208.0f/255.0f blue:161.0f/255.0f alpha:0.0].CGColor;
    }

    UIImage *bg_img = [UIImage imageNamed:@"quantity.png"];
    bg_img = [TabSquareCommonClass resizeImage:bg_img scaledToSize:lblQuantity.frame.size];
    [lblQuantity setBackgroundColor:[UIColor colorWithPatternImage:bg_img]];
}

-(void)setDishName:(NSString *)newDishName
{
    [super setDishName:newDishName];
    lblDishName.text=newDishName;
    lblDishName.font=[UIFont fontWithName:@"Century Gothic" size:20];
    CGSize newsize=  [newDishName sizeWithFont:lblDishName.font constrainedToSize:CGSizeMake(264, 400) lineBreakMode:lblDishName.lineBreakMode];
    lblDishName.frame=CGRectMake(lblDishName.frame.origin.x, lblDishName.frame.origin.y, newsize.width, newsize.height);
    
}

-(void)setBtnTagAdd:(NSString *)newbtnTagAdd
{
    int tag=[newbtnTagAdd intValue];
    b1.tag=tag;
}

-(void)setBtnTagInfo:(NSString *)newbtnTagInfo
{
    int tag=[newbtnTagInfo intValue];
    b2.tag=tag;
}

-(void)setBtnTagMinus:(NSString *)newbtnTagMinus
{
    int tag=[newbtnTagMinus intValue];
    b3.tag=tag;
}

-(void)setBtnTagRemove:(NSString *)newbtnTagRemove
{
    int tag=[newbtnTagRemove intValue];
    b4.tag=tag; 
}

-(void)setDishCatId:(NSString *)newDishCatId
{
    [super setDishCatId:newDishCatId];
    if([newDishCatId intValue]%2==0)
    {
        lblPrice.frame=CGRectMake(305, lblPrice.frame.origin.y, lblPrice.frame.size.width, lblPrice.frame.size.height);
    }
    else 
    {
        lblPrice.frame=CGRectMake(380, lblPrice.frame.origin.y, lblPrice.frame.size.width, lblPrice.frame.size.height);
    }
}

-(void)setUnpaidIndicator:(NSString *)newunpaidIndicator
{
    [super setUnpaidIndicator:newunpaidIndicator];
    lblUnpaid.layer.cornerRadius=8.0;
    if([newunpaidIndicator intValue]==0)
    {
        lblUnpaid.hidden=YES;
    }
    else {
        lblUnpaid.hidden=NO;
    }
}

@end
