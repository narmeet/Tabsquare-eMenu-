//
//  TabSquareOrderSummaryController.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/10/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "TabSquareOrderSummaryController.h"
#import "ShareableData.h"
#import "TabMainMenuDetailViewController.h"
#import "TabSquareSoupViewController.h"
#import "SBJSON.h"
#import <QuartzCore/QuartzCore.h>
#import "TabSquareDBFile.h"
#import "EditOrder.h"
#import "TabSquareMenuDetailController.h"
#import "TabSquareMenuController.h"
#import "TabMainDetailView.h"
#import "UYLGenericPrintPageRenderer.h"
#import "TabSquareBeerController.h"
#import "TabSquareBeerDetailController.h"

@implementation TabSquareOrderSummaryController

static int tapCount = 0;

@synthesize OrderList,tmpCell,lblTotal,specialRequest,summaryTitle;
@synthesize menudetailView,totalTitle,sortCatId,soupView;
@synthesize DishID,DishImage,DishPrice,DishName,DishCat,data;
@synthesize menuView,categoryTag,lblSplReq,sortDishId,subSortId,beerDetailView,beveragesBeerView2,salesRef,lblGST,lblSubTotal,lblTotalPrice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.view.frame=CGRectMake(0, 108, self.view.frame.size.width, self.view.frame.size.height+120);
    }
    NSString *img_name1 = [NSString stringWithFormat:@"%@%@", PRE_NAME, POPUP_IMAGE];
   //  NSString *img_name1 = [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, POPUP_IMAGE, [ShareableData appKey]];
    UIImage *img1 = [[TabSquareDBFile sharedDatabase] getImage:img_name1];
    bgImage.image = img1;
    
    return self;
}

-(void)createRecommendationScreen
{
    soupView=[[TabSquareSoupViewController alloc]initWithNibName:@"TabSquareSoupViewController" bundle:nil];
    soupView.orderSummary=self;
}

-(void)createDishData
{
    DishID=[[NSMutableArray alloc]init];
    DishPrice=[[NSMutableArray alloc]init];
    DishName=[[NSMutableArray alloc]init];
    DishImage=[[NSMutableArray alloc]init];
    DishCat=[[NSMutableArray alloc]init];
}

-(void)addgestureInTableView
{
    gestureView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handletap:)];
    gestureView.numberOfTapsRequired=1;
    [OrderList addGestureRecognizer:gestureView];
}


-(void)handletap:(UIGestureRecognizer*)gesture
{
    [specialRequest resignFirstResponder];
    [OrderList removeGestureRecognizer:gestureView];
}


- (void)viewDidLoad
{
    [self createDishData];
    
    subSortId=[[NSMutableArray alloc]init];
    orderCatIdList=[[NSMutableArray alloc]init];
    orderCatNameList=[[NSMutableArray alloc]init];
    [self createRecommendationScreen];
    //summaryTitle.font=[UIFont fontWithName:@"Lucida Calligraphy" size:27];
    //totalTitle.font=[UIFont fontWithName:@"Lucida Calligraphy" size:30];
    summaryTitle.text = [NSString stringWithFormat:@"Order Summary - Table No. %@", [ShareableData sharedInstance].assignedTable1 ] ;
    //summaryTitle.font=[UIFont fontWithName:@"Lucida Calligraphy" size:27];
    specialRequest.layer.borderWidth=2.0;
    specialRequest.layer.borderColor=[UIColor colorWithRed:220.0f/255.0f green:208.0f/255.0f blue:156.0f/255.0f alpha:0.8].CGColor;
    sortCatId=[[NSMutableArray alloc]init];
    sortDishId=[[NSMutableArray alloc]init];
    
    beerDetailView =[[TabSquareNewBeerScrollController alloc]initWithNibName:@"TabSquareNewBeerScrollController" bundle:nil];
    
    beveragesBeerView2=[[TabSquareBeerController alloc]initWithNibName:@"TabSquareBeerController" bundle:nil];
    [super viewDidLoad];
    lblTotal.text=@"0";
    totalTitle.text=@"0 Items Added";
    // TabSquareBeerController *bv2=[[TabSquareBeerController alloc]initWithNibName:@"TabSquareBeerController" bundle:nil];
    beerDetailView.beverageView = beveragesBeerView2;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self addgestureInTableView];
}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)GetSubCategoryId:(NSString *)catID
{
    NSMutableArray *resultFromPost;
    
    for(int i=0;i<[[ShareableData sharedInstance].categoryIdList count];i++)
    {
        if([([ShareableData sharedInstance].categoryIdList)[i] isEqualToString:catID])
        {
            if([[ShareableData sharedInstance].SubCategoryList count]!=0)
            {
                resultFromPost=([ShareableData sharedInstance].SubCategoryList)[i];
            }
            
        }
    }
    
    @try
    {
        subCatId=@"0";
    }
    @catch (NSException *exception)
    {
        
    }
    
    for(int i=0;i<[resultFromPost count];i++)
    {
        NSMutableDictionary *dataitem=resultFromPost[i];
        //NSArray *keys=[dataitem allKeys];
        if([dataitem count]!=0)
        {
            if([[NSString stringWithFormat:@"%@",dataitem[@"category_id"]] isEqualToString:catID])
            {
                subCatId=[NSString stringWithFormat:@"%@",dataitem[@"id"]];
                break;
            }
        }
        
    }
    
}

-(void)getSubCategoryData:(NSString *)sub cat:(NSString*)CatID
{
    @try
    {
        [DishID removeAllObjects];
        [DishName removeAllObjects];
        [DishPrice removeAllObjects];
        [DishImage removeAllObjects];
        [DishCat removeAllObjects];
    }
    @catch(NSException *ee)
    {
        // DLog(@"Exception : %@",ee);
    }
    @finally
    {
        //  [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
        if([sub isEqualToString:@"0"])
        {
            sub=@"<null>";
        }
        NSMutableArray  *resultFromPost = [[TabSquareDBFile sharedDatabase]getDishData:CatID subCatId:subCatId];
        // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
        @try
        {
            if(resultFromPost)
            {
                UIImage *imageData;
                int count=0;
                for(int i=0;i<[resultFromPost count];i++)
                {
                    NSMutableDictionary *dataitem=resultFromPost[i];
                    if(count==2)
                    {
                        break;
                    }
                    [DishName addObject:[NSString stringWithFormat:@"%@",dataitem[@"name"]]];
                    [DishPrice addObject:[NSString stringWithFormat:@"%@",dataitem[@"price"]]];
                    [DishID addObject:[NSString stringWithFormat:@"%@",dataitem[@"id"]]];
                    imageData = [UIImage imageWithContentsOfFile:dataitem[@"images"]];
                    [DishImage addObject:imageData];
                    [DishCat addObject:[NSString stringWithFormat:@"%@",dataitem[@"category"]]];
                    count++;
                }
                image=DishImage[0];
            }
        }
        @catch(NSException *ee)
        {
            
        }
    }
}

-(NSString*)loadWebViewDish
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:kURL@"kinaraEx/printDishes.php?tableid=%@&request=%@",[ShareableData sharedInstance].assignedTable1,[specialRequest.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]]]];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *buf=[[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding]stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return buf;
}

-(NSString*)loadWebViewDrink
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:kURL@"kinaraEx/printDrinks.php?tableid=%@&request=%@",[ShareableData sharedInstance].assignedTable1,[specialRequest.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]]]];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *buf=[[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding]stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return buf;
}

- (void)printWebView {
    
    
    UIPrintInteractionController *pc = [UIPrintInteractionController sharedPrintController];
    pc.delegate = self;
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Bill report";
    pc.printInfo = printInfo;
    pc.showsPageRange = YES;
    
    
    UYLGenericPrintPageRenderer *renderer = [[UYLGenericPrintPageRenderer alloc] init];
    renderer.headerText = printInfo.jobName;
    renderer.footerText = @"AirPrinter - Kinara.com";
    // renderer.printableRect.size = 0.5f;
    //[webView.scrollView setZoomScale:1.5f animated:NO];
    UIViewPrintFormatter *formatter = [webView viewPrintFormatter];
    
    [renderer addPrintFormatter:formatter startingAtPageAtIndex:0];
    pc.printPageRenderer = renderer;
    
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(!completed && error){
            DLog(@"Print failed - domain: %@ error code %u", error.domain, error.code);
        }
    };
    
    [pc presentAnimated:YES completionHandler:completionHandler];
    
}

-(IBAction)confirmOrderClicked:(id)sender
{
     tapCount++;
    @try
    {
        if([[ShareableData sharedInstance].IsEditOrder isEqualToString:@"0"])
        {
             [self showIndicator:1];
            //[self confirmOrder];
        }
        else
        {
            
            [self confirmOrder];
        }
        
    }
    @catch (NSException *exception)
    {
        
    }
    
    
}

-(IBAction)closeClicked:(id)sender
{
    if ([[ShareableData sharedInstance].isQuickOrder isEqualToString:@"1"]){
        [menuView showMenuHighlight];
    }
    
    [self.view removeFromSuperview];
}

