//
//  TabSquareNewBeerScrollController.m
//  TabSquareMenu
//
//  Created by ManojRai on 15/2/13.
//  Copyright (c) 2013 Trendsetterz. All rights reserved.
//
///////manoj...
#import "TabSquareNewBeerScrollController.h"
#import <QuartzCore/QuartzCore.h>
#import "TabSquareBeerListController.h"
#import "TabSquareBeerController.h"
#import "ShareableData.h"
#import "TabSquareMenuDetailController.h"
#import "TabSquareDBFile.h"

@interface TabSquareNewBeerScrollController ()

@end

@implementation TabSquareNewBeerScrollController

@synthesize hFlowView;
@synthesize vFlowView;
@synthesize hPageControl;

@synthesize detailImageView,drinkName,drinkImage;
@synthesize beerListView,beverageView,addBeverageId,addBeverageQunatity;
@synthesize beverageCatId,tempDishID;
@synthesize beverageCustomization,beverageCutType,selectedIndex;
@synthesize customizationView,beverageSkUView,beverageSKUDetail,leftArrow,rightArrow;
@synthesize mcloseButton;
@synthesize bgBlackView,mParent;
@synthesize orderScreenFlag;
@synthesize KDishImage;
@synthesize drinkNameFromOrderSummary,drinkDescriptionFromOrderSummary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setParent:(id)sender{
    
    mParent=sender;
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    
    NSString *img_name1 = [NSString stringWithFormat:@"%@%@_%@", PRE_NAME, POPUP_IMAGE,[ShareableData appKey]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
    NSString *libraryDirectory = [paths lastObject];
    NSString *location = [NSString stringWithFormat:@"%@/%@%@",libraryDirectory,img_name1,@".png"];
    
    UIImage *img1 = [UIImage imageWithContentsOfFile:location];
    
    bgImage.image = img1;
    
}
-(void)addBlankCustomizationView
{
    NSMutableDictionary *skudetail=beverageSKUDetail[beverageSkuIndex];
    customizationView.KKselectedID  =skudetail[@"sku_id"];
    NSString *beverageName=[NSString stringWithFormat:@"%@(%@)",(beverageView.beverageName)[[self.selectedIndex intValue]],skudetail[@"sku_name"]];
    customizationView.KKselectedName=beverageName;
    customizationView.KKselectedRate=skudetail[@"sku_price"];
    customizationView.KKselectedCatId=beverageCatId;
    customizationView.DishCustomization=(beverageView.beverageCustomization)[[selectedIndex intValue]];
    customizationView.KKselectedImage=(beverageView.beverageImageData)[[selectedIndex intValue]];
    customizationView.view.frame=CGRectMake(12, 0, self.view.frame.size.width-24, self.view.frame.size.height);
    customizationView.detailImageView.frame = CGRectMake(104, 229, 530, 222);
    customizationView.detailImageView.contentMode = UIViewContentModeRedraw;
    customizationView.crossBtn.frame=CGRectMake(610,210, 45, 45);////setting frame for cross button

    
    customizationView.detailImageView.clipsToBounds=YES;
    [customizationView.customizationView reloadData];
    customizationView.requestView.text=@"";
    customizationView.swipeIndicator=@"0";
    customizationView.isView=@"beverageinfo";
    if([customizationView.DishCustomization count]!=0)
    {
        [self.view addSubview:customizationView.view];
    }
}

-(void)addCustomizationView
{
    NSMutableDictionary *skudetail=beverageSKUDetail[beverageSkuIndex];
    customizationView.KKselectedID  =skudetail[@"sku_id"];
    NSString *beverageName=[NSString stringWithFormat:@"%@(%@)",(beverageView.beverageName)[[self.selectedIndex intValue]],skudetail[@"sku_name"]];
    customizationView.KKselectedName=beverageName;
    customizationView.KKselectedRate=skudetail[@"sku_price"];
    customizationView.KKselectedCatId=beverageCatId;
    customizationView.DishCustomization=(beverageView.beverageCustomization)[[selectedIndex intValue]];
    customizationView.KKselectedImage=(beverageView.beverageImageData)[[selectedIndex intValue]];
    customizationView.crossBtn.frame=CGRectMake(610,5, 45, 45);////setting frame for cross button
    [customizationView.customizationView reloadData];
    customizationView.requestView.text=@"";
    customizationView.swipeIndicator=@"0";
    customizationView.isView=@"beverageinfo";
    

    if([customizationView.DishCustomization count]!=0)
    {
        [self.view addSubview:customizationView.view];
    }
}

-(void)addItem
{
    NSMutableDictionary *skudetail=beverageSKUDetail[beverageSkuIndex];
    [[ShareableData sharedInstance].OrderItemID addObject:skudetail[@"sku_id"]];
    NSString *beverageName=[NSString stringWithFormat:@"%@(%@)",(beverageView.beverageName)[[self.selectedIndex intValue]],skudetail[@"sku_name"]];
    [[ShareableData sharedInstance].OrderItemName addObject:beverageName];
    
    [[ShareableData sharedInstance].OrderItemRate addObject:skudetail[@"sku_price"]];
    [[ShareableData sharedInstance].OrderCatId addObject:beverageCatId];
    [[ShareableData sharedInstance].IsOrderCustomization addObject:@"0"];
    [[ShareableData sharedInstance].OrderCustomizationDetail addObject:@"0"];
    [[ShareableData sharedInstance].OrderSpecialRequest addObject:@"0"];
    [[ShareableData sharedInstance].OrderItemQuantity addObject:@"1"];
    [[ShareableData sharedInstance].confirmOrder addObject:@"0"];
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*  [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderItemID forKey:@"OrderItemID"];
         [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderItemName forKey:@"OrderItemName"];
         [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderItemRate forKey:@"OrderItemRate"];
         [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderCatId forKey:@"OrderCatId"];
         [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].IsOrderCustomization forKey:@"IsOrderCustomization"];
         [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderCustomizationDetail forKey:@"OrderCustomizationDetail"];
         [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderSpecialRequest forKey:@"OrderSpecialRequest"];
         [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderItemQuantity forKey:@"OrderItemQuantity"];
         [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].confirmOrder forKey:@"confirmOrder"];
         [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].OrderId forKey:@"OrderId"];
         [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].assignedTable1 forKey:@"assignedTable1"];
         [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].assignedTable1 forKey:@"assignedTable2"];
         [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].assignedTable1 forKey:@"assignedTable3"];
         [[NSUserDefaults standardUserDefaults] setObject:[ShareableData sharedInstance].assignedTable1 forKey:@"assignedTable4"];*/
        NSArray *array=@[[ShareableData sharedInstance].OrderItemID,[ShareableData sharedInstance].OrderItemName,[ShareableData sharedInstance].OrderItemRate,[ShareableData sharedInstance].OrderCatId,[ShareableData sharedInstance].IsOrderCustomization,[ShareableData sharedInstance].OrderCustomizationDetail,[ShareableData sharedInstance].OrderSpecialRequest,[ShareableData sharedInstance].OrderItemQuantity,[ShareableData sharedInstance].confirmOrder];
        NSArray *array2 = @[[ShareableData sharedInstance].OrderId,[ShareableData sharedInstance].assignedTable1,[ShareableData sharedInstance].assignedTable2,[ShareableData sharedInstance].assignedTable3,[ShareableData sharedInstance].assignedTable4,[ShareableData sharedInstance].salesNo];;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        NSString *libraryDirectory = [paths lastObject];
        NSString *location = [libraryDirectory stringByAppendingString:@"/orderarrays.plist"];
        NSString *location2 = [libraryDirectory stringByAppendingString:@"/orderstrings.plist"];
        [array writeToFile:location atomically:YES];
        [array2 writeToFile:location2 atomically:YES];
        DLog(@"Added to Temp");
        
        // [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

