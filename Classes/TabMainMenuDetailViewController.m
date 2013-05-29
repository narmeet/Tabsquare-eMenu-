
#import "TabMainMenuDetailViewController.h"
#import "TabSquareMenuDetailController.h"
#import "SBJSON.h"
#import "ShareableData.h"
#import <QuartzCore/QuartzCore.h>
#import "TabSquareOrderSummaryController.h"
#import "TabMainDetailView.h"
#import "TabSquareDBFile.h"
#import "TabSquareMenuController.h"
#import "TabMainCourseMenuListViewController.h"


@implementation TabMainMenuDetailViewController

@synthesize menuDetailView,KDishName,KDishRate,KDishImage,KDishDescription,selectedID,DishID,DishSubId,DishDescription,DishImage,DishName,DishPrice;
@synthesize addButton,leftButton,rightButton;
@synthesize DishCatId,descriptionScroll,DishCustomization,custType,IshideAddButton;
@synthesize KDishCust,KDishCustType,Viewtype,KDishCatId,kDishId,orderSummaryView;
@synthesize detailView,swipeDetailView;
@synthesize detailView1,detailView2,dd, popupBackground;
@synthesize orderScreenFlag;

float lastContentOffset;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void)createMenuDetailView
{
    
    self.menuDetailView=[[TabSquareMenuDetailController alloc]initWithNibName:@"TabSquareMenuDetailController" bundle:nil];
}

-(void)createDetailview
{
    detailView1=[[TabMainDetailView alloc]initWithNibName:@"TabMainDetailView" bundle:nil];
    detailView1.menuBaseView=self;
    detailView2=[[TabMainDetailView alloc]initWithNibName:@"TabMainDetailView" bundle:nil];
    detailView2.menuBaseView=self;
    currentdetailView=detailView1;
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    /* menuDetailView = nil;
    detailView = nil;
    detailView1 = nil;
    detailView2 = nil;
    currentdetailView = nil;
    DishName=nil;
    DishPrice=nil;
    DishDescription=nil;
    DishID=nil;
    DishImage=nil;
    DishCustomization=nil;
    DishCatId=nil;
    DishSubId=nil;
    custType=nil;
    KDishCust=nil;
    
    swipeDetailView=nil;
    orderSummaryView=nil;
    menuDetailView=nil;
    dd=nil;
   IshideAddButton=nil;
   Viewtype=nil;
    KDishName=nil;
    KDishCustType=nil;
   kDishId=nil;
   KDishDescription=nil;
   KDishRate=nil;
    KDishImage=nil;
    KDishCatId=nil;
    selectedID=nil;
    addButton=nil;
    leftButton=nil;
    rightButton=nil;
    descriptionScroll=nil;*/
  
}

-(void)allocateArray
{
    
    self.DishName=[[NSMutableArray alloc]init];
    self.DishPrice=[[NSMutableArray alloc]init];
    self.DishDescription=[[NSMutableArray alloc]init];
    self.DishID=[[NSMutableArray alloc]init];
    self.DishImage=[[NSMutableArray alloc]init];
    self.DishCustomization=[[NSMutableArray alloc]init];
    self.DishCatId=[[NSMutableArray alloc]init];
    self.DishSubId=[[NSMutableArray alloc]init];
    self.custType=[[NSMutableArray alloc]init];
    self.KDishCust=[[NSMutableArray alloc]init];
    
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

 //   NSString *img_name = [NSString stringWithFormat:@"%@%@", PRE_NAME, POPUP_IMAGE];
     NSString *img_name = [NSString stringWithFormat:@"%@%@_%@", PRE_NAME, POPUP_IMAGE,[ShareableData appKey]];
    UIImage *img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    if(img != nil)
        [self.popupBackground setImage:img];

    @autoreleasepool {
    
    [self.swipeDetailView.layer setMasksToBounds:YES];
    self.swipeDetailView.layer.borderWidth=2.5;
    self.swipeDetailView.layer.borderColor=[UIColor colorWithRed:220.0f/255.0f green:208.0f/255.0f blue:156.0f/255.0f alpha:0.8].CGColor;
    [self.swipeDetailView.layer setShadowOpacity:1.0];
    [self.swipeDetailView.layer setShadowOffset:CGSizeMake(4.0, 2.5)];
    
    shadow = [[UIView alloc] initWithFrame:self.swipeDetailView.frame];
    [shadow setBackgroundColor:[UIColor clearColor]];
    //[self.swipeDetailView.superview addSubview:shadow];
    [shadow.layer setMasksToBounds:NO];
    [shadow.layer setShadowOpacity:1.0];
    [shadow.layer setShadowOffset:CGSizeMake(4.0, 2.5)];
    [self.swipeDetailView.superview insertSubview:shadow belowSubview:self.swipeDetailView];
    //[shadow setCenter:CGPointMake(200, 100)];
        
    [self allocateArray];

    // DLog(@"TabMainMenuDetailViewController");
    //[self createMenuDetailView];
    nextOrPrev=0;
    tt = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(onTick:)
                                   userInfo:nil
                                    repeats:YES];
    [self createDetailview];
    if ([[ShareableData sharedInstance].isQuickOrder isEqualToString:@"1"]){
        bggg.hidden = YES;
    }else{
        bggg.hidden = NO;
    }
    }
    
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

