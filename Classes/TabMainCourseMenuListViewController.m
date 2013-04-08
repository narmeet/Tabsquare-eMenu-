
#import "TabMainCourseMenuListViewController.h"
#import "TabMainMenuDetailViewController.h"
#import "SBJSON.h"
#import "ShareableData.h"
#import "TabSquareMenuDetailController.h"
#import "MSLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "TabSquareMenuController.h"
#import "TabSquareDBFile.h"
#import "TabMainDetailView.h"
#import "TabSquareBeerDetailController.h"
#import "TabSquareBeerController.h"
#import "TabSquareCommonClass.h"
#import "TabSquareComboSet.h"


@implementation TabMainCourseMenuListViewController

@synthesize menudetailView,DishList,tmpCell,resultFromPost,DishName,DishPrice,DishDescription,DishID,DishImage,SoupView, isSetType;
@synthesize DishCategoryId,beerDetailView;
@synthesize currentListTag;
@synthesize pageIndex,DishCustomization, tagIcons, tagNames;
@synthesize custType,menuview,dishDetailview,DishSubCategoryId;
@synthesize SubSectionIdData,SubSectionNameData,SectionDishData,DishSubSubCategoryId,beveragesBeerView,menuDetailViewT ;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame=CGRectMake(13, 20, self.view.frame.size.width, self.view.frame.size.height);
    }
    return self;
}

-(void)postData:(NSString *)sub cat:(NSString*)CatID
{
    NSString *taskType=[ShareableData sharedInstance].TaskType;
    if([taskType isEqualToString:@"1"])
    {
       // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
        if([sub isEqualToString:@"0"])
        {
            sub=@"<null>";
        }
        resultFromPost=[[TabSquareDBFile sharedDatabase]getDishData:CatID subCatId:sub];
       // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];

    }
    else
    {
        resultFromPost = [ShareableData sharedInstance].SearchAllItemData;
        DLog(@"%d",[resultFromPost count]);
    }
}

-(void)createMenuDetail
{
   
    // menudetailView=[[TabMainMenuDetailViewController alloc]initWithNibName:@"TabMainMenuDetailViewController" bundle:nil];
    
    ////change newScrollVC
    menudetailView=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    [menudetailView allocateArray];
}

-(void)createDishDetailview
{
    self.dishDetailview=[[TabMainDetailView alloc]initWithNibName:@"TabMainDetailView" bundle:[NSBundle mainBundle]];
}

-(void)allocateArray
{
    SubSectionIdData=[[NSMutableArray alloc]init];
    SubSectionNameData=[[NSMutableArray alloc]init];
    SectionDishData=[[NSMutableArray alloc]init];
    self.resultFromPost=[[NSMutableArray alloc]init];
    DishName=[[NSMutableArray alloc]init];
    DishPrice=[[NSMutableArray alloc]init];
    self.isSetType = [[NSMutableArray alloc]init];
    self.tagIcons = [[NSMutableArray alloc]init];
    DishDescription=[[NSMutableArray alloc]init];
    self.tagNames = [[NSMutableArray alloc]init];
    DishID=[[NSMutableArray alloc]init];
    DishImage=[[NSMutableArray alloc]init];
    DishCategoryId=[[NSMutableArray alloc]init]; 
    DishSubCategoryId=[[NSMutableArray alloc]init];
    DishSubSubCategoryId=[[NSMutableArray alloc]init];
    DishCustomization=[[NSMutableArray alloc]init];
    currentListTag=0;
    custType=[[NSMutableArray alloc]init];
}



-(void)viewDidLoad
{
    [super viewDidLoad];
    
    tag_switch = [ShareableData dishTagStatus];

      // int currentVCIndex = [self.navigationController.viewControllers indexOfObject:self.navigationController.topViewController];
   // DLog(@"MCML1 %d",currentVCIndex);
  //  menuview.view =[self.view superview];
    [self allocateArray];
    [self createMenuDetail];
    [self createDishDetailview];
    self.beerDetailView =[[TabSquareBeerDetailController alloc]initWithNibName:@"TabSquareBeerDetailController" bundle:nil];
   // beerDetailView.beverageView=self;
   /* [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(onTick:)
                                   userInfo:nil
                                    repeats:NO];*/
    self.beveragesBeerView=[[TabSquareBeerController alloc]initWithNibName:@"TabSquareBeerController" bundle:nil];
    beerDetailView.beverageView = beveragesBeerView;
    menudetailView.menuDetailView=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
}