-(void)showRequestbox
{
    int kk=0;
    for (int i=0; i<[[ShareableData sharedInstance].OrderItemID count]; ++i)
    {
        
        if([([ShareableData sharedInstance].confirmOrder)[i] isEqualToString:@"0"])
        {
            kk=1;
            break;
        }
        
    }
    if(kk==1)
    {
        lblSplReq.hidden=NO;
        specialRequest.hidden=NO;
    }
    else
    {
        // lblSplReq.hidden=YES;
        //specialRequest.hidden=YES;
    }
}
//-(void)openItemRaptor


-(void)confirmOrder
{
    tapCount=0;
    DLog(@"------------------------Order Details-------------");
    
    int kk=0;
    for (int i=0; i<[[ShareableData sharedInstance].OrderItemID count]; ++i)
    {
        
        if([([ShareableData sharedInstance].confirmOrder)[i] isEqualToString:@"0"])
        {
            kk=1;
            break;
        }
        
    }
    
    if(kk==1)
    {
        progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHud.mode = MBProgressHUDModeIndeterminate;
        progressHud.delegate = self;
        [progressHud setLabelText:@"Sending Orders. Please Wait."];
        // [progressHud setDetailsLabelText:@"This may take a while"];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            float progress = 0.0f;
            float devider = 1.0f / [[ShareableData sharedInstance].OrderItemID count];
            
            [self recallTableRaptor:[ShareableData sharedInstance].assignedTable1];///it was not there before for table void
            
            
            for (int i=0; i<[[ShareableData sharedInstance].OrderItemID count]; ++i)
            {
                if([([ShareableData sharedInstance].confirmOrder)[i] isEqualToString:@"0"])
                {
                    [self insertInTempOrder:i];
                    progress += devider;
                    progressHud.progress = progress;
                    progressHud.mode = MBProgressHUDModeAnnularDeterminate;
                    [progressHud setDetailsLabelText:[NSString stringWithFormat:@"Sent item %d/%d",i+1,[[ShareableData sharedInstance].OrderItemID count]]];
                }
                ([ShareableData sharedInstance].confirmOrder)[i] = @"1";
            }
            
            [self holdTableRaptor:[ShareableData sharedInstance].assignedTable1];
            [self forcePrint];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                lblSplReq.hidden=NO;
                specialRequest.hidden=NO;
                [ShareableData sharedInstance].isFeedbackDone=@"0";
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Thank you" message:@"Your order have been succesfully placed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    alert.tag=2;
                    [alert show];
                [ShareableData sharedInstance].isConfermOrder=TRUE;
                [OrderList reloadData];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
                NSString *libraryDirectory = [paths lastObject];
                NSString *location = [libraryDirectory stringByAppendingString:@"/orderarrays.plist"];
                NSString *location2 = [libraryDirectory stringByAppendingString:@"/orderstrings.plist"];
                               
                [[NSFileManager defaultManager] removeItemAtPath:location error:nil];
                [[NSFileManager defaultManager] removeItemAtPath:location2 error:nil];
                DLog(@"ITEMS REMOVED");
            });
        });
        
        
    }
    else if([specialRequest.text length]>1)
    {
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:kURL@"kinaraEx/printRequest.php?tableid=%@&request=%@",[ShareableData sharedInstance].assignedTable1,[specialRequest.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]]]];
        
        NSError *error;
        NSURLResponse *response;
        NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *data=[[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding]stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Thank you" message:@"Order has been placed already" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alert.tag=3;
        [alert show];
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"]&&alertView.tag==2)
    {
        if([[ShareableData sharedInstance].IsEditOrder isEqualToString:@"1"])
        {
            [ShareableData sharedInstance].IsEditOrder=@"0";
            [ShareableData sharedInstance].isQuickOrder=@"0";
            [menuView returnToEdit];
        }else if( [[ShareableData sharedInstance].IsEditOrder isEqualToString:@"2"]){
            [ShareableData sharedInstance].IsEditOrder=@"0";
            [ShareableData sharedInstance].isQuickOrder=@"0";
//            TakeWayEditOrder *SalesReport1=[[TakeWayEditOrder alloc]initWithNibName:@"TakeWayEditOrder" bundle:nil];
//            [ShareableData sharedInstance].isTakeaway=@"1";
//            [self.navigationController pushViewController:SalesReport1 animated:YES];
        }
        //[self performSelector:@selector(loadWebViewDish) withObject:nil afterDelay:.1];
        //[self performSelector:@selector(printWebView) withObject:nil afterDelay:.9];
        //  [self loadWebViewDish];
        //  [self printWebView];
        //[self performSelector:@selector(loadWebViewDrink) withObject:nil afterDelay:.1];
        //[self loadWebViewDrink];
        // [self printWebView];
        // [self performSelector:@selector(printWebView) withObject:nil afterDelay:.9];
    }
}




