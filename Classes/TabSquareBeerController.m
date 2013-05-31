//
//  TabSquareBeerController.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/6/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "TabSquareBeerController.h"
#import "TabSquareBeerDetailController.h"
#import "SBJSON.h"
#import "ShareableData.h"
#import <QuartzCore/CALayer.h>
#import "TabSquareDBFile.h"
#import "TabSquareCommonClass.h"
#import "TabSquareRemoteActivation.h"


@implementation TabSquareBeerController

@synthesize beverageView,beerDetailView,drinkName;
@synthesize resultFromPost,beverageImageData;
@synthesize beverageID,beverageName,beveragePrice,beverageDescription,beverageImage,beveragePrice1;
@synthesize beverageCustomization,beverageCustType,beverageSkuDetail;
@synthesize SubSectionIdData,SubSectionNameData,SectionBeverageData,beverageSubSubCategoryId;
@synthesize mParent;


-(void)setParent:(id)sender{
    
    mParent=sender;
    
    
}

-(void)setPageIndex:(NSInteger)newpageIndex {
    _pageIndex=newpageIndex;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    return self;
}

-(void)createBeerDetail
{
    //beerDetailView =[[TabSquareBeerDetailController alloc]initWithNibName:@"TabSquareBeerDetailController" bundle:nil];
    beerDetailView =[[TabSquareNewBeerScrollController alloc]initWithNibName:@"TabSquareNewBeerScrollController" bundle:nil];

    beerDetailView.beverageView=self;
    
   
}

-(void)postData2:(NSMutableArray*)arr{
    self.resultFromPost = arr;
}

-(void)postData:(NSString *)sub cat:(NSString*)CatID
{
    NSString *taskType=[ShareableData sharedInstance].TaskType;
    if([taskType isEqualToString:@"1"]||[taskType isEqualToString:@"3"])
    {
       // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
        NSLog(@"LogDD 3");
        self.resultFromPost=[[TabSquareDBFile sharedDatabase]getDishData:CatID subCatId:sub];
      //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    }
    else 
    {
       self.resultFromPost = [ShareableData sharedInstance].SearchAllItemData;
    }
    
    /*===========Unlocking Touch============*/
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

}

-(void)loadBeverageData//:(NSString *)sub cat:(NSString*)CatID
{
    @try
    {
        if(resultFromPost)
        {
           // DLog(@"%@",resultFromPost);
            for(int i=0;i<[resultFromPost count];i++)
            {
                NSMutableDictionary *dataitem=resultFromPost[i];;
                [beverageSubSubCategoryId addObject:[NSString stringWithFormat:@"%@",dataitem[@"sub_sub_category"]]];
                [beverageCustomization addObject:dataitem[@"customisations"]];
                [beverageCustType addObject:[NSString stringWithFormat:@"%@",dataitem[@"cust"]]];
                [beverageName addObject:[NSString stringWithFormat:@"%@",dataitem[@"name"]]];
                [beveragePrice addObject:[NSString stringWithFormat:@"%@",dataitem[@"price"]]];
                [beveragePrice1 addObject:[NSString stringWithFormat:@"%@",dataitem[@"price2"]]];          
                [beverageDescription addObject:[NSString stringWithFormat:@"%@",dataitem[@"description"]]];
                [beverageID addObject:[NSString stringWithFormat:@"%@",dataitem[@"id"]]];
                [beverageImageData addObject:[UIImage imageWithContentsOfFile:dataitem[@"images"]]];
            } 
        }
    }
    @catch(NSException *ee)
    {
        //DLog(@"Exception: %@", ee);
    }
    //[resultFromPost removeAllObjects];
}
-(void) reloadDataOfSubCat2:(NSMutableArray*)arr2
{
    [beverageView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    @try
    {
        [beverageID removeAllObjects];
        [beverageName removeAllObjects];
        [beveragePrice removeAllObjects];
        [beveragePrice1 removeAllObjects];
        [beverageDescription removeAllObjects];
        [beverageImage removeAllObjects];
        [beverageImageData removeAllObjects];
        [beverageCustomization removeAllObjects];
        [beverageSubSubCategoryId removeAllObjects];
        [beverageCustType removeAllObjects];
        [beverageSkuDetail removeAllObjects];
    }
    @catch(NSException *ee)
    {
        
    }
    @finally
    {
        
        [self postData2:arr2];
       // category=CatID;
        [self loadBeverageData];
    }
    
}

-(void) reloadDataOfSubCat:(NSString *)sub cat:(NSString*)CatID
{
    self.resultFromPost = nil;
    [beverageView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    @try
    {
        [self.beverageID removeAllObjects];
        [self.beverageName removeAllObjects];
        [self.beveragePrice removeAllObjects];
        [self.beveragePrice1 removeAllObjects];
        [self.beverageDescription removeAllObjects];
        [self.beverageImage removeAllObjects];
        [self.beverageImageData removeAllObjects];
        [self.beverageCustomization removeAllObjects];
        [self.beverageSubSubCategoryId removeAllObjects];
        [self.beverageCustType removeAllObjects];
        [self.beverageSkuDetail removeAllObjects];
    }
    @catch(NSException *ee)
    {
        
    }
    @finally
    {
        [TabSquareCommonClass setValueInUserDefault:@"bev_sub" value:sub];
        [TabSquareCommonClass setValueInUserDefault:@"bev_cat" value:CatID];
        
        currentCatId=[[NSString alloc]initWithFormat:@"%@",CatID];
        currentSubId=[[NSString alloc]initWithFormat:@"%@",sub];
        [self postData:sub cat:CatID];
        category=CatID;
        [self loadBeverageData];
    }
   
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.view.backgroundColor =[UIColor whiteColor];//changed to white color
    
   // [self getBackgroundImage]; ///setting up the backgroung image dynamically
}

-(void)getBackgroundImage
{
    
    
    NSString *img_name = [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, BACKGROUND_IMAGE, [ShareableData appKey]];
    
    UIImage *img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    
    if(img == nil || img == NULL) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:BACKGROUND_IMAGE];
        
        [[TabSquareDBFile sharedDatabase] updateUIImages:arr];
        
        img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    }
    
    [bgImage setImage:img];
    
    
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


    self.resultFromPost=[[NSMutableArray alloc]init];
    self.SubSectionIdData=[[NSMutableArray alloc]init];
    self.SubSectionNameData=[[NSMutableArray alloc]init];
    self.SectionBeverageData=[[NSMutableArray alloc]init];
    self.beverageID=[[NSMutableArray alloc]init];
    self.beverageName=[[NSMutableArray alloc]init];
    self.beveragePrice=[[NSMutableArray alloc]init];
    self.beveragePrice1=[[NSMutableArray alloc]init];
    self.beverageImage=[[NSMutableArray alloc]init];
    self.beverageDescription=[[NSMutableArray alloc]init];
    self.beverageImageData=[[NSMutableArray alloc]init];
    self.beverageCustomization=[[NSMutableArray alloc]init];
    self.beverageCustType=[[NSMutableArray alloc]init];
    self.beverageSubSubCategoryId=[[NSMutableArray alloc]init];
    self.beverageSkuDetail=[[NSMutableArray alloc]init];
    totalPrintItm=0;
    bottletotal=0;
    [self createBeerDetail];
    // Do any additional setup after loading the view from its nib.
   // DLog(@"TabSquareBeerController Load");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
   // DLog(@"TabSquareBeerController UnLoad");
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(UIImageView*)addCellBackImage:(UITableViewCell*)cell
{
    UIImageView *cellback=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 768, 245 )];
    cellback.image=[UIImage imageNamed:@"beverage_cellview"];
    return cellback;
}

