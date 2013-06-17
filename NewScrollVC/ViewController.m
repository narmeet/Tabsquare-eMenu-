//
//  ViewController.m
//  PagedFlowView
//
//  Created by manoj on 5/2/13.
//  Copyright (c) 2012 geeklu.com. All rights reserved.
//

#import "ViewController.h"
#import "TabSquareMenuDetailController.h"
#import "SBJSON.h"
#import "ShareableData.h"
#import <QuartzCore/QuartzCore.h>
#import "TabSquareOrderSummaryController.h"
#import "TabMainDetailView.h"
#import "TabSquareDBFile.h"
#import "TabSquareMenuController.h"
#import "TabMainCourseMenuListViewController.h"
#import "LanguageControler.h"
#import "TabSquareComboSet.h"
#import "TabSquareRemoteActivation.h"

@implementation ViewController
@synthesize hFlowView;
@synthesize vFlowView;
@synthesize hPageControl;
@synthesize menuDetailView,KDishName, isSetType,KDishRate,KDishImage,KDishDescription,selectedID,DishID,DishSubId,DishDescription,DishImage,DishName,DishPrice;
@synthesize addButton,leftButton,rightButton,mcloseButton;
@synthesize DishCatId,descriptionScroll,DishCustomization,custType,IshideAddButton;
@synthesize KDishCust,KDishCustType,Viewtype,KDishCatId,kDishId,orderSummaryView;
@synthesize detailView,swipeDetailView;
@synthesize tabMainDetailView;
@synthesize imageView;
@synthesize orderScreenFlag;
@synthesize tabMainCourseMenuListViewController;

@synthesize currIndex,mParent,bgBlackView;



#pragma mark - View lifecycle

-(void)setParent:(id)sender{
    
    mParent=sender;
}
-(void)allocateArray
{
    
    DishName=[[NSMutableArray alloc]init];
    DishPrice=[[NSMutableArray alloc]init];
    DishDescription=[[NSMutableArray alloc]init];
    DishID=[[NSMutableArray alloc]init];
    DishImage=[[NSMutableArray alloc]init];
    DishCustomization=[[NSMutableArray alloc]init];
    DishCatId=[[NSMutableArray alloc]init];
    DishSubId=[[NSMutableArray alloc]init];
    custType=[[NSMutableArray alloc]init];
    KDishCust=[[NSMutableArray alloc]init];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    NSString *img_name1 = [NSString stringWithFormat:@"%@%@_%@", PRE_NAME, POPUP_IMAGE,[ShareableData appKey]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
    NSString *libraryDirectory = [paths lastObject];
    NSString *location = [NSString stringWithFormat:@"%@/%@%@",libraryDirectory,img_name1,@".png"];
    
    UIImage *img1 = [UIImage imageWithContentsOfFile:location];
    
    bgImage.image = img1;

 
}

-(IBAction)addBtnClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    curr_btn = btn;
    UIView *view= [btn superview];
    CGRect frame=btn.frame;
    cur_frm = frame;
    
    int curr_index = [self.hFlowView currentPageIndex];
    BOOL bev = [DishCatId[curr_index] isEqualToString:@"8"];
    if(!bev && [isSetType[curr_index] intValue] == 1) {
        TabSquareComboSet *combo = [[TabSquareComboSet alloc] init];
        
        [combo setComboId:[[DishID objectAtIndex:curr_index] intValue] categoryId:[DishCatId[curr_index] intValue]];
        [combo setRootController:tabMainCourseMenuListViewController];
        [combo setDetailRootController:self];
        [self presentViewController:combo animated:NO completion:nil];
        return;
    }

    
    NSString *IsCustomization=@"";
    if([Viewtype isEqualToString:@"1"])
    {
        IsCustomization=custType[[selectedID intValue]];
    }
    else if([Viewtype isEqualToString:@"2"])
    {
        IsCustomization=KDishCustType;
    }
    if([IsCustomization isEqualToString:@"1"])
    {
        if([[ShareableData sharedInstance].IsViewPage count]==0)
        {
            [[ShareableData sharedInstance].IsViewPage addObject:@"main_customization"];
        }
        else
        {
            ([ShareableData sharedInstance].IsViewPage)[0] = @"main_customization";
        }
        
        [self addCustomizationView];
    }
    else
    {
        //[self addImageAnimation:frame btnView:view];
        if ([[ShareableData sharedInstance].isSpecialReq isEqualToString:@"0"]){
            [self addImageAnimation:frame btnView:view];
        }else{
            [self addBlankCustomizationView];
        }

    }
    
}