-(void)InsertCustomizationDetail:(NSInteger)index tableNo:(NSString*)tableno DishId:(NSString*)dishid
{
    NSString *custType=([ShareableData sharedInstance].IsOrderCustomization)[index];
    if([custType isEqualToString:@"1"])
    {
        NSMutableArray *customization=([ShareableData sharedInstance].OrderCustomizationDetail)[index];
        
        for(int i=0;i<[customization count];++i)
        {
            NSMutableDictionary *dataitem=customization[i];
            NSMutableDictionary *customizations=dataitem[@"Customisation"];
            NSString *custId =[NSString stringWithFormat:@"%@",customizations[@"id"]];
            
            //insert customization data into table
            [self insertInTempCustomizationOrderService:tableno DishID:itemOrderId CustomizationId:custId];
            
            
            //NSString *custType=[customizations objectForKey:@"type"];
            NSMutableArray *Option=dataitem[@"Option"];
            for(int j=0;j<[Option count];++j)
            {
                NSMutableDictionary *optionDic=Option[j];
                NSString *optionid=[NSString stringWithFormat:@"%@",optionDic[@"id"]];
                NSString *optionprice=[NSString stringWithFormat:@"%@",optionDic[@"price"]];
                NSString *optionQty=[NSString stringWithFormat:@"%@",optionDic[@"quantity"]];
                
                //insert option detail
                [self insertInTempOptionOrderService:optionid ItemCustomizationId:itemCustomisationId price:optionprice optionQty:optionQty];
                if ([optionprice isEqualToString:@"0.00"]){
                    [self insertInItemModifierRaptor:@"POS011" OperatorNo:@"1" TableNo:[ShareableData sharedInstance].assignedTable1 SalesNo:[ShareableData sharedInstance].salesNo SplitNo:[ShareableData sharedInstance].splitNo SalesRef:salesRef Modifier:optionDic[@"name"]];
                   // [ShareableData sharedInstance].OrderItemID[index]
                }else{
                    [self insertInOpenItemRaptor:@"POS011" OperatorNo:@"1" TableNo:[ShareableData sharedInstance].assignedTable1 SalesNo:[ShareableData sharedInstance].salesNo SplitNo:[ShareableData sharedInstance].splitNo PLUNo:@"000000000000171" Qty:optionQty PLUName:optionDic[@"name"] Amount:optionprice];
                }
            }
        }
        
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if (CGRectContainsPoint([self.specialRequest frame], [touch locationInView:self.view])
        )
    {
        
    }
    else
    {
        [self.specialRequest resignFirstResponder];
    }
    
}




-(void)insertInTempOrder:(int)index
{
    //[self recallTableRaptor:[ShareableData sharedInstance].assignedTable1];
    
    NSString *tableNumber1=[ShareableData sharedInstance].assignedTable1;
    NSString *tableNumber2=[ShareableData sharedInstance].assignedTable2;
    NSString *tableNumber3=[ShareableData sharedInstance].assignedTable3;
    NSString *tableNumber4=[ShareableData sharedInstance].assignedTable4;
    
    NSString *DishID1=([ShareableData sharedInstance].OrderItemID)[index];
    NSString *DishName1=([ShareableData sharedInstance].OrderItemName)[index];
    NSString *DishQuantity1=([ShareableData sharedInstance].OrderItemQuantity)[index];
    NSString *DishRate1= [NSString stringWithFormat:@"%2f",[([ShareableData sharedInstance].OrderItemRate)[index] floatValue]/[DishQuantity1 intValue]];
    
    
    NSString *OrderSpecialRequest1=([ShareableData sharedInstance].OrderSpecialRequest)[index];
    
    NSString *OrderCustomizationDetail1=([ShareableData sharedInstance].OrderCustomizationDetail)[index];
    //NSString *OrderBeverageContainerId1=[[ShareableData sharedInstance].OrderBeverageContainerId objectAtIndex:index];
    NSString *OrderBeverageContainerId1=@"0";
    
    NSString *OrderCatId1=([ShareableData sharedInstance].OrderCatId)[index];
    NSString *confirmOrder1=([ShareableData sharedInstance].confirmOrder)[index];
    NSString *IsOrderCustomization1=([ShareableData sharedInstance].IsOrderCustomization)[index];
    
    //DLog(@"Rate : %@",DishRate1);
    
    
    if(![tableNumber1 isEqualToString:@"-1"])
    {
        [self insertInTempOrderService:tableNumber1 DishID:DishID1 DishName:DishName1 DishQuantity:DishQuantity1 DishRate:DishRate1 OrderSpecialRequest:OrderSpecialRequest1 OrderCustomizationDetail:OrderCustomizationDetail1 OrderBeverageContainerId:OrderBeverageContainerId1 OrderCatId:OrderCatId1 confirmOrder:confirmOrder1 IsOrderCustomization:IsOrderCustomization1];
        
        [self InsertCustomizationDetail:index tableNo:tableNumber1 DishId:DishID1];
        
    }
    else if(![tableNumber2 isEqualToString:@"-1"])
    {
        [self insertInTempOrderService:tableNumber2 DishID:DishID1 DishName:DishName1 DishQuantity:DishQuantity1 DishRate:DishRate1 OrderSpecialRequest:OrderSpecialRequest1 OrderCustomizationDetail:OrderCustomizationDetail1 OrderBeverageContainerId:OrderBeverageContainerId1 OrderCatId:OrderCatId1 confirmOrder:confirmOrder1 IsOrderCustomization:IsOrderCustomization1];
        
        [self InsertCustomizationDetail:index tableNo:tableNumber2 DishId:DishID1];
    }
    else if(![tableNumber3 isEqualToString:@"-1"])
    {
        [self insertInTempOrderService:tableNumber3 DishID:DishID1 DishName:DishName1 DishQuantity:DishQuantity1 DishRate:DishRate1 OrderSpecialRequest:OrderSpecialRequest1 OrderCustomizationDetail:OrderCustomizationDetail1 OrderBeverageContainerId:OrderBeverageContainerId1 OrderCatId:OrderCatId1 confirmOrder:confirmOrder1 IsOrderCustomization:IsOrderCustomization1];
        
        [self InsertCustomizationDetail:index tableNo:tableNumber3 DishId:DishID1];
    }
    else if(![tableNumber4 isEqualToString:@"-1"])
    {
        [self insertInTempOrderService:tableNumber4 DishID:DishID1 DishName:DishName1 DishQuantity:DishQuantity1 DishRate:DishRate1 OrderSpecialRequest:OrderSpecialRequest1 OrderCustomizationDetail:OrderCustomizationDetail1 OrderBeverageContainerId:OrderBeverageContainerId1 OrderCatId:OrderCatId1 confirmOrder:confirmOrder1 IsOrderCustomization:IsOrderCustomization1];
        
        [self InsertCustomizationDetail:index tableNo:tableNumber4 DishId:DishID1];
    }
    ///[self holdTableRaptor:[ShareableData sharedInstance].assignedTable1]; /holding te table from iPad
}


-(void)insertInTempOptionOrderService:(NSString*)optionId ItemCustomizationId:(NSString*)custId price:(NSString*)price optionQty:(NSString*)qty
{
    NSString *post =[NSString stringWithFormat:@"option_id=%@&item_customisation_id=%@&price=%@&quantity=%@&key=%@",optionId,custId,price,qty, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/set_option", [ShareableData serverURL]];
    [request setURL:[NSURL URLWithString:url_string]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    // DLog(@"Data :%@",data);
}



-(void)insertInTempCustomizationOrderService:(NSString*)tableNumber1 DishID:(NSString*)DishID1 CustomizationId:(NSString*)CustId
{
    NSString *post =[NSString stringWithFormat:@"dish_id=%@&table_id=%@&customisation_id=%@&key=%@",DishID1,tableNumber1,CustId, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/set_customisation", [ShareableData serverURL]];
    [request setURL:[NSURL URLWithString:url_string]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *buf=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    itemCustomisationId = [buf copy];
    DLog(@"Data :%@",buf);
}-(NSArray*)holdTableRaptor:(NSString*)table{
    NSArray* returnVal;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:kURL@"Raptor/HoldTable.php?POSID=%@&OperatorNo=%@&TableNo=%@&SalesNo=%@&SplitNo=%@",@"POS011",@"1",table,[ShareableData sharedInstance].salesNo,[ShareableData sharedInstance].splitNo]]];
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //  NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
    ////NSLOG(@"json = %@",json);
    
    if ([json count]!=0){
        returnVal = [json objectForKey:@"returnVal"];
    }
    // for (int i=0;i<[returnedNodes count];i++){
    
    //  }
    
    return returnVal;

    
}
-(NSArray*)forcePrint{
    NSArray* returnVal;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:kURL@"Raptor/ForcePrint.php?SalesNo=%@&SplitNo=%@",[ShareableData sharedInstance].salesNo,[ShareableData sharedInstance].splitNo]]];
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //  NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
    ////NSLOG(@"json = %@",json);
    
    if ([json count]!=0){
        returnVal = [json objectForKey:@"returnVal"];
    }
    // for (int i=0;i<[returnedNodes count];i++){
    
    //  }
    
    return returnVal;
    
    
}
-(NSArray*)recallTableRaptor:(NSString*)table{
    NSArray* returnVal;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:kURL@"Raptor/RecallTable.php?POSID=%@&OperatorNo=%@&TableNo=%@&SalesNo=%@&SplitNo=%@",@"POS011",@"1",table,[ShareableData sharedInstance].salesNo,[ShareableData sharedInstance].splitNo]]];
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //  NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
    ////NSLOG(@"json = %@",json);
    
    if ([json count]!=0){
        returnVal = [json objectForKey:@"returnVal"];
    }
    
    NSDictionary* node = [returnVal objectAtIndex:0];
    [node objectForKey:@"ErrCode"];
    
    return [node objectForKey:@"ErrCode"];
    
}


-(void)insertInOpenItemRaptor:(NSString*)POSID OperatorNo:(NSString*)OperatorNo TableNo:(NSString*)TableNo SalesNo:(NSString*)SalesNo SplitNo:(NSString*)SplitNo PLUNo:(NSString*)PLUNo Qty:(NSString*)Qty PLUName:(NSString*)PLUName Amount:(NSString*)Amount
{
    
    NSString *post =[NSString stringWithFormat:@"POSID=%@&OperatorNo=%@&TableNo=%@&SalesNo=%@&SplitNo=%@&PLUNo=%@&Qty=%@&Amount=%@&PLUName=%@",POSID,OperatorNo,TableNo,SalesNo,SplitNo,PLUNo,Qty,Amount,PLUName];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:kURL@"Raptor/OpenItem.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString *buf=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
    
    
    // if ([json count]!=0){
    NSArray* returnVal = [json objectForKey:@"returnVal"];
    
    // for (int i=0;i<[returnedNodes count];i++){
    NSDictionary* node = [returnVal objectAtIndex:0];
    salesRef = [node objectForKey:@"SalesRef"];
    
    
}
-(void)insertInItemRaptor:(NSString*)POSID OperatorNo:(NSString*)OperatorNo TableNo:(NSString*)TableNo SalesNo:(NSString*)SalesNo SplitNo:(NSString*)SplitNo PLUNo:(NSString*)PLUNo Qty:(NSString*)Qty ItemRemark:(NSString*)ItemRemark
{
    
    NSString *post =[NSString stringWithFormat:@"POSID=%@&OperatorNo=%@&TableNo=%@&SalesNo=%@&SplitNo=%@&PLUNo=%@&Qty=%@&ItemRemark=%@&CtgryID=%@",POSID,OperatorNo,TableNo,SalesNo,SplitNo,PLUNo,Qty,ItemRemark,[ShareableData sharedInstance].categoryID];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:kURL@"Raptor/OrderItem.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString *buf=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
    
    
    // if ([json count]!=0){
    NSArray* returnVal = [json objectForKey:@"returnVal"];
    
    // for (int i=0;i<[returnedNodes count];i++){
    NSDictionary* node = [returnVal objectAtIndex:0];
    salesRef = [node objectForKey:@"SalesRef"];
    
    
}
-(void)insertInItemModifierRaptor:(NSString*)POSID OperatorNo:(NSString*)OperatorNo TableNo:(NSString*)TableNo SalesNo:(NSString*)SalesNo SplitNo:(NSString*)SplitNo SalesRef:(NSString*)SalesRef Modifier:(NSString*)Modifier
{
    
    NSString *post =[NSString stringWithFormat:@"POSID=%@&OperatorNo=%@&TableNo=%@&SalesNo=%@&SplitNo=%@&SalesRef=%@&Modifier=%@",POSID,OperatorNo,TableNo,SalesNo,SplitNo,SalesRef,Modifier];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:kURL@"Raptor/CustomModifier.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *buf=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    
    
}



