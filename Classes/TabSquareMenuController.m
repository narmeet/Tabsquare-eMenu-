

#import "TabSquareMenuController.h"
#import "TabSquareFavouriteViewController.h"
#import "TabMainCourseMenuListViewController.h"
#import "TabSquareBeerController.h"
#import "TabSquareBeerDetailController.h"
#import "TabSquareBeerListController.h"
#import "TabMainMenuDetailViewController.h"
#import "TabSquareMenuDetailController.h"
#import "TabSquareSoupViewController.h"
#import "TabSquareOrderSummaryController.h"
#import "TabSquareDBFile.h"
#import "SBJSON.h"
#import "ShareableData.h"
#import "TabSearchViewController.h"
#import "TabFeedbackViewController.h"
#import "TabSquareTableManagement.h"
#import "TabSquareAssignTable.h"
#import "TabSquareHelpController.h"
#import "TabSquareLastOrderedViewController.h"
#import "TabSquareFriendListController.h"
#import "TabSquarefriendsorderViewController.h"
#import "TabTwitterFollowerListControllerViewController.h"
#import "EditOrder.h"
#import "TabSquareCommonClass.h"
#import <QuartzCore/QuartzCore.h>
#import "Flurry.h"
#import "LanguageSelectionView.h"
#import "LanguageControler.h"
#import "TabSquareRemoteActivation.h"
#import "TabSquareTableRequestHandler.h"

#define FONT_GRILLED_CHEESE         @"GrilledCheeseBTNToasted"
#define FONT_CALIBRI_BOLD           @"Calibri"


#define FONT_MAIN_MENU_CHOICES      [UIFont fontWithName: FONT_CALIBRI_BOLD size: 80.0]
#define FONT_GROUP_CHOICES          [UIFont fontWithName: FONT_CALIBRI_BOLD size: 22.0]
#define FONT_GROUP_CHOICES_SEL      [UIFont fontWithName: FONT_CALIBRI_BOLD size: 42.0]

#define FONT_FOOD_NAMES             [UIFont fontWithName: FONT_CALIBRI_BOLD size: 20.0]


#define FONT_ADD_BUTTON_QUANTITY    [UIFont fontWithName: FONT_CALIBRI_BOLD size: 28.0]

#define FONT_ORDER_SCREEN_TITLE     [UIFont fontWithName: FONT_CALIBRI_BOLD size: 64.0]
#define FONT_ORDER_SCREEN_TOTAL     [UIFont fontWithName: FONT_CALIBRI_BOLD size: 32.0]
#define FONT_ORDER_SCREEN_ITEMS     [UIFont fontWithName: FONT_CALIBRI_BOLD size: 24.0]

#define FONT_VIEW_ORDER_ITEMS       [UIFont fontWithName: FONT_CALIBRI_BOLD size: 12.0]




#define MENU_DIVIDER                (300.0f)

#define RESTAURANT_LOGO_Y           (110.0f)



#define GRAY_VALUE                  (60.0f/255.0f)
#define LIGHT_GRAY_VALUE            (128.0f/255.0f)

#define COLOR_DARK_GRAY             [UIColor colorWithRed:GRAY_VALUE green:GRAY_VALUE blue:GRAY_VALUE alpha:1]
#define COLOR_DARK_GRAY_ALPHA       [UIColor colorWithRed:25/255 green:25/255 blue:25/255 alpha:0.2]
#define COLOR_LIGHT_GRAY            [UIColor colorWithRed:LIGHT_GRAY_VALUE green:LIGHT_GRAY_VALUE blue:LIGHT_GRAY_VALUE alpha:1]

#define COLOR_DARK_RED              [UIColor colorWithRed: 0.75 green: 0.25 blue: 0.5 alpha:1]

@implementation TabSquareMenuController

@synthesize subcategoryIdList,categoryIdList,selectedCategoryID, logoImage;
@synthesize maincourseImage;
@synthesize categoryList,subcategoryList,btnn;
@synthesize menuCategory,menuQuick;
@synthesize search,feedback,favourite,help,orderSummaryView, flagButton;
@synthesize swipeView,OrderSummaryButton,KinaraLogo,overviewMenuButton;
@synthesize swipeIndicator,FeedbackDisabled,helpOverlay,favouriteView,menulistView1,subcategoryDisplayList, isRecon, backgroundImage;

@synthesize KinaraSelectorCategory,KinaraCategory,KinaraSelectedCategoryName;
@synthesize KinaraSubCategory,KinaraSubategoryNameList,KinaraSelectedSubCategoryName,KinaraSelectorSubCategory,assignTable;

@synthesize subcatScroller,subCatbg;
@synthesize mparent, billCallBtn, waiterCallBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        favorite_status = FALSE;
        bestsellersOpened = FALSE;
        searchOpened = FALSE;
    }
    return self;
}


-(void)setParent:(id)sender{
    
    mparent=sender;
    
    
}

-(void)createFavouriteClicked
{
    favouriteView=[[TabSquareFavouriteViewController alloc]initWithNibName:@"TabSquareFavouriteViewController" bundle:nil];
    favouriteView.lastOrderedView=lastOrderedview;
    favouriteView.fbfriendView=fbFriendview;
    favouriteView.twitfollowerView=twitFriendview;
}
-(void)loadQuickOrder{
    if (menuQuick == nil){
    menuQuick = [[TabSquareQuickOrder alloc] initWithNibName:@"TabSquareQuickOrder" bundle:nil];
    menuQuick.view.frame=CGRectMake(0,[UIScreen mainScreen].bounds.size.width, menuQuick.view.frame.size.width, menuQuick.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    menuQuick.view.frame=CGRectMake(0,98, menuQuick.view.frame.size.width, menuQuick.view.frame.size.height);
    [UIView commitAnimations];
    [self.view addSubview:menuQuick.view];
    [self.view bringSubviewToFront:menuQuick.view];
    }else{
        [self displayOverview];
    }
}

-(void)createMenuListClicked
{
    menulistView1=[[TabMainCourseMenuListViewController alloc]initWithNibName:@"TabMainCourseMenuListViewController" bundle:nil];
    menulistView1.menuview=self;
    menulistView2=[[TabMainCourseMenuListViewController alloc]initWithNibName:@"TabMainCourseMenuListViewController" bundle:nil];
    menulistView2.menuview=self;
    menulistView3=[[TabMainCourseMenuListViewController alloc]initWithNibName:@"TabMainCourseMenuListViewController" bundle:nil];
    menulistView3.menuview=self;
    menulistView=menulistView1;
}

-(void)createBeveragesClicked
{
    beveragesBeerView1=[[TabSquareBeerController alloc]initWithNibName:@"TabSquareBeerController" bundle:nil];
    beveragesBeerView2=[[TabSquareBeerController alloc]initWithNibName:@"TabSquareBeerController" bundle:nil];
    beveragesBeerView=beveragesBeerView1;
}

-(void)createOrderSummary
{
    orderSummaryView=[[TabSquareOrderSummaryController alloc]initWithNibName:@"TabSquareOrderSummaryController" bundle:nil];
    orderSummaryView.menudetailView=menulistView.menudetailView;
    orderSummaryView.menuView=self;
    

}
-(void)returnToEdit{
    
    editOrderView=[[EditOrder alloc]initWithNibName:@"EditOrder" bundle:nil];
    editOrderView.tableNumber=[ShareableData sharedInstance].assignedTable1;
    [editOrderView getTableDetails:editOrderView.tableNumber];
    [self.parentViewController.navigationController pushViewController:editOrderView animated:YES];
    NSArray *arr = [self.navigationController viewControllers];
    NSArray *newStack = [NSArray arrayWithObjects:[arr objectAtIndex:0], editOrderView, nil];
    [self.navigationController setViewControllers:newStack];
    
}

-(void)createSoupView
{
    soupView=[[TabSquareSoupViewController alloc]initWithNibName:@"TabSquareSoupViewController" bundle:nil];
    soupView.menuView=self;
}

-(void)createSearchView
{
    searchView=[[TabSearchViewController alloc]initWithNibName:@"TabSearchViewController" bundle:nil];
    searchView.menulistView1=menulistView;
    searchView.BeverageView=beveragesBeerView;
    searchView.HomePage=self;
}

-(void)createFeedBackView
{
    feedbackView=[[TabFeedbackViewController alloc]initWithNibName:@"TabFeedbackViewController" bundle:nil];
    feedbackView.menuView=self;
}

-(void)createHelpView
{
    helpView=[[TabSquareHelpController alloc]initWithNibName:@"TabSquareHelpController" bundle:nil];
}

-(void)createlastOrderedView
{
    lastOrderedview=[[TabSquareLastOrderedViewController alloc]initWithNibName:@"TabSquareLastOrderedViewController" bundle:nil];
    lastOrderedview.menuView=self;
}

-(void)createFriendlist
{
    fbFriendview=[[TabSquareFriendListController alloc]initWithNibName:@"TabSquareFriendListController" bundle:nil];
    fbFriendview.menuView=self;
    
}

-(void)createTwitterfrdList
{
    twitFriendview=[[TabTwitterFollowerListControllerViewController alloc]initWithNibName:@"TabTwitterFollowerListControllerViewController" bundle:nil];
    twitFriendview.menuView=self;
    twitFriendview.favouriteView=favouriteView;
}


-(void)applyNewIndex:(NSInteger)newIndex pageController:(TabMainCourseMenuListViewController *)pageController
{
    
    NSInteger pageCount;
    if([self.subcategoryIdList count]>=1)
    {
        pageCount = [self.subcategoryIdList count]; 
    }
	else {
        pageCount=1;
    }
	BOOL outOfBounds = newIndex >= pageCount || newIndex < 0;
    
	if (!outOfBounds)
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = 0;
		pageFrame.origin.x = swipeView.frame.size.width * newIndex;
		pageController.view.frame = pageFrame;
	}
	else
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = swipeView.frame.size.height;
		pageController.view.frame = pageFrame;
	}
    
	pageController.pageIndex = newIndex;
}

- (void)applyNewIndex1:(NSInteger)newIndex pageController:(TabSquareBeerController *)pageController
{
    NSInteger pageCount;
    if([self.subcategoryIdList count]>=1)
    {
        pageCount = [self.subcategoryIdList count]; 
    }
	else {
        pageCount=1;
    }

	BOOL outOfBounds = newIndex >= pageCount || newIndex < 0;
    
	if (!outOfBounds)
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = 0;
		pageFrame.origin.x = swipeView.frame.size.width * newIndex;
		pageController.view.frame = pageFrame;
	}
	else
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = swipeView.frame.size.height;
		pageController.view.frame = pageFrame;
	}
    
	pageController.pageIndex = newIndex;
}

-(void)setSwipeView
{
    int pageCount;
    pageCount=[self.subcategoryIdList count];
    if([self.subcategoryIdList count]<=1)
    {
        pageCount=2;
    }
    swipeView.pagingEnabled=true;
    swipeView.contentSize =
    CGSizeMake(
               swipeView.frame.size.width *pageCount,
               swipeView.frame.size.height);
	swipeView.contentOffset = CGPointMake(0, 0); 
    swipeView.showsHorizontalScrollIndicator=NO;
    swipeView.userInteractionEnabled=YES;
}


-(void)KinaraStartCategory:(UIScrollView*)scrollView
{
    int tt=-2;
    BOOL found=false;
  //  UIButton *btnz = (UIButton*)[scrollView viewWithTag:3];
 //   [btnz sendActionsForControlEvents:UIControlEventTouchUpInside];
    if([[ShareableData sharedInstance].HomeCatId count]>0)
    {
        NSString *homeCatId=([ShareableData sharedInstance].HomeCatId)[0];
        tt=[homeCatId intValue];
    }
    
    int total=KinaraNumberOfButton/[categoryIdList count];
    int counter=0;
    for (UIView *v in scrollView.subviews)
    {
        if ([v isKindOfClass:[UIButton class]])
        {
            UIButton *btn=(UIButton*)v;
            
            if(btn.tag==tt)
            {
                counter++;
                if(counter==total/2)
                {
                    
                    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    found=true;
                    break;
                }
            }
        }
    }
    
    if(!found)
    {
        [self.favourite sendActionsForControlEvents:UIControlEventTouchUpInside]; 
    }
    if([[ShareableData sharedInstance].HomeCatId count]>0)
    {
        NSString *homeCatId=([ShareableData sharedInstance].HomeCatId)[0];
        tt=[homeCatId intValue];
    }
    
        // UIButton *btnz = (UIButton*)[scrollView viewWithTag:3];
}

-(void)KinaraStartSubCategory:(UIScrollView*)scrollView subID:(NSString*)SubCatID
{
    int total=KinaraNumberOfButton/[subcategoryList count];
    int counter=0;
    for (UIView *v in scrollView.subviews)
    {
        if ([v isKindOfClass:[UIButton class]])
        {
            UIButton *btn=(UIButton*)v;
            if(btn.tag==[SubCatID intValue])
            {
                counter++;
                if(counter==total/2)
                {
                    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    break;
                }
            }
        }
    }
    
}

-(void)KinaraRollCategory:(UIScrollView*)scrollView subID:(NSString*)CatID
{
    BOOL found=false;
    int total=KinaraNumberOfButton/[categoryIdList count];
    int counter=0;
    int tt=[CatID intValue];
    for (UIView *v in scrollView.subviews)
    {
        if ([v isKindOfClass:[UIButton class]])
        {
            UIButton *btn=(UIButton*)v;
            
            if(btn.tag==tt)
            {
                counter++;
                if(counter==total/2)
                {
                    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    found=true;
                    break;
                }
            }
        }
    }
    
    if(!found)
    {
        [self.favourite sendActionsForControlEvents:UIControlEventTouchUpInside]; 
    }

    
}