-(void)orderAddAnimation
{
    [self addImageAnimation:cur_frm btnView:curr_btn.superview];
}

-(void)addImageAnimation:(CGRect)btnFrame btnView:(UIView*)view
{
//    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(btnFrame.origin.x, btnFrame.origin.y, 350, 300)];
//    // imgView = self.KKselectedImage;
//    imgView.alpha = 1.0f;
//    CGRect imageFrame = imgView.frame;
//    //  viewOrigin.y = 77 + imgView.size.height / 2.0f;
//    // viewOrigin.x = 578 + imgView.size.width / 2.0f;
//    
//    imgView.frame = imageFrame;
//    UIImage *itemImage;
//    KDishImage.image=[DishImage objectAtIndex:0];
//    itemImage=[DishImage objectAtIndex:0];
//
//    
//    [imgView setImage:itemImage];
//    [self.view addSubview:imgView];
//    [self.view bringSubviewToFront:imgView];
//    imgView.clipsToBounds = NO;

UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(btnFrame.origin.x, btnFrame.origin.y, 350, 300)];
// imgView = self.KKselectedImage;
imgView.alpha = 1.0f;
CGRect imageFrame = imgView.frame;
//  viewOrigin.y = 77 + imgView.size.height / 2.0f;
// viewOrigin.x = 578 + imgView.size.width / 2.0f;

UIImage *itemImage;
itemImage=[DishImage objectAtIndex:currentIndex];
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
    
}
-(void)removeView2:(id)sender
{
    [sender removeFromSuperview];
}
-(void)addItem
{
    if([Viewtype isEqualToString:@"1"])
    {
        [[ShareableData sharedInstance].OrderItemID addObject:DishID[[self.selectedID intValue]]];
        [[ShareableData sharedInstance].OrderItemName addObject:DishName[[self.selectedID intValue]]];
        [[ShareableData sharedInstance].OrderItemRate addObject:DishPrice[[self.selectedID intValue]]];
        [[ShareableData sharedInstance].OrderCatId addObject:DishCatId[[self.selectedID intValue]]];
    }
    else if ([Viewtype isEqualToString:@"2"])
    {
        [[ShareableData sharedInstance].OrderItemID addObject:kDishId];
        [[ShareableData sharedInstance].OrderItemName addObject:KDishName.text];
        [[ShareableData sharedInstance].OrderItemRate addObject:KDishRate.text];
        [[ShareableData sharedInstance].OrderCatId addObject:KDishCatId];
    }
    [[ShareableData sharedInstance].IsOrderCustomization addObject:@"0"];
    [[ShareableData sharedInstance].OrderCustomizationDetail addObject:@"0"];
    [[ShareableData sharedInstance].OrderSpecialRequest addObject:@"0"];
    [[ShareableData sharedInstance].OrderItemQuantity addObject:@"1"];
    [[ShareableData sharedInstance].confirmOrder addObject:@"0"];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *array=@[[ShareableData sharedInstance].OrderItemID,[ShareableData sharedInstance].OrderItemName,[ShareableData sharedInstance].OrderItemRate,[ShareableData sharedInstance].OrderCatId,[ShareableData sharedInstance].IsOrderCustomization,[ShareableData sharedInstance].OrderCustomizationDetail,[ShareableData sharedInstance].OrderSpecialRequest,[ShareableData sharedInstance].OrderItemQuantity,[ShareableData sharedInstance].confirmOrder];
        NSArray *array2 = @[[ShareableData sharedInstance].OrderId,[ShareableData sharedInstance].assignedTable1,[ShareableData sharedInstance].assignedTable2,[ShareableData sharedInstance].assignedTable3,[ShareableData sharedInstance].assignedTable4];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = paths[0];
        NSString *location = [libraryDirectory stringByAppendingString:@"/orderarrays.plist"];
        NSString *location2 = [libraryDirectory stringByAppendingString:@"/orderstrings.plist"];
        [array writeToFile:location atomically:YES];
        [array2 writeToFile:location2 atomically:YES];
        DLog(@"Added to Temp");
        
        // [[NSUserDefaults standardUserDefaults] synchronize];
    });
    [orderSummaryView filterData];
    [orderSummaryView CalculateTotal];
    orderSummaryView.specialRequest.text=@"";
    [orderSummaryView showRequestbox];
    [self.view addSubview:orderSummaryView.view];
    [orderSummaryView.OrderList reloadData];
}