- (void)viewDidUnload
{
    [super viewDidUnload];
   // DLog(@"TabMainMenuDetailViewController view did unload ");
}


-(void)applyNewIndex:(NSInteger)newIndex pageController:(TabMainDetailView*)pageController
{
    NSInteger pageCount=[self.DishID count];
   	BOOL outOfBounds = newIndex >= pageCount || newIndex < 0;
    
	if (!outOfBounds)
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = 0;
		pageFrame.origin.x = swipeDetailView.frame.size.width * newIndex;
		pageController.view.frame = pageFrame;
	}
	else
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = swipeDetailView.frame.size.height;
		pageController.view.frame = pageFrame;
	}
    
    pageController.pageIndex=newIndex;
    
}


-(void)setpageIndex:(NSInteger)lowerNumber UperNum:(NSInteger)upperNumber
{
    if (lowerNumber == detailView1.pageIndex) 
	{
		if (upperNumber != detailView2.pageIndex)
		{
			[self applyNewIndex:upperNumber pageController:detailView2];
		}
	}
	else if (upperNumber == detailView1.pageIndex)
	{
		if (lowerNumber != detailView2.pageIndex)
		{
			[self applyNewIndex:lowerNumber pageController:detailView2];
		}
	}
	else
	{
		if (lowerNumber == detailView2.pageIndex)
		{
			[self applyNewIndex:upperNumber pageController:detailView1];
		}
		else if (upperNumber == detailView2.pageIndex)
		{
			[self applyNewIndex:lowerNumber pageController:detailView1];
		}
		else
		{
			[self applyNewIndex:lowerNumber pageController:detailView1];
			[self applyNewIndex:upperNumber pageController:detailView2];
		}
	}
}

-(void)setSwipeView
{
    int pageCount;
    pageCount=[self.DishID count];
    swipeDetailView.pagingEnabled=true;
    swipeDetailView.scrollEnabled=YES;
    swipeDetailView.contentSize =
    CGSizeMake(
               swipeDetailView.frame.size.width *pageCount,
               swipeDetailView.frame.size.height);
	swipeDetailView.contentOffset = CGPointMake(0, 0); 
    swipeDetailView.showsHorizontalScrollIndicator=NO;
    swipeDetailView.userInteractionEnabled=YES;
}

-(NSString*)getNextCategoryId:(NSString*)CatId
{
    for(int i=0;i<[[ShareableData sharedInstance].categoryIdList count];++i)
    {
        NSString *catid=([ShareableData sharedInstance].categoryIdList)[i];
        if([catid isEqualToString:CatId])
        {
            if(i==[[ShareableData sharedInstance].categoryIdList count]-1)
            {
                i=0;
            }
            else 
            {
                i++;
            }
            return ([ShareableData sharedInstance].categoryIdList)[i];
        }
        
    }
    return CatId;
}