-(void)createViews
{
    [self createFeedBackView];
    [self createlastOrderedView];
    [self createFriendlist];
    [self createMenuListClicked];
    [self createTwitterfrdList];
    [self createFavouriteClicked];
    [self createBeveragesClicked];
    [self createOrderSummary];
    [self createSearchView];
    [self createHelpView];
    [self createSoupView];
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
    [[TabSquareRemoteActivation remoteActivation] setPopupSuperView:self.view];
    [[TabSquareRemoteActivation remoteActivation] setMainMenuButton:self.overviewMenuButton];
    

    if(![ShareableData multiLanguageStatus])
        [self.flagButton setHidden:TRUE];

    /*=============Setting Cell Background Image===============*/
    NSString *image_name = [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, CATEGORY_IMAGE, [ShareableData appKey]];
    cellImage = [[TabSquareDBFile sharedDatabase] getImage:image_name];
    if(cellImage == nil)
        cellImage = [UIImage imageNamed:@"cell_slide.png"];
    /*=========================================================*/

    /*========================Settinng Dynamic UI==========================*/
    
    NSString *img_name = [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, BACKGROUND_IMAGE, [ShareableData appKey]];
    UIImage *img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    if(img != nil)
        [self.backgroundImage setImage:img];
    
    NSString *img_name2 = [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, MENU_BUTTON_IMAGE, [ShareableData appKey]];
    UIImage *img2 = [[TabSquareDBFile sharedDatabase] getImage:img_name2];
    if(img2 != nil)
        [self.overviewMenuButton setImage:img2 forState:UIControlStateNormal];
    
    NSString *img_name3 = [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, ORDER_SUMMURY_BUTTON_IMAGE, [ShareableData appKey]];
    UIImage *img3 = [[TabSquareDBFile sharedDatabase] getImage:img_name3];
    if(img3 != nil)
        [self.OrderSummaryButton setImage:img3 forState:UIControlStateNormal];

    
    NSMutableDictionary *fontDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:FONT_DICTIONARY];
    
    if(fontDictionary != nil) {
        
//        NSMutableDictionary *categoryFont = [fontDictionary objectForKey:@"Category"];
//        fontName = [NSString stringWithFormat:@"%@", [categoryFont objectForKey:@"font"]];
//        fontSize = [[NSString stringWithFormat:@"%@", [categoryFont objectForKey:@"size"]] floatValue];
//        
//        NSString *colors = [NSString stringWithFormat:@"%@", [categoryFont objectForKey:@"color"]];
//        NSArray *arr = [colors componentsSeparatedByString:@","];
//        float _red = [arr[0] floatValue];
//        float _green = [arr[1] floatValue];
//        float _blue = [arr[2] floatValue];
        
        fontColor = [UIColor colorWithRed:160/255.0 green:125/255.0 blue:53/255.0 alpha:1.0];
        fontSize = 70.0;
    }
    else {
        fontName = @"Century Gothic";
        fontSize = 70.0;
        fontColor = [UIColor colorWithRed:160/255.0 green:125/255.0 blue:53/255.0 alpha:1.0];
    }
    /*=====================================================================*/
    
    ///////////////////
    /*
    UIImage *logo_img = [UIImage imageNamed:@"demo_logo.png"];
    logo_img = [TabSquareCommonClass resizeImage:logo_img scaledToSize:CGSizeMake(logo_img.size.width/2, logo_img.size.height/2)];
    [self.logoImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.logoImage setImage:logo_img];
     */

    /*=====================Call Functions Objects=====================*/
    if([[ShareableData sharedInstance].currentTable isEqualToString:DEFAULT_TABLE]) {
        [self.waiterCallBtn setHidden:TRUE];
        [self.billCallBtn setHidden:TRUE];
    }
    else {
        callForWaiter = [[TabSquareTableRequestHandler alloc] initWithTableNo:[NSString stringWithFormat:@"%@", [ShareableData sharedInstance].currentTable]];
        callForBill = [[TabSquareTableRequestHandler alloc] initWithTableNo:[NSString stringWithFormat:@"%@", [ShareableData sharedInstance].currentTable]];
    }
    /*================================================================*/
    
    OrderSummaryButton.hidden=YES;
    
    searchStatus = FALSE;
    bestsellersOpened = FALSE;
    searchOpened = FALSE;
    bestsellers = [ShareableData bestSellersON];
    favorite_status = FALSE;
    isRecon = 0;
    hasLoaded = 0;
    categoryList=[[NSMutableArray alloc]init];
    categoryIdList=[[NSMutableArray alloc]init];
    
    subcategoryList=[[NSMutableArray alloc]init];
    subcategoryIdList=[[NSMutableArray alloc]init];
    subcategoryDisplayList=[[NSMutableArray alloc]init];
    sub_cat_buttons = [[NSMutableArray alloc]init];
    
    subcatScroller = nil;
    
    swipeIndicator=@"1";
    summaryTotalBadge = [CustomBadge customBadgeWithString:@"0"
                                           withStringColor:[UIColor whiteColor]
                                            withInsetColor:[UIColor redColor]
                                            withBadgeFrame:YES
                                       withBadgeFrameColor:[UIColor whiteColor]
                                                 withScale:1.2
                                               withShining:YES];
    [summaryTotalBadge setFrame:CGRectMake(OrderSummaryButton.frame.size.width-summaryTotalBadge.frame.size.width/2 - 15,(summaryTotalBadge.frame.size.width/2 * -1) +3 , self.view.frame.size.width, self.view.frame.size.height)];
    [KinaraCategory setHidden:TRUE];
    assignTable=[[TabSquareTableManagement alloc]initWithNibName:@"TabSquareTableManagement" bundle:nil];
    //@try
    {
        [self GetCategoryData];
        [self createViews];
        [self hideUnhideComponents:TRUE];
        [self addTapGesture];
        
        self.view.clipsToBounds = NO;
        [ShareableData sharedInstance].swipeView=swipeView;
        [NSTimer scheduledTimerWithTimeInterval:1.00
                                         target:self
                                       selector:@selector(onTick:)
                                       userInfo:nil
                                        repeats:YES];
        
    }
    /*
    @catch (NSException *exception) 
    {
        
    }
    @finally 
    {
        
    }
     */
    
    
    ///////////////////
    /*
    UIImage *logo_img = [UIImage imageNamed:@"demo_logo.png"];
    logo_img = [TabSquareCommonClass resizeImage:logo_img scaledToSize:CGSizeMake(logo_img.size.width/2, logo_img.size.height/2)];
    [self.logoImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.logoImage setImage:logo_img];
    */
    
    CGRect frm = orderSummaryView.view.frame;
    [orderSummaryView.view setFrame:CGRectMake(frm.origin.x, frm.origin.y-5, frm.size.width, frm.size.height)];

    KinaraSubategoryNameList=[[NSMutableArray alloc]init];
    KinaraSelectedCategoryID=0;
    KinaraSelectedCategoryName=@"";
    
    KinaraSelectedSubCategoryID=0;
    KinaraSelectedSubCategoryName=@"";
        
    KinaraCategoryBtnClick=false;
    
    KinaraNumberOfButton = 100; // subcategoryIdList
    
    KinaraCategory = [[UIScrollView alloc] initWithFrame:CGRectMake(0,87,[UIScreen mainScreen].bounds.size.width, 50)];
    [self KinaracreateScrollView:KinaraNumberOfButton frame:CGRectMake(0,0, 153,50) scrollView:KinaraCategory];
    [KinaraCategory setHidden:TRUE];
    
    [self KinaraStartCategory:KinaraCategory];
    
    
    if ([[ShareableData sharedInstance].isQuickOrder isEqualToString:@"0"]) {
        [self performSelector:@selector(loadOverview) withObject:nil afterDelay:0];
    }
    else {
      [self performSelector:@selector(loadQuickOrder) withObject:nil afterDelay:0];
    }
    
   /* [self.view addSubview:overviewMenuView];
    CGRect newFrame = CGRectMake(0, 80, overviewMenuView.frame.size.width, overviewMenuView.frame.size.height);
    overviewMenuView.frame=newFrame;
    [self.view bringSubviewToFront:overviewMenuView];*/
    
    //////////////////
}
-(void)loadOverview{
    
    [self addTable];
    return;
    
//    overviewMenuButton.selected = YES;
//    [self UnselectedBottomMenu];
//    OrderSummaryButton.selected=NO;
//    [self.view insertSubview:overviewMenuView aboveSubview:KinaraSubCategory];
//    [KinaraSubCategory setHidden:TRUE];
//    CGRect newFrame = CGRectMake(0, 80, overviewMenuView.frame.size.width, overviewMenuView.frame.size.height);
//    overviewMenuView.frame=newFrame;
//    
//    NSArray *subviews = [overviewMenuView subviews];
//    
//    //UIButton *btn=(UIButton *)[self.view viewWithTag:sender];
//  //  [KinaraCategory setContentOffset:KinaraOriginalScrollPositionPoint animated:YES];
//  //  KinaraCurrentScrollPositionPoint=KinaraCategory.contentOffset;
//    for(id subview in subviews ){
//        
//        if ([subview isKindOfClass:[UIButton class]]){
//            UIButton* temp = (UIButton*)subview;
//    
//            [temp.titleLabel setTextAlignment:NSTextAlignmentCenter];
//        }
//    }
//    [self.view bringSubviewToFront:overviewMenuView];
    
}
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
   // isScrolling = YES;
   // scrollView.panGestureRecognizer.cancelsTouchesInView = YES;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
   // isScrolling = NO;
    if (decelerate == YES){
        scrollView.panGestureRecognizer.cancelsTouchesInView = NO;
        scrollView.canCancelContentTouches = NO;
        
    }else{
    
    //[NSObject cancelPreviousPerformRequestsWithTarget:self];
    //enshore that the end of scroll is fired because apple are twats...
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:scrollView afterDelay:0.3];
    }
    
}