-(void)checkItemInOrderList
{
    bool itemExist=false;
    NSString *SelectedDishId;
    if([Viewtype isEqualToString:@"1"])
    {
        SelectedDishId=DishID[[self.selectedID intValue]];
    }
    else if ([Viewtype isEqualToString:@"2"])
    {
        SelectedDishId=kDishId;
    }
    for(int i=0;i<[[ShareableData sharedInstance].OrderItemID count];++i)
    {
        if([([ShareableData sharedInstance].OrderItemID)[i] isEqualToString:SelectedDishId]&&[([ShareableData sharedInstance].confirmOrder)[i]isEqualToString:@"0"])
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
-(void)loadDataInView:(int)selectedItem
{
    //self.view.frame=CGRectMake(50, 120, 529, 640);
    
    
   // [self showButtons];
    if (selectedItem==0) {
        rightButton.alpha=0.0;
        leftButton.alpha=1.0;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationCurveEaseIn
                         animations:^
         {
             rightButton.alpha=0.0;
             leftButton.alpha=1.0;
         }
                         completion:nil
         ];
    }
    else{
        // leftButton.alpha=0.0;
        //rightButton.hidden=0.0;
        if (selectedItem==[DishID count]-1) {
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationCurveEaseOut
                             animations:^
             {
                 rightButton.alpha=1.0;
                 leftButton.alpha=0.0;
             }
                             completion:nil
             ];
            
        }
        else{
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationCurveEaseIn
                             animations:^
             {
                 rightButton.alpha=1.0;
                 leftButton.alpha=1.0;
             }
                             completion:nil
             ];
        }
        
    }
    //currentindex=selectedItem;
    currIndex = [NSString stringWithFormat:@"%d", selectedItem];
    selectedID=[[NSString alloc]initWithFormat:@"%d",selectedItem];
    //KDishName.font=[UIFont fontWithName:@"Lucida Calligraphy" size:17];
    KDishName.text=DishName[selectedItem];
    KDishImage.image=DishImage[selectedItem];
   // CGSize newsize=  [DishName[selectedItem] sizeWithFont:KDishName.font constrainedToSize:CGSizeMake(241, 400) lineBreakMode:KDishName.lineBreakMode];
   // KDishName.frame=CGRectMake(KDishName.frame.origin.x, KDishName.frame.origin.y, newsize.width+5, newsize.height);
   //
    KDishName.numberOfLines = 3;
    KDishRate.text=[NSString stringWithFormat:@"$%@",DishPrice[selectedItem]];
    //KDishRate.font=[UIFont fontWithName:@"Lucida Calligraphy" size:17];
    KDishDescription.text=DishDescription[selectedItem];
   // KDishDescription.frame =CGRectMake(0, 0, 481, 120);
    //[KDishDescription sizeToFit];
   // descriptionScroll.contentSize=CGSizeMake(descriptionScroll.contentSize.width, KDishDescription.frame.size.height);
   // KDishDescription.font=[UIFont fontWithName:@"Lucida Calligraphy" size:14];
    IshideAddButton=@"0";
    Viewtype=@"1";
    if([ShareableData sharedInstance].ViewMode==1)
    {
        addButton.hidden=YES;
    }
    else
    {
        addButton.hidden=NO;
    }
    
}
-(void)addBlankCustomizationView
{
    menuDetailView=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
    // menuDetailView
    if([Viewtype isEqualToString:@"1"])
    {
        int index = [self.selectedID intValue];
        menuDetailView.KKselectedID=DishID[index];
        menuDetailView.KKselectedName=DishName[index];
        menuDetailView.KKselectedRate=DishPrice[index];
        menuDetailView.KKselectedCatId=DishCatId[index];
        menuDetailView.DishCustomization=DishCustomization[index];
    }
    else if([Viewtype isEqualToString:@"2"])
    {
        menuDetailView.KKselectedID=kDishId;
        menuDetailView.KKselectedName=KDishName.text;
        menuDetailView.KKselectedRate=[NSString stringWithFormat:@"%@",KDishRate.text];
        menuDetailView.KKselectedCatId=KDishCatId;
        menuDetailView.DishCustomization=KDishCust[0];
    }
    
    menuDetailView.KKselectedImage=[DishImage objectAtIndex:currentIndex];
    [menuDetailView.customizationView reloadData];
    menuDetailView.view.frame=CGRectMake(12, 0, self.view.frame.size.width-24, self.view.frame.size.height);
    menuDetailView.detailImageView.frame = CGRectMake(104, 229, 530, 260);
    menuDetailView.crossBtn.frame=CGRectMake(610,210, 45, 45);////setting frame for cross button
    
    menuDetailView.detailImageView.contentMode = UIViewContentModeRedraw;
    
    
    menuDetailView.detailImageView.clipsToBounds=YES;
    
    [self.view addSubview:menuDetailView.view];
    menuDetailView.requestView.text=@"";
    menuDetailView.swipeIndicator=@"0";
    menuDetailView.isView=@"maininfo";
    [self.view bringSubviewToFront:menuDetailView.view];
}