-(void)onTick:(NSTimer *)timer 
{
  // [DishList reloadData];
}
-(void)reloadDataOfSubCat2:(NSString *)sub cat:(NSString *)CatID{
    [self reloadDataOfSubCat:sub cat:CatID];
  //  [menuview KinarasetCategoryClicked:CatID.intValue];
    //[menuview KinarasetSubCategoryClicked:sub.intValue];
    //[menuview KinaraCategoryClicked2:CatID.intValue];
   // [menuview KinaraSubCategoryClicked2:sub.intValue];
}

-(void)reloadFonts
{
    NSMutableDictionary *fontDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:FONT_DICTIONARY];
    
    if(fontDictionary != nil) {
        
        NSMutableDictionary *itemFont = [fontDictionary objectForKey:@"Item"];
        fontName = [NSString stringWithFormat:@"%@", [itemFont objectForKey:@"font"]];
        fontSize = [[NSString stringWithFormat:@"%@", [itemFont objectForKey:@"size"]] floatValue];
        
        NSString *colors = [NSString stringWithFormat:@"%@", [itemFont objectForKey:@"color"]];
        NSArray *arr = [colors componentsSeparatedByString:@","];
        float _red   = [arr[0] floatValue];
        float _green = [arr[1] floatValue];
        float _blue  = [arr[2] floatValue];
        
        fontColor = [UIColor colorWithRed:_red/255.0 green:_green/255.0 blue:_blue/255.0 alpha:1.0];
    }
    else {
        fontName = @"Copperplate-Light";
        fontSize = 30.0;
        fontColor = [UIColor whiteColor];
    }
    
}

-(void)reloadDataOfSubCat:(NSString *)sub cat:(NSString*)CatID
{
    ////NSLOG(@"cat = %@, , , , sub_cat = %@", CatID, sub);

    tag_switch = [ShareableData dishTagStatus];
    [self reloadFonts];
    
    @try
    {
        [DishID removeAllObjects];
        [DishName removeAllObjects];
        [self.isSetType removeAllObjects];
        [DishPrice removeAllObjects];
        [DishDescription removeAllObjects];
        [DishImage removeAllObjects];
        [DishCategoryId removeAllObjects];
        [DishSubCategoryId removeAllObjects];
        [DishSubSubCategoryId removeAllObjects];
        [DishCustomization removeAllObjects];
        [custType removeAllObjects];
        [self.tagIcons removeAllObjects];
        [self.tagNames removeAllObjects];
    }
    @catch(NSException *ee)
    {
       // DLog(@"Exception : %@",ee);
    }
    @finally 
    {
        currentCatId=[[NSString alloc]initWithFormat:@"%@",CatID];
        currentSubId=[[NSString alloc]initWithFormat:@"%@",sub];
        [self postData:sub cat:CatID];
        @try
        {
            //NSLOG(@"result from post count = %d", [resultFromPost count]);
            if(resultFromPost)
            {
                for(int i=0;i<[resultFromPost count];i++)
                {
                    @autoreleasepool {
                    NSMutableDictionary *dataitem=resultFromPost[i];
                    if ([ShareableData sharedInstance].TaskType=@"2"){
                        [DishCategoryId addObject:[NSString stringWithFormat:@"%@",dataitem[@"category"]]];
                        [DishSubCategoryId addObject:[NSString stringWithFormat:@"%@",dataitem[@"sub_category"]]];
                    }else{
                        [DishCategoryId addObject:CatID];
                        [DishSubCategoryId addObject:sub];
                    }
                    [DishSubSubCategoryId addObject:[NSString stringWithFormat:@"%@",dataitem[@"sub_sub_category"]]];
                    [DishName addObject:[NSString stringWithFormat:@"%@",dataitem[@"name"]]];
                    [DishPrice addObject:[NSString stringWithFormat:@"%@",dataitem[@"price"]]];
                    [DishDescription addObject:[NSString stringWithFormat:@"%@",dataitem[@"description"]]];
                    [DishID addObject:[NSString stringWithFormat:@"%@",dataitem[@"id"]]];
                    [DishImage addObject:[UIImage imageWithContentsOfFile:dataitem[@"images"]]];
                    [DishCustomization addObject:dataitem[@"customisations"]];
                    [custType addObject:[NSString stringWithFormat:@"%@",dataitem[@"cust"]]];
                        
                    [self.tagIcons addObject:dataitem[@"tag_icons"]];
                    [self.tagNames addObject:dataitem[@"tag_names"]];
                        
                        if([CatID intValue] != 8){
                            [self.isSetType addObject:[NSString stringWithFormat:@"%@",dataitem[@"is_set"]]];
                        }
                    }
                }
                
            }
        }
        @catch(NSException *ee)
        {
            
        }
    }
    
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //DLog(@"TabMainCourseMenuListViewController ");
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)addCustomization
{
    //NSMutableArray *cust=[DishCustomization objectAtIndex:selectedItem];
    //DLog(@"%@",[DishCustomization objectAtIndex:selectedItem]);
    
    [menudetailView.menuDetailView.DishCustomization removeAllObjects];
    for(int i=0;i<[DishCustomization[selectedItem] count];++i)
    {
        [menudetailView.menuDetailView.DishCustomization addObject:DishCustomization[selectedItem][i]];
    }
    
    //DLog(@"%@",[DishCustomization objectAtIndex:selectedItem]);    
}