/////////////////  New Code //////////////////
-(void)KinaracreateScrollView:(int)size1  frame:(CGRect)frame1 scrollView:(UIScrollView*)ScrollView
{
    KinaraSelectorCategory=[UIButton buttonWithType:UIButtonTypeCustom];
    /*
    [KinaraSelectorCategory setImage:[UIImage imageNamed:@"trans button.png"] forState:UIControlStateNormal];
    [KinaraSelectorCategory setImage:[UIImage imageNamed:@"trans button.png"] forState:UIControlStateHighlighted];
    [KinaraSelectorCategory setImage:[UIImage imageNamed:@"trans button.png"] forState:UIControlStateSelected];
     */
    KinaraSelectorCategory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-76.5, ScrollView.frame.origin.y-5, 153, 70);
    
    [KinaraSelectorCategory setHidden:TRUE];
    
    ScrollView.userInteractionEnabled = YES;
    [ScrollView setShowsHorizontalScrollIndicator:NO];
    [ScrollView setShowsVerticalScrollIndicator:NO];
    ScrollView.scrollEnabled=YES;
    ScrollView.backgroundColor=[UIColor clearColor];
    ScrollView.clipsToBounds = NO;
  //  ScrollView.canCancelContentTouches = YES;
    //ScrollView.is
    for(int i=0;i<size1;)
    {
        UIButton *btn=[[UIButton alloc]initWithFrame:frame1];
        [btn setImage:[UIImage imageNamed:@"categoryback.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"categoryback.png"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"categoryback.png"] forState:UIControlStateSelected];
        
        int index=i%[categoryList count];
        NSString *catID=categoryIdList[index];
        btn.tag=[catID intValue];
        
        [btn addTarget:self action:@selector(KinaraCategoryClicked:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *title=[self KinaraaddCategoryTitle:[catID intValue] labelValue:categoryList[index]];
        [btn addSubview:title];
        [btn.titleLabel setText:title.text];
        [ScrollView addSubview:btn];
        i++;
        frame1.origin.x = i*(frame1.size.width);
        ScrollView.contentSize = CGSizeMake(btn.frame.size.width*(size1-1), ScrollView.frame.size.height);
    }
    ScrollView.delegate=self;
    [[self view] addSubview:ScrollView];
    [ScrollView scrollRectToVisible:CGRectMake(ScrollView.contentSize.width/2-115,0,320,frame1.size.width/2) animated:NO];
    
    
    
    KinaraCurrentScrollPositionPoint=ScrollView.contentOffset;
    KinaraOriginalScrollPositionPoint=ScrollView.contentOffset;
    
    if([categoryList count]<4)
    {
        int countList=[categoryList count];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGRect frame1=CGRectMake(ScrollView.frame.origin.x, ScrollView.frame.origin.y, width/2-(76.5*countList),ScrollView.frame.size.height);
        UIImageView *hide1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nillin.png"]];
        hide1.frame=frame1;
        hide1.userInteractionEnabled=YES;
        [self.view bringSubviewToFront:hide1];
        [[self view] addSubview:hide1];
        
        CGRect frame2=CGRectMake(width/2+(76.5*countList), ScrollView.frame.origin.y ,width,ScrollView.frame.size.height);
        UIImageView *hide2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nillin.png"]];
        hide2.frame=frame2;
        hide2.userInteractionEnabled=YES;
        [self.view bringSubviewToFront:hide2];
        [[self view] addSubview:hide2];
    }
    
    [self scrollViewDidEndScrollingAnimation:ScrollView];
    
    
    [self.view bringSubviewToFront:KinaraSelectorCategory];
    [self.view addSubview:KinaraSelectorCategory];
}


-(void)KinaracreateSubCategoryScrollView:(int)size1 frame:(CGRect)frame1 scrollView:(UIScrollView*)ScrollView
{
    //size1 = [subcategoryIdList count];
    [ScrollView setHidden:TRUE];
    
    ////////NSLOG(@"Coming here again sub-cat %@, simze1 = %d", subcategoryIdList, size1);
    ScrollView.userInteractionEnabled = YES;
    [ScrollView setShowsHorizontalScrollIndicator:NO];
    [ScrollView setShowsVerticalScrollIndicator:NO];
    ScrollView.scrollEnabled=NO;
    ScrollView.backgroundColor=[UIColor clearColor];
    ScrollView.clipsToBounds = NO;
    
    if(subcatScroller != nil)
        [subcatScroller removeFromSuperview];
    
    subcatScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 61)];
    subcatScroller.delegate=self;
    //subcatScroller.scrollEnabled=NO;//narmeet for fha
    [subcatScroller setHidden:TRUE];
    
    [subcatScroller setShowsHorizontalScrollIndicator:NO];
    [subcatScroller setShowsVerticalScrollIndicator:NO];
    CGSize scrollableSize = CGSizeMake(self.view.frame.size.width, 40);
    [subcatScroller setContentSize:scrollableSize];
    [subcatScroller setScrollEnabled:YES];
    
    
    //  NSString *img_name1 = [NSString stringWithFormat:@"%@%@", PRE_NAME, HEADER_IMAGE];
    NSString *img_name1 = [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, HEADER_IMAGE, [ShareableData appKey]];
    UIImage *img1 = [[TabSquareDBFile sharedDatabase] getImage:img_name1];
    if(img1 == nil)
        img1 = [UIImage imageNamed:@"subCatHeader"];
    
    subCatbg = [[UIImageView alloc] initWithImage:img1];
    
    
    CGRect tempFrame = CGRectMake(subcatScroller.frame.origin.x, subcatScroller.frame.origin.y-5, subcatScroller.frame.size.width, subcatScroller.frame.size.height) ;
    // [[UIImageView alloc] initWithFrame:CGRectMake(subcatScroller.frame.origin.x, subcatScroller.frame.origin.y, subcatScroller.frame.size.width, subcatScroller.frame.size.height)];
    subCatbg.frame = tempFrame;
    [self.view addSubview:subCatbg];
    [subCatbg setHidden:TRUE];
    //[subcatScroller sendSubviewToBack:subCatbg];
    
    [self.view addSubview:subcatScroller];
    
    //ScrollView.e
    
    [sub_cat_buttons removeAllObjects];
    
    if([subcategoryIdList count]>0)
    {
        for(int i=0;i<size1;i++)
        {
            UIButton *btn=[[UIButton alloc]initWithFrame:frame1];
            [btn.titleLabel setFont:[UIFont fontWithName:@"Copperplate" size:22.0]];
            [btn setImage:[UIImage imageNamed:@"subcategory_normal.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"subcategory_normal.png"] forState:UIControlStateHighlighted];
            [btn setImage:[UIImage imageNamed:@"subcategory_normal.png"] forState:UIControlStateSelected];
            
            int index=i%[subcategoryIdList count];
            NSString *subcatID=subcategoryIdList[index];
            btn.tag=[subcatID intValue];
            
            [btn addTarget:self action:@selector(KinaraSubCategoryClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *title=[self KinaraaddCategoryTitle:[subcatID intValue] labelValue:subcategoryList[index]];
            [btn addSubview:title];
            //[btn.titleLabel setText:title.text];
            [title setText:[self filterString:title.text pattern:@"[1-9]-"]];
            [btn setTitle:title.text forState:UIControlStateNormal];
            [title setFont:[UIFont fontWithName:@"Copperplate" size:17.0]];
            title.textColor=[UIColor colorWithRed:160/255.0 green:125/255.0 blue:53/255.0 alpha:1.0];
            [ScrollView addSubview:btn];
            frame1.origin.x = i*(frame1.size.width);
            
            if(i < [subcategoryIdList count])
                [sub_cat_buttons addObject:btn];
        }
    }
    
    ScrollView.contentSize = CGSizeMake(frame1.size.width*(size1-1), ScrollView.frame.size.height);
    
    ScrollView.delegate=self;
    [[self view] addSubview:ScrollView];
    [ScrollView scrollRectToVisible:CGRectMake(ScrollView.contentSize.width/2-115,0,320,frame1.size.width/2) animated:NO];
    KinaraCurrentScrollPositionPointSub=ScrollView.contentOffset;
    
    KinaraOriginalScrollPositionPointSub=KinaraSubCategory.contentOffset;
    
    if([subcategoryIdList count]<4)
    {
        int countList=[subcategoryIdList count];
        
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGRect frame1=CGRectMake(ScrollView.frame.origin.x, ScrollView.frame.origin.y, width/2-(55*countList),ScrollView.frame.size.height);
        UIImageView *hide1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KinaraHide.png"]]; // KinaraHide.png
        hide1.frame=frame1;
        hide1.userInteractionEnabled=YES;
        [self.view bringSubviewToFront:hide1];
        //[[self view] addSubview:hide1];
        
        CGRect frame2=CGRectMake(width/2+(70*countList), ScrollView.frame.origin.y ,width,ScrollView.frame.size.height);
        UIImageView *hide2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KinaraHide.png"]];
        hide2.frame=frame2;
        hide2.userInteractionEnabled=YES;
        [self.view bringSubviewToFront:hide2];
        //[[self view] addSubview:hide2];
    }
    
    [self createScrollerButtons:[subcategoryIdList count]];
}

-(UIButton*)getNearestBtn{
    
    UIButton* currentBtn;
    
    float cntr = [UIScreen mainScreen].bounds.size.width / 2;
    
    for (int i=0; i < [[subcatScroller subviews] count];i++){
        
        UIView *sub_view = (UIView *)[[subcatScroller subviews] objectAtIndex:i];
        if ([sub_view isMemberOfClass:[UIButton class]]){
            
            UIButton* temp = (UIButton*)sub_view;
            
            
            float tempBtnVal = temp.frame.origin.x + (temp.frame.size.width/2)-subcatScroller.contentOffset.x;
            if (tempBtnVal>0 && tempBtnVal < [UIScreen mainScreen].bounds.size.width){
                
                if (currentBtn == nil){
                    currentBtn = temp;
                }
                float curBtnVal = currentBtn.frame.origin.x + (currentBtn.frame.size.width/2)-subcatScroller.contentOffset.x;
                if (abs(cntr-tempBtnVal) < abs(cntr - curBtnVal) ){
                    currentBtn = temp;
                }
            }
        }
    }
    return currentBtn;
    
}


-(void)createScrollerButtons:(int)count
{
    prevX = 0;
    initLoading = 1;
    UIButton* firstBtn;
    float content_size = subcatScroller.contentSize.width;
    
    for(int i = 0; i < count; i++)
    {
        
        NSString *title=subcategoryList[i];
        NSString *filtered = [self filterString:title pattern:@"[1-9]-"];
        
        CGSize stringsize = [filtered sizeWithFont:[UIFont fontWithName:@"Copperplate" size:30.0]];
        float width  = stringsize.width + 30;
        float height = 60;
        
        float screen_width = self.view.frame.size.width;
        
        float gap = 60;//screen_width - (width * count);
        //        gap /= count+1;
        //
        //       if(count > 4)
        //            gap = prevX;
        //        CGRect frm = CGRectMake((i*width) + ((i+1)*gap), 0, width, height);
        CGRect frm = CGRectMake(gap+prevX, 0, width, height);
        UIButton *btn=[[UIButton alloc]initWithFrame:frm];
        prevX = frm.origin.x + frm.size.width;
        [btn.titleLabel setFont:[UIFont fontWithName:@"Copperplate" size:20.0]];
        [btn setTitleColor:COLOR_LIGHT_GRAY forState:UIControlStateNormal];
        [btn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [btn.titleLabel setNumberOfLines:1];
        // [btn setBackgroundImage:[UIImage imageNamed:@"subcategory_normal.png"] forState:UIControlStateNormal];
        [btn setTitle:filtered forState:UIControlStateNormal];
        [btn setTitle:filtered forState:UIControlStateReserved];
        
        // [btn sizeToFit];
        
        // [btn.titleLabel setAdjustsFontSizeToFitWidth:TRUE];
        //btn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        [btn setTag:subcategoryIdList[i]];
        [btn addTarget:self action:@selector(subCatAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setExclusiveTouch:YES];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(7, 4, 8, 4)];
        [subcatScroller addSubview:btn];
        //subcategory_selected1
        if(i == 0) {
            // prev_btn = btn;
            temp_btn = btn;
            // [btn setBackgroundImage:[UIImage imageNamed:@"subcategory_selected1.png"] forState:UIControlStateNormal];
        }
        
        content_size = frm.origin.x + frm.origin.y;
    }
    
    [subcatScroller setContentSize:CGSizeMake(content_size+450 , subcatScroller.contentSize.height-100)];
    
    //subcatScroller.pagingEnabled=YES;
    [prev_btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)subCatAction:(id)sender
{
    if(sender == prev_btn){
        // float test =  (([UIScreen mainScreen].bounds.size.width/2)-prev_btn.frame.origin.x-(prev_btn.frame.size.width/2));
        
        
        // [subcatScroller setContentOffset:CGPointMake(0, prev_btn.frame.origin.y) animated:YES];
        // [subcatScroller setContentOffset:CGPointMake(test*-1, prev_btn.frame.origin.y) animated:YES];
        
        return;
    }
    
    /*=========Locking Touch=========*/
    //[[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    
    UIButton *_temp_btn = (UIButton *)sender;

    [self zoomButton:_temp_btn];
    
    UIButton *btn = nil;
    NSArray *subs = KinaraSubCategory.subviews;
    for(int i = ([subs count]/2)-2; i < [subs count]; i++)
    {
        UIView *sub_view = (UIView *)[subs objectAtIndex:i];
        if([sub_view isMemberOfClass:[UIButton class]]) {
            UIButton *tmp = (UIButton *)sub_view;
            if([[[_temp_btn titleForState:UIControlStateReserved] lowercaseString] isEqualToString:[[tmp titleForState:UIControlStateNormal] lowercaseString]]) {
                btn = tmp;
                break;
            }
        }
    }
    
    //  [subcatScroller setContentSize:CGSizeMake(subcatScroller.contentSize.width+100 , subcatScroller.contentSize.height-100)];
    
    [KinaraSubCategory setContentOffset:CGPointMake(btn.frame.origin.x - 332, KinaraSubCategory.contentOffset.y) animated:YES];
    prev_btn = sender;
    initLoading = 0;
}

- (void) changeFontSize: (id)sender
{
    // if (initLoading == 0){
    if(sender == prev_btn)
        return;
    // }
    //if(groupButton.tag == indexSelected) {
    UIButton *temp_btn = (UIButton *)sender;
    float scaleSize = 1.5f;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    
    temp_btn.transform = CGAffineTransformMakeScale(scaleSize, scaleSize);
    [ temp_btn setTitleColor:[UIColor colorWithRed:160/255.0 green:125/255.0 blue:53/255.0 alpha:1.0] forState:UIControlStateNormal ] ;
    [UIView commitAnimations];
    // } else {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    if (prev_btn !=nil){
        prev_btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [ prev_btn setTitleColor:[UIColor colorWithRed:160/255.0 green:125/255.0 blue:53/255.0 alpha:1.0] forState:UIControlStateNormal ] ;
    }
    [UIView commitAnimations];
    //   }
}



-(void)zoomButton:(UIView *)btn
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	anim.duration = 0.35;
	anim.repeatCount = 1;
	anim.autoreverses = YES;
	anim.removedOnCompletion = YES;
	anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.5)];
	//anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(80, 1, 3, 3.0)];
	
	[btn.layer addAnimation:anim forKey:nil];
    float move1=subcatScroller.contentOffset.x+(([UIScreen mainScreen].bounds.size.width/2));
    float move2=btn.frame.origin.x+(btn.frame.size.width/2);
    float test =  (([UIScreen mainScreen].bounds.size.width/2)-btn.frame.origin.x-(btn.frame.size.width/2));
    
    float diff=move1-move2;
    [subcatScroller setContentOffset:CGPointMake(0, btn.frame.origin.y) animated:YES];
    [subcatScroller setContentOffset:CGPointMake(test*-1, btn.frame.origin.y) animated:YES];
    [self changeFontSize:btn];
    
       

}

-(UILabel*)KinaraaddCategoryTitle:(NSInteger)index labelValue:(NSString*)Lvalue
{
    CGRect labelframe=CGRectMake(20, 0, 120, 50);
    UILabel *categoryTitle=[[UILabel alloc]initWithFrame:labelframe];
    categoryTitle.backgroundColor=[UIColor clearColor];
    categoryTitle.numberOfLines=2;
    categoryTitle.tag=index;
    categoryTitle.text=[Lvalue uppercaseString];
    categoryTitle.font=[UIFont boldSystemFontOfSize:14];
    categoryTitle.textAlignment=NSTextAlignmentCenter;
    return categoryTitle;
}


-(IBAction)KinaraCategoryClicked:(id)sender
{
    [self UnselectedBottomMenu];
      OrderSummaryButton.selected=NO;
    
    [subcategoryList removeAllObjects];
    [subcategoryIdList removeAllObjects];
    
    KinaraCategoryBtnClick=true;
    
    UIButton *btn=(UIButton*)sender;
    
    KinaraSelectedCategoryName=[btn.titleLabel.text copy];
    KinaraSelectedCategoryID=btn.tag;
    
    self.selectedCategoryID=[NSString stringWithFormat:@"%d",KinaraSelectedCategoryID];
    
    float move1=KinaraCurrentScrollPositionPoint.x+(([UIScreen mainScreen].bounds.size.width/2));
    float move2=btn.frame.origin.x+(btn.frame.size.width/2);
    
    float diff=move1-move2;
    
    if(KinaraCategory.contentOffset.x+[UIScreen mainScreen].bounds.size.width-diff+153 > KinaraCategory.contentSize.width || KinaraCategory.contentOffset.x-153-diff < 0)
    {
        [KinaraCategory setContentOffset:KinaraOriginalScrollPositionPoint animated:YES];
    }
    else
    {
        [KinaraCategory setContentOffset:CGPointMake(KinaraCurrentScrollPositionPoint.x-diff,KinaraCurrentScrollPositionPoint.y) animated:YES];
    }
    
    KinaraCurrentScrollPositionPoint=KinaraCategory.contentOffset;
    KinaraCategoryBtnClick=false;
}

-(IBAction)overviewBtnClicked:(id)sender{
    
    [mainMenu setHidden:FALSE]; // Changed
    

    [orderSummaryView.view removeFromSuperview];
    [feedbackView.view removeFromSuperview];
    [searchView.view removeFromSuperview];
    overviewMenuButton.selected = NO;
    
    overviewMenuView.hidden=YES;
    KinaraSubCategory.hidden=YES;
    [self.view bringSubviewToFront:swipeView];

    UIButton *btn=(UIButton*)sender;
    NSString *btnVal = [NSString stringWithFormat:@"%d",btn.tag ];
    NSArray *chunks = [btnVal componentsSeparatedByString: @"1001"];
    //int subCat = [(NSString*)[chunks objectAtIndex:0] intValue];
    btnn = (UIButton*)[KinaraSubCategory viewWithTag:[(NSString*)chunks[1] intValue]];
    
    ////NSLOG(@"chunk = %@", chunks);
    
    if (KinaraSelectedCategoryID != [chunks[0] intValue]){
       // KinaraSelectedCategoryID = [(NSString*)[chunks objectAtIndex:0] intValue];
    [self KinaraCategoryClicked3:[(NSString*)chunks[0] intValue ]];
        if (KinaraSelectedSubCategoryID != [chunks[1] intValue]){
           // [self resetSCat];
            //[self performSelector:@selector(KinaraSubCategoryClicked3:) withObject:sender afterDelay:0.01];
            [ self KinaraSubCategoryClicked3:sender];
        }
    }
    else{
        [self KinaraCategoryClicked3:[(NSString*)chunks[0] intValue ]];

    if (KinaraSelectedSubCategoryID != [chunks[1] intValue]){
       // [self resetSubCat];
   // [self performSelector:@selector(KinaraSubCategoryClicked3:) withObject:sender afterDelay:0.01];
        [self KinaraSubCategoryClicked3:sender];
    }
    }
   // [self KinaraSubCategoryClicked2:[(NSString*)[chunks objectAtIndex:0] intValue]];
}

-(IBAction)displayOverview
{
    favorite_status = FALSE;
    bestsellersOpened = FALSE;
    searchOpened = FALSE;
    
    UIView *gift_view = [self.view viewWithTag:8888];
    
    if(gift_view != nil)
    {
        [gift_view setHidden:TRUE];
    }

    if(searchStatus) {
        [self.search sendActionsForControlEvents:UIControlEventTouchUpInside];
        searchStatus = FALSE;
        return;
    }
    
    [self hideUnhideComponents:TRUE];
    [mainMenu setHidden:FALSE];
    
    if(!searchView.view.isHidden)
        [searchView.view setHidden:TRUE];

    [favouriteView.view setHidden:TRUE];

   
    //return;
    
    if ([[ShareableData sharedInstance].isQuickOrder isEqualToString:@"0"]){
   // if (KinaraSelectedCategoryID !=8){
    overviewMenuButton.selected = YES;
    [self UnselectedBottomMenu];
    OrderSummaryButton.selected=NO;
  //  [self resetCat];
    //KinaraSelectedCategoryID = 8;
        overviewMenuView.hidden = NO;
        KinaraSubCategory.hidden=YES;
        menuQuick.view.hidden=TRUE;
        [menuTable setAlpha:1.0];
        [self.view bringSubviewToFront:mainMenu];
        
    [self.view bringSubviewToFront:overviewMenuView];
    [self performSelector:@selector(bringMenuToFront) withObject:nil afterDelay:0.4];
    }else{
        overviewMenuButton.selected = YES;
        [self UnselectedBottomMenu];
        OrderSummaryButton.selected=NO;
        //  [self resetCat];
        //KinaraSelectedCategoryID = 8;
        menuQuick.view.hidden = NO;
        KinaraSubCategory.hidden=YES;
        [self.view bringSubviewToFront:menuQuick.view];
    }
    
}


-(void)bringMenuToFront
{
    [self.view bringSubviewToFront:overviewMenuView];
}


-(IBAction)KinaraCategoryClicked2:(int)sender
{
    [self UnselectedBottomMenu];
      OrderSummaryButton.selected=NO;
    
    [subcategoryList removeAllObjects];
    [subcategoryIdList removeAllObjects];
    
    KinaraCategoryBtnClick=true;
    
    UIButton *btn=(UIButton *)[self.view viewWithTag:sender];

    
    KinaraSelectedCategoryName=btn.titleLabel.text;
    KinaraSelectedCategoryID=sender;
    
    self.selectedCategoryID=[NSString stringWithFormat:@"%d",KinaraSelectedCategoryID];
    
    float move1=KinaraCurrentScrollPositionPoint.x+(([UIScreen mainScreen].bounds.size.width/2));
    float move2=btn.frame.origin.x+(btn.frame.size.width/2);
    
    float diff=move1-move2;
    
    if(KinaraCategory.contentOffset.x+[UIScreen mainScreen].bounds.size.width-diff+153 > KinaraCategory.contentSize.width || KinaraCategory.contentOffset.x-153-diff < 0)
    {
        [KinaraCategory setContentOffset:KinaraOriginalScrollPositionPoint animated:YES];
    }
    else
    {
        [KinaraCategory setContentOffset:CGPointMake(KinaraCurrentScrollPositionPoint.x-diff,KinaraCurrentScrollPositionPoint.y) animated:YES];
    }
    
    KinaraCurrentScrollPositionPoint=KinaraCategory.contentOffset;
    KinaraCategoryBtnClick=false;
}
-(void)resetCat{
   /* if (KinaraSelectedCategoryID == 8){
    [KinaraCategory setContentOffset:CGPointMake(KinaraOriginalScrollPositionPoint.x-100,KinaraOriginalScrollPositionPoint.y) animated:YES];
    KinaraCurrentScrollPositionPoint=KinaraCategory.contentOffset;
    }else{*/
       [KinaraCategory setContentOffset:KinaraOriginalScrollPositionPoint animated:NO];
        KinaraCurrentScrollPositionPoint=KinaraCategory.contentOffset;
        
   // }
    
}
-(IBAction)KinaraCategoryClicked3:(int)sender
{
    [self UnselectedBottomMenu];
      OrderSummaryButton.selected=NO;
    
    [subcategoryList removeAllObjects];
    [subcategoryIdList removeAllObjects];
    
    KinaraCategoryBtnClick=true;
    NSArray *subviews = [KinaraCategory subviews];
    
    UIButton *btn=(UIButton *)[self.view viewWithTag:sender];
   // [KinaraCategory setContentOffset:KinaraOriginalScrollPositionPoint animated:YES];
  //  KinaraCurrentScrollPositionPoint=KinaraCategory.contentOffset;
   
    
    for(id subview in subviews ){
        
        if ([subview isKindOfClass:[UIButton class]] && [subview tag] ==btn.tag && [subview frame].origin.x >764){
            btn = (UIButton*)subview;
            break;
        }
        
        
    }

    
    
    KinaraSelectedCategoryName=btn.titleLabel.text;
    KinaraSelectedCategoryID=sender;
    
    self.selectedCategoryID=[NSString stringWithFormat:@"%d",KinaraSelectedCategoryID];
    
    float move1=KinaraCurrentScrollPositionPoint.x+(([UIScreen mainScreen].bounds.size.width/2));
    float move2=btn.frame.origin.x+(btn.frame.size.width/2);
    
    float diff=move1-move2;
    
    if(KinaraCategory.contentOffset.x+[UIScreen mainScreen].bounds.size.width-diff+153 > KinaraCategory.contentSize.width || KinaraCategory.contentOffset.x-153-diff < 0)
    {
        [KinaraCategory setContentOffset:KinaraOriginalScrollPositionPoint animated:NO];
    }
    else
    {
        [KinaraCategory setContentOffset:CGPointMake(KinaraCurrentScrollPositionPoint.x-diff,KinaraCurrentScrollPositionPoint.y) animated:NO];
    }
    
    KinaraCurrentScrollPositionPoint=KinaraCategory.contentOffset;
    KinaraCategoryBtnClick=false;
    
    KinaraSubcategoryBtnClick=false;
    @try
    {
        [KinaraSubCategory removeFromSuperview];
        [KinaraSelectorSubCategory removeFromSuperview];
    }
    @catch (NSException *exception)
    {
        DLog(@"Exception");
    }
    @finally
    {
        //if ([isRecon isEqualToString:@"0"]){
        [self KinarafindingSelectedCategory:KinaraCategory];
        // }
        
        [self KinaraGetSubCategoryData:self.selectedCategoryID];
        
        KinaraSelectorSubCategory=[UIButton buttonWithType:UIButtonTypeCustom];
        [KinaraSelectorSubCategory setHidden:TRUE];
        [KinaraSelectorSubCategory setImage:[UIImage imageNamed:@"subcategory_selected1.png"] forState:UIControlStateNormal];
        [KinaraSelectorSubCategory setImage:[UIImage imageNamed:@"subcategory_selected1.png"] forState:UIControlStateHighlighted];
        [KinaraSelectorSubCategory setImage:[UIImage imageNamed:@"subcategory_selected1.png"] forState:UIControlStateSelected];
        
        if([self.subcategoryList count]>0)
        {
            KinaraSelectorSubCategory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-76.5, KinaraCategory.frame.origin.y+65, 153, 50);
            KinaraSubCategory = [[UIScrollView alloc] initWithFrame:CGRectMake(-25, KinaraCategory.frame.origin.y+65,[UIScreen mainScreen].bounds.size.width, 50)];
            [self KinaracreateSubCategoryScrollView:KinaraNumberOfButton frame:CGRectMake(0,0, 153,50) scrollView:KinaraSubCategory];
        }
        else
        {
            KinaraSubCategory = [[UIScrollView alloc] initWithFrame:CGRectMake(-25,KinaraCategory.frame.origin.y+65,0, 0)];
            [KinaraSubCategory setHidden:TRUE];
            [self KinaracreateSubCategoryScrollView:0  frame:CGRectMake(0,0, 0,0) scrollView:KinaraSubCategory];
            KinaraSelectorSubCategory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-76.5,  KinaraCategory.frame.origin.y+65, 0, 0);
        }
        
        [KinaraSelectorSubCategory setAlpha:0.5];
        
        CGRect frm = KinaraSelectorSubCategory.frame;
        [KinaraSelectorSubCategory setFrame:CGRectMake(frm.origin.x+1, frm.origin.y, frm.size.width-2, frm.size.height-2)];

        [self.view bringSubviewToFront:KinaraSelectorSubCategory];
        [self.view addSubview:KinaraSelectorSubCategory];
        
        [KinaraSubCategory setHidden:TRUE];
        [self KinarafindingSelectedCategory:KinaraSubCategory];
        
        
        
        if([self.subcategoryList count]>0)
            [self KinarasetCategoryClicked:KinaraSelectedCategoryID];
            [self KinarasetSubCategoryClicked:KinaraSelectedSubCategoryID];
        
    }
    
    if(KinaraSelectorCategory.hidden)
    {
        //KinaraSelectorCategory.hidden=NO;
        [self UnselectedBottomMenu];
          OrderSummaryButton.selected=NO;
    }

//[self performSelector:@selector(subCatAction:) withObject:prev_btn afterDelay:8.0];
    [self subCatAction:temp_btn];
}

-(void)resetSubCat{
    [KinaraSubCategory setContentOffset:KinaraOriginalScrollPositionPointSub animated:NO];
    KinaraCurrentScrollPositionPointSub=KinaraSubCategory.contentOffset;
}


-(IBAction)KinaraSubCategoryClicked3:(id)sender
{
    UIButton *btn2=(UIButton*)sender;
    NSString *btnVal = [NSString stringWithFormat:@"%d",btn2.tag ];
    NSArray *chunks = [btnVal componentsSeparatedByString: @"1001"];
    //int subCat = [(NSString*)[chunks objectAtIndex:0] intValue];
    btnn = (UIButton*)[KinaraSubCategory viewWithTag:[(NSString*)chunks[1] intValue]];
    KinaraSubcategoryBtnClick=true;
    NSArray *subviews = [KinaraSubCategory subviews];

    UIButton *btn=btnn;
   // [KinaraSubCategory setContentOffset:KinaraOriginalScrollPositionPointSub animated:YES];
   //KinaraCurrentScrollPositionPointSub=KinaraSubCategory.contentOffset;
    for(id subview in subviews ){
        
        if ([subview isKindOfClass:[UIButton class]] && [subview tag] ==btn.tag && [subview frame].origin.x >764){
            btn = (UIButton*)subview;
            selectedButton = btn;
            break;
        }
        
        
    }
    
    KinaraSelectedSubCategoryName=btn.titleLabel.text;
    KinaraSelectedSubCategoryID=btn.tag;
    
    float move1=KinaraCurrentScrollPositionPointSub.x+(([UIScreen mainScreen].bounds.size.width/2));
    float move2=btn.frame.origin.x+(btn.frame.size.width/2);
    
    float diff=move1-move2;
    
    if(KinaraSubCategory.contentOffset.x+[UIScreen mainScreen].bounds.size.width-diff+153 > KinaraSubCategory.contentSize.width || KinaraSubCategory.contentOffset.x-153-diff < 0)
    {
        [KinaraSubCategory setContentOffset:KinaraOriginalScrollPositionPointSub animated:NO];
    }
    else
    {
        [KinaraSubCategory setContentOffset:CGPointMake(KinaraCurrentScrollPositionPointSub.x-diff-24.5,KinaraCurrentScrollPositionPointSub.y) animated:NO];
    }
    KinaraCurrentScrollPositionPointSub=KinaraSubCategory.contentOffset;
    KinaraSubcategoryBtnClick=false;
    [KinaraSubCategory setHidden:TRUE];
    [self KinarafindingSelectedCategory:KinaraSubCategory];
    [self KinarasetSubCategoryClicked:KinaraSelectedSubCategoryID];
  // self subCatAction:<#(id)#>
}
-(IBAction)KinaraSubCategoryClicked:(id)sender
{
    
    ////NSLOG(@"sub cat clicked, btn = %@,   title = %@", sender, [(UIButton *)sender titleForState:UIControlStateNormal]);
    KinaraSubcategoryBtnClick=true;
    
    UIButton *btn=(UIButton*)sender;
    
   
    
    KinaraSelectedSubCategoryName=btn.titleLabel.text;
    KinaraSelectedSubCategoryID=btn.tag;
    
    float move1=KinaraCurrentScrollPositionPointSub.x+(([UIScreen mainScreen].bounds.size.width/2));
    float move2=btn.frame.origin.x+(btn.frame.size.width/2);
    
    float diff=move1-move2;
    
    if(KinaraSubCategory.contentOffset.x+[UIScreen mainScreen].bounds.size.width-diff+153 > KinaraSubCategory.contentSize.width || KinaraSubCategory.contentOffset.x-153-diff < 0)
    {
       // [KinaraSubCategory setContentOffset:KinaraOriginalScrollPositionPointSub animated:YES];
       
        //[subcatScroller setContentOffset:KinaraOriginalScrollPositionPointSub animated:YES];

        [KinaraSubCategory setContentOffset:KinaraOriginalScrollPositionPointSub animated:YES];
    }
    else
    {
        //  [subcatScroller setContentOffset:CGPointMake(btn.frame.origin.x, btn.frame.origin.y) animated:YES];
        [KinaraSubCategory setContentOffset:CGPointMake(KinaraCurrentScrollPositionPointSub.x-diff-24.5,KinaraCurrentScrollPositionPointSub.y) animated:YES];
    }
    KinaraCurrentScrollPositionPointSub=subcatScroller.contentOffset;//KinaraSubCategory.contentOffset;
    KinaraSubcategoryBtnClick=false;
    

}



-(IBAction)KinaraSubCategoryClicked2:(int)sender
{
    ////NSLOG(@"copy of subcat action clicked");
    KinaraSubcategoryBtnClick=true;
    
    UIButton *btn=(UIButton *)[KinaraSubCategory viewWithTag:sender];
    
    KinaraSelectedSubCategoryName=btn.titleLabel.text;
    KinaraSelectedSubCategoryID=btn.tag;
    
    float move1=KinaraCurrentScrollPositionPointSub.x+(([UIScreen mainScreen].bounds.size.width/2));
    float move2=btn.frame.origin.x+(btn.frame.size.width/2);
    
    float diff=move1-move2;
    
    if(KinaraSubCategory.contentOffset.x+[UIScreen mainScreen].bounds.size.width-diff+153 > KinaraSubCategory.contentSize.width || KinaraSubCategory.contentOffset.x-153-diff < 0)
    {
        [KinaraSubCategory setContentOffset:KinaraOriginalScrollPositionPoint animated:YES];
    }
    else
    {
        [KinaraSubCategory setContentOffset:CGPointMake(KinaraCurrentScrollPositionPointSub.x-diff-24.5,KinaraCurrentScrollPositionPointSub.y) animated:YES];
    }
    KinaraCurrentScrollPositionPointSub=KinaraSubCategory.contentOffset;
    KinaraSubcategoryBtnClick=false;
}


-(void)KinarafindingSelectedCategory:(UIScrollView*)scrollView
{
    
    for (UIView *v in scrollView.subviews)
    {
        if ([v isKindOfClass:[UIButton class]])
        {
            UIButton *btn=(UIButton*)v;
            
            float x1=scrollView.contentOffset.x+(([UIScreen mainScreen].bounds.size.width/2)-(btn.frame.size.width/2));
            float x2=scrollView.contentOffset.x+(([UIScreen mainScreen].bounds.size.width/2)+(btn.frame.size.width/2));
            float BtnMidPoint=btn.frame.origin.x+(btn.frame.size.width/2);
            if(BtnMidPoint >= x1 && BtnMidPoint <= x2)
            {
                if(scrollView==KinaraCategory)
                {
                    KinaraSelectedCategoryName=btn.titleLabel.text;
                    KinaraSelectedCategoryID=btn.tag;
                    
                    self.selectedCategoryID=[NSString stringWithFormat:@"%d",KinaraSelectedCategoryID];
                    
                    DLog(@"Selected Category Tag : %d",KinaraSelectedCategoryID);
                    DLog(@"Selected Category Name : %@",KinaraSelectedCategoryName);
                }
                else if(scrollView==KinaraSubCategory)
                {
                    KinaraSelectedSubCategoryID=btn.tag;
                    KinaraSelectedSubCategoryName=btn.titleLabel.text;
                    
                    DLog(@"Selected SubCategory Tag : %d",KinaraSelectedSubCategoryID);
                    DLog(@"Selected SubCategory Name : %@",KinaraSelectedSubCategoryName);
                }
                break;
            }
        }
    }
    
}



-(void)swapMenuView
{
    
    [menulistView3 reloadDataOfSubCat:subcategoryIdList[currentSubTag+1] cat:self.selectedCategoryID];
    [menulistView3.DishList reloadData];
    
    TabMainCourseMenuListViewController *swapController = [[TabMainCourseMenuListViewController alloc]initWithNibName:@"TabMainCourseMenuListViewController" bundle:nil];
    swapController.menuview=self;
    [swapController reloadDataOfSubCat:subcategoryIdList[currentSubTag+1] cat:self.selectedCategoryID];
    [swapController.DishList reloadData];
    TabMainCourseMenuListViewController *swapController2 = [[TabMainCourseMenuListViewController alloc]initWithNibName:@"TabMainCourseMenuListViewController" bundle:nil];
    swapController2.menuview=self;
    [swapController2 reloadDataOfSubCat:subcategoryIdList[currentSubTag-1] cat:self.selectedCategoryID];
    [swapController2.DishList reloadData];
    TabMainCourseMenuListViewController *swapController3 = [[TabMainCourseMenuListViewController alloc]initWithNibName:@"TabMainCourseMenuListViewController" bundle:nil];
    swapController3.menuview=self;
    [swapController3 reloadDataOfSubCat:subcategoryIdList[currentSubTag] cat:self.selectedCategoryID];
    [swapController3.DishList reloadData];

    [menulistView3 reloadDataOfSubCat:subcategoryIdList[currentSubTag] cat:self.selectedCategoryID];
    [menulistView3.DishList reloadData];
    
   // menulistView1 = swapController3;
    //menulistView3 = swapController2;
    
    //menulistView2 = swapController;
    
    menulistView1 = menulistView2;
    menulistView2=swapController2;
   // menulistView3 = swapController;
   // menulistView3 = swapController;
    
   
    
}

-(void)swapMenuView1
{
    [menulistView2 reloadDataOfSubCat:@"0" cat:self.selectedCategoryID];
    [menulistView2.DishList reloadData];
    TabMainCourseMenuListViewController *swapController = menulistView1;
    menulistView1 = menulistView2;
    menulistView2 = swapController;
}


-(void)swapBeverageView
{
    
    [beveragesBeerView2 reloadDataOfSubCat:subcategoryIdList[currentSubTag] cat:self.selectedCategoryID];
    [beveragesBeerView2.beverageView reloadData];
    TabSquareBeerController *swapController = beveragesBeerView1;
    beveragesBeerView1 = beveragesBeerView2;
    beveragesBeerView2 = swapController;
}



////////////////////   ScrollView Delegates start //////////////////

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    UIScrollView *swipe=(UIScrollView*)sender;
    if(swipe==swipeView)
    {
        ////NSLOG(@"Does come in scrollview did scroll...");

        CGFloat pageWidth = swipeView.frame.size.width;
        float fractionalPage = swipeView.contentOffset.x / pageWidth;
        
        NSInteger lowerNumber = floor(fractionalPage);
        NSInteger upperNumber = lowerNumber + 1;
        int CatID=KinaraSelectedCategoryID;
        int subtag=[self getSubCategoryArrayIndex:KinaraSelectedSubCategoryID];
        if([[TabSquareDBFile sharedDatabase] isBevCheck: [NSString stringWithFormat:@"%d",CatID] ]&&[subcategoryDisplayList[subtag]isEqualToString:@"1"])
        {
            [self setpageIndexInBeverage:lowerNumber UperNum:upperNumber];
        }
        else {
            [self setpageIndexInMenuList:lowerNumber UperNum:upperNumber];
        }
        
    }
    
    
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
   // [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if(scrollView==swipeView)
    {
        CGFloat pageWidth = swipeView.frame.size.width; 
        float fractionalPage = swipeView.contentOffset.x / pageWidth;
        NSInteger nearestNumber = lround(fractionalPage);
        int catId= KinaraSelectedCategoryID;
        int subtag=[self getSubCategoryArrayIndex:KinaraSelectedSubCategoryID];
        if([[TabSquareDBFile sharedDatabase] isBevCheck: [NSString stringWithFormat:@"%d",catId] ]&&[subcategoryDisplayList[subtag]isEqualToString:@"1"])
        {
            if(beveragesBeerView1.pageIndex!=nearestNumber)
            {
                currentSubTag=beveragesBeerView2.pageIndex;
                KinaraSelectedSubCategoryID=[subcategoryIdList[currentSubTag]intValue];
                KinaraSelectedSubCategoryName=subcategoryList[currentSubTag];
                [KinaraSubCategory setHidden:TRUE];
                [self KinaraStartSubCategory:KinaraSubCategory subID:subcategoryIdList[currentSubTag]];
                [self swapBeverageView];
            }
            //code for circular
            /* else 
             {
             if(nearestNumber==[subcategoryList count]-1)
             {
             [self setSwipeView];
             [self applyNewIndex1:0 pageController:beveragesBeerView2];
             currentSubTag=beveragesBeerView2.pageIndex;
             KinaraSelectedSubCategoryID=[[subcategoryIdList objectAtIndex:currentSubTag]intValue];
             KinaraSelectedSubCategoryName=[subcategoryList objectAtIndex:currentSubTag];
             [self KinaraStartSubCategory:KinaraSubCategory subID:[subcategoryIdList objectAtIndex:currentSubTag]];
             [self swapBeverageView];
             }
             
             }*/
        }
        else 
        {
            if (menulistView1.pageIndex != nearestNumber)
            {
                currentSubTag=menulistView2.pageIndex;
                ////NSLOG(@"Current sub tag 1= %d", currentSubTag);
                KinaraSelectedSubCategoryID=[subcategoryIdList[currentSubTag]intValue];
                KinaraSelectedSubCategoryName=subcategoryList[currentSubTag];
                [KinaraSubCategory setHidden:TRUE];
                [self KinaraStartSubCategory:KinaraSubCategory subID:subcategoryIdList[currentSubTag]];
                
                //this is for slow move from current position
                //[KinaraSubCategory setContentOffset:CGPointMake(KinaraCurrentScrollPositionPointSub.x+180,KinaraCurrentScrollPositionPointSub.y) animated:YES];
                //KinaraCurrentScrollPositionPointSub=KinaraSubCategory.contentOffset;
               
                [self swapMenuView];
                
            }
            else
            {
                if(nearestNumber==[subcategoryIdList count]-1)
                {
                    categorytag++;
                    self.selectedCategoryID=categoryIdList[categorytag];
                    [self KinaraGetSubCategoryData:categoryIdList[categorytag]];
                    [self KinaraRollCategory:KinaraCategory subID:selectedCategoryID];
                    if([subcategoryIdList count]!=0)
                    {
                        currentSubTag=0;
                        ////NSLOG(@"Current sub tag 2= %d", currentSubTag);
                        KinaraSelectedSubCategoryID=[subcategoryIdList[currentSubTag]intValue];
                        KinaraSelectedSubCategoryName=subcategoryList[currentSubTag];
                        //[self removeSwipeSubviews];
                        [self setSwipeView];
                        [self applyNewIndex:0 pageController:menulistView2];
                        [self applyNewIndex:2 pageController:menulistView3];
                        [self swapMenuView];
                    }
                    else
                    {
                        [self setSwipeView];
                        //[self applyNewIndex:0 pageController:menulistView1];
                        [self applyNewIndex:0 pageController:menulistView2];
                        [self applyNewIndex:2 pageController:menulistView3];
                        [self swapMenuView1];
                        
                    }
                    
                    
                }
            }
            
        }
        
    }
    else if(scrollView==KinaraCategory)
    {
        KinaraSubcategoryBtnClick=false;
        @try 
        {
            [KinaraSubCategory removeFromSuperview]; 
            [KinaraSelectorSubCategory removeFromSuperview];
        }
        @catch (NSException *exception)
        {
            DLog(@"Exception");
        }
        @finally
        {
            //if ([isRecon isEqualToString:@"0"]){
            [self KinarafindingSelectedCategory:scrollView];
           // }
            
            [self KinaraGetSubCategoryData:self.selectedCategoryID];
            
            KinaraSelectorSubCategory=[UIButton buttonWithType:UIButtonTypeCustom];
            [KinaraSelectorSubCategory setHidden:TRUE];
            [KinaraSelectorSubCategory setImage:[UIImage imageNamed:@"subcategory_selected1.png"] forState:UIControlStateNormal];
            [KinaraSelectorSubCategory setImage:[UIImage imageNamed:@"subcategory_selected1.png"] forState:UIControlStateHighlighted];
            [KinaraSelectorSubCategory setImage:[UIImage imageNamed:@"subcategory_selected1.png"] forState:UIControlStateSelected];
            
            if([self.subcategoryList count]>0)
            {
                KinaraSelectorSubCategory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-76.5, KinaraCategory.frame.origin.y+65, 153, 50);
                KinaraSubCategory = [[UIScrollView alloc] initWithFrame:CGRectMake(-25, KinaraCategory.frame.origin.y+65,[UIScreen mainScreen].bounds.size.width, 50)];
                ////NSLOG(@"Calling from here...");
                [KinaraSubCategory setHidden:TRUE];
                [self KinaracreateSubCategoryScrollView:KinaraNumberOfButton frame:CGRectMake(0,0, 153,50) scrollView:KinaraSubCategory];
            }
            else
            {
                KinaraSubCategory = [[UIScrollView alloc] initWithFrame:CGRectMake(-25,KinaraCategory.frame.origin.y+65,0, 0)];
                [KinaraSubCategory setHidden:TRUE];
                [self KinaracreateSubCategoryScrollView:0  frame:CGRectMake(0,0, 0,0) scrollView:KinaraSubCategory];
                KinaraSelectorSubCategory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-76.5,  KinaraCategory.frame.origin.y+65, 0, 0);
            }
            
            [self.view bringSubviewToFront:KinaraSelectorSubCategory];
            [KinaraSelectorSubCategory setAlpha:0.5];
            CGRect frm = KinaraSelectorSubCategory.frame;
            [KinaraSelectorSubCategory setFrame:CGRectMake(frm.origin.x+1, frm.origin.y, frm.size.width-2, frm.size.height-2)];
            [self.view addSubview:KinaraSelectorSubCategory];
            [self KinarafindingSelectedCategory:KinaraSubCategory];
            [self KinarasetCategoryClicked:KinaraSelectedCategoryID];
            if([self.subcategoryList count]>0)
            {
                ////NSLOG(@"selected sub_cat_id = %d", KinaraSelectedSubCategoryID);
                 [self KinarasetSubCategoryClicked:KinaraSelectedSubCategoryID];
            }
            
            ////NSLOG(@"Log xx 7");
            
        }
        
        if(KinaraSelectorCategory.hidden)
        {
            //KinaraSelectorCategory.hidden=NO;
            [self UnselectedBottomMenu];
              OrderSummaryButton.selected=NO;
        }
    }
    else if(scrollView==KinaraSubCategory)
    {
        [self KinarafindingSelectedCategory:scrollView];
        [self KinarasetSubCategoryClicked:KinaraSelectedSubCategoryID];
    }
    
   
}