-(NSString*)getSubCategoryId:(NSString*)subcatId CatId:(NSString*)catId
{
    NSString *subId=@"";
    NSMutableArray *subIdList=[[TabSquareDBFile sharedDatabase]getSubCategoryData:currentCatId];
    if([subIdList count]!=0)
    {
        for(int i=0;i<[subIdList count];++i)
        {
            NSMutableDictionary *dataitem=subIdList[i];
            subId=dataitem[@"id"];
            if([subcatId isEqualToString:subId])
            {
                if(currentMove==1)
                {
                    if(i==[subIdList count]-1)
                    {
                        i=0;
                    }
                    else 
                    {
                        i++;
                    }
                }
                else if (currentMove==0)
                {
                    if(i==0)
                    {
                        i=[subIdList count]-1;
                    }
                    else 
                    {
                        i--;
                    }

                }
                NSMutableDictionary *dataitem=subIdList[i];
                subId=dataitem[@"id"];
                return subId;
            }
            
        }
        
    }
    else 
    {
        subId=@"<null>";
    }
    return subId;
}



-(void)reloadDataOfNextCat:(NSString*)CatID subCatId:(NSString*)subId
{
    @try
    {
        [DishID removeAllObjects];
        [DishName removeAllObjects];
        [DishPrice removeAllObjects];
        [DishDescription removeAllObjects];
        [DishImage removeAllObjects];
        [DishCatId removeAllObjects];
        [DishSubId removeAllObjects];
        [DishCustomization removeAllObjects];
        [custType removeAllObjects];
    }
    @catch(NSException *ee)
    {
        // DLog(@"Exception : %@",ee);
    }
    @finally 
    {
        //NSString *NextCatId=[self getNextCategoryId:CatID];
     //   [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
        NSString *subcategoryId=[self getSubCategoryId:subId CatId:CatID];
        NSMutableArray *resultFromPost=[[TabSquareDBFile sharedDatabase]getDishData:CatID subCatId:subcategoryId];
       // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
        
        @try
        {
            if(resultFromPost)
            {
                for(int i=0;i<[resultFromPost count];i++)
                {
                    NSMutableDictionary *dataitem=resultFromPost[i];
                    [DishCatId addObject:[NSString stringWithFormat:@"%@",dataitem[@"category"]]];
                    [DishSubId addObject:[NSString stringWithFormat:@"%@",dataitem[@"sub_category"]]];
                    [DishName addObject:[NSString stringWithFormat:@"%@",dataitem[@"name"]]];
                    [DishPrice addObject:[NSString stringWithFormat:@"%@",dataitem[@"price"]]];
                    [DishDescription addObject:[NSString stringWithFormat:@"%@",dataitem[@"description"]]];
                    [DishID addObject:[NSString stringWithFormat:@"%@",dataitem[@"id"]]];
                    [DishImage addObject:[UIImage imageWithContentsOfFile:dataitem[@"images"]]];
                    [DishCustomization addObject:dataitem[@"customisations"]];
                    [custType addObject:[NSString stringWithFormat:@"%@",dataitem[@"cust"]]];
                }
            }
        }
        @catch(NSException *ee)
        {
            
        }
    }
    
    
}


-(void)removeSwipeSubviews
{
    for(int i=0;i<[swipeDetailView.subviews count];++i)
    {
        [[swipeDetailView subviews][i] removeFromSuperview];
    }
}

-(void)swapDetailview
{
    if ((currentIndex+1)<[DishID count]){
    [detailView2 loadDataInView:currentIndex+1];
    }else{
        [detailView2 loadDataInView:0];
    }
    
    TabMainDetailView *swapController = detailView1;
    detailView1 = detailView2;
    detailView2 = swapController;
    //[swapController loadDataInView:currentIndex];
   // swapController lo
}