-(void)addCustomizationView
{
    menuDetailView=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
    // menuDetailView
    if([Viewtype isEqualToString:@"1"])
    {
        int index = [self.selectedID intValue];
        menuDetailView.KKselectedID=DishID[index];
        menuDetailView.KKselectedName=DishName[index];
        menuDetailView.KKselectedRate=DishPrice[index];
        menuDetailView.KKselectedCatId=DishCatId[index];
        menuDetailView.DishCustomization=DishCustomization[index];
    }
    else if([Viewtype isEqualToString:@"2"])
    {
        menuDetailView.KKselectedID=kDishId;
        menuDetailView.KKselectedName=KDishName.text;
        menuDetailView.KKselectedRate=[NSString stringWithFormat:@"%@",KDishRate.text];
        menuDetailView.KKselectedCatId=KDishCatId;
        menuDetailView.DishCustomization=KDishCust[0];
    }
    
    menuDetailView.KKselectedImage=[DishImage objectAtIndex:currentIndex];
    [menuDetailView.customizationView reloadData];
    menuDetailView.view.frame=CGRectMake(1, 0, menuDetailView.view.frame.size.width, menuDetailView.view.frame.size.height);
    menuDetailView.crossBtn.frame=CGRectMake(610,5, 45, 45);////setting frame for cross button

    [self.view addSubview:menuDetailView.view];
    menuDetailView.requestView.text=@"";
    menuDetailView.swipeIndicator=@"0";
    menuDetailView.isView=@"maininfo";
    [self.view bringSubviewToFront:menuDetailView.view];
}
-(void)viewWillDisappear:(BOOL)animated{
//    [tt invalidate];
//    tt = nil;
    
}
-(void)onTick:(NSTimer *)timer
{
//    if([ShareableData sharedInstance].ViewMode==1)
//    {
//        addButton.hidden=YES;
//    }
//    else
//    {
//        addButton.hidden=NO;
//    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [tabMainCourseMenuListViewController setMenuStatus:@"0"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    /*============Registering to receive language change signal==============*/
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(languageChanged:)
     name:LANGUAGE_CHANGED
     object:nil];
    
    /*=====================Register to recieve Mode Change Activation======================*/
    [[TabSquareRemoteActivation remoteActivation] registerRemoteNotification:self];


       // DLog(@"TabMainMenuDetailViewController");
    //[self createMenuDetailView];
    nextOrPrev=0;