-(int)getCategoryArrayIndex:(int)Value
{
    for(int i=0;i<[categoryIdList count];i++)
    {
        int v=[categoryIdList[i] intValue];
        if(v==Value)
            return i;
    }
    return -1;
}

-(void)KinarasetCategoryClicked:(int)tag
{
    [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
    hasLoaded = 0;
    DLog(@"Tag = %d",tag);
    categorytag=[self getCategoryArrayIndex:tag];
    
    [ShareableData sharedInstance].TaskType=@"1";
    [self removeSwipeSubviews];
    
    int CatID= [categoryIdList[categorytag]integerValue];
    int subtag=[self getSubCategoryArrayIndex:KinaraSelectedSubCategoryID];
    if( [[TabSquareDBFile sharedDatabase] isBevCheck: [NSString stringWithFormat:@"%d",CatID] ]&&[subcategoryDisplayList[subtag]isEqualToString:@"1"])
    {
        if([[ShareableData sharedInstance].IsViewPage count]==0)
        {
            [[ShareableData sharedInstance].IsViewPage addObject:@"beverage_main"];
        }
        else 
        {
            ([ShareableData sharedInstance].IsViewPage)[0] = @"beverage_main";
        }
        swipeView.hidden=NO;
        [self KinaraGetSubCategoryData:categoryIdList[categorytag]];
        [self setSwipeView];
        [self applyNewIndex1:0 pageController:beveragesBeerView1];
        [self applyNewIndex1:1 pageController:beveragesBeerView2];
        
        [self removeAllView];
        
        int cc=[subcategoryIdList count];
        //DLog(@"Total Sub : %d",cc);
        if(cc > 0)
        {
            [self beveragesClicked:0];
        }
        else
        {
            [self beveragesSubCategoryClicked:0 sub:@"0"];    
        }
        
    }
    else 
    {
        if([[ShareableData sharedInstance].IsViewPage count]==0)
        {
            [[ShareableData sharedInstance].IsViewPage addObject:@"main_detail"];
        }
        else 
        {
            ([ShareableData sharedInstance].IsViewPage)[0] = @"main_detail";
        }
        swipeView.hidden=NO;
        [self KinaraGetSubCategoryData:categoryIdList[categorytag]];
        [self setSwipeView];
        [self applyNewIndex:0 pageController:menulistView1];
        [self applyNewIndex:1 pageController:menulistView2];
         [self applyNewIndex:2 pageController:menulistView3];
        [self removeAllView];
        
        int cc=[subcategoryIdList count];
        //DLog(@"Total Sub : %d",cc);
        if(cc > 0)
        {
            [self CategotyMenuSelected:0];
        }
        else
        {
            [self mainSubCategoryClicked:0 sub:@"0"];
        }
    }
}

-(int)getSubCategoryArrayIndex:(int)Value
{
    for(int i=0;i<[subcategoryIdList count];i++)
    {
        int v=[subcategoryIdList[i] intValue];
        if(v==Value)
            return i;
    }
    return -1;
}

-(void)KinarasetSubCategoryClicked:(int)tag
{
    [ShareableData sharedInstance].TaskType=@"1";
    
    int CatID=[categoryIdList[categorytag] intValue];
   // if (CatID == 8){
        [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
  //  }else{
   //     [ShareableData sharedInstance].swipeView.scrollEnabled=YES;
   // }
    [orderSummaryView.view removeFromSuperview];
    int subtag=[self getSubCategoryArrayIndex:tag];
    if(CatID==1)
    {
        [menulistView.menudetailView.view removeFromSuperview];
    }
    else if([[TabSquareDBFile sharedDatabase] isBevCheck: [NSString stringWithFormat:@"%d",CatID] ]&&[subcategoryDisplayList[subtag]isEqualToString:@"1"])
    {
        [self beveragesSubCategoryClicked:0 sub:subcategoryIdList[subtag]];
        [menulistView.menudetailView.view removeFromSuperview];
        beveragesBeerView.view.hidden = NO;
        beveragesBeerView1.view.hidden = NO;
        beveragesBeerView2.view.hidden = NO;
    }
    else if([[TabSquareDBFile sharedDatabase] isBevCheck: [NSString stringWithFormat:@"%d",CatID] ]&&[subcategoryDisplayList[subtag]isEqualToString:@"0"])
    {
        currentSubTag=[self getSubCategoryArrayIndex:tag];
        [self mainSubCategoryClicked:0 sub:subcategoryIdList[subtag]];
        [menulistView.menudetailView.view removeFromSuperview];
        beveragesBeerView.view.hidden = YES;
        beveragesBeerView1.view.hidden = YES;
        beveragesBeerView2.view.hidden = YES;
    }
    else
    {
        ////NSLOG(@"Log xxx 1");
        currentSubTag=[self getSubCategoryArrayIndex:tag];
        ////NSLOG(@"Log xxx 2, subcatcount = %d, subtag = %d", [subcategoryIdList count], subtag);
        [self mainSubCategoryClicked:0 sub:subcategoryIdList[subtag]];
        ////NSLOG(@"Log xxx 3");
        [menulistView.menudetailView.view removeFromSuperview];
        ////NSLOG(@"Log xxx 4");
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    ////NSLOG(@"in end deaccelerate");
    BOOL Status;
    scrollView.panGestureRecognizer.cancelsTouchesInView = YES;
    scrollView.canCancelContentTouches = YES;
    
    if (scrollView == subcatScroller){
        
        [self subCatAction:[self getNearestBtn]];
        
        
    }

    
    if(scrollView==KinaraCategory)
    {
        Status=KinaraCategoryBtnClick;
    }
    else if(scrollView==KinaraSubCategory)
    {
        Status=KinaraSubcategoryBtnClick;
    }
    else if (scrollView==swipeView  )
    {
        [self scrollViewDidEndScrollingAnimation:scrollView]; 
    }
    if(!Status)
    {
        BOOL found=false;
        float move1=0;
        float move2=0;
        
        for (UIView *v in scrollView.subviews)
        {
            if ([v isKindOfClass:[UIButton class]])
            {
                UIButton *btn=(UIButton*)v;
                
                float x1=scrollView.contentOffset.x+(([UIScreen mainScreen].bounds.size.width/2)-(btn.frame.size.width/2));
                float x2=scrollView.contentOffset.x+(([UIScreen mainScreen].bounds.size.width/2)+(btn.frame.size.width/2));
                float BtnMidPoint=btn.frame.origin.x+(btn.frame.size.width/2);
                if(scrollView==KinaraCategory){
                if(BtnMidPoint >= x1 && BtnMidPoint <= x2)
                {
                    DLog(@"%f",BtnMidPoint);
                    DLog(@"%f",x1);
                    DLog(@"%f",x2);
                    found=true;
                    move1=scrollView.contentOffset.x+(([UIScreen mainScreen].bounds.size.width/2));
                    move2=btn.frame.origin.x+(btn.frame.size.width/2);
                    break;
                }
                }else{
                    if(BtnMidPoint >= (x1+25) && BtnMidPoint <= (x2+25))
                    {
                        DLog(@"%f",BtnMidPoint);
                        DLog(@"%f",x1);
                        DLog(@"%f",x2);
                        found=true;
                        move1=scrollView.contentOffset.x+(([UIScreen mainScreen].bounds.size.width/2));
                        move2=btn.frame.origin.x+(btn.frame.size.width/2);
                        break;
                    }
                }
            }
        }
        
        if(found)
        {
            float diff=move1-move2;
            if(scrollView.contentOffset.x+[UIScreen mainScreen].bounds.size.width-diff+153 > scrollView.contentSize.width || scrollView.contentOffset.x-153-diff < 0)
            {
                if(scrollView==KinaraCategory)
                    [scrollView setContentOffset:KinaraOriginalScrollPositionPoint animated:YES];
                else
                    [scrollView setContentOffset:KinaraOriginalScrollPositionPointSub animated:YES];
            }
            else
            {
                if(scrollView==KinaraCategory){
                [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x-diff,scrollView.contentOffset.y) animated:YES];
                }else{
                    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x-diff-25,scrollView.contentOffset.y) animated:YES];
                }
            }
            
            if(scrollView==KinaraCategory)
                KinaraCurrentScrollPositionPoint=scrollView.contentOffset;
            else if(scrollView==KinaraSubCategory)
                KinaraCurrentScrollPositionPointSub=scrollView.contentOffset;
            
        }
    }
    
    
}