-(void)checkItemInOrderList
{
    bool itemExist=false;
    for(int i=0;i<[[ShareableData sharedInstance].OrderItemID count];++i)
    {
        NSMutableDictionary *beveragesku=beverageSKUDetail[beverageSkuIndex];
        if([([ShareableData sharedInstance].OrderItemID)[i] isEqualToString:beveragesku[@"sku_id"]]&&[([ShareableData sharedInstance].confirmOrder)[i]isEqualToString:@"0"])
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

-(void)removeView2:(id)sender
{
    if([[ShareableData sharedInstance].IsViewPage count]==0)
    {
        [[ShareableData sharedInstance].IsViewPage addObject:@"beverage_main"];
    }
    else
    {
        ([ShareableData sharedInstance].IsViewPage)[0] = @"beverage_main";
    }
    [sender removeFromSuperview];
    // [self.view removeFromSuperview];
}

-(void)addImageAnimation:(CGRect)btnFrame btnView:(UIView*)view
{
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(btnFrame.origin.x, btnFrame.origin.y, 350, 300)];
    // imgView = self.KKselectedImage;
    imgView.alpha = 1.0f;
    CGRect imageFrame = imgView.frame;
    //  viewOrigin.y = 77 + imgView.size.height / 2.0f;
    // viewOrigin.x = 578 + imgView.size.width / 2.0f;
    
    UIImage *itemImage;
    itemImage=(beverageView.beverageImageData)[[selectedIndex intValue]];
    imgView.contentMode=UIViewContentModeScaleAspectFit;
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
    // DLog(@"Order Conferm");
}

-(IBAction)addBeerListView:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    UIView *view= [btn superview];
    CGRect frame=btn.frame;
    beverageSkuIndex=btn.tag;
    // NSString *type=[beverageCutType objectAtIndex:[selectedIndex intValue]];
    if([(beverageView.beverageCustomization)[[selectedIndex intValue]]count]==0)
    {
        //[self addImageAnimation:frame btnView:view];
        if ([[ShareableData sharedInstance].isSpecialReq isEqualToString:@"0"]){
            [self addImageAnimation:frame btnView:view];
        }else{
            [self addBlankCustomizationView];
        }
    }
    else
    {
        [self addCustomizationView];
    }
    
}