-(UIImageView*)setImageInFrame:(CGRect)frame1;
{
    CGSize kMaxImageViewSize = {.width = 68, .height = 180};
    UIImage *image=beverageImageData[bottletotal];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
    imageView.frame=frame1;
    CGSize imageSize = image.size;
    CGFloat aspectRatio = imageSize.width / imageSize.height;
    CGRect frame = imageView.frame;
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
    imageView.frame = frame;
    return imageView;
}


-(void)getSectionBeverageData
{
    [SectionBeverageData removeAllObjects];
    [SubSectionIdData removeAllObjects];
    [SubSectionNameData removeAllObjects];
    totalSubSection=0;
    int total;
    
  //  [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    NSMutableArray*  SubSectionData=[[TabSquareDBFile sharedDatabase]getSubSubCategoryData:currentCatId subCatId:currentSubId];
  //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    
    // DLog(@"%@",DishSubSubCategoryId);
    for(int i=0;i<[SubSectionData count];++i)
    {
        total=i;
        int count=0;
        NSMutableDictionary *dataitem=SubSectionData[i];
        NSString *subsubId=dataitem[@"id"];
        NSString *subsubName=dataitem[@"name"];
        
        for(int j=0;j<[beverageSubSubCategoryId count];++j)
        {
            if([beverageSubSubCategoryId[j] isEqualToString:subsubId])
            {
                count++;
                if(total==i)
                {
                    totalSubSection++;
                    [SubSectionIdData addObject:subsubId];
                    [SubSectionNameData addObject:subsubName];
                    total=[SubSectionData count];
                }
                  
                //break;
            }
            
        }
        [SectionBeverageData addObject:[NSString stringWithFormat:@"%d",count]];         
    }
   // DLog(@"%@",SectionBeverageData);
}