-(void)resetCustomization
{
    for(int i=0;i<[DishCustomization[selectedItem] count] ;++i)
    {
        NSMutableDictionary *dataitem=DishCustomization[selectedItem][i];
        NSMutableArray *Option=dataitem[@"Option"];
        for(int i=0;i<[Option count];++i)
        {
            Option[i][@"quantity"] = @"0";
        }
    }
}

-(void)addCustomizationView
{
    menuDetailViewT=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
    
    menuDetailViewT.KKselectedID  =DishID[selectedItem];
   menuDetailViewT.KKselectedName=DishName[selectedItem];
    menuDetailViewT.KKselectedRate=DishPrice[selectedItem];
    menuDetailViewT.KKselectedCatId=DishCategoryId[selectedItem];
    if ([[ShareableData sharedInstance].isQuickOrder isEqualToString:@"1"]){
        menuDetailViewT.backImage.hidden=YES;
    }else{
        menuDetailViewT.backImage.hidden=NO;
    }
    
    //[self addCustomization];    
    //DLog(@"%@",[DishCustomization objectAtIndex:selectedItem]);
    menuDetailViewT.DishCustomization=DishCustomization[selectedItem];
    menuDetailViewT.KKselectedImage=DishImage[selectedItem];
    [menuDetailViewT.customizationView reloadData];
   menuDetailViewT.requestView.text=@"";
    menuDetailViewT.swipeIndicator=@"1";
    menuDetailViewT.isView=@"main";
    menuDetailViewT.view.frame=CGRectMake(12, 0, self.view.frame.size.width-24, self.view.frame.size.height);
    [self.view addSubview:menuDetailViewT.view];
    
}

-(void)addItem
{
    [[ShareableData sharedInstance].OrderItemID addObject:DishID[selectedItem] ];
    DLog(DishID[selectedItem]);
    [[ShareableData sharedInstance].OrderItemName addObject:DishName[selectedItem]];
    DLog(DishName[selectedItem]);
    [[ShareableData sharedInstance].OrderItemRate addObject:DishPrice[selectedItem]];
    DLog(DishPrice[selectedItem]);
    [[ShareableData sharedInstance].OrderCatId addObject:DishCategoryId[selectedItem]];
    DLog(DishCategoryId[selectedItem]);
    [[ShareableData sharedInstance].IsOrderCustomization addObject:@"0"];
    [[ShareableData sharedInstance].OrderCustomizationDetail addObject:@"0"];
    [[ShareableData sharedInstance].OrderSpecialRequest addObject:@"0"];
    [[ShareableData sharedInstance].OrderItemQuantity addObject:@"1"];
    [[ShareableData sharedInstance].confirmOrder addObject:@"0"];
   // [menuview badgeRefresh];
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
        NSArray *array2 = @[[ShareableData sharedInstance].OrderId,[ShareableData sharedInstance].assignedTable1,[ShareableData sharedInstance].assignedTable2,[ShareableData sharedInstance].assignedTable3,[ShareableData sharedInstance].assignedTable4,[ShareableData sharedInstance].salesNo];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths lastObject];
        NSString *location = [libraryDirectory stringByAppendingString:@"/orderarrays.plist"];
        NSString *location2 = [libraryDirectory stringByAppendingString:@"/orderstrings.plist"];
        [array writeToFile:location atomically:YES];
        [array2 writeToFile:location2 atomically:YES];
    DLog(@"Added to Temp");
    
   // [[NSUserDefaults standardUserDefaults] synchronize];
         });
    
    TabSquareFlurryTracking *flurry = [TabSquareFlurryTracking flurryTracking];
    NSMutableArray *orders = [ShareableData sharedInstance].OrderItemName;
    NSString *item_name = [orders objectAtIndex:[orders count]-1];
    [flurry trackItem:item_name eventName:DISH_PURCHASE_EVENT category:[TabSquareCommonClass getValueInUserDefault:@"current_menu"]];
    
}