-(UIView*)addLabelAndButton:(UITableViewCell*)cell indexPath:(NSInteger)index
{
    //CGFloat width=cell.frame.size.width;
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 406,30)];
    cellView.backgroundColor=[UIColor clearColor];
    
    UIImageView *backImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"labelstrip.png"]];
    backImg.frame=CGRectMake(0, 0, 406,32);
    [cellView addSubview:backImg];
    
    //add label header
    UILabel *skuName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 140, 30)];
    
    NSMutableDictionary *skudetail=beverageSKUDetail[index];
    
    skuName.text=skudetail[@"sku_name"];
    skuName.backgroundColor=[UIColor clearColor];
    skuName.font=[UIFont systemFontOfSize:16];
    skuName.textColor = [UIColor blackColor];
    [cellView addSubview:skuName];
    
    //add price label
    UILabel *price=[[UILabel alloc]initWithFrame:CGRectMake(212, 0, 60,30)];
    price.backgroundColor=[UIColor clearColor];
    price.font=[UIFont systemFontOfSize:16];
    price.textAlignment=UITextAlignmentRight;
    price.text=[NSString stringWithFormat:@"$%@",skudetail[@"sku_price"]];
    price.textColor=[UIColor blackColor];
    [cellView addSubview:price];
    
    //add label button
    UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
    add.tag=index;
    add.frame=CGRectMake(299, 1, 105, 30);
    [add setImage:[UIImage imageNamed:@"add_Scrollbtn.png"] forState:UIControlStateNormal];
    [add setImage:[UIImage imageNamed:@"add_Scrollbtn.png"] forState:UIControlStateHighlighted];
    [add setImage:[UIImage imageNamed:@"add_Scrollbtn.png"] forState:UIControlStateSelected];
    [add addTarget:self action:@selector(addBeerListView:) forControlEvents:UIControlEventTouchUpInside];
    if([ShareableData sharedInstance].ViewMode==1 || [orderScreenFlag isEqualToString:@"1"]){

    
        add.hidden=YES;
    }
    else
    {
        add.hidden=NO;
    }
    [cellView addSubview:add];
    
    return cellView;
}