//    tt=[NSTimer scheduledTimerWithTimeInterval:1.0
//                                        target:self
//                                      selector:@selector(onTick:)
//                                      userInfo:nil
//                                       repeats:YES];
    
    // imageArray = [[NSArray alloc] initWithObjects:@"callwater.png",@"callbill_selected.png",@"callBill.png",@"category.png",nil];
    //NSLOG(@"selectedImageAtMenu==%d",selectedImageAtMenu);
    
    hFlowView.delegate = self;
    hFlowView.dataSource = self;
    hFlowView.pageControl = hPageControl;
    hFlowView.minimumPageAlpha = 0.3;
    hFlowView.minimumPageScale = 0.9;
   
    [self.view addSubview:addButton];
    [self.view bringSubviewToFront:addButton];

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
    
}




-(void)showDetailView:(int)selectedItem
{
    
   // TabSquareMenuController *tabMainDetailView =[[TabSquareMenuController alloc]init];
    //[super.TabSquareMenuController hideUnhideComponents:YES];

   
    bgBlackView.userInteractionEnabled=NO;
    rightButton.hidden=TRUE;
    
    selectedIndex=selectedItem;
    currentIndex=selectedItem;
    ////NSLOG(@"dd.selectedItem==%d",selectedItem);
    selectedImageAtMenu =selectedItem;
    
    //loading the rate,name,description of the selected Dish
    KDishName.text=DishName[selectedItem];
    KDishName.font =[UIFont fontWithName:@"Century Gothic" size:25];

    KDishRate.text=DishPrice[selectedItem];
    KDishRate.font =[UIFont fontWithName:@"Century Gothic" size:20];

    KDishDescription.text=DishDescription[selectedItem];
    KDishDescription.font =[UIFont fontWithName:@"Century Gothic" size:20];

 //   //NSLOG(@"KDishName==%@",KDishName.text);
    //[hFlowView reloadData];
    
}