-(void)insertInTempOrderService:(NSString*)tableNumber1 DishID:(NSString*)DishID1 DishName:(NSString*)DishName1 DishQuantity:(NSString*)DishQuantity1 DishRate:(NSString*)DishRate1 OrderSpecialRequest:(NSString*)OrderSpecialRequest1 OrderCustomizationDetail:(NSString*)OrderCustomizationDetail1 OrderBeverageContainerId:(NSString*)OrderBeverageContainerId1 OrderCatId:(NSString*)OrderCatId1 confirmOrder:(NSString*)confirmOrder1 IsOrderCustomization:(NSString*)IsOrderCustomization1
{
    if (DishID1.length!=15){
        if ([OrderCatId1 isEqualToString:[ShareableData sharedInstance].bevCat]){
            [self insertInOpenItemRaptor:@"POS011" OperatorNo:@"1" TableNo:[ShareableData sharedInstance].assignedTable1 SalesNo:[ShareableData sharedInstance].salesNo SplitNo:[ShareableData sharedInstance].splitNo PLUNo:@"000000000000172" Qty:DishQuantity1 PLUName:DishName1 Amount:DishRate1];
            if (OrderSpecialRequest1.length<2){
                OrderSpecialRequest1 = @"";
            }else{
                 [self insertInItemModifierRaptor:@"POS011" OperatorNo:@"1" TableNo:[ShareableData sharedInstance].assignedTable1 SalesNo:[ShareableData sharedInstance].salesNo SplitNo:[ShareableData sharedInstance].splitNo SalesRef:salesRef Modifier:OrderSpecialRequest1];
            }
        }else{
            [self insertInOpenItemRaptor:@"POS011" OperatorNo:@"1" TableNo:[ShareableData sharedInstance].assignedTable1 SalesNo:[ShareableData sharedInstance].salesNo SplitNo:[ShareableData sharedInstance].splitNo PLUNo:@"000000000000171" Qty:DishQuantity1 PLUName:DishName1 Amount:DishRate1];
            if (OrderSpecialRequest1.length<2){
                OrderSpecialRequest1 = @"";
            }else{
                [self insertInItemModifierRaptor:@"POS011" OperatorNo:@"1" TableNo:[ShareableData sharedInstance].assignedTable1 SalesNo:[ShareableData sharedInstance].salesNo SplitNo:[ShareableData sharedInstance].splitNo SalesRef:salesRef Modifier:OrderSpecialRequest1];
            }
        }
    }else{
        if (OrderSpecialRequest1.length<2){
            OrderSpecialRequest1 = @"";
        }
        [self insertInItemRaptor:@"POS011" OperatorNo:@"1" TableNo:[ShareableData sharedInstance].assignedTable1 SalesNo:[ShareableData sharedInstance].salesNo SplitNo:[ShareableData sharedInstance].splitNo PLUNo:DishID1 Qty:DishQuantity1 ItemRemark:OrderSpecialRequest1];
    }
    NSString *post =[NSString stringWithFormat:@"table=%@&dish_id=%@&dish_name=%@&quantity=%@&price=%@&order_special_request=%@&order_customisation_detail=%@&order_beverage_container_id=%@&order_cat_id=%@&confirm_order=%@&is_order_customisation=%@&order_id=%@",tableNumber1,DishID1,DishName1,DishQuantity1,DishRate1,OrderSpecialRequest1,OrderCustomizationDetail1,OrderBeverageContainerId1,OrderCatId1,@"0",IsOrderCustomization1,[ShareableData sharedInstance].OrderId];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:kURL@"mm/webs/set_temp_order"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *buf=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    itemOrderId = [buf copy];
    DLog(@"Data :%@",buf);

    
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
    categoryTitle.textAlignment=UITextAlignmentCenter;
    return categoryTitle;
}
- (void)addRecommendation
{
    @try
    {
        [self GetSubCategoryId:orderCatId];
        [self getSubCategoryData:subCatId cat:orderCatId];
        if([DishName count]!=0)
        {
            //NSString *btnVal = @"8100149"; for beverages
            
            ////NSLOG(@"orderCatName in Recoomendation page====%@",orderCatName);
            soupView.catMenuLabel.text=[NSString stringWithFormat:@"Would you like to try some %@",[orderCatName substringFromIndex:2]];
            //////manoj
            soupView.catMenuLabel.text=[NSString stringWithFormat:@"How about a drink ?"];
            
            soupView.lblheading.text=[NSString stringWithFormat:@"Would you like to try a %@ with your selection:",orderCatName];
            soupView.DishImage.image=image;
            soupView.DishName1.text=DishName[0];
            soupView.DishName2.text=DishName[1];
            // 2100160
            
            // soupView.goToMenuBtn.tag = [[NSString stringWithFormat:@"%@1001%@",orderCatId,subCatId ] intValue];
            ////manoj
            soupView.goToMenuBtn.tag = [[NSString stringWithFormat:@"%@1001%@",[ShareableData sharedInstance].bevCat,@"149" ] intValue];
            
            
            // UILabel *titleX=[self KinaraaddCategoryTitle:[orderCatId intValue] labelValue:orderCatName];
            // [soupView.goToMenuBtn addSubview:titleX];
            // [soupView.goToMenuBtn.titleLabel setText:titleX.text];
            soupView.DishPrice1.text=[NSString stringWithFormat:@"$%@",DishPrice[0]];
            soupView.DishPrice2.text=[NSString stringWithFormat:@"$%@",DishPrice[1]];
            soupView.DishQuantity1.text=@"0";
            soupView.DishQuantity2.text=@"0";
            soupView.DishCatId=orderCatId;
            //[soupView setParent:self];
            soupView.view.frame=CGRectMake(120, 60, soupView.view.frame.size.width, soupView.view.frame.size.height);
            [self.view addSubview:soupView.view];
        }
        else
        {
            [self confirmOrder];
        }
        
    }
    @catch (NSException *exception)
    {
        
    }
    @finally 
    {
        
    }
}

-(int)getTotalCatDishes:(NSString*)catId
{
    int totalDishes = 0;
    for(int j=0;j<[[ShareableData sharedInstance].OrderCatId count];++j)
    {
        if([([ShareableData sharedInstance].OrderCatId)[j] isEqualToString:catId])
        {
            totalDishes++;
        }
    }
    return totalDishes;
}