-(void)checkItemInOrderList
{
    bool itemExist=false;
    for(int i=0;i<[[ShareableData sharedInstance].OrderItemID count];++i)
    {
        if([([ShareableData sharedInstance].OrderItemID)[i] isEqualToString:DishID[selectedItem]]&&[([ShareableData sharedInstance].confirmOrder)[i]isEqualToString:@"0"])
        {
            int quantity= [([ShareableData sharedInstance].OrderItemQuantity)[i]intValue];
            float price=[([ShareableData sharedInstance].OrderItemRate)[i]floatValue]/quantity;
            quantity++;
            NSString *currentPrice=[NSString stringWithFormat:@"%.02f",price*quantity];
            NSString *currentQty=[NSString stringWithFormat:@"%d",quantity];
            ([ShareableData sharedInstance].OrderItemRate)[i] = currentPrice;
            ([ShareableData sharedInstance].OrderItemQuantity)[i] = currentQty;
           // [menuview badgeRefresh];
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
    [sender removeFromSuperview];
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
    UIImage *itemImage=DishImage[selectedItem];
    
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

-(void)orderAddAnimation
{
    CGRect frame=currentButton.frame;
     UIView *view= [currentButton superview];
    [self addImageAnimation:frame btnView:view];
}

-(IBAction)addClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    currentButton = btn;
    UIView *view= [btn superview];
    CGRect frame=btn.frame;
    int tag=btn.tag;
   // DLog(@"Tag : %d",tag);
    selectedItem=tag;
    NSString *dishCatId2 = DishCategoryId[selectedItem];

    
    BOOL bev = [dishCatId2 isEqualToString:[ShareableData sharedInstance].bevCat];
    
    if(!bev && [[isSetType objectAtIndex:selectedItem] intValue] == 1) {
        TabSquareComboSet *combo = [[TabSquareComboSet alloc] init];
        
        [combo setComboId:[[DishID objectAtIndex:selectedItem] intValue] categoryId:[DishCategoryId[selectedItem] intValue]];
        [combo setRootController:self];
        [self presentViewController:combo animated:NO completion:nil];
        return;
    }

    
    NSString *type=custType[tag];
    
    //[[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    NSString *dishSubCatId2 = DishSubCategoryId[selectedItem];
    int bevDisplay = 0;
   // TabSquareBeerController* beveragesBeerView=[[TabSquareBeerController alloc]initWithNibName:@"TabSquareBeerController" bundle:nil];
    if(![dishCatId2 isEqualToString:[ShareableData sharedInstance].bevCat]){
        NSMutableArray *subCategoryData=[[TabSquareDBFile sharedDatabase]getSubCategoryData:[ShareableData sharedInstance].bevCat];
        for(int i=0;i<[subCategoryData count];++i){
            NSMutableDictionary *subCategory=subCategoryData[i];
            NSString *subId=subCategory[@"id"];
            NSString *displayId=subCategory[@"display"];
            if ([subId isEqualToString:dishSubCatId2]&&[displayId isEqualToString:@"1"]){
                bevDisplay = 1;
                [beveragesBeerView reloadDataOfSubCat2:resultFromPost];
                [beveragesBeerView.beverageView reloadData];
            }
        }
        
       // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    }
    if (bevDisplay == 1){
        // NSMutableArray *beverageCustomization;
        // NSMutableArray *beverageSkuDetail;
        // NSMutableArray *beverageCustType;
      //  beerDetailView.beverageView = beveragesBeerView;
        //int currentindex=[[DishID objectAtIndex:selectedItem] intValue];
        @autoreleasepool {
         
        beerDetailView.selectedIndex=[NSString stringWithFormat:@"%d",selectedItem];
       // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
        beerDetailView.beverageSKUDetail=[[TabSquareDBFile sharedDatabase]getBeverageSkuDetail:DishID[selectedItem]];
       // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
        beerDetailView.beverageCatId=[NSString stringWithFormat:@"%d",8];
        beerDetailView.beverageCustomization=DishCustomization;
        beerDetailView.beverageCutType=custType;
        [beerDetailView.beverageSkUView reloadData];
        [beerDetailView loadBeverageData:selectedItem];
        [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
        [self.view addSubview:beerDetailView.view];
        [self.view bringSubviewToFront:beerDetailView.view];
        }
    }else{

    if([type isEqualToString:@"0"])
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

-(IBAction)infoClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    if([[ShareableData sharedInstance].IsViewPage count]==0)
    {
        [[ShareableData sharedInstance].IsViewPage addObject:@"main_info"];
    }
    else
    {
        ([ShareableData sharedInstance].IsViewPage)[0] = @"main_info";
    }
    int tag=btn.tag;
    selectedItem=tag;
    [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
    [self createMenuDetail];
    [self InfoClicked];
}

-(int)getDishIndex:(NSString*)subcatId rowIndex:(NSInteger)index
{
    int i=0;
    for(int j=0;j<[DishSubSubCategoryId count];++j)
    {
        if([DishSubSubCategoryId[j] isEqualToString:subcatId])
        {
            if(index==i)
            {
                return j;
            }
            i++;
        }
    }
    return i;
}

-(int)getTotalSubDishes:(NSString*)subsubId
{
    int totalDishes = 0;
    for(int j=0;j<[DishSubSubCategoryId count];++j)
    {
        if([DishSubSubCategoryId[j] isEqualToString:subsubId])
        {
            totalDishes++;
        }
    }
    return totalDishes;
}

-(void)getSectionDishData
{
    [SectionDishData removeAllObjects];
    [SubSectionIdData removeAllObjects];
    [SubSectionNameData removeAllObjects];
    totalSubSection=0;
    int total;
   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    NSMutableArray*  SubSectionData=[[TabSquareDBFile sharedDatabase]getSubSubCategoryData:currentCatId subCatId:currentSubId];
   // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    
    // DLog(@"%@",DishSubSubCategoryId);
    for(int i=0;i<[SubSectionData count];++i)
    {
        total=i;
        int count=0;
        NSMutableDictionary *dataitem=SubSectionData[i];
        NSString *subsubId=dataitem[@"id"];
        NSString *subsubName=dataitem[@"name"];
    
        for(int j=0;j<[DishSubSubCategoryId count];++j)
        {
            
            if([DishSubSubCategoryId[j] isEqualToString:subsubId])
            {
                count=1;
                if(total==i)
                {
                    totalSubSection++;
                    [SubSectionIdData addObject:subsubId];
                    [SubSectionNameData addObject:subsubName];
                    total=[SubSectionData count];
                }
                [SectionDishData addObject:[NSString stringWithFormat:@"%d",j]];    
                //break;
            }
            
        }
               
    }
}

#pragma mark Table view methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self getSectionDishData];
    if(totalSubSection!=0)
    {
        return totalSubSection;
    }
    else 
    {
        return 1;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(8.0, 5.0,tableView.bounds.size.width, 30)];
        //[customView setBackgroundColor:[UIColor greenColor]];
    
    	//UIColor *backgroundImg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"headerBG.png"]];
    
        //customView.backgroundColor=backgroundImg;
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        headerLabel.textColor = [UIColor whiteColor];//[UIColor blackColor];
   // headerLabel.textColor=[UIColor blackColor];
        headerLabel.font =[UIFont fontWithName:@"Copperplate-Light" size:40];
        //headerLabel.frame = CGRectMake(7,-4,tableView.bounds.size.width, 30.0);
        [headerLabel setFrame:CGRectMake(0.0, 5.0,tableView.bounds.size.width, 28)];
        [headerLabel setTextAlignment:NSTextAlignmentCenter];

        NSString* headertxt=@"";
        if(totalSubSection!=0)
        {
            headertxt=SubSectionNameData[section];
            if([headertxt isEqual:[NSNull null]])
            {
                headertxt=@"";
            }
            
        }
    
        headerLabel.text=headertxt;
        [customView addSubview:headerLabel];
        return customView;
  }
-(UIImageView*)setImageInFrame:(CGRect)frame1 :(UIImage*)gg;
{
    CGSize kMaxImageViewSize = {.width = 129, .height = 82};
    UIImage *image=gg;
    UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
    imageView.frame=frame1;
    CGSize imageSize = image.size;
    CGFloat aspectRatio = imageSize.width / imageSize.height;
    CGRect frame = imageView.frame;
    int originalWidth = frame.size.width;
    if (!(aspectRatio >= 0)){
        aspectRatio = 1;
    }
    if (kMaxImageViewSize.width / aspectRatio <= kMaxImageViewSize.height)
    {
        frame.size.width = kMaxImageViewSize.width;
        frame.size.height = frame.size.width / aspectRatio;
    }
    else
    {
        frame.size.height = kMaxImageViewSize.height;
        frame.size.width = frame.size.height * aspectRatio;
    }
    
    int spareWidth = originalWidth - frame.size.width;
    int spaceBuffer = spareWidth/2;
    
    frame.origin.x +=spaceBuffer;
    
    imageView.frame = frame;
    return imageView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([SubSectionIdData count]!=0)
    {
       return [self getTotalSubDishes:SubSectionIdData[section]];
    }
    //NSLOG(@"dish images count = %d, tag count = %d", [DishImage count], [self.tagIcons count]);
     
    return [DishID count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *CellIdentifier = [NSString stringWithFormat:@"DishItem%@",DishID ];
    DishItem *cell = (DishItem *)[self.DishList dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell==nil)
    {
        [[NSBundle mainBundle]loadNibNamed:@"DishItemCell" owner:self options:nil];
        cell=self.tmpCell;
        self.tmpCell=nil;
    
    
    UIImageView *bg_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 741.0, 110.0)];
    
    NSString *img_name = [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, SUBCATEGORY_IMAGE, [ShareableData appKey]];
    UIImage *img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    if(img == nil)
      //  img = [UIImage imageNamed:@"cell_slide.png"];
        img =[UIImage imageWithContentsOfFile:@"cell_slide.png"];
    [bg_view setImage:img];
    [cell.contentView addSubview:bg_view];
    [cell.contentView sendSubviewToBack:bg_view];

    
    if([DishID count]>indexPath.row)
    {
        int sortIndex;
        if([SubSectionIdData count]>indexPath.section)
        {
            sortIndex =[self getDishIndex:SubSectionIdData[indexPath.section] rowIndex:indexPath.row];  
        }
        else 
        {
            sortIndex=indexPath.row;
        }     
        //NSData *img_data = (NSData *)[DishImage objectAtIndex:sortIndex];
        
        UIImage *img = (UIImage *)[DishImage objectAtIndex:sortIndex];
        
        int cat = ((NSString*)DishCategoryId[sortIndex]).intValue;

        int x_axis = 16.0;
        
        if(tag_switch && cat != 8)
            x_axis = 38.0;
        
        UIButton *img_btn = [[UIButton alloc] initWithFrame:CGRectMake(x_axis, 15, 129, 98)];
        if (cat ==8){
            img_btn.frame= [ self setImageInFrame:img_btn.frame :img ].frame;
        }
        
        float new_y = (bg_view.frame.size.height - img_btn.frame.size.height)/2;
        img_btn.frame = CGRectMake(img_btn.frame.origin.x, new_y, img_btn.frame.size.width, img_btn.frame.size.height);
        
        /*=============Add Dish tag icons if dish tag is on==============*/
        if(tag_switch) {
            CGRect tag_frm = CGRectMake(5, 7, 27, 28);
            float gap = 1.0;
            NSMutableArray *arr = (NSMutableArray *)[self.tagIcons objectAtIndex:sortIndex];
            NSMutableArray *name_arr = (NSMutableArray *)[self.tagNames objectAtIndex:sortIndex];
            
            for(int i = 0; i < [arr count]; i++) {
                
                float _y = (i*gap) + (i * tag_frm.size.height) + tag_frm.origin.y;
                
                CGRect frm = CGRectMake(tag_frm.origin.x, _y, tag_frm.size.width , tag_frm.size.height);
                
                UIButton *tag1 = [[UIButton alloc] initWithFrame:frm];
                NSString *img_name = [NSString stringWithFormat:@"%@", [arr objectAtIndex:i]];
                [tag1 setBackgroundImage:[[TabSquareDBFile sharedDatabase]getImage:img_name] forState:UIControlStateNormal];
                [tag1 setTitle:[name_arr objectAtIndex:i] forState:UIControlStateReserved];
                [tag1 setContentMode:UIViewContentModeScaleAspectFit];
                [tag1 addTarget:self action:@selector(tagPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:tag1];
                
            }
        }
        /*
        else {
            [img_btn setFrame:CGRectMake(16, img_btn.frame.origin.y, img_btn.frame.size.width, img_btn.frame.size.height)];

        }
         */
        /*===============================================================*/
        
        [img_btn setBackgroundImage:img forState:UIControlStateNormal];
        [img_btn setTag:sortIndex];
        [img_btn addTarget:self action:@selector(infoClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [img_btn.layer setShadowOpacity:1.0];
//        [img_btn.layer setMasksToBounds:NO];
//        [img_btn.layer setShadowOffset:CGSizeMake(4.0, 2.0)];
        [cell.contentView addSubview:img_btn];
        
        //MSLabel *titleLabel = [[MSLabel alloc] initWithFrame:CGRectMake(14, 47, 463, 45)];
        MSLabel *titleLabel = [[MSLabel alloc] initWithFrame:CGRectMake(180, 47, 459, 45)];
        titleLabel.lineHeight = 20;
        //titleLabel.anchorBottom = YES;
        titleLabel.numberOfLines = 2;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.text = DishDescription[sortIndex]; 
        titleLabel.font=[UIFont fontWithName:@"Century Gothic" size:18];
        [titleLabel setTextColor:fontColor];
        [cell.contentView addSubview:titleLabel];   
        cell.DishName=DishName[sortIndex];
        cell.Discription=DishDescription[sortIndex];
        
        cell.Price=[NSString stringWithFormat:@"$%@",DishPrice[sortIndex]];
        
        
        if([ShareableData sharedInstance].ViewMode==1)
        {
            cell.btnTag=@"-1"; 
        }
        else
        {
            cell.btnTag=[NSString stringWithFormat:@"%d",sortIndex];
        }
        cell.btnTagInfo=[NSString stringWithFormat:@"%d",sortIndex];
    }
    }
    [cell setNeedsDisplay];

    return cell;
}


-(IBAction)tagPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *text = [btn titleForState:UIControlStateReserved];
    CGRect frm = btn.frame;
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(frm.origin.x-3, frm.origin.y-1, 600.0, frm.size.height+2)];
    [lbl setText:text];
    [lbl sizeToFit];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:[UIColor whiteColor]];

    [lbl setFrame:CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y, lbl.frame.size.width, frm.size.height+2)];
    
    UIView *base = [[UIView alloc] initWithFrame:CGRectMake(lbl.frame.origin.x+5, lbl.frame.origin.y, lbl.frame.size.width+frm.size.width+3, lbl.frame.size.height)];
    [base setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0]];
    [lbl setFrame:CGRectMake(frm.size.width+1, 0.0, lbl.frame.size.width+2, lbl.frame.size.height)];
    [base addSubview:lbl];
    
    [base.layer setBorderColor:[UIColor blackColor].CGColor];
    [base.layer setCornerRadius:4.0];
    [base.layer setBorderWidth:0.7];
    //[base setAlpha:0.85];
    [base setAlpha:0.0];
    [btn.superview addSubview:base];
    [btn.superview bringSubviewToFront:btn];
    
    [self flipViewSpinAndScale:btn baseView:base];
}

- (void)flipViewSpinAndScale:(UIView *)view baseView:(UIView *)base_view
{
    
    /*======================================*/
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration = 0.75;
    fadeInAnimation.autoreverses = NO;
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:0.4];
    [view.layer addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    /*======================================*/

    [CATransaction begin];
    
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	anim.duration = 0.50;
	anim.repeatCount = 1;
	anim.autoreverses = YES;
	anim.removedOnCompletion = YES;
	anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4, 1.4, 1.5)];
	[view.layer addAnimation:anim forKey:nil];
    
    
    [CATransaction setCompletionBlock:^{
        
        CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeInAnimation.duration =2.5;
        fadeInAnimation.autoreverses = NO;
        fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.55];
        fadeInAnimation.toValue = [NSNumber numberWithFloat:0.85];
        [base_view.layer addAnimation:fadeInAnimation forKey:@"animateOpacity"];
        
        /*======================================*/
        CABasicAnimation *fadeInAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeInAnimation1.duration = 0.75;
        fadeInAnimation1.autoreverses = NO;
        fadeInAnimation1.fromValue = [NSNumber numberWithFloat:0.4];
        fadeInAnimation1.toValue = [NSNumber numberWithFloat:0.85];
        [view.layer addAnimation:fadeInAnimation1 forKey:@"animateOpacity"];
        /*======================================*/

        [self performSelector:@selector(removePopup:) withObject:base_view afterDelay:2.6];
    }];
    [CATransaction commit];

}