-(NSString*)getSubCategoryName:(NSString*)subId
{
    NSString *subName=@"";
    for(int i=0;i<[SubSectionIdData count];++i)
    {
        if([SubSectionIdData[i]isEqualToString:subId])
        {
            subName=SubSectionNameData[i];
            return subName;
        }
       
    }
    return subName;
}


-(int)getSubCategoryCount:(NSString*)subId
{
    int count=0;
    for(int i=0;i<[SubSectionIdData count];++i)
    {
        if([SubSectionIdData[i]isEqualToString:subId])
        {
            count=[SectionBeverageData[i]intValue];
            return count;
        }
        
    }
    return count;
}

-(void)addBeverageSubCategoryName:(UITableViewCell*)cell subId:(NSString*)subId 
{
     UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 153.0,700, 40)];
     headerLabel.backgroundColor = [UIColor clearColor];
     headerLabel.opaque = NO;
     headerLabel.textColor = [UIColor blackColor];
     headerLabel.font =[UIFont systemFontOfSize:25];
     headerLabel.frame = CGRectMake(7,210.5,768, 40.0);
     headerLabel.textAlignment = UITextAlignmentCenter;
     NSString* headertxt=@"";
     if(totalSubSection!=0)
     {
         headertxt=[self getSubCategoryName:subId];
         if([headertxt isEqual:[NSNull null]])
         {
             headertxt=@"";
         }
     }
     headerLabel.text=headertxt;
    [cell.contentView addSubview:headerLabel];
}