-(int)getDishIndex:(NSString*)catId rowIndex:(NSInteger)index
{
    int i=0;
    for(int j=0;j<[[ShareableData sharedInstance].OrderCatId count];++j)
    {
        if([([ShareableData sharedInstance].OrderCatId)[j] isEqualToString:catId])
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

-(void)DishCategorized
{
    [sortCatId removeAllObjects];
    [orderCatIdList removeAllObjects];
    [orderCatNameList removeAllObjects];
    [sortDishId removeAllObjects];
    [subSortId removeAllObjects];
    totalOrderCat=0;
    if(!placeId)
    {
        placeId=[[NSString alloc]init];
        CatId =[[NSString alloc]init];
    }
    orderCatId=@"";
    orderCatName=@"";
    placeId=@"";
    CatId=@"";
    int total;
    // DLog(@"%@",[[ShareableData sharedInstance] OrderCatId]);
    for(int i=0;i<[[ShareableData sharedInstance].categoryIdList count];++i)
    {
        total=i;
        int count=0;
        NSString *catId=([ShareableData sharedInstance].categoryIdList)[i];
        NSString *catName=([ShareableData sharedInstance].categoryList)[i];
        for(int j=0;j<[[ShareableData sharedInstance].OrderCatId count];++j)
        {
            
            if([([ShareableData sharedInstance].OrderCatId)[j] isEqualToString:catId])
            {
                count=1;
                if(total==i)
                {
                    totalOrderCat++;
                    [orderCatIdList addObject:catId];
                    [orderCatNameList addObject:catName];
                    
                    total=[[ShareableData sharedInstance].categoryIdList count];
                }
                [sortCatId addObject:[NSString stringWithFormat:@"%d",j]];
                //break;
            }
            
        }
        if(count==0)
        {
            if([orderCatId isEqualToString:@""])
            {
                categoryTag=[NSString stringWithFormat:@"%d",i]; //narmeet
                orderCatId=catId;
                orderCatName=([ShareableData sharedInstance].categoryList)[i];
            }
        }
        
    }
    
    
    /* if ( totalOrderCat != [[ShareableData sharedInstance].OrderCatId count]){
     for (int p=0; p<[[ShareableData sharedInstance].OrderCatId count];p++){
     int hasCat = 0;
     for (int y =0;y<[sortCatId count];y++){
     
     if (([ShareableData sharedInstance].OrderCatId)[p]== ([ShareableData sharedInstance].categoryIdList)[y]){
     hasCat = 1;
     }
     }
     if (hasCat == 0){
     totalOrderCat++;
     [orderCatIdList addObject:@"1001"];
     [orderCatNameList addObject:@"Others"];
     [sortCatId addObject:[NSString stringWithFormat:@"%d",p]];
     
     }
     }
     }*/
}

-(int)getSectionIndex:(NSInteger)section
{
    for(int i=0;i<[sortDishId count];++i)
    {
        NSInteger index=[sortDishId[i]intValue];
        if(index==section)
        {
            return i;
        }
    }
    return 0;
}


-(void)DishSubCategorized:(NSInteger)sectionIndex
{
    // [sortDishId removeAllObjects];
    NSString *currentCatId=orderCatIdList[sectionIndex];
    NSMutableArray *subDishId=[[NSMutableArray alloc]init];
    //get subcategoryId
    // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    NSMutableArray *subCategoryData=[[TabSquareDBFile sharedDatabase]getSubCategoryData:currentCatId];
    for(int i=0;i<[subCategoryData count];++i)
    {
        NSMutableDictionary *subCategory=subCategoryData[i];
        NSString *subId=subCategory[@"id"];
        NSString *displayId=subCategory[@"display"];
        for(int j=0;j<[self getTotalCatDishes:orderCatIdList[sectionIndex]];++j)
        {
            int sortIndex=[self getDishIndex:orderCatIdList[sectionIndex] rowIndex:j];
            NSString *dishId=([ShareableData sharedInstance].OrderItemID)[sortIndex];
            
            
            if([currentCatId isEqualToString:[ShareableData sharedInstance].bevCat])
            {
                if ([displayId isEqualToString:@"1"]|| [dishId length]<15){
                    dishId=[[TabSquareDBFile sharedDatabase]getBeverageId:dishId];
                }
            }
            if (dishId.intValue !=0){
                NSString *dishSubId=[[TabSquareDBFile sharedDatabase]getSubCategoryIdData:dishId];
                if ([dishSubId length]<1){
                    if ([dishId isEqualToString:@"000000000000171"]){
                        dishSubId=@"138";
                    }else{
                        dishSubId=@"148";
                    }
                    
                }
                
                if([subId isEqualToString:dishSubId])
                {
                    [subDishId addObject:[NSString stringWithFormat:@"%d",sortIndex]];
                    //break;
                }
                
            }
            
        }
    }
    if (!([subDishId count]>0)){
        [subDishId addObject:[NSString stringWithFormat:@"%d",0]];
    }
    [sortDishId addObject:[NSString stringWithFormat:@"%d",sectionIndex]];
    [subSortId addObject:subDishId];
    //DLog(@"%@",subSortId);
    // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
}


-(UILabel*)addOptionName:(NSString*)optionText OptionFrame:(CGRect)optionFrame
{
    UILabel *optionName=[[UILabel alloc]initWithFrame:optionFrame];
    optionName.font=[UIFont fontWithName:@"Lucida Calligraphy" size:16];
    optionName.text=[optionText copy];
    optionName.backgroundColor=[UIColor clearColor];
    return optionName;
}

-(UILabel*)addOptionQunatity:(NSString*)optionQty OptionFrame:(CGRect)optionFrame
{
    UILabel *optionQuantity=[[UILabel alloc]initWithFrame:optionFrame];
    optionQuantity.font=[UIFont fontWithName:@"Lucida Calligraphy" size:16];
    optionQuantity.text=optionQty;
    optionQuantity.textAlignment=UITextAlignmentCenter;
    optionQuantity.backgroundColor=[UIColor colorWithRed:253.0f/255.0f green:214.0f/255.0f blue:162.0f/255.0f alpha:1.0];
    optionQuantity.layer.borderWidth=1.0;
    optionQuantity.layer.borderColor= [UIColor colorWithRed:242.0f/255.0f green:143.0f/255.0f blue:15.0f/255.0f alpha:1.0].CGColor;
    return optionQuantity;
}

-(NSString*)getOptionQuantity:(NSInteger)custIndex rowIndex:(NSInteger)optionindex sortIndex:(NSInteger)index
{
    NSMutableArray *dataitem=([ShareableData sharedInstance].OrderCustomizationDetail)[index];
    NSMutableDictionary *custDetail=dataitem[custIndex];
    NSMutableArray *Option=custDetail[@"Option"];
    NSMutableDictionary *optionDic=Option[optionindex];
    return optionDic[@"quantity"];
}

-(void)UpdateOptionCustomizationPrice:(NSInteger)custIndex rowIndex:(NSInteger)optionindex sortIndex:(NSInteger)index  currentQuantity:(int)currentQty
{
    NSMutableArray *dataitem=([ShareableData sharedInstance].OrderCustomizationDetail)[index];
    NSMutableDictionary *custDetail=dataitem[custIndex];
    NSMutableArray *Option=custDetail[@"Option"];
    NSMutableDictionary *optionDic=Option[optionindex];
    NSString *qty=optionDic[@"quantity"];
    int quantity=[qty intValue];
    float price=[optionDic[@"price"]floatValue]/quantity;
    NSString *currentPrice=[NSString stringWithFormat:@"%0.2f",price*currentQty];
    [self replaceOptionprice:custIndex rowIndex:optionindex sortIndex:index newValue:currentPrice];
}

-(void)replaceOptionQuantity:(NSInteger)custIndex rowIndex:(NSInteger)optionindex sortIndex:(NSInteger)index  newValue:(NSString*)value
{
    NSMutableArray *dataitem=([ShareableData sharedInstance].OrderCustomizationDetail)[index];
    NSMutableDictionary *custDetail=dataitem[custIndex];
    NSMutableArray *Option=custDetail[@"Option"];
    Option[optionindex][@"quantity"] = value;
}

-(void)replaceOptionprice:(NSInteger)custIndex rowIndex:(NSInteger)optionindex sortIndex:(NSInteger)index  newValue:(NSString*)value
{
    NSMutableArray *dataitem=([ShareableData sharedInstance].OrderCustomizationDetail)[index];
    NSMutableDictionary *custDetail=dataitem[custIndex];
    NSMutableArray *Option=custDetail[@"Option"];
    Option[optionindex][@"price"] = value;
}


-(IBAction)plusBtnClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    UIView *cellview  =  [btn superview];
    int sortIndex=cellview.tag;
    
    NSString *btntag=[NSString stringWithFormat:@"%d",btn.tag];
    NSMutableArray *array=[NSMutableArray array];
    if([btntag length]==2)
    {
        for(int i=0;i<[btntag length];++i)
        {
            NSString *index= [btntag substringWithRange:NSMakeRange(i, 1)];
            [array addObject:index];
        }
    }
    else
    {
        [array addObject:[NSString stringWithFormat:@"0"]];
        [array addObject:btntag];
    }
    
    NSString *quan=[self getOptionQuantity:[array[0]intValue] rowIndex:[array[1]intValue] sortIndex:sortIndex];
    int quantity = [quan intValue];
    ++quantity;
    NSString *updateQ=[NSString stringWithFormat:@"%d",quantity];
    [self UpdateOptionCustomizationPrice:[array[0]intValue] rowIndex:[array[1]intValue] sortIndex:sortIndex currentQuantity:quantity];
    [self replaceOptionQuantity:[array[0]intValue]  rowIndex:[array[1]intValue] sortIndex:sortIndex  newValue:updateQ];
    [self.OrderList reloadData];
    [self CalculateTotal];
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
    
    // [[NSUserDefaults standardUserDefaults] synchronize];
}

-(IBAction)minusBtnClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    UIView *cellview  =  [btn superview];
    int sortIndex=cellview.tag;
    
    NSString *btntag=[NSString stringWithFormat:@"%d",btn.tag];
    NSMutableArray *array=[NSMutableArray array];
    if([btntag length]==2)
    {
        for(int i=0;i<[btntag length];++i)
        {
            NSString *index= [btntag substringWithRange:NSMakeRange(i, 1)];
            [array addObject:index];
        }
    }
    else
    {
        [array addObject:[NSString stringWithFormat:@"0"]];
        [array addObject:btntag];
    }
    
    NSString *quan=[self getOptionQuantity:[array[0]intValue] rowIndex:[array[1]intValue] sortIndex:sortIndex];
    int quantity = [quan intValue];
    if(quantity>1)
    {
        --quantity;
        NSString *updateQ=[NSString stringWithFormat:@"%d",quantity];
        [self UpdateOptionCustomizationPrice:[array[0]intValue] rowIndex:[array[1]intValue] sortIndex:sortIndex currentQuantity:quantity];
        [self replaceOptionQuantity:[array[0]intValue]  rowIndex:[array[1]intValue] sortIndex:sortIndex  newValue:updateQ];
        [self.OrderList reloadData];
        [self CalculateTotal];
    }
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
        
        // [[NSUserDefaults standardUserDefaults] synchronize];
    });
    
}