-(void)KinaraGetSubCategoryData:(NSString *)catID
{
    self.selectedCategoryID=catID;
    NSMutableArray *resultFromPost;
    
    for(int i=0;i<[[ShareableData sharedInstance].categoryIdList count];i++)
    {
        if([([ShareableData sharedInstance].categoryIdList)[i] isEqualToString:catID])
        {
            if([[ShareableData sharedInstance].SubCategoryList count]!=0)
            {
                resultFromPost=([ShareableData sharedInstance].SubCategoryList)[i];
                break;
            }
            
        }
    }
    
    @try
    {
        [subcategoryList removeAllObjects];
        [subcategoryIdList removeAllObjects];
        [subcategoryDisplayList removeAllObjects];
    }
    @catch (NSException *exception)
    {
        
    }
    for(int i=0;i<[resultFromPost count];i++)
    {
        NSMutableDictionary *dataitem=resultFromPost[i];
        
        if([dataitem count]!=0)
        {
            if([[NSString stringWithFormat:@"%@",dataitem[@"category_id"]] isEqualToString:catID])
            {
                [subcategoryList addObject:[NSString stringWithFormat:@"%@",dataitem[@"name"]]];
                [subcategoryIdList addObject:[NSString stringWithFormat:@"%@",dataitem[@"id"]]];
                [subcategoryDisplayList addObject:[NSString stringWithFormat:@"%@",dataitem[@"display"]]];
            }
        }
        
    }
    
}


////////////////////   ScrollView Delegates Ending //////////////////
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)onTick:(NSTimer *)timer
{
    @try {
        [self badgeRefresh];
        ////NSLOG(@"mode value = %d", [ShareableData sharedInstance].ViewMode);
        if([ShareableData sharedInstance].ViewMode==1)
        {
            OrderSummaryButton.hidden=YES;
            favourite.enabled=FALSE;
        }
        else
        {
            OrderSummaryButton.hidden=NO;
            favourite.enabled=YES;
        }
        feedback.enabled=[ShareableData sharedInstance].isConfermOrder;
        if(feedback.enabled)
        {
            FeedbackDisabled.enabled=NO;
        }
        else
        {
            FeedbackDisabled.enabled=YES;
        }
        //  CGPoint point = CGPointMake(0, 936);
        

    }
    @catch (NSException *exception) {
        
    }
    
}


