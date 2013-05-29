
#import "TabMainDetailView.h"
#import "ShareableData.h"
#import "TabSquareOrderSummaryController.h"
#import "TabSquareMenuDetailController.h"
#import "TabMainMenuDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TabSquareFlurryTracking.h"
#import "TabSquareCommonClass.h"
#import "TabSquareComboSet.h"
#import "TabSquareDBFile.h"

@interface TabMainDetailView ()

@end

@implementation TabMainDetailView

@synthesize pageIndex;
@synthesize menuDetailView,KDishName,KDishRate,KDishImage,KDishDescription,selectedID,DishID,DishDescription,DishImage,DishName,DishPrice;
@synthesize addButton,leftButton,rightButton;
@synthesize DishCatId,DishSubId,descriptionScroll,DishCustomization,custType,IshideAddButton;
@synthesize KDishCust,KDishCustType,Viewtype,KDishCatId,kDishId,orderSummaryView;
@synthesize menuBaseView,currIndex, popupBackground;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    
   // NSString *img_name = [NSString stringWithFormat:@"%@%@", PRE_NAME, POPUP_IMAGE];
     NSString *img_name = [NSString stringWithFormat:@"%@%@_%@", PRE_NAME, POPUP_IMAGE,[ShareableData appKey]];
    UIImage *img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    if(img != nil)
        [self.popupBackground setImage:img];

    
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
    // DLog(@"TabMainMenuDetailViewController");
    //[self createMenuDetailView];
    nextOrPrev=0;
   tt=[NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(onTick:)
                                   userInfo:nil
                                    repeats:YES];
    
    /*
    [self.view.layer setBorderColor:[UIColor colorWithRed:20.0f/255.0f green:208.0f/255.0f blue:156.0f/255.0f alpha:0.8].CGColor];
    [self.view.layer setShadowOpacity:0.85];
    [self.view.layer setShadowOffset:CGSizeMake(4.0, 2.5)];
    self.view.layer.borderWidth=15.5;
    */
    
   // [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [tt invalidate];
    tt = nil;
}

-(void)onTick:(NSTimer *)timer 
{
    if([ShareableData sharedInstance].ViewMode==1)
    {
        addButton.hidden=YES;
    }
    else
    {
        addButton.hidden=NO;
    }
}

-(void)hideButtons
{
    // addButton.hidden=YES;
    leftButton.hidden=YES;
    rightButton.hidden=YES;
}

-(void)showButtons
{
    addButton.hidden=NO;
    leftButton.hidden=NO;
    rightButton.hidden=NO;
}