-(void)removePopup:(UIView *)popup_view
{
    [popup_view removeFromSuperview];
}

-(void)showIndicator
{
    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)];
	progressHud= [[MBProgressHUD alloc] initWithView:progressView];
	[self.view addSubview:progressHud];
	[self.view bringSubviewToFront:progressHud];
	progressHud.delegate = self;
	[progressHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (void)InfoClicked
{
    /*============================*/
    /*
    //NSLOG(@"Dish Id =%@", DishID);
    //NSLOG(@"selected item = %d",selectedItem);
    NSMutableArray *combo_data = [[TabSquareDBFile sharedDatabase] getCombodata:DishCategoryId[selectedItem]];
    */
    
    //[[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    NSString *dishCatId2 = DishCategoryId[selectedItem];
    NSString *dishSubCatId2 = DishSubCategoryId[selectedItem];
    int bevDisplay = 0;

    BOOL bev = [dishCatId2 isEqualToString:[ShareableData sharedInstance].bevCat];
    if(!bev && [[isSetType objectAtIndex:selectedItem] intValue] == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:isSetType forKey:@"set_array"];
        [TabSquareCommonClass setValueInUserDefault:@"is_set_type" value:@"1"];
        
        [TabSquareCommonClass setValueInUserDefault:@"set_id" value:[DishID objectAtIndex:selectedItem]];
        [TabSquareCommonClass setValueInUserDefault:@"set_cat_id" value:dishCatId2];
    }
    else
        [TabSquareCommonClass setValueInUserDefault:@"is_set_type" value:@"0"];

    /*============================*/
    
   // TabSquareBeerController* beveragesBeerView=[[TabSquareBeerController alloc]initWithNibName:@"TabSquareBeerController" bundle:nil];
    if(![dishCatId2 isEqualToString:[ShareableData sharedInstance].bevCat]){
        @autoreleasepool {
        
        NSMutableArray *subCategoryData=[[TabSquareDBFile sharedDatabase]getSubCategoryData:[ShareableData sharedInstance].bevCat];
        for(int i=0;i<[subCategoryData count];++i){
            NSMutableDictionary *subCategory=subCategoryData[i];
            NSString *subId=subCategory[@"id"];
            NSString *displayId=subCategory[@"display"];
            
            if ([subId isEqualToString:dishSubCatId2]&&[displayId isEqualToString:@"1"]){
                bevDisplay = 1;
                [beveragesBeerView reloadDataOfSubCat:dishSubCatId2 cat:dishCatId2];
                [beveragesBeerView.beverageView reloadData];
            }
        }
    }
        
      // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    }
    if (bevDisplay == 1){
       // NSMutableArray *beverageCustomization;
       // NSMutableArray *beverageSkuDetail;
      // NSMutableArray *beverageCustType;
        @autoreleasepool {
            
        
        beerDetailView.leftArrow.hidden=YES;
        beerDetailView.rightArrow.hidden=YES;
      //  beerDetailView.beverageView = beveragesBeerView;
    //int currentindex=[[DishID objectAtIndex:selectedItem] intValue];
        beerDetailView.selectedIndex=[NSString stringWithFormat:@"%d",selectedItem];
   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    beerDetailView.beverageSKUDetail=[[TabSquareDBFile sharedDatabase]getBeverageSkuDetail:DishID[selectedItem]];
   // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    beerDetailView.beverageCatId=[NSString stringWithFormat:@"%d",8];
    beerDetailView.beverageCustomization=DishCustomization;
    beerDetailView.beverageCutType=custType;
    [beerDetailView.beverageSkUView reloadData];
    [beerDetailView loadBeverageData:selectedItem];
    [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
    [TabSquareCommonClass setValueInUserDefault:@"is_set_type" value:@"0"];
    [self.view addSubview:beerDetailView.view];
    [self.view bringSubviewToFront:beerDetailView.view];
        }
    }else{
        beerDetailView.leftArrow.hidden=NO;
        beerDetailView.rightArrow.hidden=NO;
        
        if(DishID)
        {
            menudetailView.selectedID=[NSString stringWithFormat:@"%d",selectedItem];
            menudetailView.DishID=DishID;
            menudetailView.DishImage=DishImage;
            menudetailView.DishName=DishName;
            menudetailView.DishPrice=DishPrice;
            menudetailView.DishDescription=DishDescription;
            menudetailView.DishCatId=DishCategoryId;
            menudetailView.KDishCatId=DishCategoryId[selectedItem];;
            menudetailView.DishSubId=DishSubCategoryId;
            menudetailView.DishCustomization=DishCustomization;
            menudetailView.custType=custType;
            menudetailView.Viewtype=@"1";
//            if([ShareableData sharedInstance].ViewMode==1){
//                menudetailView.Viewtype=@"1";
//
//            }
//            else{
//                menudetailView.Viewtype=@"2";
//
//            }

            menudetailView.KDishImage.image=DishImage[selectedItem];
            menudetailView.view.frame=CGRectMake(5, 0, menudetailView.view.frame.size.width, menudetailView.view.frame.size.height);
            [self.view addSubview:menudetailView.view];
            [self.view bringSubviewToFront:menudetailView.view];
            [menudetailView showDetailView:selectedItem];
            
            //////// to hide the all other buttons and scroll background from the parent view //////
            menudetailView.mParent=self;
            menuview.subCatbg.hidden=TRUE;
            menuview.subcatScroller.hidden=TRUE;
            menuview.OrderSummaryButton.userInteractionEnabled=FALSE;
            menuview.search.userInteractionEnabled=FALSE;
            menuview.favourite.userInteractionEnabled=FALSE;
            menuview.help.userInteractionEnabled=FALSE;
            menuview.overviewMenuButton.userInteractionEnabled=FALSE;
            menuview.KinaraLogo.userInteractionEnabled=FALSE;
     
        }
    }
}

-(void)unhideTheScrollerAndSubCatBgOnMenuController{
    
    menuview.subCatbg.hidden=FALSE;
    menuview.subcatScroller.hidden=FALSE;
    menuview.OrderSummaryButton.userInteractionEnabled=TRUE;
    menuview.search.userInteractionEnabled=TRUE;
    menuview.favourite.userInteractionEnabled=TRUE;
    menuview.help.userInteractionEnabled=TRUE;
    menuview.overviewMenuButton.userInteractionEnabled=TRUE;
    menuview.KinaraLogo.userInteractionEnabled=TRUE;
    
}

@end