-(void)loadBeverageData:(int)index
{
    
    
    if ([[ShareableData sharedInstance].TaskType isEqualToString:@"3"]){
        
        DLog(@"current index %d",index);
        // DLog(@"current index %@",selectedIndex);
        selectedIndex = [[NSString stringWithFormat:@"%d",index] copy] ;
        DLog(@"selected index %@",selectedIndex);
        currentindex=index;
        int newindex=0;
        for (int i=0;i<[beverageView.beverageID count];i++){
            if ([(beverageView.beverageID)[i] isEqualToString:[NSString stringWithFormat:@"%d",tempDishID]]){
                newindex=i;
                break;
            }
        }
        selectedIndex = [[NSString stringWithFormat:@"%d",newindex] copy];
        currentindex = newindex;
        
        drinkName.text=(beverageView.beverageName)[newindex];
        drinkName.textColor=[UIColor whiteColor];
        drinkImage.image=(beverageView.beverageImageData)[newindex];
        drinkImage.contentMode=UIViewContentModeScaleAspectFill;
        _drinkDiscription.text=(beverageView.beverageDescription)[newindex];
        _drinkDiscription.textColor=[UIColor whiteColor];
        
        //get beverageskudetail
        
        //   [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
        beverageSKUDetail=[[TabSquareDBFile sharedDatabase]getBeverageSkuDetail:(beverageView.beverageID)[newindex]];
        //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
        
        if([beverageSKUDetail count]==0)
        {
            beverageSkUView.hidden=YES;
        }
        else
        {
            beverageSkUView.hidden=NO;
            [beverageSkUView reloadData];
        }
        
        
        
        
        [ShareableData sharedInstance].TaskType = @"0";
    }
    else{
        if(index==0||(index>0&index<[beverageView.beverageName count]))
        {DLog(@"current index %d",index);
            // DLog(@"current index %@",selectedIndex);
            selectedIndex = [[NSString stringWithFormat:@"%d",index] copy] ;
            DLog(@"selected index %@",selectedIndex);
            currentindex=index;
                       
            selectedImageAtMenu=index;
            
            drinkName.text=(beverageView.beverageName)[index];
            drinkName.textColor=[UIColor whiteColor];
            _drinkDiscription.text=(beverageView.beverageDescription)[index];
            _drinkDiscription.textColor=[UIColor whiteColor];
            
         //   ////NSLOG(@"drinkName===%@",drinkName.text);
            

            drinkName.font =[UIFont fontWithName:@"Lucida Calligraphy" size:25];
            _drinkDiscription.font =[UIFont fontWithName:@"Lucida Calligraphy" size:15];

//            drinkImage.image=(beverageView.beverageImageData)[index];
//            drinkImage.contentMode=UIViewContentModeScaleAspectFill;
//            drinkDiscription.text=(beverageView.beverageDescription)[index];
//            
            //get beverageskudetail
            
            //   [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
            beverageSKUDetail=[[TabSquareDBFile sharedDatabase]getBeverageSkuDetail:(beverageView.beverageID)[index]];
            // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
            
            if([beverageSKUDetail count]==0)
            {
                beverageSkUView.hidden=YES;
            }
            else
            {
                beverageSkUView.hidden=NO;
                [beverageSkUView reloadData];
            }
            
        }
    }
    
       

}


-(void)createBeerListView
{
    beerListView=[[TabSquareBeerListController alloc]initWithNibName:@"TabSquareBeerListController" bundle:nil];
    beerListView.beverageDetailView=self;
}