-(void)loadDataInView:(int)selectedItem
{
    //NSLog(@"Selected index = %d", selectedItem);
    
    NSString *currrent_id = nil;
    currrent_id = DishID[selectedItem];
    NSLog(@"set 2 dish id = %@", currrent_id);
    
    [TabSquareCommonClass setValueInUserDefault:@"set_id" value:currrent_id];

    TabSquareFlurryTracking *flurry = [TabSquareFlurryTracking flurryTracking];
    [flurry trackItem:DishName[selectedItem] eventName:DISH_OPEN_EVENT category:[TabSquareCommonClass getValueInUserDefault:@"current_menu"]];
    
    [self showButtons];
    currentindex=selectedItem;
    currIndex = [NSString stringWithFormat:@"%d", currentindex];
    selectedID=[[NSString alloc]initWithFormat:@"%d",selectedItem];
    KDishName.font=[UIFont fontWithName:@"Copperplate-Light" size:23];
    KDishName.text=DishName[selectedItem];
    KDishImage.image=DishImage[selectedItem];
    [KDishImage.layer setShadowOpacity:1.0];
    [KDishImage.layer setShadowOffset:CGSizeMake(2.5, 1.5)];
    CGSize newsize=  [DishName[selectedItem] sizeWithFont:KDishName.font constrainedToSize:CGSizeMake(241, 400) lineBreakMode:KDishName.lineBreakMode];
    KDishName.frame=CGRectMake(KDishName.frame.origin.x, KDishName.frame.origin.y, newsize.width+5, newsize.height);
    KDishName.numberOfLines = 3;
    KDishRate.text=[NSString stringWithFormat:@"$%@",DishPrice[selectedItem]];
    KDishRate.font=[UIFont fontWithName:@"Copperplate-Light" size:20];
    KDishDescription.text=DishDescription[selectedItem];
    KDishDescription.frame =CGRectMake(0, 0, 481, 120);
    [KDishDescription sizeToFit];
    descriptionScroll.contentSize=CGSizeMake(descriptionScroll.contentSize.width, KDishDescription.frame.size.height);
    KDishDescription.font=[UIFont fontWithName:@"Copperplate-Light" size:19];
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
    
    menuDetailView.KKselectedImage=self.KDishImage.image;
    [menuDetailView.customizationView reloadData];
    menuDetailView.view.frame=CGRectMake(1, 0, menuDetailView.view.frame.size.width, menuDetailView.view.frame.size.height);
   
    [menuBaseView.view addSubview:menuDetailView.view];
    menuDetailView.requestView.text=@"";
    menuDetailView.swipeIndicator=@"0";
    menuDetailView.isView=@"maininfo";
    [menuBaseView.view bringSubviewToFront:menuDetailView.view];
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
    
    TabSquareFlurryTracking *flurry = [TabSquareFlurryTracking flurryTracking];
    NSMutableArray *orders = [ShareableData sharedInstance].OrderItemName;
    NSString *item_name = [orders objectAtIndex:[orders count]-1];
    [flurry trackItem:item_name eventName:DISH_PURCHASE_EVENT category:[TabSquareCommonClass getValueInUserDefault:@"current_menu"]];
    
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
    //  viewOrigin.y = 77 + imgView.size.height / 2.0f;
    // viewOrigin.x = 578 + imgView.size.width / 2.0f;
    
    imgView.frame = imageFrame;
    UIImage *itemImage;
    
    itemImage=self.KDishImage.image;
    
    [imgView setImage:itemImage];
    [menuBaseView.view addSubview:imgView];
    [menuBaseView.view bringSubviewToFront:imgView];
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


-(IBAction)closeClicked:(id)sender
{
    TabSquareFlurryTracking *flurry = [TabSquareFlurryTracking flurryTracking];
    [flurry endTrackingEvent];
    
    [menuBaseView closeClicked:0];
}

-(void)orderAddAnimation
{
    CGRect frame=currentButton.frame;
    UIView *view= [currentButton superview];
    [self addImageAnimation:frame btnView:view];
}

-(IBAction)addClicked:(id)sender
{
    NSMutableArray *setArray= [[NSUserDefaults standardUserDefaults] objectForKey:@"set_array"];
    if([setArray[currentindex] isEqualToString:@"1"]) {
        TabSquareComboSet *combo = [[TabSquareComboSet alloc] init];
        NSString *set_id = [TabSquareCommonClass getValueInUserDefault:@"set_id"];
        NSString *set_cat_id = [TabSquareCommonClass getValueInUserDefault:@"set_cat_id"];
        
        [combo setComboId:[set_id intValue] categoryId:[set_cat_id intValue]];
        
        [combo setDetailRootController:self];
        [self presentViewController:combo animated:NO completion:nil];
    }
    
    UIButton *btn = (UIButton*)sender;
    currentButton = btn;
    UIView *view  = [btn superview];
    CGRect frame  = btn.frame;
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
        [self addImageAnimation:frame btnView:view];
    }
    
}




-(IBAction)nextClicked:(id)sender
{
    
    int index=currentindex;
    index++;
    if(index==[DishID count])
    {
       // [menuBaseView moveNextSubCat];
       // [menuBaseView ]
        index=[DishID count]-1;
    }
    else
    {
        [self loadDataInView:index];
    }
    
    //NSLog(@"Selected index> = %d", index);
}

-(IBAction)prevClicked:(id)sender
{
    int index=currentindex;
    if(index==0)
    {
       // [menuBaseView movePrevSubCat];
       // index=[DishID count]-1;
    }else{
        index--;
        [self loadDataInView:index];
    }
   // else
   // {
        
   // }
    
}


-(void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

//[UIColor colorWithRed:220.0f/255.0f green:208.0f/255.0f blue:156.0f/255.0f alpha:0.8].CGColor;
//backtrans.png
//descriptionScroll