/* this code before sahid change.....
-(void)addBottelImage:(UITableViewCell*)cell indexrow:(int)rowIndex
{
    CGRect frame=CGRectMake(0,35, 68, 180);
    bottletotal=rowIndex*7;
    if(bottletotal==0)
    {
        totalPrintItm=0;
    }
    else 
    {
        bottletotal=totalPrintItm;
    }
    
    int i=0;
    float originX = 0.0f;
    int prevId=0;    
    if([beverageSubSubCategoryId count]>bottletotal)
    {
        prevId=[beverageSubSubCategoryId[bottletotal] intValue];
        int total;
        if([SubSectionIdData count]==1)
        {
           total =[beverageImageData count]-bottletotal;
        }
        else 
        {
            total=[self getSubCategoryCount:beverageSubSubCategoryId[bottletotal]];
        }
        
        if(total<7)
        {
            originX=(768-((frame.size.width+36)*total+52))/2;
        }
        originX=originX+52;
        
    }

    for( ;bottletotal<[beverageImageData count];bottletotal++)
    {
        int cuurentId=[beverageSubSubCategoryId[bottletotal] intValue];
        
        if(cuurentId!=prevId)
        {
            prevId=cuurentId;
            //totalPrintItm+=i;
            break;
        }
        if(i<7)
        {
            if(i==0)
            {
                [self addBeverageSubCategoryName:cell subId:beverageSubSubCategoryId[bottletotal]];
            }
            //DLog(@"%@",[beverageID objectAtIndex:bottletotal]);
            //DLog(@"%@",[beverageSubSubCategoryId objectAtIndex:bottletotal]);
            UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
            frame.origin.x=(frame.size.width+36)*i+originX;
            UIImage *image=beverageImageData[bottletotal];
            UIImageView *imageview=[self setImageInFrame:frame];
            CGRect imageframe=imageview.frame;
            imageframe.origin.y=245-(35+imageframe.size.height);
            add.frame=imageframe;
            add.imageView.clipsToBounds=YES;
            add.tag=bottletotal;
            [add setImage:image forState:UIControlStateNormal];
            [add addTarget:self action:@selector(beverageDetailView:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:add];
            cell.contentView.contentMode=UIViewContentModeCenter;
            totalPrintItm++;
            i++;
        }
        else 
        {
            //totalPrintItm+=i;
            break;
        }
    }
}
*/
-(void)addBottelImage:(UITableViewCell*)cell indexrow:(int)rowIndex
{
    CGRect frame=CGRectMake(0,35, 68, 180);
    bottletotal=rowIndex*7;
    if(bottletotal==0)
        {
            totalPrintItm=0;
            }
    else
        {
            bottletotal=totalPrintItm;
            }
    
    int i=0;
    float originX = 10.0f;
    int prevId=0;
    if([beverageSubSubCategoryId count]>bottletotal)
        {
            prevId=[beverageSubSubCategoryId[bottletotal] intValue];
            int total;
            if([SubSectionIdData count]==1)
                {
                    total =[beverageImageData count]-bottletotal;
                    }
            else
                {
                    total=[self getSubCategoryCount:beverageSubSubCategoryId[bottletotal]];
                    }
            
            if(total<7)
                {
                    originX=(768-((frame.size.width+36)*total+52))/2;
                }
            originX=originX+52;
            
            }
    
    float gap = 38.0;
    
    for( ;bottletotal<[beverageImageData count];bottletotal++)
        {
            int cuurentId=[beverageSubSubCategoryId[bottletotal] intValue];
            
            if(cuurentId!=prevId)
                {
                    prevId=cuurentId;
                    break;
                }
            if(i<7)
                {
                    if(i==0)
                        {
                        [self addBeverageSubCategoryName:cell subId:beverageSubSubCategoryId[bottletotal]];
                    }
                
                    UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
                    
                    frame.origin.x=(frame.size.width * i) + (gap * i) + gap;
                    
                    if(i == 0)
                    
                        frame.origin.x = gap;
                    
                    UIImage *image=beverageImageData[bottletotal];
                    UIImageView *imageview=[self setImageInFrame:frame];
                    CGRect imageframe=imageview.frame;
                    imageframe.origin.y=245-(35+imageframe.size.height);
                    add.frame=imageframe;
                    add.imageView.clipsToBounds=YES;
                    add.tag=bottletotal;
                    [add setImage:image forState:UIControlStateNormal];
                    [add addTarget:self action:@selector(beverageDetailView:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:add];
                    cell.contentView.contentMode=UIViewContentModeCenter;
                    totalPrintItm++;
                    i++;
                    }
            else 
                {
                    break;
                    }
            }
}

-(IBAction)beverageDetailView:(id)sender
{
    [self createBeerDetail];
    UIButton *bottle=(UIButton*)sender;
   
    if([[ShareableData sharedInstance].IsViewPage count]==0)
    {
        [[ShareableData sharedInstance].IsViewPage addObject:@"beverage_main_info"];
    }
    else
    {
        ([ShareableData sharedInstance].IsViewPage)[0] = @"beverage_main_info";
    }

    int currentindex=bottle.tag;
    beerDetailView.selectedIndex=[NSString stringWithFormat:@"%d",currentindex];
    
    beerDetailView.mParent=self;
    
    beerDetailView.beverageSKUDetail=[[TabSquareDBFile sharedDatabase]getBeverageSkuDetail:beverageID[currentindex]];

    beerDetailView.beverageCatId=category;
    
    beerDetailView.beverageCustomization=beverageCustomization;

    beerDetailView.beverageCutType=beverageCustType;
    [beerDetailView.beverageSkUView reloadData];
    [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
    [self.view addSubview:beerDetailView.view];
    [beerDetailView loadBeverageData:currentindex];

    [self.mParent hideTheScrollerAndSubCatBgOnMenuController];

  
}
-(void)parentCallToUnHideTheScrollerAndSubCatBgOnMenuController{
    
    [mParent UnhideTheScrollerAndSubCatBgOnMenuController];
}

-(int)getTotalBeverageRows
{
    int totalBeverageRows=0;
    for(int i=0;i<[SectionBeverageData count];++i)
    {
        int total=[SectionBeverageData[i]intValue];
        int que=total/7;
        int rem=total%7;
        if(rem>0)
        {
            totalBeverageRows+=que+1;
        }
        else 
        {
            totalBeverageRows+=que;
        }
    }
    return totalBeverageRows;
}


#pragma mark Table view methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self getSectionBeverageData];
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int total=[self getTotalBeverageRows];
    DLog(@"%d",total);
    if(total<3)
    {
        return 4; // changed from 3 to 4 due to more visible row in rack view
    }
    else
    {
        return total;        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // static NSString *CellIdentifier = @"Cell";
    NSString *CellIdentifier = [NSString stringWithFormat:@"%@ %d",currentSubId, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];// = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero ] autorelease];
     //  cell = [[[UITableViewCell alloc]initWithStyle:NULL reuseIdentifier:CellIdentifier] autorelease];
        UIImageView *backImage=[self addCellBackImage:cell];
        [cell.contentView addSubview:backImage];
        [self addBottelImage:cell indexrow:indexPath.row];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}


/*=================================Language Change Notification==================================*/
/*===========Update UI here*/


-(void)languageChanged:(NSNotification *)notification
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    last_sub = [TabSquareCommonClass getValueInUserDefault:@"bev_sub"];
    last_catId = [TabSquareCommonClass getValueInUserDefault:@"bev_cat"];
    
    if([last_sub length] < 1 || [last_catId length] < 1)
        return;

    [self reloadDataOfSubCat:last_sub cat:last_catId];
    [self.beverageView reloadData];
}


/*=================View Mode Selected===================*/
-(void)viewModeActivated:(NSNotification *)notification
{
    [self.beverageView reloadData];
}


/*=================Edit Mode Selected===================*/
-(void)editModeActivated:(NSNotification *)notification
{
    [self.beverageView reloadData];
    
}


@end