-(void)createCustomizationView
{
    customizationView=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
}


- (void)viewDidLoad
{
   
    [self createBeerListView];
    [self createCustomizationView];
    addBeverageId=[[NSMutableArray alloc]init];
    addBeverageQunatity=[[NSMutableArray alloc]init];
    beverageCustomization=[[NSMutableArray alloc]init];
    beverageCutType=[[NSMutableArray alloc]init];
//    detailImageView.layer.borderWidth=3.0;
//    detailImageView.layer.borderColor=[UIColor colorWithRed:168.0f/255.0f green:49.0f/255.0f blue:19.0f/255.0f alpha:1.0].CGColor;
//    if ([[ShareableData sharedInstance].isQuickOrder isEqualToString:@"1"]){
//        bgg.hidden = YES;
//    }else{
//        bgg.hidden = NO;
//    }
    hFlowView.delegate = self;
    hFlowView.dataSource = self;
    hFlowView.pageControl = hPageControl;
    hFlowView.minimumPageAlpha = 0.3;
    hFlowView.minimumPageScale = 0.9;
    
    [self.view addSubview:beverageSkUView];
    [self.view bringSubviewToFront:beverageSkUView];
    
    [self.view addSubview:mcloseButton];
    [self.view bringSubviewToFront:mcloseButton];
    
    currentIndex=0;
    @autoreleasepool {
        
        
        hFlowView.layer.borderWidth=3.0;
        hFlowView.layer.borderColor=[UIColor colorWithRed:168.0f/255.0f green:49.0f/255.0f blue:19.0f/255.0f alpha:1.0].CGColor;
        nextOrPrev=0;
     
        if ([[ShareableData sharedInstance].isQuickOrder isEqualToString:@"1"]){
            bggg.hidden = YES;
        }else{
            bggg.hidden = NO;
        }
    }
    [super viewDidLoad];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView;{
    return CGSizeMake(550, 441);
    
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView {
    if (pageNumber>=0) {
        // ////NSLOG(@"Scrolled to page # %d", pageNumber);
        [self loadBeverageData:pageNumber];

        // [KDishImage.layer setShadowOpacity:1.0];
        //[KDishImage.layer setShadowOffset:CGSizeMake(2.5, 1.5)];
        drinkName.text=(beverageView.beverageName)[pageNumber];
       // drinkName.textColor=[UIColor whiteColor];
        _drinkDiscription.text=(beverageView.beverageDescription)[pageNumber];
        //_drinkDiscription.textColor=[UIColor whiteColor];
        

//        drinkName.font =[UIFont fontWithName:@"Lucida Calligraphy" size:25];
//        _drinkDiscription.font =[UIFont fontWithName:@"Lucida Calligraphy" size:15];
//        
       // ////NSLOG(@"KDishName.text====%@d", drinkName.text);
        
        
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView{
    
    if([orderScreenFlag isEqualToString:@"1"]){
        return 1;
        
    }
    else{
        return [(beverageView.beverageImageData) count];
        
        
    }
    
    return 1;
    
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
//    ////NSLOG(@"DishImage====%d",[DishName count]);
//    drinkImage.image=(beverageView.beverageImageData)[pageNumber];

    
    imageView = (UIImageView *)[flowView dequeueReusableCell];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        // imageView.layer.cornerRadius = 6;
        
        imageView.layer.borderWidth=6;
        
        // setup shadow layer and corner
        imageView.layer.shadowColor = [UIColor grayColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(0, 1);
        imageView.layer.shadowOpacity = 1;
        imageView.layer.shadowRadius = 9.0;
        // imageView.layer.cornerRadius = 9.0;
        imageView.clipsToBounds = NO;
         imageView.backgroundColor =[UIColor colorWithRed:250 green:192 blue:144 alpha:0.8];
        
        
        imageView.layer.borderColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0].CGColor;
        
    }
//    CGSize kMaxImageViewSize = {.width = 68, .height = 50};
//    UIImage *image=(beverageView.beverageImageData)[index];
//    imageView=[[UIImageView alloc]initWithImage:image];
//    imageView.frame=CGRectMake(5, 10, 50, 50);
//    CGSize imageSize = image.size;
//    CGFloat aspectRatio = imageSize.width / imageSize.height;
//    CGRect frame = imageView.frame;
//    if (!(aspectRatio >= 0)){
//        aspectRatio = 1;
//    }
//    if (kMaxImageViewSize.width / aspectRatio <= kMaxImageViewSize.height)
//    {
//        frame.size.width = kMaxImageViewSize.width;
//        frame.size.height = frame.size.width / aspectRatio;
//    }
//    else
//    {
//        frame.size.height = kMaxImageViewSize.height;
//        frame.size.width = frame.size.height * aspectRatio;
//    }
//    imageView.frame = frame;
    
    
    if([orderScreenFlag isEqualToString:@"1"]){
      //  ////NSLOG(@"selectedItemIndex==%d",selectedItemIndex);
       // imageView.image = [(beverageView.beverageImageData) objectAtIndex:selectedItemIndex];
        imageView.image = KDishImage;
        drinkName.text=drinkNameFromOrderSummary;
        drinkName.textColor=[UIColor whiteColor];
        ;//(beverageView.beverageName)[selectedItemIndex];
        _drinkDiscription.text=drinkDescriptionFromOrderSummary;
        _drinkDiscription.textColor=[UIColor whiteColor];
        

        drinkName.font =[UIFont fontWithName:@"Lucida Calligraphy" size:25];
        _drinkDiscription.font =[UIFont fontWithName:@"Lucida Calligraphy" size:15];
        

    }
    else{
        imageView.image = [(beverageView.beverageImageData) objectAtIndex:index];

    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    
    return imageView;
    
}

-(UIButton*)getAddbutton:(UIView*)view
{
    UIButton *add = nil;
    for(int i=0;i<[view.subviews count];++i)
    {
        if([(view.subviews)[i] isKindOfClass:[UIButton class]])
        {
            add=(UIButton*)(view.subviews)[i];
            return add;
        }
    }
    return add;
}
-(void)viewDidDisappear:(BOOL)animated{
    
    hFlowView = nil;
     vFlowView= nil;
     hPageControl= nil;
    
     detailImageView= nil;
    drinkName= nil;
    drinkImage= nil;
     beerListView= nil;
    beverageView= nil;
    addBeverageId= nil;
    addBeverageQunatity= nil;
     beverageCatId= nil;
    tempDishID= nil;
     beverageCustomization= nil;
    beverageCutType= nil;
    selectedIndex= nil;
     customizationView= nil;
    beverageSkUView= nil;
    beverageSKUDetail= nil;
    leftArrow= nil;
    rightArrow= nil;
     mcloseButton= nil;
     bgBlackView= nil;
    mParent= nil;
     orderScreenFlag= nil;
     KDishImage= nil;
     drinkNameFromOrderSummary= nil;
    drinkDescriptionFromOrderSummary= nil;
}

-(void)onTick:(NSTimer *)timer
{
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // DLog(@"TabSquareBeerDetailController UnLoad");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [beverageSKUDetail count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UIView *detailView=[self addLabelAndButton:cell indexPath:indexPath.row];
    detailView.tag=indexPath.row;
    [cell.contentView addSubview:detailView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}
              
-(IBAction)closeClicked:(id)sender
{
    if([[ShareableData sharedInstance].IsViewPage count]==0)
    {
        [[ShareableData sharedInstance].IsViewPage addObject:@"beverage_main"];
    }
    else
    {
        ([ShareableData sharedInstance].IsViewPage)[0] = @"beverage_main";
    }
    [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
    [self.view removeFromSuperview];
    [mParent parentCallToUnHideTheScrollerAndSubCatBgOnMenuController];

}

@end