-(void)scrollViewDidScroll:(UIScrollView*)sender
{
    currentIndex=detailView2.pageIndex;
    //currentIndex=[detailView2.currIndex intValue];
    
    int scrollDirection;
    if (lastContentOffset > swipeDetailView.contentOffset.x){
        scrollDirection = 2; //load previous
            if ((currentIndex+1)<[DishID count]) {
                [detailView2 loadDataInView:currentIndex+1];
                //[detailView2 prevClicked:nil];
        } else {
            currentIndex=0;
        }
    }
    else if (lastContentOffset < swipeDetailView.contentOffset.x){
        scrollDirection = 1; //load next
        if ((currentIndex+1)<[DishID count]){
            [detailView2 loadDataInView:currentIndex+1];
            //[detailView2 nextClicked:nil];
        }
        else{
            currentIndex=0;
        }
    }
    
    lastContentOffset = swipeDetailView.contentOffset.x;
    //DLog(@"%d",currentIndex);

   // UIScrollView *swipe=(UIScrollView*)sender;
    CGFloat pageWidth = swipeDetailView.frame.size.width; 
    float fractionalPage = swipeDetailView.contentOffset.x / pageWidth;
    
    NSInteger lowerNumber = floor(fractionalPage);
    NSInteger upperNumber = lowerNumber + 1;
    [self setpageIndex:lowerNumber UperNum:upperNumber];
    
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat pageWidth = swipeDetailView.frame.size.width;
    float fractionalPage = swipeDetailView.contentOffset.x / pageWidth;
    NSInteger nearestNumber = lround(fractionalPage);
    if(detailView1.pageIndex!=nearestNumber)
    {
        currentIndex=detailView2.pageIndex;
        [self swapDetailview];
    }
    /*  else if(nearestNumber==[DishID count]-1)
     {
     [self moveNextSubCat];
     }
     else if (nearestNumber==0&&nearestNumber==detailView1.pageIndex)
     {
     [self movePrevSubCat];
     }*/
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

-(void)moveNextSubCat
{
    currentMove=1;
  //  currentCatId=[[NSString alloc]initWithFormat:@"%@",[DishCatId objectAtIndex:0]];
  //  currentSubId=[[NSString alloc]initWithFormat:@"%@",[DishSubId objectAtIndex:0]];
    
  //  [self reloadDataOfNextCat:currentCatId subCatId:currentSubId];
    if([DishID count]!=0)
    {
        [self showDetailView];
    }
    
}

-(void)movePrevSubCat
{
    currentMove=0;
  //  currentCatId=[[NSString alloc]initWithFormat:@"%@",[DishCatId objectAtIndex:0]];
   // currentSubId=[[NSString alloc]initWithFormat:@"%@",[DishSubId objectAtIndex:0]];
  //  [self reloadDataOfNextCat:currentCatId subCatId:currentSubId];
    if([DishID count]!=0)
    {
        [self showDetailView];
    }

}





-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
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




-(void)loadData:(TabMainDetailView*)detailview
{
    //[menudetailView showButtons];
    detailview.DishID=DishID;
    detailview.DishImage=DishImage;
    detailview.DishName=DishName;
    detailview.DishPrice=DishPrice;
    detailview.DishDescription=DishDescription;
    detailview.DishCatId=DishCatId;
    detailview.DishSubId=DishSubId;
    detailview.DishCustomization=DishCustomization;
    detailview.custType=custType;
}


-(void)showDetailView
{
    [self removeSwipeSubviews];
    [self setSwipeView];
    [self applyNewIndex:0 pageController:detailView1];
    [self applyNewIndex:1 pageController:detailView2];
    [swipeDetailView addSubview:detailView1.view];
    [swipeDetailView addSubview:detailView2.view];
    [self loadData:detailView1];
    [self loadData:detailView2];
    [detailView1 loadDataInView:[selectedID intValue]];
   /* if ([selectedID intValue]==([DishID count]-1)){
    [detailView2 loadDataInView:0];
    }else if ([selectedID intValue] == 0){
        
        [detailView2 loadDataInView:1];
    }else{
       [detailView2 loadDataInView:([selectedID intValue]+1)];
    }*/
}


-(void)showIndicator
{
    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)];
	progressHud= [[MBProgressHUD alloc] initWithView:progressView];
	[self.view addSubview:progressHud];
	[self.view bringSubviewToFront:progressHud];
	//progressHud.dimBackground = YES;
	progressHud.delegate = self;
    //progressHud.labelText = @"loading....";
	[progressHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}




@end
