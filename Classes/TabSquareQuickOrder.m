//
//  TabSquareQuickOrder.m
//  TabSquareMenu
//
//  Created by Asvin Kaur on 4/12/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "TabSquareQuickOrder.h"
#import "DTCustomColoredAccessory.h"
#import "ShareableData.h"
#import "TabSquareDBFile.h"
#import "TabSquareMenuController.h"
#import "TabSquareOrderSummaryController.h"
#import "TabMainCourseMenuListViewController.h"
#import "TabMainMenuDetailViewController.h"
#import "TabSquareMenuDetailController.h"
#import "TabMainDetailView.h"
#import "TabSquareBeerController.h"
#import "TabSquareBeerDetailController.h"
#import <QuartzCore/QuartzCore.h>
#import "TabSquareComboSet.h"

@interface TabSquareQuickOrder ()

@end

@implementation TabSquareQuickOrder
@synthesize beerDetailView,beveragesBeerView;
@synthesize menuView;
@synthesize customizationView;
@synthesize menuSubCategory,tt,dishes;
@synthesize DishID,DishName,DishPrice,DishImage,DishCatId,DishDescription,DishCustomization,resultFromDB,DishSubCatId,custType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dishes= [[NSMutableArray alloc]init];
  menuSubCategory= [[NSMutableArray alloc]init];
   //catID =
    selectedIndex = -1;
    [self.tt2 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"NewDishCell"];
    beerDetailView =[[TabSquareBeerDetailController alloc]initWithNibName:@"TabSquareBeerDetailController" bundle:nil];
    beveragesBeerView=[[TabSquareBeerController alloc]initWithNibName:@"TabSquareBeerController" bundle:nil];
    beerDetailView.beverageView = beveragesBeerView;

   
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadDishData
{
    DishID=[NSString stringWithFormat:@"%@",resultFromDB[@"id"]];
    DishName=[NSString stringWithFormat:@"%@",resultFromDB[@"name"]];
    DishPrice=[NSString stringWithFormat:@"%@",resultFromDB[@"price"]];
    DishDescription=[NSString stringWithFormat:@"%@",resultFromDB[@"description"]];
    DishCatId=[NSString stringWithFormat:@"%@",resultFromDB[@"category"]];
    DishCustomization=resultFromDB[@"customisations"];
    DishSubCatId=[NSString stringWithFormat:@"%@",resultFromDB[@"sub_category"]];
    DishImage=[UIImage imageWithContentsOfFile:resultFromDB[@"images"]];//resultFromDB[@"images"];
    custType =[NSString stringWithFormat:@"%@",resultFromDB[@"cust"]];
    
}


-(void)addOrder
{
    [self addImageAnimation:tempFrame btnView:tempView];
}