-(UIButton*)createMinusbutton:(CGRect)btnFrame
{
    UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
    add.frame=btnFrame;
    [add setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
    [add setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateHighlighted];
    [add setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateSelected];
    [add addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return add;
}

-(UIButton*)createPlusbutton:(CGRect)btnFrame
{
    UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
    add.frame=btnFrame;
    [add setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [add setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateHighlighted];
    [add setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateSelected];
    [add addTarget:self action:@selector(plusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return add;
}

-(void)addCustomization:(UITableViewCell*)cell rowIndex:(NSInteger)index
{
    int ignoreSpec = 0;
    NSString *custType=([ShareableData sharedInstance].IsOrderCustomization)[index];
    int ccustType=[custType intValue];
    
    NSString *dishName= ([ShareableData sharedInstance].OrderItemName)[index];
    CGSize newsize= [dishName sizeWithFont:[UIFont fontWithName:@"Lucida Calligraphy" size:18] constrainedToSize:CGSizeMake(264, 400) lineBreakMode:UILineBreakModeWordWrap];
    custOriginY=12+newsize.height;
    
    float OptionY=custOriginY;
    int count=0;
    NSString* specReq=@"";
    DLog(@"Cust Type : %@",custType);//kalim
    DLog(@"int Cust Type : %d",ccustType);//kalim
    if([custType isEqualToString:@"1"]|| [custType length] > 1)
        //if(ccustType==1)//kalim
    {
        NSMutableArray *customization=([ShareableData sharedInstance].OrderCustomizationDetail)[index];
        
        DLog(@"CCC: %@",customization);
        DLog(@"CCC Count : %d",[customization count]);
        
        for(int i=0;i<[customization count];++i)
        {
            NSMutableDictionary *dataitem=customization[i];
            // NSMutableDictionary *customizations=dataitem[@"Option"];
            //   NSString *custType=customizations[@"name"];
            //NSMutableArray *Option=dataitem[@"Option"];
            //for(int j=0;j<[Option count];++j)
            // {
            if ([dataitem[@"Option"] isKindOfClass:[NSArray class]]){
                for (int y=0;y<[dataitem[@"Option"] count];y++){
                    OptionY=35*count+custOriginY;
                    count++;
                    NSString *optionname=[[dataitem[@"Option"] objectAtIndex:y] objectForKey:@"name"] ;
                    UILabel *optionName=[self addOptionName:optionname OptionFrame:CGRectMake(60, OptionY, 180, 40)];
                    [cell.contentView addSubview:optionName];
                }
                
                /*  if([custType isEqualToString:@"1"])
                 {
                 
                 NSString *optionprice=[NSString stringWithFormat:@"$%@",@"0.00"];
                 UILabel *optionPrice=[self addOptionName:optionprice OptionFrame:CGRectMake(348, OptionY, 150, 40)];
                 [cell.contentView addSubview:optionPrice];
                 
                 NSString *btntag=[NSString stringWithFormat:@"%d%d",i,0];
                 
                 NSString *optionQty=@"0";//optionDic[@"quantity"];
                 UILabel *optionQunatity=[self addOptionQunatity:optionQty OptionFrame:CGRectMake(618, OptionY+12, 28, 29)];
                 [cell.contentView addSubview:optionQunatity];
                 
                 NSString *isOrderConfirm = ([ShareableData sharedInstance].confirmOrder)[index];
                 if([isOrderConfirm isEqualToString:@"0"])
                 {
                 UIButton *minusBtn=[self createMinusbutton:CGRectMake(590, OptionY+12, 30, 27)];
                 minusBtn.tag=[btntag intValue];
                 [cell.contentView addSubview:minusBtn];
                 
                 UIButton *plusBtn=[self createPlusbutton:CGRectMake(645, OptionY+12, 30, 27)];
                 plusBtn.tag=[btntag intValue];
                 [cell.contentView addSubview:plusBtn];
                 }
                 }*/
                // OptionY=35*(j+1);
                //}
            }else{
                NSString *special= dataitem[@"Option"] ;
                if(count!=0 || [dataitem count]!=0)
                {
                    OptionY=35*i+custOriginY;
                }
                UILabel *specialrequest=[self addOptionName:special OptionFrame:CGRectMake(60, OptionY, 180, 40)];
                [cell.contentView addSubview:specialrequest];
            }
            
        }
        
    }
    @try{
        NSString *special=([ShareableData sharedInstance].OrderSpecialRequest)[index];
        //int spv=[special intValue];
        if(![special isEqualToString:@"0"])
            //if(spv!=0)
        {
            if(count!=0)
            {
                OptionY=OptionY+35;
            }
            UILabel *specialrequest=[self addOptionName:special OptionFrame:CGRectMake(60, OptionY, 150, 40)];
            [cell.contentView addSubview:specialrequest];
        }
    }@catch(NSException *ex){
        
    }
    //
    //int spv=[special intValue];
    // if(![special isEqualToString:@"0"])
    //if(spv!=0)
    //{
    
    // }
    
    
}

-(int)gettotalCustomization:(NSInteger)index
{
    int total = 0;
    NSMutableArray *customization=([ShareableData sharedInstance].OrderCustomizationDetail)[index];
    /* for(int i=0;i<[customization count];++i)
     {
     NSMutableDictionary *dataitem=customization[i];
     // NSMutableDictionary *customizations=[dataitem objectForKey:@"Customisation"];
     NSMutableArray *Option=dataitem[@"Option"];
     for(int j=0;j<[Option count];++j)
     {
     // NSMutableDictionary *optionDic=[Option objectAtIndex:j];
     //NSString *optionQty=[optionDic objectForKey:@"quantity"];
     //if([optionQty intValue]>=1)
     // {
     total++;
     // }
     }
     }*/
    return [customization count];
}

#pragma mark Table view methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //[self DishCategorized];
    // DLog(@"NO OF ROWS!!!! BASKETTT %d",totalOrderCat);
    return 1;//totalOrderCat;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // [self DishSubCategorized:section];
    
    //  return [self getTotalCatDishes:orderCatIdList[section]];
    return [[ShareableData sharedInstance].OrderItemName count];
}

/*-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0,8.0,tableView.bounds.size.width, 40)];
 customView.backgroundColor = [UIColor grayColor];
 
 UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
 headerLabel.backgroundColor = [UIColor clearColor];
 headerLabel.opaque = NO;
 headerLabel.textColor = [UIColor whiteColor];
 headerLabel.font = [UIFont boldSystemFontOfSize:18];
 headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
 headerLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
 headerLabel.frame = CGRectMake(11,-11, 320.0, 44.0);
 headerLabel.textAlignment = UITextAlignmentLeft;
 NSString* headertxt=orderCatNameList[section];
 headerLabel.text=headertxt;
 [customView addSubview:headerLabel];
 return customView;
 }*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrderCellList";
    
    OrderCell *cell = (OrderCell *)[self.OrderList dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell==nil)
    {
        [[NSBundle mainBundle]loadNibNamed:@"OrderCellList" owner:self options:nil];
        cell=self.tmpCell;
        self.tmpCell=nil;
    }
    // int sortIndex=[self getDishIndex:[orderCatIdList objectAtIndex:indexPath.section] rowIndex:indexPath.row];
    //  NSInteger index=[self getSectionIndex:indexPath.section];
    
    //   NSMutableArray *d = subSortId[index];
    // int sortIndex = [d[indexPath.row] intValue];
    int sortIndex = indexPath.row;
    cell.Srl = [NSString stringWithFormat:@"%d",indexPath.row +1];
    cell.IsOrderConfirm=([ShareableData sharedInstance].confirmOrder)[sortIndex];
    cell.Quantity=([ShareableData sharedInstance].OrderItemQuantity)[sortIndex];
    cell.DishName=([ShareableData sharedInstance].OrderItemName)[sortIndex];
    cell.Price=[NSString stringWithFormat:@"$%@",([ShareableData sharedInstance].OrderItemRate)[sortIndex]];
    cell.Price2=[NSString stringWithFormat:@"$%0.2f",[([ShareableData sharedInstance].OrderItemRate)[sortIndex] floatValue]/[([ShareableData sharedInstance].OrderItemQuantity)[sortIndex] intValue]];
    cell.btnTagAdd=[NSString stringWithFormat:@"%d",sortIndex];
    cell.contentView.tag=sortIndex;
    cell.btnTagInfo=[NSString stringWithFormat:@"%d",sortIndex];
    cell.btnTagMinus=[NSString stringWithFormat:@"%d",sortIndex];
    cell.btnTagRemove=[NSString stringWithFormat:@"%d",sortIndex];
    [self addCustomization:cell rowIndex:sortIndex];
    return cell;
}

/*-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
 {
 UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0,4.0,tableView.bounds.size.width, 40)];
 footerView.backgroundColor = [UIColor clearColor];
 return footerView;
 }
 
 -(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
 {
 return 10;
 }*/


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight=60;
    //DLog(@"%d",indexPath.section);
    // int sortIndex=[self getDishIndex:[orderCatIdList objectAtIndex:indexPath.section] rowIndex:indexPath.row];
    
    //  NSInteger index=[self getSectionIndex:indexPath.section];
    //  data=subSortId[index];
    // int sortIndex=[data[indexPath.row]intValue];
    int sortIndex = indexPath.row;
    //DLog(@"%@",sortDishId);
    NSString *dishName= ([ShareableData sharedInstance].OrderItemName)[sortIndex];
    CGSize newsize= [dishName sizeWithFont:[UIFont fontWithName:@"Lucida Calligraphy" size:18] constrainedToSize:CGSizeMake(264, 400) lineBreakMode:UILineBreakModeWordWrap];
    
    if(newsize.height>60)
    {
        cellHeight= newsize.height+5;
    }
    NSString *custType=([ShareableData sharedInstance].IsOrderCustomization)[sortIndex];
    if([custType isEqualToString:@"1"])
    {
        int custCount=[self gettotalCustomization:sortIndex];
        cellHeight = (35*custCount)+cellHeight;
    }
    NSString *special=([ShareableData sharedInstance].OrderSpecialRequest)[sortIndex];
    if(![special isEqualToString:@"0"])
    {
        cellHeight = cellHeight+30;
    }
    return cellHeight;
}


-(void) showIndicator:(int)tag
{
    /*UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)];
     progressHud= [[MBProgressHUD alloc] initWithView:progressView];
     [self.view addSubview:progressHud];
     [self.view bringSubviewToFront:progressHud];
     progressHud.delegate = self;*/
    if(tag==0)
    {
        [self myTask];
        // [progressHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
    else
    {
        //[progressHud showWhileExecuting:@selector(addRecommendation) onTarget:self withObject:nil animated:YES];
        if (tapCount==1) {
            [self addRecommendation];
            
        }
        else{
            
            [self confirmOrder];
        }
    }
	
}

- (void)myTask
{
    
    NSString *orderId=([ShareableData sharedInstance].OrderItemID)[selectedItemIndex];
    // [ShareableData sharedInstance].or
    //get data from DB
    // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    if([([ShareableData sharedInstance].OrderCatId)[selectedItemIndex]isEqualToString:[ShareableData sharedInstance].bevCat])
    {
        NSString *temp=[[TabSquareDBFile sharedDatabase]getBeverageId:orderId];
        if (temp.intValue != 0){
            orderId = [temp copy];
        }
    }
    NSMutableArray *resultFromPost=[[TabSquareDBFile sharedDatabase]getDishDataDetail:orderId];
    //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    
    //  [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    NSString *dishCatId2 = ([ShareableData sharedInstance].OrderCatId)[selectedItemIndex];
    NSString *dishSubCatId2 = [NSString stringWithFormat:@"%@",resultFromPost[0][@"sub_category"]];
    int bevDisplay = 0;
    
    if([dishCatId2 isEqualToString:[ShareableData sharedInstance].bevCat]){
        [ShareableData sharedInstance].TaskType = @"3";
        NSMutableArray *subCategoryData=[[TabSquareDBFile sharedDatabase]getSubCategoryData:[ShareableData sharedInstance].bevCat];
        for(int i=0;i<[subCategoryData count];++i){
            NSMutableDictionary *subCategory=subCategoryData[i];
            NSString *subId=subCategory[@"id"];
            NSString *displayId=subCategory[@"display"];
            if ([subId isEqualToString:dishSubCatId2]&&[displayId isEqualToString:@"1"]){
                bevDisplay = 1;
                [beveragesBeerView2 reloadDataOfSubCat:dishSubCatId2 cat:dishCatId2];
                [beveragesBeerView2.beverageView reloadData];
            }
            
        }
        
        //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    }
    if (bevDisplay == 1){
        // NSMutableArray *beverageCustomization;
        // NSMutableArray *beverageSkuDetail;
        // NSMutableArray *beverageCustType;
        beerDetailView =[[TabSquareNewBeerScrollController alloc]initWithNibName:@"TabSquareNewBeerScrollController" bundle:nil];
        beerDetailView.beverageView = self;
        
        beerDetailView.tempDishID = orderId.intValue;
        
        beerDetailView.orderScreenFlag=@"1";
        beerDetailView.selectedIndex=[NSString stringWithFormat:@"%d",selectedItemIndex];
        // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
        beerDetailView.beverageSKUDetail=[[TabSquareDBFile sharedDatabase]getBeverageSkuDetail:orderId];
        // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
        beerDetailView.beverageCatId=[NSString stringWithFormat:@"%d",8];
        beerDetailView.beverageCustomization=resultFromPost[0][@"customisations"];
        beerDetailView.drinkNameFromOrderSummary=resultFromPost[0][@"name"];
        beerDetailView.drinkDescriptionFromOrderSummary=resultFromPost[0][@"description"];//[NSString stringWithFormat:@"%@",dataitem[@"price"]];
        beerDetailView.beverageCutType=resultFromPost[0][@"cust"];
        //UIImage *imageUrl = [UIImage imageWithContentsOfFile:resultFromPost[0][@"images"]];
        //if(imageUrl)
        //{
            beerDetailView.KDishImage=[UIImage imageWithContentsOfFile:resultFromPost[0][@"images"]];
        //}
        [beerDetailView.beverageSkUView reloadData];
        beerDetailView.selectedItemIndex=selectedItemIndex;
        
        //[beerDetailView loadBeverageData:selectedItemIndex];
        [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
        [self.view addSubview:beerDetailView.view];
        [self.view bringSubviewToFront:beerDetailView.view];
    }else{
        
        
        
        [menudetailView.KDishCust removeAllObjects];
        //[menudetailView removeSwipeSubviews];
        //[menudetailView.swipeDetailView addSubview:menudetailView.detailView1.view];
        //menudetailView.swipeDetailView.scrollEnabled=NO;
        menudetailView.orderSummaryView=self;
        menudetailView.IshideAddButton=@"1";
        //menudetailView.detailView1.Viewtype=@"2";
       // [menudetailView.menuDetailView.view removeFromSuperview];
        menudetailView.view.frame=CGRectMake(10,-10, menudetailView.view.frame.size.width, menudetailView.view.frame.size.height);
        [self.view addSubview:menudetailView.view];
        ////NSLOG(@"resultFromPost==%@",resultFromPost);

        for(int i=0;i<[resultFromPost count];i++)
        {
            NSMutableDictionary *dataitem=resultFromPost[i];
            menudetailView.KDishCatId=[NSString stringWithFormat:@"%@",([ShareableData sharedInstance].OrderCatId)[selectedItemIndex]];
            menudetailView.KDishName.text=[NSString stringWithFormat:@"%@",dataitem[@"name"]];
            menudetailView.KDishRate.text=[NSString stringWithFormat:@"%@",dataitem[@"price"]];
            menudetailView.KDishDescription.text=[NSString stringWithFormat:@"%@",dataitem[@"description"]];
            menudetailView.kDishId =[NSString stringWithFormat:@"%@",orderId];
            [menudetailView.KDishCust addObject:dataitem[@"customisations"]];
            menudetailView.KDishCustType=[NSString stringWithFormat:@"%@",dataitem[@"cust"]];
            menudetailView.KDishName.font=[UIFont fontWithName:@"Century Gothic" size:21];
            CGSize newsize=  [menudetailView.KDishName.text sizeWithFont:menudetailView.KDishName.font constrainedToSize:CGSizeMake(241, 400) lineBreakMode: menudetailView.KDishName.lineBreakMode];
            menudetailView.KDishName.frame=CGRectMake( menudetailView.KDishName.frame.origin.x, menudetailView.KDishName.frame.origin.y, newsize.width, newsize.height);
            menudetailView.orderScreenFlag=@"1";

            UIImage *imageUrl = [UIImage imageWithContentsOfFile:dataitem[@"images"]];
            if(imageUrl)
            {
                menudetailView.KDishImage=[UIImage imageWithContentsOfFile:dataitem[@"images"]];
            }
            break;
        }
        
        //[menudetailView  hideButtons];
    }
}

-(IBAction)infoClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    selectedItemIndex=btn.tag;
    [self showIndicator:0];
}

-(IBAction)removeClicked:(id)sender
{
    @try
    {
        UIButton *btn=(UIButton*)sender;
        int tag=btn.tag;
        [[ShareableData sharedInstance].OrderItemID  removeObjectAtIndex:tag];
        [[ShareableData sharedInstance].OrderItemName  removeObjectAtIndex:tag];
        [[ShareableData sharedInstance].OrderItemRate  removeObjectAtIndex:tag];
        [[ShareableData sharedInstance].OrderItemQuantity  removeObjectAtIndex:tag];
        [[ShareableData sharedInstance].IsOrderCustomization removeObjectAtIndex:tag];
        [[ShareableData sharedInstance].OrderCustomizationDetail removeObjectAtIndex:tag];
        [[ShareableData sharedInstance].OrderCatId removeObjectAtIndex:tag];
        [[ShareableData sharedInstance].confirmOrder removeObjectAtIndex:tag];
        [[ShareableData sharedInstance].OrderSpecialRequest removeObjectAtIndex:tag];
        
        [self.OrderList reloadData];
        [self CalculateTotal];
        
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

-(void)UpdateOrderPrice:(int)itemIndex currentQuantity:(int)currentQty
{
    int quantity= [([ShareableData sharedInstance].OrderItemQuantity)[itemIndex]intValue];
    float price=[([ShareableData sharedInstance].OrderItemRate)[itemIndex]floatValue]/quantity;
    NSString *currentPrice=[NSString stringWithFormat:@"%0.2f",price*currentQty];
    ([ShareableData sharedInstance].OrderItemRate)[itemIndex] = currentPrice;
}


-(IBAction)minusClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    int tag=btn.tag;
    int inMinus = 0;
    // DLog(@"Index Selected : %d",tag);
    int quantity = [([ShareableData sharedInstance].OrderItemQuantity)[tag] intValue];
    if(quantity>1)
    {
        --quantity;
        NSString *updateQ=[NSString stringWithFormat:@"%d",quantity];
        [self UpdateOrderPrice:tag currentQuantity:quantity];
        ([ShareableData sharedInstance].OrderItemQuantity)[tag] = updateQ;
        [self.OrderList reloadData];
        [self CalculateTotal];
        inMinus = 1;
    }
    if (quantity == 1 && inMinus == 0){
        [self removeClicked:sender];
    }
}

-(IBAction)plusClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    int tag=btn.tag;
    // DLog(@"Index Selected : %d",tag);
    
    int quantity = [([ShareableData sharedInstance].OrderItemQuantity)[tag] intValue];
    ++quantity;
    NSString *updateQ=[NSString stringWithFormat:@"%d",quantity];
    [self UpdateOrderPrice:tag currentQuantity:quantity];
    ([ShareableData sharedInstance].OrderItemQuantity)[tag] = updateQ;
    [self.OrderList reloadData];
    [self CalculateTotal];
}

-(void)InsertOrderData:(NSString *)orderID orderName:(NSString *)orderName orderRate:(NSString *)orderRate orderIsSpicy:(NSString *)orderIsSpicy orderIsOily:(NSString *)orderIsOily orderQuantity:(NSString *)orderQuantity
{
    //NSString *Key=@"kinara123";
    
    NSString *post =[NSString stringWithFormat:@"key=%@&order_id=%@&name=%@&rate=%@&is_spicy=%@&is_oily=%@&quantity=%@", [ShareableData appKey],orderID,orderName,orderRate,orderIsSpicy,orderIsOily,orderQuantity];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/insert_order", [ShareableData serverURL]];
    [request setURL:[NSURL URLWithString:url_string]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    //    DLog(@"Main Course Shakahari for vegetarians : %@",data);
}

-(float)getTotalCustomizationRate:(int)index
{
    
    /* float custPrice=0;
     NSString *custType=([ShareableData sharedInstance].IsOrderCustomization)[index];
     if([custType isEqualToString:@"1"])
     {
     DLog(@" WHAT!!: %@",([ShareableData sharedInstance].OrderCustomizationDetail)[index]);
     NSMutableArray *customization=([ShareableData sharedInstance].OrderCustomizationDetail)[index];
     for(int i=0;i<[customization count];++i)
     {
     NSMutableDictionary *dataitem=customization[i];
     NSMutableDictionary *customizations=dataitem[@"Customisation"];
     NSString *custType=customizations[@"type"];
     NSMutableArray *Option=dataitem[@"Option"];
     if([custType isEqualToString:@"1"])
     {
     for(int j=0;j<[Option count];++j)
     {
     NSMutableDictionary *optionDic=Option[j];
     NSString *optionprice=optionDic[@"price"];
     // DLog(@"%f",[optionprice floatValue]);
     custPrice+=[optionprice floatValue];
     }
     
     
     }
     
     }
     
     
     }*/
    
    return 0;
    
}

-(void)CalculateTotal
{
    lblTotal.text=@"0";
    float total=[lblTotal.text floatValue];
    int totalQty = 0;
    
    for(int i=0;i<[[ShareableData sharedInstance].OrderItemID  count];i++)
    {
        totalQty += [([ShareableData sharedInstance].OrderItemQuantity)[i] intValue];
        float custPrice=[self getTotalCustomizationRate:i];
        total+=[([ShareableData sharedInstance].OrderItemRate)[i] floatValue]+custPrice;
    }
    //int finaltotal = lroundf(total);
    lblTotalPrice.text=[NSString stringWithFormat:@"$%.2f",total];
    lblGST.text=[NSString stringWithFormat:@"$%.2f",(total*7)/100];
    lblSubTotal.text=[NSString stringWithFormat:@"$%.2f",(total*107/100)];
    // lblTotal.font=[UIFont fontWithName:@"Lucida Calligraphy" size:22];
    totalTitle.text=[NSString stringWithFormat:@"%i Items Added",totalQty];
    if (totalQty == 0){
        /*
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OrderItemID"];
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
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        NSString *libraryDirectory = [paths lastObject];
        NSString *location = [libraryDirectory stringByAppendingString:@"/orderarrays.plist"];
        
        //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"orderarrays" ofType:@"plist"];
        // NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        // NSArray *array = [[NSArray alloc] initWithContentsOfFile:location];
        // NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"orderstrings" ofType:@"plist"];
        // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        // NSString *libraryDirectory = [paths objectAtIndex:0];
        NSString *location2 = [libraryDirectory stringByAppendingString:@"/orderstrings.plist"];
        // NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        //  NSArray *array2 = [[NSArray alloc] initWithContentsOfFile:location2];
        
        [[NSFileManager defaultManager] removeItemAtPath:location error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:location2 error:nil];
        // [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)filterData
{
    NSMutableArray *TempOrderItemID=[[NSMutableArray alloc]init];
    NSMutableArray *TempOrderItemName=[[NSMutableArray alloc]init];
    NSMutableArray *TempOrderItemRate=[[NSMutableArray alloc]init];
    NSMutableArray *TempOrderItemQuantity=[[NSMutableArray alloc]init];
    NSMutableArray *TempOrderCatId=[[NSMutableArray alloc]init];
    NSMutableArray *TempOrderCustomizationDetail =[[NSMutableArray alloc]init];
    NSMutableArray *TempConfirmOrder=[[NSMutableArray alloc]init];
    NSMutableArray *TempIsOrderCustomization=[[NSMutableArray alloc]init];
    NSMutableArray *TempIsOrderSpecial=[[NSMutableArray alloc]init];
    
    //DLog(@"%d",[[ShareableData sharedInstance].OrderItemID count]);
    //DLog(@"%d",[[ShareableData sharedInstance].OrderCatId count]);
    for(int i=0;i<[[ShareableData sharedInstance].OrderItemID count];i++)
    {
        if(!([([ShareableData sharedInstance].OrderItemQuantity)[i] isEqualToString:@"0"] || [([ShareableData sharedInstance].OrderItemID)[i] isEqualToString:@"SpecialS1"]))
        {
            //DLog(@"%@",[[ShareableData sharedInstance].OrderItemName objectAtIndex:i]);
            [TempOrderItemID addObject:([ShareableData sharedInstance].OrderItemID)[i]];
            [TempOrderItemName addObject:([ShareableData sharedInstance].OrderItemName)[i]];
            [TempOrderItemRate addObject:([ShareableData sharedInstance].OrderItemRate)[i]];
            [TempOrderItemQuantity addObject:([ShareableData sharedInstance].OrderItemQuantity)[i]];
            [TempOrderCatId addObject:([ShareableData sharedInstance].OrderCatId)[i]];
            [TempConfirmOrder addObject:([ShareableData sharedInstance].confirmOrder)[i]];
            [TempIsOrderCustomization addObject:([ShareableData sharedInstance].IsOrderCustomization)[i]];
            [TempOrderCustomizationDetail addObject:([ShareableData sharedInstance].OrderCustomizationDetail)[i]];
            [TempIsOrderSpecial addObject:([ShareableData sharedInstance].OrderSpecialRequest)[i]];
        }
        
        if([([ShareableData sharedInstance].OrderItemID)[i] isEqualToString:@"SpecialS1"])
        {
            //DLog(@"%@",[[ShareableData sharedInstance].OrderItemName objectAtIndex:i]);
            self.specialRequest.text=[NSString stringWithFormat:@"%@\n%@",self.specialRequest.text,
                                      ([ShareableData sharedInstance].OrderItemName)[i]];
        }
    }
    
    [[ShareableData sharedInstance].OrderItemID removeAllObjects];
    [[ShareableData sharedInstance].OrderItemName removeAllObjects];
    [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
    [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
    [[ShareableData sharedInstance].OrderCatId removeAllObjects];
    [[ShareableData sharedInstance].confirmOrder removeAllObjects];
    [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
    [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
    [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
    for(int j=0;j<[TempOrderItemID count];j++)
    {
        [[ShareableData sharedInstance].OrderItemID addObject:TempOrderItemID[j]];
        [[ShareableData sharedInstance].OrderItemName addObject:TempOrderItemName[j]];
        [[ShareableData sharedInstance].OrderItemRate addObject:TempOrderItemRate[j]];
        [[ShareableData sharedInstance].OrderItemQuantity addObject:TempOrderItemQuantity[j]];
        [[ShareableData sharedInstance].OrderCatId addObject:TempOrderCatId[j]];
        [[ShareableData sharedInstance].confirmOrder addObject:TempConfirmOrder[j]];
        [[ShareableData sharedInstance].OrderCustomizationDetail addObject:TempOrderCustomizationDetail[j]];
        [[ShareableData sharedInstance].IsOrderCustomization addObject:TempIsOrderCustomization[j]];
        [[ShareableData sharedInstance].OrderSpecialRequest addObject:TempIsOrderSpecial[j]];
    }
    
    
}

- (void)view:(UIView *)view willRemoveSubview:(UIView *)subview{
    [self.OrderList reloadData];
    [self CalculateTotal];
}


- (void)checkForWIFIConnection {
    Reachability* wifiReach = [Reachability reachabilityForLocalWiFi];
    
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    
    if (netStatus!=ReachableViaWiFi)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No WIFI available!", @"AlertView")
                                                            message:NSLocalizedString(@"You have no wifi connection available. Please connect to a WIFI network.", @"AlertView")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
                                                  otherButtonTitles:NSLocalizedString(@"Check Your Settings", @"AlertView"), nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=AIRPLANE_MODE"]];
        NSURL*url=[NSURL URLWithString:@"prefs:root=WIFI"];
        [[UIApplication sharedApplication] openURL:url];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [self checkForWIFIConnection];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

-(void)keyboardWillShow
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    CGRect rect = self.view.frame;
    rect.origin.y -= 150;
    rect.size.height += 150;
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)keyboardWillHide
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    CGRect rect = self.view.frame;
    rect.origin.y += 150;
    rect.size.height -= 150;
    self.view.frame = rect;
    [UIView commitAnimations];
}


@end