-(IBAction)closeClicked:(id)sender
{
    if(orderSummaryView)
    {
        [orderSummaryView.OrderList reloadData];
    }
    ([ShareableData sharedInstance].IsViewPage)[0] = @"main_detail";
    [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
    [self.view removeFromSuperview];
    
//    tabMainCourseMenuListViewController=(TabMainCourseMenuListViewController)self.parentViewController;//[[TabMainCourseMenuListViewController alloc]initWithNibName:@"TabMainCourseMenuListViewController" bundle:nil];
//    
//    
//
    tabMainCourseMenuListViewController.menuStatus = @"0";
    
    [self.mParent unhideTheScrollerAndSubCatBgOnMenuController];
}

//-(IBAction)addClicked:(id)sender{
//    //tabMainDetailView=[[TabMainDetailView alloc]init];
//    [self loadDataInView:selectedIndex];
//    Viewtype=@"1";
//    [self addBtnClicked:sender];
//}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView;{
    return CGSizeMake(550, 441);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView {
    if (pageNumber>=0) {
       // //NSLOG(@"Scrolled to page # %d", pageNumber);
        
        // [KDishImage.layer setShadowOpacity:1.0];
        //[KDishImage.layer setShadowOffset:CGSizeMake(2.5, 1.5)];
        currentIndex=pageNumber;
        selectedID =[NSString stringWithFormat:@"%d",pageNumber];
        KDishName.text=DishName[pageNumber];
        KDishRate.text=DishPrice[pageNumber];
        KDishDescription.text=DishDescription[pageNumber];
//        KDishName.font =[UIFont fontWithName:@"Lucida Calligraphy" size:25];
//        KDishRate.font =[UIFont fontWithName:@"Lucida Calligraphy" size:25];
//        KDishDescription.font =[UIFont fontWithName:@"Lucida Calligraphy" size:15];
        
       // //NSLOG(@"KDishName.text====%@d", KDishName.text);
        
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView{
   
    //NSLOG(@"DishImage count====%d", [DishImage count]);

    if([orderScreenFlag isEqualToString:@"1"]){
        return 1;

    }
    else{

        return [DishImage count];

        
    }
    
    return 1;
    
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    ////NSLOG(@"DishImage====%@",KDishCatId);

    imageView = (UIImageView *)[flowView dequeueReusableCell];
    
    if ([KDishCatId isEqualToString:@"8"]) { ///////for beverages
        
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
            // imageView.layer.masksToBounds = YES;
            
            imageView.backgroundColor =[UIColor colorWithRed:250 green:192 blue:144 alpha:0.8];
            imageView.contentMode = UIViewContentModeScaleAspectFit;

            imageView.layer.borderColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0].CGColor;
            
        }
        // //NSLOG(@"index flowView # %d", index);
        ////NSLOG(@"KDishImagev== %@", KDishImage);
        
        if([ShareableData sharedInstance].ViewMode==1)
        {
            addButton.hidden=YES;
            imageView.image = [DishImage objectAtIndex:index];
            
        }
        else
        {
            if([orderScreenFlag isEqualToString:@"1"]){
                addButton.hidden=TRUE;
//                KDishName.font =[UIFont fontWithName:@"Lucida Calligraphy" size:25];
//                KDishRate.font =[UIFont fontWithName:@"Lucida Calligraphy" size:25];
//                KDishDescription.font =[UIFont fontWithName:@"Lucida Calligraphy" size:20];
                KDishName.frame=CGRectMake(90, 518,354,62);
              //  KDishRate.frame=CGRectMake(448,528,112,452);

                imageView.image = KDishImage;
            }
            else{
                addButton.hidden=FALSE;
                
                imageView.image = [DishImage objectAtIndex:index];
                
            }
            
            
        }

        
    }
    else{
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
       // imageView.layer.masksToBounds = YES;


        imageView.layer.borderColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0].CGColor;

    }
   // //NSLOG(@"index flowView # %d", index);
    ////NSLOG(@"KDishImagev== %@", KDishImage);
    
    if([ShareableData sharedInstance].ViewMode==1)
    {
        addButton.hidden=YES;
        imageView.image = [DishImage objectAtIndex:index];

    }
    else
    {
        if([orderScreenFlag isEqualToString:@"1"]){
            addButton.hidden=TRUE;
//            KDishName.font =[UIFont fontWithName:@"Lucida Calligraphy" size:25];
//            KDishRate.font =[UIFont fontWithName:@"Lucida Calligraphy" size:25];
//            KDishDescription.font =[UIFont fontWithName:@"Lucida Calligraphy" size:20];
            KDishName.frame=CGRectMake(90, 518,354,62);
            //KDishRate.frame=CGRectMake(448,528,112,452);
            imageView.image = KDishImage;
        }
        else{
            addButton.hidden=FALSE;
            
            imageView.image = [DishImage objectAtIndex:index];
            
        }

        
    }
    
    }
    
        
    return imageView;
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


/*=================================Language Change Notification==================================*/
/*===========Update UI here*/

-(void)languageChanged:(NSNotification *)notification
{
    
    [self.hFlowView reloadData];
    [self.vFlowView reloadData];
    
}


/*=================View Mode Selected===================*/
-(void)viewModeActivated:(NSNotification *)notification
{
    [self.addButton setHidden:TRUE];
}


/*=================Edit Mode Selected===================*/
-(void)editModeActivated:(NSNotification *)notification
{
    [self.addButton setHidden:FALSE];
}


@end