-(void)addClicked:(NSInteger)sender
{
    
    //UIButton *btn=(UIButton*)sender;
    UIView *view= [self.view superview];
    CGRect frame= CGRectMake(10,10,10,10);
    
    tempView = view;
    tempFrame = frame;
    
    //int tag=btn.tag;
    // DLog(@"Tag : %d",tag);
    //selectedItem=tag;
    // NSString *type=[custType objectAtIndex:tag];
    NSMutableDictionary *dataitem=dishes[sender];
    
    if([dataitem[@"is_set"] intValue] == 1) {
        TabSquareComboSet *combo = [[TabSquareComboSet alloc] init];
        
        [combo setComboId:[dataitem[@"id"] intValue] categoryId:[dataitem[@"category"] intValue]];
        [combo setQuickorderController:self];
        [self presentViewController:combo animated:NO completion:nil];
        return;
    }
    
    NSString *orderId=dataitem[@"id"];//[NSString stringWithFormat:@"%@",[lastOrderedId objectAtIndex:tag]];
    // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    NSMutableArray *resultFromPost=[[TabSquareDBFile sharedDatabase]getDishDataDetail:orderId];
    // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    
    resultFromDB=resultFromPost[0];
    
    //parse data
    [self loadDishData];
    
    
    
    // NSString *dishCatId2 = [DishCategoryId objectAtIndex:tag];
    //  NSString *dishSubCatId2 = [DishSubCategoryId objectAtIndex:tag];
    int bevDisplay = 0;
    @autoreleasepool {
        
        // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
        
        if([DishCatId isEqualToString:@"8"]){
            NSMutableArray *subCategoryData=[[TabSquareDBFile sharedDatabase]getSubCategoryData:@"8"];
            for(int i=0;i<[subCategoryData count];++i){
                NSMutableDictionary *subCategory=subCategoryData[i];
                NSString *subId=subCategory[@"id"];
                NSString *displayId=subCategory[@"display"];
                if ([subId isEqualToString:DishSubCatId]&&[displayId isEqualToString:@"1"]){
                    [ShareableData sharedInstance].TaskType = @"3";
                    bevDisplay = 1;
                    [beveragesBeerView reloadDataOfSubCat2:dishes];
                    [beveragesBeerView.beverageView reloadData];
                }
                
            }
            
            
            // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
        }
    }
    if (bevDisplay == 1){
        @autoreleasepool {
            
            // NSMutableArray *beverageCustomization;
            // NSMutableArray *beverageSkuDetail;
            // NSMutableArray *beverageCustType;
            
            //int currentindex=[[DishID objectAtIndex:selectedItem] intValue];
            beerDetailView.selectedIndex=[NSString stringWithFormat:@"%d",sender];
            beerDetailView.tempDishID = DishID.intValue;
            // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
            beerDetailView.beverageSKUDetail=[[TabSquareDBFile sharedDatabase]getBeverageSkuDetail:DishID];
            //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
            beerDetailView.beverageCatId=[NSString stringWithFormat:@"%d",8];
            beerDetailView.beverageCustomization=DishCustomization;
            //beerDetailView.beverageCutType=custType;
            [beerDetailView.beverageSkUView reloadData];
            [beerDetailView loadBeverageData:sender];
            [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
            [self.view addSubview:beerDetailView.view];
            [self.view bringSubviewToFront:beerDetailView.view];
        }
    }else{
        
        if([custType isEqualToString:@"0"])
        {
            [self addImageAnimation:frame btnView:view];
        }
        else
        {
            if([[ShareableData sharedInstance].IsViewPage count]==0)
            {
                [[ShareableData sharedInstance].IsViewPage addObject:@"main_customization"];
            }
            else
            {
                ([ShareableData sharedInstance].IsViewPage)[0] = @"main_customization";
            }
            
            [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
            [self addCustomizationView];
        }
    }
    
    
}


-(void)addBlankCustomizationView
{
    // menuView.menulistView1.menudetailView.menuDetailView=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
    customizationView=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
    customizationView.KKselectedID  =DishID;
    customizationView.KKselectedName=DishName;
    customizationView.KKselectedRate=DishPrice;
    customizationView.KKselectedCatId=DishCatId;
    if ([[ShareableData sharedInstance].isQuickOrder isEqualToString:@"1"]){
        customizationView.backImage.hidden=YES;
    }else{
        customizationView.backImage.hidden=NO;
    }
    customizationView.DishCustomization=DishCustomization;
    customizationView.KKselectedImage=DishImage;
    [customizationView.customizationView reloadData];
    customizationView.requestView.text=@"";
    customizationView.swipeIndicator=@"1";
    customizationView.isView=@"main";
    customizationView.view.frame=CGRectMake(12, 0, self.view.frame.size.width-24, self.view.frame.size.height);
    customizationView.detailImageView.frame = CGRectMake(104, 229, 530, 222);
    customizationView.detailImageView.contentMode = UIViewContentModeRedraw;
    customizationView.crossBtn.frame=CGRectMake(610,210, 45, 45);////setting frame for cross button
    customizationView.detailImageView.clipsToBounds=YES;
    [self.view addSubview:customizationView.view];
   
    //////// to hide the all other buttons and scroll background from the parent view //////
    customizationView.mParent=self;
    menuView.mparent=self;
    menuView.subCatbg.hidden=TRUE;
    menuView.subcatScroller.hidden=TRUE;
    menuView.OrderSummaryButton.userInteractionEnabled=FALSE;
    menuView.search.userInteractionEnabled=FALSE;
    menuView.favourite.userInteractionEnabled=FALSE;
    menuView.help.userInteractionEnabled=FALSE;
    menuView.overviewMenuButton.userInteractionEnabled=FALSE;
    menuView.KinaraLogo.userInteractionEnabled=FALSE;
    menuView.flagButton.userInteractionEnabled=FALSE;
}

-(void)addCustomizationView
{
   // menuView.menulistView1.menudetailView.menuDetailView=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
    customizationView=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
    customizationView.KKselectedID  =DishID;
    customizationView.KKselectedName=DishName;
    customizationView.KKselectedRate=DishPrice;
    customizationView.KKselectedCatId=DishCatId;
    if ([[ShareableData sharedInstance].isQuickOrder isEqualToString:@"1"]){
    customizationView.backImage.hidden=YES;
    }else{
       customizationView.backImage.hidden=NO;  
    }
    customizationView.DishCustomization=DishCustomization;
    customizationView.KKselectedImage=DishImage;
    [customizationView.customizationView reloadData];
    customizationView.requestView.text=@"";
    customizationView.swipeIndicator=@"1";
    customizationView.isView=@"main";
    customizationView.view.frame=CGRectMake(12, -200, self.view.frame.size.width-24, self.view.frame.size.height);
    customizationView.crossBtn.frame=CGRectMake(610,210, 45, 45);////setting frame for cross button
    [self.view addSubview:customizationView.view];
    
    //////// to hide the all other buttons and scroll background from the parent view //////
    customizationView.mParent=self;
    menuView.mparent=self;
    menuView.subCatbg.hidden=TRUE;
    menuView.subcatScroller.hidden=TRUE;
    menuView.OrderSummaryButton.userInteractionEnabled=FALSE;
    menuView.search.userInteractionEnabled=FALSE;
    menuView.favourite.userInteractionEnabled=FALSE;
    menuView.help.userInteractionEnabled=FALSE;
    menuView.overviewMenuButton.userInteractionEnabled=FALSE;
    menuView.KinaraLogo.userInteractionEnabled=FALSE;
    menuView.flagButton.userInteractionEnabled=FALSE;

}

-(void)addImageAnimation:(CGRect)btnFrame btnView:(UIView*)view
{
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(btnFrame.origin.x, btnFrame.origin.y, 350, 300)];
    // imgView = self.KKselectedImage;
    imgView.alpha = 1.0f;
    CGRect imageFrame = imgView.frame;
    // viewOrigin.y = 77 + imgView.size.height / 2.0f;
    // viewOrigin.x = 578 + imgView.size.width / 2.0f;
    
    imgView.frame = imageFrame;
    UIImage *itemImage=DishImage;
    
    [imgView setImage:itemImage];
    [self.view addSubview:imgView];
    [self.view bringSubviewToFront:imgView];
    imgView.clipsToBounds = NO;
    
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setToValue:@0.3f];
    fadeOutAnimation.fillMode = kCAFillModeForwards;
    fadeOutAnimation.removedOnCompletion = NO;
    
    // Set up scaling
    CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    [resizeAnimation setToValue:[NSValue valueWithCGSize:CGSizeMake(40.0f, imageFrame.size.height * (40.0f / 350))]];
    resizeAnimation.fillMode = kCAFillModeForwards;
    resizeAnimation.removedOnCompletion = NO;
    
    // Set up path movement
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    
    CGPoint endPoint = CGPointMake(630, -190);
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, btnFrame.origin.x, btnFrame.origin.y);
    CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, btnFrame.origin.x, endPoint.x,btnFrame.origin.y, endPoint.x, endPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:@[fadeOutAnimation, pathAnimation, resizeAnimation]];
    group.duration = 0.7f;
    group.delegate = self;
    [group setValue:imgView forKey:@"imageViewBeingAnimated"];
    [imgView.layer addAnimation:group forKey:@"savingAnimation"];
    
    [self performSelector:@selector(removeView2:) withObject:imgView afterDelay:0.8];
    
    [self checkItemInOrderList];
    
    //DLog(@"Order Conferm");
}
-(void)removeView2:(id)sender
{
    [sender removeFromSuperview];
}
-(void)unhideTheScrollerAndSubCatBgOnMenuController{
    
    menuView.subCatbg.hidden=FALSE;
    menuView.subcatScroller.hidden=FALSE;
    menuView.OrderSummaryButton.userInteractionEnabled=TRUE;
    menuView.search.userInteractionEnabled=TRUE;
    menuView.favourite.userInteractionEnabled=TRUE;
    menuView.help.userInteractionEnabled=TRUE;
    menuView.overviewMenuButton.userInteractionEnabled=TRUE;
    menuView.KinaraLogo.userInteractionEnabled=TRUE;
    menuView.flagButton.userInteractionEnabled=TRUE;
    
    
}