-(void)setpageIndexInMenuList:(NSInteger)lowerNumber UperNum:(NSInteger)upperNumber
{
    
    if (lowerNumber == menulistView1.pageIndex) 
	{
		if (upperNumber != menulistView2.pageIndex)
		{
			[self applyNewIndex:upperNumber pageController:menulistView2];
		}
	}
	else if (upperNumber == menulistView1.pageIndex)
	{
		if (lowerNumber != menulistView2.pageIndex)
		{
			[self applyNewIndex:lowerNumber pageController:menulistView2];
		}
	}
	else
	{
		if (lowerNumber == menulistView2.pageIndex)
		{
			[self applyNewIndex:upperNumber pageController:menulistView1];
		}
		else if (upperNumber == menulistView2.pageIndex)
		{
			[self applyNewIndex:lowerNumber pageController:menulistView1];
		}
		else
		{
			[self applyNewIndex:lowerNumber pageController:menulistView1];
			[self applyNewIndex:upperNumber pageController:menulistView2];
		}
	}
}

-(void)setpageIndexInBeverage:(NSInteger)lowerNumber UperNum:(NSInteger)upperNumber
{
    
    if (lowerNumber == beveragesBeerView1.pageIndex)
	{
		if (upperNumber != beveragesBeerView2.pageIndex)
		{
			[self applyNewIndex1:upperNumber pageController:beveragesBeerView2];
		}
	}
	else if (upperNumber == beveragesBeerView1.pageIndex)
	{
		if (lowerNumber != beveragesBeerView2.pageIndex)
		{
			[self applyNewIndex1:lowerNumber pageController:beveragesBeerView2];
		}
	}
	else
	{
		if (lowerNumber == beveragesBeerView2.pageIndex)
		{
			[self applyNewIndex1:upperNumber pageController:beveragesBeerView1];
		}
		else if (upperNumber == beveragesBeerView2.pageIndex)
		{
			[self applyNewIndex1:lowerNumber pageController:beveragesBeerView1];
		}
		else
		{
			[self applyNewIndex1:lowerNumber pageController:beveragesBeerView1];
			[self applyNewIndex1:upperNumber pageController:beveragesBeerView2];
		}
	}
}



- (void)viewDidAppear:(BOOL)animated
{
    mparent=nil;///to unable the orderSummaryButton & backButton
   
    ////to hide the header 
    [subCatbg setHidden:TRUE];
    [subcatScroller setHidden:TRUE];
       [super viewDidAppear:animated];
    //[self.view sendSubviewToBack:search];
}

-(void)GetCategoryData
{
    categoryIdList=[ShareableData sharedInstance].categoryIdList;
    categoryList=[ShareableData sharedInstance].categoryList;
    
}


-(void)removeSwipeSubviews
{
    for(int i=0;i<[swipeView.subviews count];++i)
    {
        [[swipeView subviews][i] removeFromSuperview];
    }
}

-(void)removeAllView
{
    UIView *gift_view = [self.view viewWithTag:8888];
    [gift_view removeFromSuperview];

    [fbFriendview.view removeFromSuperview];
    ////[favouriteView.twitfollowerView.view removeFromSuperview];
    ////[favouriteView.fbfriendView.view removeFromSuperview];
    ////[favouriteView.lastOrderedView.view removeFromSuperview];
    [twitFriendview.view removeFromSuperview];
    [lastOrderedview.view removeFromSuperview];
    [orderSummaryView.view removeFromSuperview];
    [feedbackView.view removeFromSuperview];
    [searchView.view removeFromSuperview];
    ////[favouriteView.view removeFromSuperview];
    [beveragesBeerView1.beerDetailView.view removeFromSuperview];
    [beveragesBeerView1.view removeFromSuperview];
    [beveragesBeerView2.beerDetailView.view removeFromSuperview];
    [beveragesBeerView2.view removeFromSuperview];
    [menulistView1.menudetailView.menuDetailView.view removeFromSuperview];
    [menulistView1.menudetailView.view removeFromSuperview];
    [menulistView1.view removeFromSuperview];
    [menulistView2.menudetailView.menuDetailView.view removeFromSuperview];
    [menulistView2.menudetailView.view removeFromSuperview];
    [menulistView2.view removeFromSuperview];
    [menulistView3.menudetailView.menuDetailView.view removeFromSuperview];
    [menulistView3.menudetailView.view removeFromSuperview];
    [menulistView3.view removeFromSuperview];
}

-(void)CategotyMenuSelected:(UIButton*)button
{
    
    [self UnselectedBottomMenu];
      OrderSummaryButton.selected=NO;
    [self removeAllView];
    [swipeView addSubview:menulistView1.view];
    [swipeView addSubview:menulistView2.view];
    [swipeView addSubview:menulistView3.view];
    swipeView.clipsToBounds = NO;
    menulistView1.view.clipsToBounds=NO;
    menulistView.view.clipsToBounds = NO;
    menulistView2.view.clipsToBounds=NO;
}

-(void)beveragesClicked:(UIButton*)button
{
    [self UnselectedBottomMenu];
      OrderSummaryButton.selected=NO;
    [self removeAllView];
    [swipeView addSubview:beveragesBeerView1.view];
    [swipeView addSubview:beveragesBeerView2.view];
    swipeView.clipsToBounds = NO;
    beveragesBeerView1.view.clipsToBounds=NO;
    beveragesBeerView.view.clipsToBounds = NO;
    beveragesBeerView2.view.clipsToBounds=NO;
}




-(void)favouritesClicked:(UIButton*)button
{
    KinaraSubCategory.hidden=YES;
    KinaraSelectorSubCategory.hidden=YES;
    [self UnselectedBottomMenu];
      OrderSummaryButton.selected=NO;
    [self removeAllView];
    if([[ShareableData sharedInstance].isLogin isEqualToString:@"0"])
    {
        favouriteView.view.frame=CGRectMake(13, 160, favouriteView.view.frame.size.width, favouriteView.view.frame.size.height);
        [self.view addSubview:favouriteView.view];
        
    }
    else 
    {
        lastOrderedview.view.frame=CGRectMake(13, 160,lastOrderedview.view.frame.size.width, lastOrderedview.view.frame.size.height);
        [self.view addSubview:lastOrderedview.view];
        [lastOrderedview loadlastOrdereddata];
    }
    
}


-(void)addTapGesture
{
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    singleTap.numberOfTapsRequired=3;
    [KinaraLogo addGestureRecognizer:singleTap];
}