-(void)checkItemInOrderList
{
    bool itemExist=false;
    for(int i=0;i<[[ShareableData sharedInstance].OrderItemID count];++i)
    {
        if([([ShareableData sharedInstance].OrderItemID)[i] isEqualToString:DishID]&&[([ShareableData sharedInstance].confirmOrder)[i]isEqualToString:@"0"])
        {
            int quantity= [([ShareableData sharedInstance].OrderItemQuantity)[i]intValue];
            float price=[([ShareableData sharedInstance].OrderItemRate)[i]floatValue]/quantity;
            quantity++;
            NSString *currentPrice=[NSString stringWithFormat:@"%.02f",price*quantity];
            NSString *currentQty=[NSString stringWithFormat:@"%d",quantity];
            ([ShareableData sharedInstance].OrderItemRate)[i] = currentPrice;
            ([ShareableData sharedInstance].OrderItemQuantity)[i] = currentQty;
            
            itemExist=true;
            break;
            
        }
    }
    if(!itemExist)
    {
        [self addItem];
    }
}
-(void)addItem
{
    [[ShareableData sharedInstance].OrderItemID addObject:DishID];
    [[ShareableData sharedInstance].OrderItemName addObject:DishName];
    [[ShareableData sharedInstance].OrderItemRate addObject:DishPrice];
    [[ShareableData sharedInstance].OrderCatId addObject:DishCatId];
    [[ShareableData sharedInstance].IsOrderCustomization addObject:@"0"];
    [[ShareableData sharedInstance].OrderCustomizationDetail addObject:@"0"];
    [[ShareableData sharedInstance].OrderSpecialRequest addObject:@"0"];
    [[ShareableData sharedInstance].OrderItemQuantity addObject:@"1"];
    [[ShareableData sharedInstance].confirmOrder addObject:@"0"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    // Return the number of sections.
    int x =0;
    for (int j=0;j<[[ShareableData sharedInstance].SubCategoryList count];j++){
        NSMutableArray *resultFromPost = ([ShareableData sharedInstance].SubCategoryList)[j];
        x += [resultFromPost count];
       // [menuSubCategory removeAllObjects];
        [menuSubCategory addObjectsFromArray:resultFromPost];
        
    }
    return x;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.backgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"overviewBtnBg"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"overviewBtnBg_over.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
            NSMutableDictionary *dataitem=menuSubCategory[indexPath.row];
            // first row
    cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",dataitem[@"name"] ]; // only top row showing
            
            
                cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
               
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    [self.tt2 reloadData];
    
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (selectedIndex >=0){
   // NSString *searchTerm = self.searches[section];
    NSMutableDictionary *dataitem=menuSubCategory[selectedIndex];
   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
        [dishes removeAllObjects];
        //NSLOG(@"LogDD 5");
    [dishes addObjectsFromArray:[[TabSquareDBFile sharedDatabase]getDishData:[NSString stringWithFormat:@"%@",dataitem[@"category_id"] ] subCatId:[NSString stringWithFormat:@"%@",dataitem[@"id"] ]]];
   // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    return [dishes count];
    }else{
        return 0;
    }
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"NewDishCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UIImage * targetImage = [UIImage imageNamed:@"overviewBtnBg"];
    
    // redraw the image to fit |yourView|'s size
    UIGraphicsBeginImageContextWithOptions(cell.frame.size, NO, 0.f);
    [targetImage drawInRect:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView* imageView = [[UIImageView alloc] initWithImage:resultImage];
    UIGraphicsEndImageContext();
    [cell.contentView addSubview:imageView];
    
   // cell.backgroundColor = [UIColor colorWithPatternImage:resultImage];
     CGRect frame=CGRectMake(0,0, 146,96);
    if (selectedIndex >=0){
     NSMutableDictionary *dataitem=dishes[indexPath.row];
    UILabel *cellDishName = [[UILabel alloc]init];
        cellDishName.backgroundColor = [UIColor clearColor];
    cellDishName.frame = frame;
    cellDishName.text= [NSString stringWithFormat:@"%@",dataitem[@"name"]];
    cellDishName.textAlignment = NSTextAlignmentCenter;
        cellDishName.numberOfLines = 4;
    [cell.contentView addSubview:cellDishName];
    cell.contentView.contentMode = UIViewContentModeCenter;
    }
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self addClicked:indexPath.row];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

@end