-(void)handleTap:(UIGestureRecognizer*)gesture
{
    if([ShareableData sharedInstance].ViewMode==2)
    { if([[ShareableData sharedInstance].isQuickOrder isEqualToString:@"0"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Option" message:nil
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go To Tbl Mgmt",@"Switch to Quick Order",nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Option" message:nil
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go To Tbl Mgmt",@"Switch to Normal Menu",nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        
    }
    }
    else if([ShareableData sharedInstance].ViewMode==1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to:" message:nil
                                                       delegate:self cancelButtonTitle:@"Go To Tbl Mgmt" otherButtonTitles:@"Cancel", nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }
}

-(void)waiterLogOutClicked
{
    /* NSString *post =[NSString stringWithFormat:@"order_id=%@",[ShareableData sharedInstance].OrderId];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"http://108.178.27.242/luigi/webs/staff_logout"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter a 4 digit password:"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    [alert release];
    DLog(@"%@",data);*/
    
    [ShareableData sharedInstance].assignedTable1=@"-1";
    [ShareableData sharedInstance].assignedTable2=@"-1";
    [ShareableData sharedInstance].assignedTable3=@"-1";
    [ShareableData sharedInstance].assignedTable4=@"-1";
    
    [[ShareableData sharedInstance].OrderItemID removeAllObjects];
    [[ShareableData sharedInstance].OrderItemName removeAllObjects];
    [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
    [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
    

    [[ShareableData sharedInstance].OrderCatId removeAllObjects];
    [[ShareableData sharedInstance].confirmOrder removeAllObjects];
    [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
    [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
    [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
    
    [[ShareableData sharedInstance].TaxList removeAllObjects];
    [[ShareableData sharedInstance].TaxNameValue removeAllObjects];
    [[ShareableData sharedInstance].inFormat removeAllObjects];
    [[ShareableData sharedInstance].isDeduction removeAllObjects];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    menulistView1=nil;
    KinaraSelectorCategory=nil;
    KinaraSelectorSubCategory=nil;
    KinaraCategory=nil;
    KinaraSubCategory=nil;
    KinaraSubategoryNameList=nil;
    KinaraSelectedCategoryName=nil;
    KinaraSelectedSubCategoryName=nil;
    favouriteView=nil;
    helpOverlay=nil;
    swipeIndicator=nil;
    swipeView=nil;
   selectedCategoryID=nil;
    menuCategory=nil;
   isRecon=nil;
    
    categoryList=nil;
    categoryIdList=nil;
    subcategoryList=nil;
   subcategoryIdList=nil;
    subcategoryDisplayList=nil;
    maincourseImage=nil;
    orderSummaryView=nil;
    menuQuick=nil;
    assignTable=nil;
    
    search=nil;
  feedback=nil;
    favourite=nil;
    help=nil;
    OrderSummaryButton=nil;
    overviewMenuButton=nil;
    KinaraLogo=nil;
    FeedbackDisabled=nil;
    btnn=nil;
    menulistView=nil;
    menulistView1=nil;
    menulistView2=nil;
    menulistView3=nil;
    helpView=nil;
   beveragesBeerView=nil;
    beveragesBeerView1=nil;
    beveragesBeerView2=nil;
    lastOrderedview=nil;
    fbFriendview=nil;
    twitFriendview=nil;
    orderSummaryView=nil;
    searchView=nil;
    feedbackView=nil;
   soupView=nil;
    subId=nil;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([ShareableData sharedInstance].ViewMode==2)
    {
        if([title isEqualToString:@"Logout"])
        {
            alertTag=1;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter a 4 digit password:"
                                                           delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            UITextField * alertTextField = [alert textFieldAtIndex:0];
            alertTextField.keyboardType = UIKeyboardTypeNumberPad;
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        }
        else if([title isEqualToString:@"Go To Tbl Mgmt"])
        {
            alertTag=2;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter a 4 digit password:"
                                                           delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            UITextField * alertTextField = [alert textFieldAtIndex:0];
            alertTextField.keyboardType = UIKeyboardTypeNumberPad;
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        }
        else if([title isEqualToString:@"OK"]&&alertTag==1)
        {
            [self waiterLogOutClicked];
            [ShareableData sharedInstance].tableNumber=@"-1";
            [ShareableData sharedInstance].isLogin=@"0";
           // TabSquareAssignTable *assignTable=[[TabSquareAssignTable alloc]initWithNibName:@"TabSquareAssignTable" bundle:nil];
           // [self presentModalViewController:assignTable animated:YES];
           // [self.parentViewController.parentViewController dismissViewControllerAnimated:YES completion:Nil];
            
            /*
            if ([ShareableData bestSellersON]){
                [categoryList removeObjectAtIndex:0];
            }
            */
             
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if([title isEqualToString:@"OK"]&&alertTag==2)
        {
            [ShareableData sharedInstance].ViewMode=2;
           /* [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OrderItemID"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OrderItemName"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OrderItemRate"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OrderCatId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsOrderCustomization"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OrderCustomizationDetail"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OrderSpecialRequest"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OrderItemQuantity"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"confirmOrder"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OrderId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"assignedTable1"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"assignedTable2"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"assignedTable3"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"assignedTable4"];*/
           // [[NSUserDefaults standardUserDefaults] synchronize];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *libraryDirectory = paths[0];
            NSString *location = [libraryDirectory stringByAppendingString:@"/orderarrays.plist"];
            
            //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"orderarrays" ofType:@"plist"];
            // NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
           // NSArray *array = [[NSArray alloc] initWithContentsOfFile:location];
            // NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"orderstrings" ofType:@"plist"];
            // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            // NSString *libraryDirectory = [paths objectAtIndex:0];
            NSString *location2 = [libraryDirectory stringByAppendingString:@"/orderstrings.plist"];
            // NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
          //  NSArray *array2 = [[NSArray alloc] initWithContentsOfFile:location2];
            
            [[NSFileManager defaultManager] removeItemAtPath:location error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:location2 error:nil];

            [ShareableData sharedInstance].assignedTable1=@"-1";
            [ShareableData sharedInstance].assignedTable2=@"-1";
            [ShareableData sharedInstance].assignedTable3=@"-1";
            [ShareableData sharedInstance].assignedTable4=@"-1";
            
            [ShareableData sharedInstance].tableNumber=@"-1";
            [[ShareableData sharedInstance].OrderItemID removeAllObjects];
            [[ShareableData sharedInstance].OrderItemName removeAllObjects];
            [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
            [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
            [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
            [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
            [[ShareableData sharedInstance].OrderCatId removeAllObjects];
            [[ShareableData sharedInstance].confirmOrder removeAllObjects];
            [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
            [[ShareableData sharedInstance].TempOrderID removeAllObjects];
          //  TabSquareTableManagement *assignTable=[[TabSquareTableManagement alloc]initWithNibName:@"TabSquareTableManagement" bundle:nil];
           // [self presentModalViewController:assignTable animated:YES];
           // [self.parentViewController.parentViewController dismissViewControllerAnimated:YES completion:Nil];
            
            /*
            if ([ShareableData bestSellersON]){
                [categoryList removeObjectAtIndex:0];
            }
            */
            
            /*========Need to apply language updation code to set English as Default here=========*/
            if(![ShareableData multiLanguageStatus]) {
                [self.flagButton setHidden:TRUE];
                return;
            }
            else {
                [self.flagButton setHidden:FALSE];
            }
            
            LanguageSelectionView *language = [[LanguageSelectionView alloc] initWithFrame:self.view.bounds sender:self.flagButton];
            [language setFlag];

            /*====================================================================================*/
            
            [self.navigationController popToRootViewControllerAnimated:YES];

        }else if([title isEqualToString:@"Switch to Quick Order"]){
            
            backupActiveLanguage = [NSString stringWithFormat:@"%@", [ShareableData sharedInstance].currentLanguage];
            [[ShareableData sharedInstance] setCurrentLanguage:ENGLISH];

            [ShareableData sharedInstance].isQuickOrder = @"1";
            [self loadQuickOrder];
            
            
        }else if([title isEqualToString:@"Switch to Normal Menu"]){
            [ShareableData sharedInstance].isQuickOrder = @"0";
           // [[ShareableData sharedInstance] setCurrentLanguage:[NSString stringWithFormat:@"%@", backupActiveLanguage]];
            [[ShareableData sharedInstance] setCurrentLanguage:ENGLISH];
            [self loadOverview];
            [self displayOverview];
        }
    }
    else
    {
        if([title isEqualToString:@"Go To Tbl Mgmt"])
        {
            
            alertTag=2;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter a 4 digit password:"
                                                           delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            UITextField * alertTextField = [alert textFieldAtIndex:0];
            alertTextField.keyboardType = UIKeyboardTypeNumberPad;
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            
        }else if([title isEqualToString:@"OK"])
        {
            [ShareableData sharedInstance].ViewMode=2;
            [ShareableData sharedInstance].assignedTable1=@"-1";
            [ShareableData sharedInstance].assignedTable2=@"-1";
            [ShareableData sharedInstance].assignedTable3=@"-1";
            [ShareableData sharedInstance].assignedTable4=@"-1";
            
            [ShareableData sharedInstance].tableNumber=@"-1";
            [[ShareableData sharedInstance].OrderItemID removeAllObjects];
            [[ShareableData sharedInstance].OrderItemName removeAllObjects];
            [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
            [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
            [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
            [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
            [[ShareableData sharedInstance].OrderCatId removeAllObjects];
            [[ShareableData sharedInstance].confirmOrder removeAllObjects];
            [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
            [[ShareableData sharedInstance].TempOrderID removeAllObjects];
            
            //[self presentModalViewController:assignTable animated:YES];
            //[self.parentViewController.parentViewController dismissViewControllerAnimated:YES completion:Nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


-(void)mainSubCategoryClicked:(UIButton*)button sub:(NSString*)sub
{
    subId=sub;
    [menulistView1.menudetailView.view removeFromSuperview];
    [menulistView1.menudetailView.menuDetailView.view removeFromSuperview];
    [menulistView2.menudetailView.view removeFromSuperview];
    [menulistView2.menudetailView.menuDetailView.view removeFromSuperview];
    [menulistView3.menudetailView.view removeFromSuperview];
    [menulistView3.menudetailView.menuDetailView.view removeFromSuperview];
    [menulistView1 reloadDataOfSubCat:subId cat:self.selectedCategoryID];
    //[menulistView1.DishList reloadData];
    
    if(![prevSubId isEqualToString:sub]) {
       // [self loadAnimation:menulistView1.DishList];
        [menulistView1.DishList reloadData];
    }

    [swipeView addSubview:menulistView1.view];
    if([self.subcategoryIdList count]!=0)
    {
        [swipeView addSubview:menulistView2.view];
        [swipeView addSubview:menulistView3.view];
        
    }

    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

}


-(void)loadAnimation:(UITableView *)table
{
    [table beginUpdates];
    //[table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    [table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [table endUpdates];
}



-(IBAction)beveragesSubCategoryClicked:(UIButton*)button sub:(NSString*)sub 
{
    subId=sub;
    [beveragesBeerView1.beerDetailView.customizationView.view removeFromSuperview];
    [beveragesBeerView2.beerDetailView.customizationView.view removeFromSuperview];
    [beveragesBeerView1.beerDetailView.view removeFromSuperview];
    [beveragesBeerView1.beerDetailView.beerListView.view removeFromSuperview];
    [beveragesBeerView2.beerDetailView.view removeFromSuperview];
    [beveragesBeerView2.beerDetailView.beerListView.view removeFromSuperview];
    
    [beveragesBeerView1 reloadDataOfSubCat:subId cat:self.selectedCategoryID];  
    [beveragesBeerView1.beverageView reloadData];
    
    [swipeView addSubview:beveragesBeerView2.view];
    [swipeView addSubview:beveragesBeerView1.view];
    
    
}

-(void)showIndicator:(int)tag
{
    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)];
	progressHud= [[MBProgressHUD alloc] initWithView:progressView];
	[self.view addSubview:progressHud];
	[self.view bringSubviewToFront:progressHud];
    
	progressHud.delegate = self;
    if(tag==0)
    {
        [progressHud showWhileExecuting:@selector(myTask1) onTarget:self withObject:nil animated:YES]; 
    }
    else if(tag==1)
    {
        [progressHud showWhileExecuting:@selector(beverageLoad) onTarget:self withObject:nil animated:YES];
    }
}

-(void)showIndicator1:(int)tag
{
    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)];
	progressBar= [[ProgressBar alloc] initWithView:progressView];
	[self.view addSubview:progressBar];
	[self.view bringSubviewToFront:progressBar];
    
	progressBar.delegate = self;
    [progressBar showWhileExecuting:@selector(myTask2) onTarget:self withObject:nil animated:YES];
}

-(void)myTask1
{
    [beveragesBeerView1 reloadDataOfSubCat:subId cat:self.selectedCategoryID];  
    [beveragesBeerView1.beverageView reloadData];
}

-(void)myTask2
{
    [menulistView1 reloadDataOfSubCat:subId cat:self.selectedCategoryID];
    [menulistView1.DishList reloadData];
    [swipeView addSubview:menulistView1.view];    
    if([self.subcategoryIdList count]!=0)
    {
        [swipeView addSubview:menulistView2.view];
        [swipeView addSubview:menulistView3.view];
    }
}

-(void)showMenuHighlight
{
    KinaraSubCategory.hidden=YES;
    KinaraSelectorSubCategory.hidden=NO;
    //KinaraSelectorCategory.hidden=NO;
}



-(void)beverageLoad
{
    [self swapBeverageView];
}

-(IBAction)orderSummaryClicked:(id)sender
{
    favorite_status = FALSE;
    searchOpened = FALSE;
    [orderSummaryView.view setHidden:NO];
    overviewMenuButton.hidden=FALSE;
    overviewMenuButton.selected = NO;
    //[self UnselectedBottomMenu];
    OrderSummaryButton.selected=YES;
    
    overviewMenuView.hidden=YES;
    menuQuick.view.hidden = YES;
    //@try
    {
        if([[ShareableData sharedInstance].IsViewPage count]==0)
        {
            [[ShareableData sharedInstance].IsViewPage addObject:@"order_summary"];
        }
        else
        {
            ([ShareableData sharedInstance].IsViewPage)[0] = @"order_summary";
        }
        KinaraSubCategory.hidden=YES;
        KinaraSelectorSubCategory.hidden=YES;
        KinaraSelectorCategory.hidden=YES;
        [self UnselectedBottomMenu];
        [fbFriendview.view removeFromSuperview];
        //[favouriteView.view removeFromSuperview];
        [lastOrderedview.view removeFromSuperview];
        [feedbackView.view removeFromSuperview];
        [searchView.view removeFromSuperview];
        [orderSummaryView.soupView.view removeFromSuperview];
               
        [orderSummaryView filterData];
        [orderSummaryView CalculateTotal];
        orderSummaryView.specialRequest.text=@"";
        [orderSummaryView showRequestbox];
        [self.view addSubview:orderSummaryView.view];
        
        [orderSummaryView.OrderList reloadData];
    }
    /*
    @catch (NSException *exception) {
        
               DLog(@"%@",exception);
    }
    @finally {
        
    }
    */
}


-(IBAction)favouriteClicked:(id)sender
{
    /*
     UIView *gift_view = [self.view viewWithTag:8888];
     //NSLOG(@"gift view = %@", gift_view);
     
     if(!gift_view.isHidden)
     return;
     */
    
    searchOpened = FALSE;
    
    [self.overviewMenuButton setHidden:FALSE]; // Changed
    
    if(!mainMenu.isHidden)
        [mainMenu setHidden:TRUE];
    
    [TabSquareCommonClass setValueInUserDefault:@"crm_open" value:@"1"];
    
    [self UnselectedBottomMenu];
    OrderSummaryButton.selected=NO;
    [self removeAllView];
    hasLoaded = 0;
    
    [self removeSwipeSubviews];
    KinaraSubCategory.hidden=YES;
    KinaraSelectorSubCategory.hidden=YES;
    KinaraSelectorCategory.hidden=YES;
    swipeView.hidden=YES;
    favourite.selected=YES;
    [favouriteView.view setHidden:FALSE];
    
    if([[ShareableData sharedInstance].isLogin isEqualToString:@"0"]&&[[ShareableData sharedInstance].isFBLogin isEqualToString:@"0"]&&[[ShareableData sharedInstance].isTwitterLogin isEqualToString:@"0"])
    {
        //changed
        
        if(!favorite_status) {
            favouriteView.view.frame=CGRectMake(13, 160, favouriteView.view.frame.size.width, favouriteView.view.frame.size.height);
            
            [self.view addSubview:favouriteView.view];
            favorite_status = TRUE;
        }
        
        if(favouriteView.view.isHidden)
            [favouriteView.view setHidden:FALSE];
        
        /*else
         {
         favouriteView.view.frame=CGRectMake(13, 160, favouriteView.view.frame.size.width, favouriteView.view.frame.size.height);
         [self.view addSubview:favouriteView.view];
         }
         */
        
    }
    else if([[ShareableData sharedInstance].isFBLogin isEqualToString:@"1"])
    {
        if (!fbFriendview) {
            fbFriendview.view.frame=CGRectMake(13,160, fbFriendview.view.frame.size.width, fbFriendview.view.frame.size.height);
            [fbFriendview.friendOrderView.view removeFromSuperview];
            [self.view addSubview:fbFriendview.view];
            [fbFriendview.friendlistView reloadData];
        }
        else{
            [fbFriendview.view removeFromSuperview];
            [favouriteView loadFBfriendList];
        }
        
    }
    else if([[ShareableData sharedInstance].isTwitterLogin isEqualToString:@"1"])
    {
        twitFriendview.view.frame=CGRectMake(13,160, twitFriendview.view.frame.size.width, twitFriendview.view.frame.size.height);
        [self.view addSubview:twitFriendview.view];
    }
    /*
     else
     {
     lastOrderedview.view.frame=CGRectMake(13, 160, lastOrderedview.view.frame.size.width, lastOrderedview.view.frame.size.height);
     [self.view addSubview:lastOrderedview.view];
     [lastOrderedview loadlastOrdereddata];
     [lastOrderedview.lastOrderedView reloadData];
     }
     */
    
    //[self createFavouriteClicked];
    [self.favouriteView.view setHidden:FALSE];
    [self.view bringSubviewToFront:self.favouriteView.view];
    
}


-(IBAction)searchClicked:(id)sender
{
    ////////////removing the FBLogin screen/////////////////
     FBDialog *loginPage = [[FBDialog alloc]init];
    [loginPage removeWindowOfFB];
    
    
    
    mparent=nil; 
    [self.overviewMenuButton setHidden:FALSE]; // Changed
    
    favorite_status = FALSE;
    
    [subCatbg setHidden:TRUE];
    [subcatScroller setHidden:TRUE];
    
    
    if(!mainMenu.isHidden)
        [mainMenu setHidden:TRUE];
    
    KinaraSubCategory.hidden=YES;
    KinaraSelectorSubCategory.hidden=YES;
    KinaraSelectorCategory.hidden=YES;
    
    [self UnselectedBottomMenu];
    OrderSummaryButton.selected=NO;
    [self removeAllView];
    search.selected=YES;
    
    
    searchView = nil;
    [self createSearchView];
    
    //[searchView getPickerData];
    searchView.view.frame=CGRectMake(12, 138, searchView.view.frame.size.width, searchView.view.frame.size.height);
    
    
    [self.view addSubview:searchView.view];
    [self.view bringSubviewToFront:searchView.view];
    [self.overviewMenuButton setHidden:FALSE]; // Changed
}


-(IBAction)feedbackDisabledClicked:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message: @"You can only submit your feedback once the first order is placed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

-(IBAction)feedbackClicked:(id)sender
{
    mparent =nil;
    if([[ShareableData sharedInstance].isFeedbackDone isEqualToString:@"0"])
    {
        KinaraSubCategory.hidden=YES;
        KinaraSelectorSubCategory.hidden=YES;
        KinaraSelectorCategory.hidden=YES;
        [self UnselectedBottomMenu];
          OrderSummaryButton.selected=NO;
        feedback.selected=YES;
        feedbackView.view.frame=CGRectMake(0, 160, feedbackView.view.frame.size.width, feedbackView.view.frame.size.height);
        [self.view addSubview:feedbackView.view];
    }
    else
    {
        UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:nil message:@"You have already provided the feedback." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert3 show];
    }
    
}

-(IBAction)helpClicked:(id)sender
{    mparent =nil;
    favorite_status = FALSE;
    
    if(search.selected)
    {
        [self.view addSubview:helpView.view];
        helpView.helpOverlay.image=[UIImage imageNamed:@"Search_f.png"];
    }
    else if (favourite.selected) 
    {
        [self.view addSubview:helpView.view];
        helpView.helpOverlay.image=[UIImage imageNamed:@"favorites_f.png"];
    }
    else if([[ShareableData sharedInstance].IsViewPage count]!=0)
    {
        if ([([ShareableData sharedInstance].IsViewPage)[0] isEqualToString:@"main_detail"]) 
        {
            [self.view addSubview:helpView.view];
            helpView.helpOverlay.image=[UIImage imageNamed:@"Main menu_f.png"];
        }
        else if ([([ShareableData sharedInstance].IsViewPage)[0] isEqualToString:@"beverage_main"]) 
        {
            [self.view addSubview:helpView.view];
            helpView.helpOverlay.image=[UIImage imageNamed:@"Main menu_f.png"];
        }
        else if ([([ShareableData sharedInstance].IsViewPage)[0] isEqualToString:@"main_info"]) 
        {
            [self.view addSubview:helpView.view];
            helpView.helpOverlay.image=[UIImage imageNamed:@"dish info_f.png"];
        }
        else if ([([ShareableData sharedInstance].IsViewPage)[0] isEqualToString:@"beverage_main_info"]) 
        {
            [self.view addSubview:helpView.view];
            helpView.helpOverlay.image=[UIImage imageNamed:@"dish info_f.png"];
        }
        
        
    }
}


-(void)UnselectedBottomMenu
{
    search.selected=NO;
    favourite.selected=NO;
    feedback.selected=NO;
    help.selected=NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self clearSubViews];
}
-(void)viewWillAppear:(BOOL)animated{
  
    if (favouriteView) {
        [self.favouriteView.view setHidden:TRUE];
        overviewMenuButton.hidden=TRUE;
        
    }
    
}

-(void)clearSubViews
{
    for(UIView *sub_view in self.view.subviews)
        [sub_view removeFromSuperview];
    
    self.menulistView1 = nil;
    self.KinaraSelectorCategory = nil;
    self.KinaraSelectorSubCategory = nil;
    self.KinaraCategory = nil;
    self.KinaraSubCategory = nil;
    self.KinaraSubategoryNameList = nil;
    self.KinaraSelectedCategoryName = nil;
    self.KinaraSelectedSubCategoryName = nil;
    self.favouriteView = nil;
    self.helpOverlay = nil;
    self.swipeIndicator = nil;
    editOrderView = nil;
    self.selectedCategoryID = nil;
    self.menuCategory = nil;
    self.isRecon = nil;
    self.categoryList = nil;
    self.categoryIdList = nil;
    self.subcategoryList = nil;
    self.subcategoryIdList = nil;
    self.subcategoryDisplayList = nil;
    self.maincourseImage = nil;
    self.orderSummaryView = nil;
    self.menuQuick = nil;
    self.assignTable = nil;
    self.search = nil;
    self.feedback = nil;
    self.favourite = nil;
    self.help = nil;
    self.OrderSummaryButton = nil;
    self.overviewMenuButton = nil;
    self.KinaraLogo = nil;
    self.FeedbackDisabled = nil;
    self.swipeView = nil;
    self.btnn = nil;
}

-(IBAction)EnterTableNumber:(id)sender
{
    if([ShareableData sharedInstance].ViewMode==2)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter your table number:" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeNumberPad;
        alertTextField.placeholder = @"";
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }
}


/*===============================Updates In User Interface================================*/

-(void)addTable
{
    mainMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 114, overviewMenuView.frame.size.width, overviewMenuView.frame.size.height)];
    [self.view addSubview:mainMenu];
    
    thumbanilSize = CGSizeMake(100.0, 93.0);
    
    firstImages = [[TabSquareDBFile sharedDatabase]getFirstImages:categoryIdList];
    
    tempCategoryList = [NSMutableArray arrayWithArray:categoryList];
    /*=======Adding bestsellers as a hardcode category=======*/
    
    [self addBestsellers];
    
    ////NSLOG(@"first images = %@", firstImages);
    CGRect frame = CGRectMake(35,30, mainMenu.frame.size.width-70, mainMenu.frame.size.height+5);
    menuTable               = [[UITableView alloc] initWithFrame:frame];
	menuTable.delegate      = self;
	menuTable.dataSource    = self;
	
	menuTable.backgroundColor = [UIColor clearColor];
	menuTable.showsVerticalScrollIndicator = NO;
	[menuTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	menuTable.autoresizesSubviews = YES;
    menuTable.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[mainMenu addSubview:menuTable];
    [menuTable reloadData];
	
}

-(void)addBestsellers
{
    /*===========Returns if Bestsellers set to off=============*/
    if(![ShareableData bestSellersON])
        return;
    
    NSString *dishImage = @"bestseller.png";
    UIImage *imageData = [UIImage imageNamed:dishImage];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = paths[0];
    NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,dishImage];
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(imageData)];
    [data1 writeToFile:location atomically:YES];

    [firstImages insertObject:location atIndex:0];
    
    [tempCategoryList insertObject:BEST_SELLERS atIndex:0];
}

-(void)badgeRefresh
{
    int totalQty = 0;
    
    for(int i=0;i<[[ShareableData sharedInstance].OrderItemID  count];i++)
    {
        totalQty += [([ShareableData sharedInstance].OrderItemQuantity)[i] intValue];
        // float custPrice=[self getTotalCustomizationRate:i];
        //total+=[([ShareableData sharedInstance].OrderItemRate)[i] floatValue]+custPrice;
    }
    if (totalQty == 0&&[summaryTotalBadge.badgeText isEqualToString:@"0"]){
        
    }else if (totalQty == 0&&![summaryTotalBadge.badgeText isEqualToString:@"0"]){
        //summaryTotalBadge.badgeText = @"0";
        [summaryTotalBadge autoBadgeSizeWithString:@"0"];
        [summaryTotalBadge removeFromSuperview];
    }else if (totalQty !=0 && [summaryTotalBadge.badgeText isEqualToString:@"0"]){
        // summaryTotalBadge.badgeText = [NSString stringWithFormat:@"%d",totalQty ];
        [summaryTotalBadge autoBadgeSizeWithString:[NSString stringWithFormat:@"%d",totalQty ]];
        [OrderSummaryButton addSubview:summaryTotalBadge];
    }else if (totalQty !=0 && ![summaryTotalBadge.badgeText isEqualToString:@"0"]){
        //summaryTotalBadge.badgeText = [NSString stringWithFormat:@"%d",totalQty ];
        [summaryTotalBadge autoBadgeSizeWithString:[NSString stringWithFormat:@"%d",totalQty ]];
        // [summaryTotalBadge removeFromSuperview];
        
        // [OrderSummaryButton addSubview:summaryTotalBadge];
    }
    //[summaryTotalBadge reloadInputViews];
    // [summaryTotalBadge setNeedsDisplay];
    
}




#pragma mark -
#pragma mark Table View Data Source Methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [tempCategoryList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 120;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* CellIdentifier = @"MessageCellIdentifier";
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:nil];
	if(cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	
    
    /*========================Background Image=========================*/
    
    UIImageView *background = [[UIImageView alloc] initWithImage:cellImage];
    [background setFrame:CGRectMake(0, 0, menuTable.frame.size.width, 110.0)];
    [cell.contentView addSubview:background];
    
    
    /*=========================Category Name=========================*/
    UILabel *category_lbl = [[UILabel alloc] initWithFrame:CGRectMake(145.0, 35.0, 498.0, 50.0)];
    [category_lbl setFont:[UIFont fontWithName:@"Futura" size:40]];
    NSString *str = [tempCategoryList objectAtIndex:indexPath.row];
    NSString *category = [self filterString:str pattern:@"[1-9]-"];
    
    [category_lbl setText:category];
    [category_lbl setTextColor:fontColor];
    [category_lbl setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:category_lbl];
    
    
    /*=======Check for Bstsellers========*/
    int indx = indexPath.row;
    if([ShareableData bestSellersON] && indx != 0) {
        indx --;
    }

    /*=========================Category Image=========================*/
    
    CGRect img_frm = CGRectMake(background.frame.origin.x+10, 0, thumbanilSize.width, thumbanilSize.height);
    float _y = (background.frame.size.height-img_frm.size.height)/2;
    
    img_frm = CGRectMake(img_frm.origin.x, _y, img_frm.size.width, img_frm.size.height);
    
    UIImageView *dish_image = [[UIImageView alloc] initWithFrame:img_frm];
    //UIImage *img = [UIImage imageWithContentsOfFile:[firstImages objectAtIndex:indexPath.row]];
    UIImage *img = [UIImage imageWithContentsOfFile:firstImages[indexPath.row]];
    dish_image.frame = img_frm;
    
    if(img == nil)
        img = [UIImage imageNamed:@"defaultImgB.png"];

    [dish_image setImage:img];
    [dish_image.layer setShadowOpacity:1.0];
    [dish_image.layer setMasksToBounds:NO];
    [dish_image.layer setShadowOffset:CGSizeMake(4.0, 2.0)];
    //dish_image.contentMode = UIViewContentModeScaleAspectFit;
        
	[cell.contentView addSubview:dish_image];
    

    [cell.contentView setTag:[[categoryIdList objectAtIndex:indx] intValue]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
    [cell setNeedsDisplay];

	return cell;
	
}


-(void)overviewBtnClicked2:(id) sender{
    
    NSString *str = [categoryList objectAtIndex:0];
    NSString *category = [self filterString:str pattern:@"[1-9]-"];
    [TabSquareCommonClass setValueInUserDefault:@"current_menu" value:category];
    
    
    int sub_cat_id = [[TabSquareDBFile sharedDatabase]getFirstSubCategoryId:[NSString stringWithFormat:@"%d",147]];
    
    main_cat_id = 8;///prevously it was 149
    [TabSquareCommonClass setValueInUserDefault:@"main_cat_id" value:[NSString stringWithFormat:@"%d", main_cat_id]];
    
    NSString *tag_val = [NSString stringWithFormat:@"%d1001%d", main_cat_id, sub_cat_id];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:[tag_val intValue]];
    [self overviewBtnClicked:btn];
    
    [mainMenu setHidden:TRUE];
    [self hideUnhideComponents:FALSE];
    
    
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*=========Locking Touch=========*/
   // [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    NSLog(@"Log 1111");
    beveragesBeerView.mParent=self;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = cell.textLabel;// [menuLabels objectAtIndex: button.tag];
    UIColor *targetColor = COLOR_LIGHT_GRAY;
    UIColor *currentColor = label.textColor;
       [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         label.textColor = targetColor;
                         cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
                         
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             [UIView animateWithDuration:0.1
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
                                                  label.textColor = currentColor;
                                              }
                                              completion:^(BOOL finished){
                                                  if (finished){
                                                      [UIView animateWithDuration:0.15
                                                                            delay:0
                                                                          options:UIViewAnimationOptionCurveEaseInOut
                                                                       animations:^{
                                                                           cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                                                                           
                                                                       }
                                                                       completion:^(BOOL finished){
                                                                           
                                                                           
                                                                           NSString *str = [tempCategoryList objectAtIndex:indexPath.row];
                                                                           NSString *category = [self filterString:str pattern:@"[1-9]-"];
                                                                           [TabSquareCommonClass setValueInUserDefault:@"current_menu" value:category];
                                                                           
                                                                           
                                                                           int sub_cat_id = [[TabSquareDBFile sharedDatabase]getFirstSubCategoryId:[NSString stringWithFormat:@"%d", cell.contentView.tag]];
                                                                           
                                                                           main_cat_id = cell.contentView.tag;
                                                                           [TabSquareCommonClass setValueInUserDefault:@"main_cat_id" value:[NSString stringWithFormat:@"%d", main_cat_id]];
                                                                           
                                                                           NSString *tag_val = [NSString stringWithFormat:@"%d1001%d", main_cat_id, sub_cat_id];
                                                                           
                                                                           /*========Setting Bestsellers off=========*/
                                                                           BOOL best_flag = FALSE;
                                                                           if(![ShareableData bestSellersON] && indexPath.row == 0) {
                                                                               [TabSquareCommonClass setValueInUserDefault:BEST_SELLERS value:@"0"];
                                                                           }
                                                                           else if([ShareableData bestSellersON] && indexPath.row == 0) {
                                                                               
                                                                               [TabSquareCommonClass setValueInUserDefault:BEST_SELLERS value:@"1"];
                                                                               
                                                                               best_flag = TRUE;
                                                                               
                                                                               [beveragesBeerView.view setHidden:TRUE];
                                                                               [beveragesBeerView1.view setHidden:TRUE];
                                                                               [beveragesBeerView2.view setHidden:TRUE];

                                                                               [self searchBetseellers];
                                                                           }
                                                                           
                                                                           if(!best_flag) {
                                                                               
                                                                               UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                                                                               [btn setTag:[tag_val intValue]];
                                                                               [self overviewBtnClicked:btn];
                                                                               [self hideUnhideComponents:FALSE];

                                                                           }

                                                                           /*========================================*/
                                                                           
                                                                           [mainMenu setHidden:TRUE];
                                                                           [self hideUnhideComponents:FALSE];

                                                                       }
                                                       ];}
                                              }
                              ];}
                     }];

    
}


-(void)hideUnhideComponents:(BOOL)status
{
    [beveragesBeerView.view setHidden:status];
    [beveragesBeerView1.view setHidden:status];
    [beveragesBeerView2.view setHidden:status];

    [orderSummaryView.view setHidden:status];
    [subcatScroller setHidden:status];
    [subCatbg setHidden:status];
    [menulistView.view setHidden:status];
    [menulistView1.view setHidden:status];
    [menulistView2.view setHidden:status];
    [self.overviewMenuButton setHidden:status];
}


-(void)runSpinAnimationWithDuration:(CGFloat)duration onView:(UIView *)myView;
{
    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [rotationAnimation setToValue:[NSNumber numberWithFloat:100]];
    [rotationAnimation setDuration:5.0];
    [rotationAnimation setRepeatCount:3]; // Repeat forever
    [rotationAnimation setAutoreverses:YES]; // Return to starting point
    
    [[myView layer] addAnimation:rotationAnimation forKey:nil];}

-(void)alphaAnimation:(UIView *)view dutarion:(CGFloat)time
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:time];
    [view setAlpha:0.0];
    [UIView commitAnimations];
}


-(NSString *)filterString:(NSString *)str pattern:(NSString *)pattern
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *category = [regex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@""];
    category = [category stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    return category;
}

-(void)hideTheScrollerAndSubCatBgOnMenuController{
    
    self.subCatbg.hidden=TRUE;
    self.subcatScroller.hidden=TRUE;
    self.OrderSummaryButton.userInteractionEnabled=FALSE;
    self.search.userInteractionEnabled=FALSE;
    self.favourite.userInteractionEnabled=FALSE;
    self.overviewMenuButton.userInteractionEnabled=FALSE;
    self.KinaraLogo.userInteractionEnabled=FALSE;
    
}
-(void)UnhideTheScrollerAndSubCatBgOnMenuController{
    
    self.subCatbg.hidden=FALSE;
    self.subcatScroller.hidden=FALSE;
    self.OrderSummaryButton.userInteractionEnabled=TRUE;
    self.search.userInteractionEnabled=TRUE;
    self.favourite.userInteractionEnabled=TRUE;
    self.overviewMenuButton.userInteractionEnabled=TRUE;
    self.KinaraLogo.userInteractionEnabled=TRUE;
}


-(IBAction)flagPressed:(id)sender
{    
    mparent =nil;
    
    if(![ShareableData multiLanguageStatus]) {
        [self.flagButton setHidden:TRUE];
        return;
    }
    else {
        [self.flagButton setHidden:FALSE];
    }
    
    LanguageSelectionView *language = [[LanguageSelectionView alloc] initWithFrame:self.view.bounds sender:(UIButton *)sender];
    [self.view addSubview:language];
    
}


/*Activating search table list view*/
-(void)setSearchOn:(NSString *)keyword
{
    searchStatus = TRUE;
    searchOpened = TRUE;
    searhKeyword = [NSString stringWithFormat:@"%@", keyword];
    
    [subCatbg setHidden:FALSE];
    [subcatScroller setHidden:FALSE];
    
    [self.favouriteView.view setHidden:TRUE];
    
    for(UIView *sub_view in subcatScroller.subviews)
        [sub_view removeFromSuperview];
    
    UILabel *searchLbl = [[UILabel alloc] initWithFrame:subcatScroller.bounds];

    /*================If Bestsellers on============*/
    if([[TabSquareCommonClass getValueInUserDefault:BEST_SELLERS] intValue] == 1) {
        [searchLbl setText:keyword];
        [searchLbl setFont:[UIFont fontWithName:@"Copperplate" size:20.0]];
        [searchLbl setTextColor:COLOR_DARK_GRAY];
        [searchLbl setTextAlignment:NSTextAlignmentCenter];
        
        searchStatus = FALSE;
        
        float scaleSize = 1.5f;
        searchLbl.transform = CGAffineTransformMakeScale(scaleSize, scaleSize);

    }
    else {
        [searchLbl setText:[NSString stringWithFormat:@"%@ %@", [[LanguageControler activeText:@"Search Results For"] uppercaseString], [[TabSearchViewController getActiveKeyWord:keyword] uppercaseString]]];
        [searchLbl setTextAlignment:NSTextAlignmentCenter];
        [searchLbl setFont:[UIFont fontWithName:@"Century Gothic" size:31.0]];
        searchLbl.shadowColor = [UIColor colorWithWhite:0.7 alpha:1];
        searchLbl.shadowOffset = CGSizeMake(1, 2);
    }
    
    [searchLbl setBackgroundColor:[UIColor clearColor]];

    [subcatScroller addSubview:searchLbl];
    
}


/*=================================Language Change Notification==================================*/
/*===========Update UI here============*/


-(void)languageChanged:(NSNotification *)notification
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    categoryIdList=[ShareableData sharedInstance].categoryIdList;
    categoryList=[ShareableData sharedInstance].categoryList;
    
    [tempCategoryList removeAllObjects];
    tempCategoryList = [NSMutableArray arrayWithArray:categoryList];
    /*=========This will check and update if any bestsellers==========*/
    if([ShareableData bestSellersON]) {
        [tempCategoryList insertObject:[[ShareableData sharedInstance] activeBestsellerName] atIndex:0];
    }
    
    [self KinaraGetSubCategoryData:self.selectedCategoryID];
    [self updateScrollerTitles];
    
    [menuTable reloadData];
    
    if(bestsellersOpened) {
        [self searchBetseellers];
        return;
    }
    
    if(searchOpened && [searhKeyword length] > 0) {
        [self searchClicked:self.search];
        searchView.searchTextField.text = searhKeyword;
        [searchView callTosearch:nil];
    }
    
}

-(void)updateScrollerTitles
{
    ////NSLOG(@"Scroller header list = %@", subcategoryList);
    int i = 0;
    for(UIView *sub_view in subcatScroller.subviews) {
        
        if([sub_view isMemberOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)sub_view;
            NSString *title = [NSString stringWithFormat:@"%@", subcategoryList[i]];
            title = [title stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            [btn setTitle:title forState:UIControlStateNormal];
            i++;
        }
    }
}


/*==========Searching Bestsellers===========*/

-(void)searchBetseellers
{
    /*====================Unlocking touch===================*/
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    bestsellersOpened = TRUE;
    
    NSMutableArray *search_data = [[TabSquareDBFile sharedDatabase] getDishKeyData:@""];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    /*========Sort By Catgegory==========*/
    for(int i = 0; i < [categoryIdList count]; i++) {
        
        NSString *key_id = categoryIdList[i];
        
        for(int j = 0; j < [search_data count]; j++) {
            
            NSMutableDictionary *dict = search_data[j];
            NSString *search_id = dict[@"category"];
            
            if([key_id isEqualToString:search_id]) {
                [temp addObject:dict];
            }
        }
    }

    [[ShareableData sharedInstance].SearchAllItemData removeAllObjects];
    [ShareableData sharedInstance].SearchAllItemData= temp;
    [ShareableData sharedInstance].TaskType=@"2";
    
    
    menulistView1.view.frame=CGRectMake(0, 197, menulistView1.view.frame.size.width, menulistView1.view.frame.size.height);
    [self.view addSubview:menulistView1.view];
    [self.menulistView1 reloadDataOfSubCat:@"0" cat:@"1"];
    [menulistView1.view setHidden:FALSE];
    [self setSearchOn:[LanguageControler activeText:@"Best of the Best"]];
    [menulistView1.DishList reloadData];

    [menulistView.menudetailView.view removeFromSuperview];
    [beveragesBeerView.view removeFromSuperview];
    [beveragesBeerView1.view removeFromSuperview];
    [beveragesBeerView2.view removeFromSuperview];
    [orderSummaryView.view removeFromSuperview];
    
    /*====================Unlocking touch===================*/
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}



/*=================View Mode Selected===================*/
-(void)viewModeActivated:(NSNotification *)notification
{
    //NSLOG(@"view mode");
    //[menulistView.DishList reloadData];
    
    //[orderSummaryView.view removeFromSuperview];
    
}


/*=================Edit Mode Selected===================*/
-(void)editModeActivated:(NSNotification *)notification
{
   
    [self.overviewMenuButton setUserInteractionEnabled:YES];
    [self.OrderSummaryButton setUserInteractionEnabled:YES];
     // NSLog(@"mParent===%@",[mparent class]);
   /////////to unhide the orderSummaryButton & backButton
        if ([mparent class] ==[TabMainCourseMenuListViewController class]) {
            [self.overviewMenuButton setUserInteractionEnabled:NO];
            [self.OrderSummaryButton setUserInteractionEnabled:NO];
            mparent=nil;
    }

    
}


/*======================Call for Waiter/Bill Functions=======================*/
-(IBAction)callForWaiter:(id)sender
{
    [callForWaiter performSelectorInBackground:@selector(callForStaff:) withObject:WAITER];
}


-(IBAction)callForBill:(id)sender
{
    [callForWaiter performSelectorInBackground:@selector(callForStaff:) withObject:BILL];
}


@end
