

#import "TabSquareTableManagement.h"
#import "TabSquareAssignTable.h"
#import <QuartzCore/CALayer.h>
#import "ShareableData.h"
#import "TabSquareTableStatus.h"
#import "SBJSON.h"
#import "TabSquareMenuController.h"
#import "TabSquareHomeController.h"
#import "TabSquareDBFile.h"
#import "TabSquarePlaogramView.h"
#import "TabSquareCommonClass.h"
#import "Reachability.h"
#import "TabSquareRemoteActivation.h"


#define FIXED_VIEW_ALERT    1999

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 3

@implementation TabSquareTableManagement

@synthesize tableNoView,statusView,TotalTableNo,takeawayButton,takeawayAssignBtn, tableNumber,oldTableNumber, bgImage,sectionID;
@synthesize numberOfGuests;
@synthesize quickOrderSwitch,specialReqSwitch;

int switchMode = 0;

bool funcCalled = NO;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
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


-(void)getTotalNumberofTable
{
    //NSString *Key=@"kinara123";
    
    NSString *post =[NSString stringWithFormat:@"key=%@", [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_tables", [ShareableData serverURL]];
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
    //DLog(@"Data :%@",data);
    TotalTableNo = @"";
    TotalTableNo=@"30";//special request by Sankaran;
      
}

-(void)getTables
{
    //NSString *Key=@"kinara123";
    
    NSString *post =[NSString stringWithFormat:@"SectionID=%@", sectionID ];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:kURL@"Raptor/GetTableStatus.php"];
    [request setURL:[NSURL URLWithString:url_string]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    //DLog(@"Data :%@",data);
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
   // ////NSLOG(@"json = %@",json);
    
  
      
    
   // NSMutableArray* temp = [TotalFreeTables copy];
   // NSDictionary* node = [returnVal objectAtIndex:0];
    // [node objectForKey:@"ErrCode"];
    @try{
         NSArray* returnVal = [json objectForKey:@"returnVal"];
        if ([TotalFreeTables count]>0){
        [TotalFreeTables replaceObjectsInRange:(NSMakeRange(0, [TotalFreeTables count])) withObjectsFromArray:returnVal range:(NSMakeRange(0, [returnVal count]))];
        }else{
            [TotalFreeTables addObjectsFromArray:returnVal];
        }
  /*  for(int i=0;i<[resultFromPost count];i++)
    {
        [TotalFreeTables addObject:[NSString stringWithFormat:@"%@",resultFromPost[i]]];
    }*/
   
    } @catch (NSException* ex) {
        
        
    }
    
    [ShareableData sharedInstance].totalFreeTables = TotalFreeTables;
    ////NSLOG(@"Total Free Tables = %@", TotalFreeTables);
}

-(void)getTableStatusView
{
   // [TableStatus removeAllObjects];
    for(int i=1,k=0;i<=[TotalFreeTables count];++i,++k)
    {
        NSString *tableno=[[TotalFreeTables objectAtIndex:i-1] objectForKey:@"TBLNo"];
       /* if ([TableStatus count]<TotalTableNo.intValue){
        [TableStatus addObject:@"0"];
        }*/
        
        for(int j=0;j<[TotalFreeTables count];++j)
        {
            @try {
                if([tableno isEqualToString:[[TotalFreeTables objectAtIndex:j] objectForKey:@"TBLNo"]] && [[[TotalFreeTables objectAtIndex:j] objectForKey:@"TBLStatus"] isEqualToString:@"A"])
                {
                    TableStatus[k] = @"0";
                    ((UILabel*)[self.view viewWithTag:(k+1000)]).backgroundColor=[UIColor whiteColor];
                    break;
                }
                else {
                    TableStatus[k] = @"1";
                    ((UILabel*)[self.view viewWithTag:(k+1000)]).backgroundColor=[UIColor orangeColor];
                }

            }
            @catch (NSException *exception) {
                
            }
        
                    }
    }
}


-(void)createViews{
    assignTableView = nil;
    tablestatusView = nil;
    homeView = nil;
    TableMgmt = nil;
  //  home = nil;
    SalesReport1 = nil;
   // taEdit = nil;
    assignTableView = [[TabSquareAssignTable alloc]initWithNibName:@"TabSquareAssignTable" bundle:[NSBundle mainBundle]];
    //TabSquareAssignTable *assignTableView;
    tablestatusView=[[TabSquareTableStatus alloc]initWithNibName:@"TabSquareTableStatus" bundle:[NSBundle mainBundle]];
    homeView=[[TabSquareHomeController alloc]initWithNibName:@"TabSquareHomeController" bundle:nil];
    TableMgmt=[[TabSquareMenuController alloc]initWithNibName:@"TabSquareMenuController" bundle:nil];
   // SalesReport1=[[SalesReport alloc]initWithNibName:@"SalesReport" bundle:nil];
   // TakeWayEditOrder *taEdit;
    
}


/*-(void)createAssignTableView
{
    assignTableView=[[TabSqua
 Table alloc]initWithNibName:@"TabSquareAssignTable" bundle:[NSBundle mainBundle]];
}*/

/*-(void)createTableStatusView
{
    tablestatusView=[[TabSquareTableStatus alloc]initWithNibName:@"TabSquareTableStatus" bundle:[NSBundle mainBundle]];
    
}*/

-(void)viewDidLoad
{
    
    [super viewDidLoad];

    
    TotalFreeTables=[[NSMutableArray alloc]init];
    TableStatus=[[NSMutableArray alloc]init];
    TATables=[[NSMutableArray alloc]init];
    existingTables  = [NSMutableArray new];
    
    
    [self showIndicator];
    statusView.layer.cornerRadius=12.0;
    tableData=[[NSMutableArray alloc]init];
    tableStatus=[[NSMutableArray alloc]init];
   // [self createAssignTableView];
   // [self createTableStatusView];
    //[self createViews];
    
  //  [self createHomeView];
    
    [ShareableData sharedInstance].isLogin = @"0";
    [ShareableData sharedInstance].Customer = @"0";
    [ShareableData sharedInstance].isFBLogin = @"0";
    [ShareableData sharedInstance].isTwitterLogin = @"0";
   // [objFacebookViewC logout];
    [ShareableData sharedInstance].ViewMode = 2;
    [self checkSections];
    [self initTABtns];
    // Do any additional setup after loading the view from its nib.
    taskType=0;
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SEARCH_DATA];
    [TabSquareCommonClass setValueInUserDefault:BEST_SELLERS value:@"0"];
    [TabSquareCommonClass setValueInUserDefault:@"crm_open" value:@"0"];

    [self checkForWIFIConnection];

    //[self performSelector:@selector(changeData) withObject:nil afterDelay:25.0];
    
    tt =[NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(onTick)
                                       userInfo:nil
                                        repeats:YES];
    [ShareableData sharedInstance].isQuickOrder =@"0";
    //add alert box to ask if user would like to cancel
    [self createViews];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
    NSString *libraryDirectory = [paths lastObject];
    NSString *location = [libraryDirectory stringByAppendingString:@"/orderarrays.plist"];
    
    [[NSFileManager defaultManager] removeItemAtPath:location error: nil];
    
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"orderarrays" ofType:@"plist"];
    // NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:location];
    
    if (array !=nil){
        
        DLog(@"Crash Loaded");
        [ShareableData sharedInstance].performUpdateCheck = @"1";
        [ShareableData sharedInstance].ViewMode = 2;
        [ShareableData sharedInstance].IsEditOrder =@"0";
        [ShareableData sharedInstance].isQuickOrder =@"0";
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        NSString *libraryDirectory = [paths lastObject];
        NSString *location = [libraryDirectory stringByAppendingString:@"/orderarrays.plist"];
        
        //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"orderarrays" ofType:@"plist"];
        // NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:location];
        // NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"orderstrings" ofType:@"plist"];
        // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        // NSString *libraryDirectory = [paths objectAtIndex:0];
        NSString *location2 = [libraryDirectory stringByAppendingString:@"/orderstrings.plist"];
        // NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        NSArray *array2 = [[NSArray alloc] initWithContentsOfFile:location2];
        
        
        
        [ShareableData sharedInstance].assignedTable1 = [array2[1] copy];
        [ShareableData sharedInstance].assignedTable2 = [array2[2] copy];
        [ShareableData sharedInstance].assignedTable3 = [array2[3] copy];
        [ShareableData sharedInstance].assignedTable4 = [array2[4] copy];
        [ShareableData sharedInstance].OrderId = [array2[0] copy];
       // [self getSalesNumber:[ShareableData sharedInstance].assignedTable1];
        // [[ShareableData sharedInstance].OrderItemID release];
        [ShareableData sharedInstance].OrderItemID = [array[0] mutableCopy];
        // [[ShareableData sharedInstance].OrderItemName release];
        [ShareableData sharedInstance].OrderItemName =[array[1] mutableCopy];
        // [[ShareableData sharedInstance].OrderItemRate release];
        [ShareableData sharedInstance].OrderItemRate =[array[2] mutableCopy];
        // [[ShareableData sharedInstance].OrderCatId release];
        [ShareableData sharedInstance].OrderCatId =[array[3] mutableCopy];
        // [[ShareableData sharedInstance].IsOrderCustomization release];
        [ShareableData sharedInstance].IsOrderCustomization =[array[4] mutableCopy];
        // [[ShareableData sharedInstance].OrderCustomizationDetail release];
        [ShareableData sharedInstance].OrderCustomizationDetail =[array[5] mutableCopy];
        //  [[ShareableData sharedInstance].OrderSpecialRequest release];
        [ShareableData sharedInstance].OrderSpecialRequest =[array[6] mutableCopy];
        //  [[ShareableData sharedInstance].OrderItemQuantity release];
        [ShareableData sharedInstance].OrderItemQuantity =[array[7] mutableCopy];
        //   [[ShareableData sharedInstance].confirmOrder release];
        [ShareableData sharedInstance].confirmOrder =[array[8] mutableCopy];
        [ShareableData sharedInstance].salesNo =[array2[5] copy];
        

        
        
        [[ShareableData sharedInstance] setCurrentTable:[NSString stringWithFormat:@"%@", [ShareableData sharedInstance].assignedTable1]];

        
        
        
        //[self AssignTAData];
      /*  if (homeView !=nil){
            [self createHomeView];
        }*/
        
        
        //[self dismissModalViewControllerAnimated:NO];
        //[self presentViewController:homeView animated:YES completion:Nil];
        [self.navigationController pushViewController:homeView animated:YES];
        
    }
[self setSection2:3];///previous value =1
}


-(void)viewWillAppear:(BOOL)animated{
    quickOrderSwitch.on=NO;
    specialReqSwitch.on = YES;
    
    [[ShareableData sharedInstance].OrderItemID removeAllObjects];
    [[ShareableData sharedInstance].OrderItemName removeAllObjects];
    [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
    [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
    
    [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
    [[ShareableData sharedInstance].OrderCatId removeAllObjects];
    //[[ShareableData sharedInstance].OrderBeverageContainerId removeAllObjects];
    [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
    [[ShareableData sharedInstance].confirmOrder removeAllObjects];
    [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
    
   // [self getTableStatusView];
    [self checkSections];
    if ([TATables count]>0){
        sectionID = [[TATables objectAtIndex:0] objectForKey:@"SectionID"];/////previous value objectAtIndex=1
    }
    [ShareableData sharedInstance].categoryID=@"1";
    //[self initTABtns];
   // UIButton* btnn = (UIButton*)[self.view viewWithTag:3];
    //[(UIButton*)[self.view viewWithTag:3] performSelector:@selector(setSection:) withObject:@"3"];
   
    funcCalled = NO;

}

-(void)viewDidDisappear:(BOOL)animated{
    
    if([[ShareableData sharedInstance].currentTable isEqualToString:DEFAULT_TABLE]) {
        [tt invalidate];
        tt=nil;
    }

  //  DLog(@"WOOOOOOOOOOOOOOOO");
  //  [self dismissViewControllerAnimated:NO completion:Nil];
    
}

-(void)checkSections{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:kURL@"Raptor/GetTableLayout.php"]]];
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
   // NSString *data=[[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding]stringByTrimmingCharactersInSet:
                   // [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
   
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
    // ////NSLOG(@"json = %@",json);
    
    
    NSArray* returnVal = [json objectForKey:@"returnVal"];
    
    
    // NSDictionary* node = [returnVal objectAtIndex:0];
    // [node objectForKey:@"ErrCode"];
   // [TotalFreeTables removeAllObjects];
    /*  for(int i=0;i<[resultFromPost count];i++)
     {
     [TotalFreeTables addObject:[NSString stringWithFormat:@"%@",resultFromPost[i]]];
     }*/
     [TATables removeAllObjects];
   // [TotalFreeTables addObjectsFromArray:returnVal];
   // [TATables addObjectsFromArray:[data componentsSeparatedByString:@","]];
[TATables addObjectsFromArray:returnVal];
    
   // return [data componentsSeparatedByString:@","];
    
}
-(IBAction)assignTK:(id)btn{
    
   // UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)];
  //  progressHud= [[MBProgressHUD alloc] initWithView:progressView];
   // [self.view addSubview:progressHud];
   // [self.view bringSubviewToFront:progressHud];
    //progressHud.dimBackground = YES;
   // progressHud.delegate = self;
    //progressHud.labelText = @"loading....";
    
   // [progressHud showWhileExecuting:@selector(myTask2:) onTarget:self withObject:btn animated:YES];
    Reachability* wifiReach = [Reachability reachabilityForLocalWiFi];
    
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    if (netStatus!=ReachableViaWiFi){
 
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No WIFI available!", @"AlertView")
                                                            message:NSLocalizedString(@"You have no wifi connection available. Please connect to a WIFI network.", @"AlertView")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
                                                  otherButtonTitles:NSLocalizedString(@"Check Your Settings", @"AlertView"), nil];
        [alertView show];
    }
   
    else{
        
    [self myTask2:btn];
        
        
    }

    
    
    
}
-(void)myTask2:(id)btn{
    
    [[ShareableData sharedInstance].OrderItemID removeAllObjects];
    [[ShareableData sharedInstance].OrderItemName removeAllObjects];
    [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
    [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
    
    [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
    [[ShareableData sharedInstance].OrderCatId removeAllObjects];
    //[[ShareableData sharedInstance].OrderBeverageContainerId removeAllObjects];
    [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
    [[ShareableData sharedInstance].confirmOrder removeAllObjects];
    [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
    int d = ((UIButton*)btn).tag;
    tableNumber = [NSString stringWithFormat:@"%d",d ];
    [ShareableData sharedInstance].ViewMode = 2;
    [[ShareableData sharedInstance].IsEditOrder isEqualToString:@"0"];
    [ShareableData sharedInstance].assignedTable1=[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"];
    [ShareableData sharedInstance].assignedTable2=@"-1";
    [ShareableData sharedInstance].assignedTable3=@"-1";
    [ShareableData sharedInstance].assignedTable4=@"-1";
    //[self AssignTAData:d];
   // tableNumber = [NSString stringWithFormat:@"%d",d ];
    [self AssignData:@"1"];
   /* if (homeView !=nil){
        [self createHomeView];
    }*/
    
    
    //[self dismissModalViewControllerAnimated:NO];
    //[self presentModalViewController:homeView animated:YES];
   // [self presentViewController:homeView animated:YES completion:Nil];
    [ShareableData sharedInstance].IsEditOrder=@"1";
    [ShareableData sharedInstance].isQuickOrder=@"1";
    [ShareableData sharedInstance].isFeedbackDone=@"0";
    [ShareableData sharedInstance].isConfermOrder=TRUE;
    if([[ShareableData sharedInstance].isConfromHomePage isEqualToString:@"1"])
    {
       // TabSquareMenuController *TableMgmt=[[TabSquareMenuController alloc]initWithNibName:@"TabSquareMenuController" bundle:nil];
        [self.navigationController pushViewController:TableMgmt animated:YES];
        
    }
    else
    {
        //[self dismissModalViewControllerAnimated:NO];
       // TabSquareHomeController *TableMgmt=[[TabSquareHomeController alloc]initWithNibName:@"TabSquareHomeController" bundle:nil];
        [self.navigationController pushViewController:homeView animated:YES];
    }

}
-(void)AssignTAData:(int)tbl
{
    
    NSString *post =[NSString stringWithFormat:@"table1=%d&table2=%@&table3=%@&table4=%@&ipad_id=%@&no_of_guests=%@&key=%@",tbl,@"",@"",@"",@"0",@"1", [ShareableData appKey]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/set_order", [ShareableData serverURL]];
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
    [ShareableData sharedInstance].OrderId=data;
    //DLog(@"%@",data);
}

-(void)changeData
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"6" forKey:@"TBLNo"];
    [dict setObject:@"H" forKey:@"TBLStatus"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"test"];
    [TotalFreeTables replaceObjectAtIndex:11 withObject:dict];
}

-(void)onTick{
    if (funcCalled == NO){
       funcCalled = YES;
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       // [self getTotalNumberofTable];
        
    //if([[[NSUserDefaults standardUserDefaults] objectForKey:@"test"] intValue] != 1) {
    [self getTables];
    //}
       // [self getTableStatusView];
       // [TATables removeAllObjects];
        //[TATables addObjectsFromArray:[[self checkTakeaway] copy]];
        
        /*================Update UI=================*/
        [[TabSquareRemoteActivation remoteActivation] tablesUpdated];
        /*==========================================*/

        
        [self checkSections];
        
        
        dispatch_async( dispatch_get_main_queue(), ^{
            //[self checkTABtns];
            [tableNoView reloadData];
            funcCalled = NO;
        });
    });
    
    }
    
    //[self getTaxesList];
    
    //[tableStatusView reloadData];
   // [self.view setNeedsDisplay];
    
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IBAction)tableDetailView:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    int tag=btn.tag;
    tableNumber=[NSString stringWithFormat:@"%d",tag];
    // tableNumber = [[TotalFreeTables objectAtIndex:tag] objectForKey:@"TBLNo"];
    taskType=1;
    
    if (tableNumber.intValue>1233){
        // UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)];
        //   progressHud= [[MBProgressHUD alloc] initWithView:progressView];
        // [self.view addSubview:progressHud];
        // [self.view bringSubviewToFront:progressHud];
        //progressHud.dimBackground = YES;
        //progressHud.delegate = self;
        //progressHud.labelText = @"loading....";
        
        // [progressHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        [self myTask];
        
    }else{
        
        [self showIndicator];
    }
}
-(IBAction)tableDetailView2:(int)sender
{
  //  UIButton *btn=(UIButton*)sender;
   // int tag=btn.tag;
    tableNumber=[NSString stringWithFormat:@"%d",sender];
    // tableNumber = [[TotalFreeTables objectAtIndex:tag] objectForKey:@"TBLNo"];
    taskType=1;
    
    if (tableNumber.intValue>1233){
        // UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)];
        //   progressHud= [[MBProgressHUD alloc] initWithView:progressView];
        // [self.view addSubview:progressHud];
        // [self.view bringSubviewToFront:progressHud];
        //progressHud.dimBackground = YES;
        //progressHud.delegate = self;
        //progressHud.labelText = @"loading....";
        
        // [progressHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        [self myTask];
        
    }else{
        
        [self showIndicator];
    }
}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}
-(void)setSection:(id)sender{
    UIButton* ss = (UIButton*)sender;
    sectionID = [NSString stringWithFormat:@"%d",ss.tag ];
    
    for (int i=0;i<[TATables count];i++){
        UILabel* tableName = (UILabel*)[self.view viewWithTag:(2233+i)];
        if (sectionID.intValue ==  [[[TATables objectAtIndex:i]objectForKey:@"SectionID"] intValue]){
        
            tableName.backgroundColor=[UIColor orangeColor];
        }else{
            tableName.backgroundColor=[UIColor whiteColor];
        }
        
    }
    if (sectionID.intValue == 4){/////previous value=3
        [ShareableData sharedInstance].categoryID=@"3";/////previous value=3
    }else{
        [ShareableData sharedInstance].categoryID=@"1";/////previous value=1
    }
    [self onTick];
    
    
}
-(void)setSection2:(int)sender{
   // UIButton* ss = (UIButton*)sender;
    sectionID = [NSString stringWithFormat:@"%d",sender ];
    
    for (int i=0;i<[TATables count];i++){
        UILabel* tableName = (UILabel*)[self.view viewWithTag:(2233+i)];
        if (sectionID.intValue ==  [[[TATables objectAtIndex:i]objectForKey:@"SectionID"] intValue]){
            
            tableName.backgroundColor=[UIColor orangeColor];
        }else{
            tableName.backgroundColor=[UIColor whiteColor];
        }
        
    }
    if (sectionID.intValue == 4){/////previous value=3
        [ShareableData sharedInstance].categoryID=@"3";/////previous value=3
    }else{
        [ShareableData sharedInstance].categoryID=@"1";/////previous value=1
    }
    [self onTick];
    
    
}


-(void)initTABtns
{
    sectionID=@"3";/////previous value=1
    
   // CGRect frame=CGRectMake(0,10, 103,100);
    //int i=0;
  //  int totalRows = 0;
   // NSArray* tempArray = [[self checkTakeaway] copy];
    for(int i=0;i<[TATables count];i++)
    {
        UILabel* tableName = (UILabel*)[self.view viewWithTag:(2233+i)];
        UIButton* btnn = (UIButton*)[self.view viewWithTag:(1233+i)];
        btnn.tag = [[[TATables objectAtIndex:i]objectForKey:@"SectionID"] intValue];
        
        if (btnn.tag == sectionID.intValue){
            tableName.backgroundColor=[UIColor orangeColor];
            [ btnn addTarget:self action:@selector(setSection:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            tableName.backgroundColor=[UIColor whiteColor];
            [ btnn addTarget:self action:@selector(setSection:) forControlEvents:UIControlEventTouchUpInside];
        }
        btnn.hidden = NO;
        tableName.hidden=NO;
        
          /*  if([TATables containsObject:[NSString stringWithFormat:@"%d",(1234+i)] ])
            {
                tableName.backgroundColor=[UIColor orangeColor];
                 [ btnn addTarget:self action:@selector(tableDetailView:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                tableName.backgroundColor=[UIColor whiteColor];
                [ btnn addTarget:self action:@selector(assignTK:) forControlEvents:UIControlEventTouchUpInside];
            }*/
            tableName.layer.cornerRadius=10.0;
            tableName.text=[NSString stringWithFormat:@"%d",btnn.tag];
        
            [existingTables addObject:tableName.text];
        
            tableName.textAlignment=NSTextAlignmentCenter;
            tableName.font=[UIFont boldSystemFontOfSize:25];
            //[cell.contentView addSubview:tableName];
           // [add addTarget:self action:@selector(tableDetailView:) forControlEvents:UIControlEventTouchUpInside];
           // [cell.contentView addSubview:add];
            tableName.contentMode=UIViewContentModeCenter;
            //i++;
       
    
        
    }
    
}

-(void)checkTABtns
{
    
    // CGRect frame=CGRectMake(0,10, 103,100);
    //int i=0;
    //  int totalRows = 0;
   // NSArray* tempArray = [[self checkTakeaway] copy];
    for(int i=0;i<[TATables count];i++)
    {
        UILabel* tableName = (UILabel*)[self.view viewWithTag:(2233+i)];
        
        if([TATables containsObject:[NSString stringWithFormat:@"%d",(1234+i)] ])
        {
            tableName.backgroundColor=[UIColor orangeColor];
            [((UIButton*)[self.view viewWithTag:(1233+i)]) removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [ ((UIButton*)[self.view viewWithTag:(1233+i)]) addTarget:self action:@selector(tableDetailView:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            tableName.backgroundColor=[UIColor whiteColor];
            [((UIButton*)[self.view viewWithTag:(1233+i)]) removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [ ((UIButton*)[self.view viewWithTag:(1233+i)]) addTarget:self action:@selector(assignTK:) forControlEvents:UIControlEventTouchUpInside];
        }
       
       
        //[cell.contentView addSubview:tableName];
        // [add addTarget:self action:@selector(tableDetailView:) forControlEvents:UIControlEventTouchUpInside];
        // [cell.contentView addSubview:add];
      
        
    }
    
    
}



-(void)addTabledataImage:(UITableViewCell*)cell indexRow:(int)rowIndex
{
   /* if ([TableStatus count] == 0){
        [self getTableStatusView];
    }*/
    CGRect frame=CGRectMake(0,10, 103,100);
    int i=0;
    totalData=rowIndex*5;
    for( ;totalData<[TotalFreeTables count];totalData++)
    {
        //DLog(@"%d",totalData);
        if(i<5)
        {
            UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
            add.tag=totalData;
            frame.origin.x=(frame.size.width+32)*i;
            add.frame=frame;
            UILabel *tableName=[[UILabel alloc]init];
            tableName.tag = totalData + 1000;
            tableName.frame=frame;
            if ([[[TotalFreeTables objectAtIndex:totalData] objectForKey:@"TBLStatus"] isEqualToString:@"A"]){
                tableName.backgroundColor=[UIColor whiteColor];
            }else{
                tableName.backgroundColor=[UIColor orangeColor];
            }
          /*  if([TableStatus[totalData]isEqualToString:@"0"])
            {
                tableName.backgroundColor=[UIColor whiteColor];
            }
            else if([TableStatus[totalData]isEqualToString:@"1"])
            {
                tableName.backgroundColor=[UIColor orangeColor];
            }*/
            tableName.layer.cornerRadius=10.0;
            tableName.text=[[TotalFreeTables objectAtIndex:totalData] objectForKey:@"TBLNo"];//[NSString stringWithFormat:@"%d",totalData+1];
            
            [existingTables addObject:tableName.text];
            
            tableName.textAlignment=NSTextAlignmentCenter;
            tableName.font=[UIFont boldSystemFontOfSize:25];
            [cell.contentView addSubview:tableName];
            [add addTarget:self action:@selector(tableDetailView:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:add];
            cell.contentView.contentMode=UIViewContentModeCenter;
            i++;
        }
        else 
        {
            break;
        }
    }
    
}
-(IBAction)quickOrderSwitch:(id)sender{
    
    if (quickOrderSwitch.on) {
        
        
        [ShareableData sharedInstance].isQuickOrder=@"1";
    }
    else{
        
        [ShareableData sharedInstance].isQuickOrder=@"0";
    }
}
-(IBAction)specialReqSwitch:(id)sender{
    
    if (specialReqSwitch.on) {
        
        
        [ShareableData sharedInstance].isSpecialReq=@"1";
    }
    else{
        
        [ShareableData sharedInstance].isSpecialReq=@"0";
    }
}


-(int)totalrows
{
    int total=[TotalFreeTables count];//[TotalTableNo intValue];
    int que=total/5;
    int rem=total%5;
    if(rem>0)
    {
        return que+1;
    }
    else 
    {
        return que;
    }
}



#pragma mark Table view methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int total=[TotalFreeTables count];//[TotalTableNo intValue];
    int que=total/5;
    int rem=total%5;
    if(rem>0)
    {
        return que+1;
    }
    else 
    {
        return que;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell %d%@",indexPath.row,sectionID];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];  
    if (cell == nil) 
    {
       // cell = [[UITableViewCell alloc] initWithFrame:CGRectZero ];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        [self addTabledataImage:cell indexRow:indexPath.row];
        
    }else{
       // int i=0;
        int tagVal = indexPath.row*5;
        for (int y=0;y<5;y++){
            UILabel* tempBtn = ((UILabel*)[cell viewWithTag:tagVal+y+1000]);
            @try {
                if (tempBtn !=nil){
                    if ([[[TotalFreeTables objectAtIndex:tagVal+y] objectForKey:@"TBLStatus"] isEqualToString:@"A"]){
                        
                        tempBtn.backgroundColor=[UIColor whiteColor];
                    }else{
                        tempBtn.backgroundColor=[UIColor orangeColor];
                    }

            }
            }
            @catch (NSException *exception) {
                
            }
                       
      
            
            
        }
    }
    
   // [cell setNeedsDisplay];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (IBAction)ViewReport:(id)sender
{
    taskType=4;
    [self showIndicator];
}

-(IBAction)takeAway:(id)sender
{
	taskType=3;
    [self showIndicator];
}



-(IBAction)gotoDishViewMode:(id)sender
{
    
    Reachability* wifiReach = [Reachability reachabilityForLocalWiFi];
    
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    if (netStatus!=ReachableViaWiFi){
        
        
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No WIFI available!", @"AlertView")
                                                            message:NSLocalizedString(@"You have no wifi connection available. Please connect to a WIFI network.", @"AlertView")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
                                                  otherButtonTitles:NSLocalizedString(@"Check Your Settings", @"AlertView"), nil];
        [alertView show];
    
    }
    
    else{

        if(sender != nil) {
            [[ShareableData sharedInstance] setCurrentTable:DEFAULT_TABLE];
        }

        
        [ShareableData sharedInstance].ViewMode=1;
        [ShareableData sharedInstance].isLogin=@"0";
        //taskType=2;
        
        if([[ShareableData sharedInstance].assignedTable1 isEqualToString:@"-1"]&&[[ShareableData sharedInstance].assignedTable2 isEqualToString:@"-1"]&&[[ShareableData sharedInstance].assignedTable3 isEqualToString:@"-1"]&&[[ShareableData sharedInstance].assignedTable4 isEqualToString:@"-1"])
        {
            [ShareableData sharedInstance].isTakeaway=@"1";
            [ShareableData sharedInstance].AddItemFromTakeaway=@"1";
            
        }
        
        // [self showIndicator];
        if([[ShareableData sharedInstance].isConfromHomePage isEqualToString:@"1"])
        {
            //////NSLOG(@"in if");
            //[self dismissModalViewControllerAnimated:NO];
            @autoreleasepool {
                
                //  TabSquareMenuController *mainMenu=[[TabSquareMenuController alloc]initWithNibName:@"TabSquareMenuController" bundle:nil];
                // [self presentModalViewController:mainMenu animated:YES];
                // [self presentViewController:mainMenu animated:YES completion:Nil];
                [self.navigationController pushViewController:TableMgmt animated:YES];
            }
            
        }
        else
        {
            //////NSLOG(@"in else");
            @autoreleasepool {
                
                
                //[self dismissModalViewControllerAnimated:NO];
                //  TabSquareHomeController *home=[[TabSquareHomeController alloc]initWithNibName:@"TabSquareHomeController" bundle:nil];
                // [self presentModalViewController:home animated:YES];
                // [self presentViewController:home animated:YES completion:Nil];
                [self.navigationController pushViewController:homeView animated:YES];
            }
            
        }
        
        
    }

   }

-(IBAction)gotoDishMenuLIst2
{
    taskType=2;
    
    if([[ShareableData sharedInstance].assignedTable1 isEqualToString:@"-1"]&&[[ShareableData sharedInstance].assignedTable2 isEqualToString:@"-1"]&&[[ShareableData sharedInstance].assignedTable3 isEqualToString:@"-1"]&&[[ShareableData sharedInstance].assignedTable4 isEqualToString:@"-1"])
    {
        [ShareableData sharedInstance].isTakeaway=@"1";
        [ShareableData sharedInstance].AddItemFromTakeaway=@"1";
    }
    
    // [self showIndicator];
    if([[ShareableData sharedInstance].isConfromHomePage isEqualToString:@"1"])
    {
         @autoreleasepool {
        //[self dismissModalViewControllerAnimated:NO];
             //TabSquareMenuController *mainMenu=[[TabSquareMenuController alloc]initWithNibName:@"TabSquareMenuController" bundle:nil];
             // [self presentModalViewController:mainMenu animated:YES];
            // [self presentViewController:mainMenu animated:YES completion:Nil];
             //self pres
             [self.navigationController pushViewController:TableMgmt animated:YES];
         }
    }
    else
    {
         @autoreleasepool {
        //[self dismissModalViewControllerAnimated:NO];
             //[self dismissModalViewControllerAnimated:NO];
            // TabSquareHomeController *home=[[TabSquareHomeController alloc]initWithNibName:@"TabSquareHomeController" bundle:nil];
             // [self presentModalViewController:home animated:YES];
            // [self presentViewController:home animated:YES completion:Nil];
             //self dism
             [self.navigationController pushViewController:homeView animated:YES];
         }
    }
}


-(IBAction)gotoDishMenuLIst:(id)sender
{
    taskType=2;
    
    if([[ShareableData sharedInstance].assignedTable1 isEqualToString:@"-1"]&&[[ShareableData sharedInstance].assignedTable2 isEqualToString:@"-1"]&&[[ShareableData sharedInstance].assignedTable3 isEqualToString:@"-1"]&&[[ShareableData sharedInstance].assignedTable4 isEqualToString:@"-1"])
    {
    [ShareableData sharedInstance].isTakeaway=@"1";
    [ShareableData sharedInstance].AddItemFromTakeaway=@"1";
    }
    
    // [self showIndicator];
    if([[ShareableData sharedInstance].isConfromHomePage isEqualToString:@"1"])
    {
         @autoreleasepool {
             //[self dismissModalViewControllerAnimated:NO];
            // TabSquareMenuController *mainMenu=[[TabSquareMenuController alloc]initWithNibName:@"TabSquareMenuController" bundle:nil];
             // [self presentModalViewController:mainMenu animated:YES];
            // [self presentViewController:mainMenu animated:YES completion:Nil];
             //self pres
             [self.navigationController pushViewController:TableMgmt animated:YES];
         }
    }
    else 
    {
         @autoreleasepool {
             //[self dismissModalViewControllerAnimated:NO];
             //[self dismissModalViewControllerAnimated:NO];
           //  TabSquareHomeController *home=[[TabSquareHomeController alloc]initWithNibName:@"TabSquareHomeController" bundle:nil];
             // [self presentModalViewController:home animated:YES];
           //  [self presentViewController:home animated:YES completion:Nil];
             //self dism
             [self.navigationController pushViewController:homeView animated:YES];
         }
    }   
}

-(void) showIndicator
{if(taskType ==1 || taskType ==4){
    [self myTask];
       }else{
           UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)];
           progressHud= [[MBProgressHUD alloc] initWithView:progressView];
           [self.view addSubview:progressHud];
           [self.view bringSubviewToFront:progressHud];
           //progressHud.dimBackground = YES;
           progressHud.delegate = self;
           //progressHud.labelText = @"loading....";
           
           [progressHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];

       
    }
    //
}

-(NSDictionary*)recallTableRaptor:(NSString*)table{
    
    NSArray* returnVal;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:kURL@"Raptor/RecallTable.php?POSID=%@&OperatorNo=%@&TableNo=%@&SalesNo=%@&SplitNo=%@",@"POS011",@"1",table,[ShareableData sharedInstance].salesNo,[ShareableData sharedInstance].splitNo]]];
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //  NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
   // ////NSLOG(@"json = %@",json);
    
    if ([json count]!=0){
        returnVal = [json objectForKey:@"returnVal"];
    }
    // for (int i=0;i<[returnedNodes count];i++){
    
    //  }
    NSDictionary* node = [returnVal objectAtIndex:0];
    // [node objectForKey:@"ErrCode"];
    [self holdTableRaptor:table];
    
    return node;
    
}

-(BOOL)tableExists:(NSString *)obj
{
    BOOL exists = FALSE;
    
    for(int i = 0; i < [TotalFreeTables count]; i++) {
        NSMutableDictionary *dict = (NSMutableDictionary *)TotalFreeTables[i];
        
        if([[dict[@"TBLNo"] uppercaseString] isEqualToString:obj]) {
            exists = TRUE;
            
            if([[dict[@"TBLStatus"] uppercaseString] isEqualToString:@"H"]) {
                exists = FALSE;
                
                [ShareableData showAlert:@"Alert" message:@"This function can not be used for opened tables. Please reassign table instead."];
                
                return exists;
            }
            
            break;
        }
    }
    
    if(!exists) {
        [ShareableData showAlert:@"Alert" message:@"This table does not exist!"];
    }
    
    return exists;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [myTextField resignFirstResponder];
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    Reachability* wifiReach = [Reachability reachabilityForLocalWiFi];
    
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    
    BOOL fixed_mode = FALSE;
    
    if(alertView.tag == FIXED_VIEW_ALERT) {
        
        if(buttonIndex == 0) {
            NSString *table_number = [NSString stringWithString:[[alertView textFieldAtIndex:0] text]];
            
            if(![self tableExists:[table_number uppercaseString]]) {
                //[ShareableData showAlert:@"Alert" message:@"This table does not exist!"];
            }
            else {
                [[ShareableData sharedInstance] setCurrentTable:[NSString stringWithFormat:@"%@", table_number]];
                //NSLOG(@"Table number> = %@", [ShareableData sharedInstance].currentTable);
                ////NSLOG(@"Total Free Tables 1st = %@", TotalFreeTables);
                BOOL assigned = TRUE;
                
                for(int i = 0; i < [TotalFreeTables count]; i++) {
                    NSMutableDictionary *dict = (NSMutableDictionary *)TotalFreeTables[i];
                    
                    if([[dict[@"TBLNo"] uppercaseString] isEqualToString:[[ShareableData sharedInstance].currentTable uppercaseString]] && [[dict[@"TBLStatus"] uppercaseString] isEqualToString:@"A"]) {
                        assigned = FALSE;
                        break;
                    }
                }
                
                if(assigned) {
                    fixed_mode = TRUE;
                    tableNumber = [NSString stringWithFormat:@"%@", [ShareableData sharedInstance].currentTable];
                    title = @"Reassign iPad to this table";
                }
                else {
                   
                    [self gotoDishViewMode:nil];
                }
                
            }
        }
        
    }

    
    if ([title isEqualToString:@"Assign"]){
        
//        numberOfGuests = [alertView textFieldAtIndex:0];
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select menu mode"
//                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Quick Order Mode",@"Normal Mode", nil];
//        
//        [alert show];
        
        
        if (netStatus!=ReachableViaWiFi){
            
            // UITextField *guests = [alertView textFieldAtIndex:0];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No WIFI available!", @"AlertView")
                                                                message:NSLocalizedString(@"You have no wifi connection available. Please connect to a WIFI network.", @"AlertView")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
                                                      otherButtonTitles:NSLocalizedString(@"Check Your Settings", @"AlertView"), nil];
            [alertView show];
        }
        else{
            
            if (quickOrderSwitch.on==NO) {
     
                
            
            [ShareableData sharedInstance].isQuickOrder=@"0";
            NSDictionary* ttemp = [self recallTableRaptor:[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"]];
            
            if ([[ttemp objectForKey:@"ErrCode"] isEqualToString:@"03"]){
                
                [[ShareableData sharedInstance] setCurrentTable:[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"]];
                
                [[ShareableData sharedInstance].OrderItemID removeAllObjects];
                [[ShareableData sharedInstance].OrderItemName removeAllObjects];
                [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
                [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
                
                [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
                [[ShareableData sharedInstance].OrderCatId removeAllObjects];
                //[[ShareableData sharedInstance].OrderBeverageContainerId removeAllObjects];
                [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
                [[ShareableData sharedInstance].confirmOrder removeAllObjects];
                [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
                
                UITextField *guests = (UITextField*)[alertView viewWithTag:3698];
                if (guests.text.intValue >0 ){
                    [[ShareableData sharedInstance].IsEditOrder isEqualToString:@"0"];
                    [self AssignData:guests.text];
                    
                    //[self presentModalViewController:homeView animated:YES];
                    // [self presentViewController:homeView animated:YES completion:Nil];
                    [self.navigationController pushViewController:homeView animated:YES];
                }
            }
            
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Table has already been assigned by another device/POS"
                                                               delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                
                [alert show];
                
            }
        }
            
            else{
                
                       [ShareableData sharedInstance].isQuickOrder=@"1";
                            NSDictionary* ttemp = [self recallTableRaptor:[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"]];
                
                            if ([[ttemp objectForKey:@"ErrCode"] isEqualToString:@"03"]){
                                
                                [[ShareableData sharedInstance] setCurrentTable:[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"]];
                
                                [[ShareableData sharedInstance].OrderItemID removeAllObjects];
                                [[ShareableData sharedInstance].OrderItemName removeAllObjects];
                                [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
                                [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
                
                                [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
                                [[ShareableData sharedInstance].OrderCatId removeAllObjects];
                                //[[ShareableData sharedInstance].OrderBeverageContainerId removeAllObjects];
                                [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
                                [[ShareableData sharedInstance].confirmOrder removeAllObjects];
                                [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
                                //UITextField *guests = [alertView textFieldAtIndex:0];
 UITextField *guests = (UITextField*)[alertView viewWithTag:3698];
//                                if (numberOfGuests.text.intValue >0 ){
//                                    [[ShareableData sharedInstance].IsEditOrder isEqualToString:@"0"];
//                                    [self AssignData:numberOfGuests.text];
//                
//                                    //[self presentModalViewController:homeView animated:YES];
//                                    // [self presentViewController:homeView animated:YES completion:Nil];
//                                    [self.navigationController pushViewController:homeView animated:YES];
//                                }
                                if (guests.text.intValue >0 ){
                                    [ShareableData sharedInstance].IsEditOrder =@"0";
//                                    [ShareableData sharedInstance].AddItemFromTakeaway=@"0";
//
//                                    [ShareableData sharedInstance].isConfromHomePage=@"1";
//
                                    [self AssignData:guests.text];
                                    
                                     [self gotoDishMenuLIst2];

                                }

                            }
                            
                            else{
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Table has already been assigned by another device/POS"
                                                                               delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                                
                                [alert show];
                                
                            }
                        }
                
            }

    }
        
        
    
//    if ([title isEqualToString:@"Normal Mode"]){
//        if (netStatus!=ReachableViaWiFi){
//            
//            // UITextField *guests = [alertView textFieldAtIndex:0];
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No WIFI available!", @"AlertView")
//                                                                message:NSLocalizedString(@"You have no wifi connection available. Please connect to a WIFI network.", @"AlertView")
//                                                               delegate:self
//                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
//                                                      otherButtonTitles:NSLocalizedString(@"Check Your Settings", @"AlertView"), nil];
//            [alertView show];
//        }
//        else{
//            [ShareableData sharedInstance].isQuickOrder=@"0";
//            NSDictionary* ttemp = [self recallTableRaptor:[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"]];
//            
//            if ([[ttemp objectForKey:@"ErrCode"] isEqualToString:@"03"]){
//                
//                
//                [[ShareableData sharedInstance].OrderItemID removeAllObjects];
//                [[ShareableData sharedInstance].OrderItemName removeAllObjects];
//                [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
//                [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
//                
//                [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
//                [[ShareableData sharedInstance].OrderCatId removeAllObjects];
//                //[[ShareableData sharedInstance].OrderBeverageContainerId removeAllObjects];
//                [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
//                [[ShareableData sharedInstance].confirmOrder removeAllObjects];
//                [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
//                
//                //UITextField *guests = [alertView textFieldAtIndex:0];
//                if (numberOfGuests.text.intValue >0 ){
//                    [[ShareableData sharedInstance].IsEditOrder isEqualToString:@"0"];
//                    [self AssignData:numberOfGuests.text];
//                    
//                    //[self presentModalViewController:homeView animated:YES];
//                    // [self presentViewController:homeView animated:YES completion:Nil];
//                    [self.navigationController pushViewController:homeView animated:YES];
//                }
//            }
//            
//            else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Table has already been assigned by another device/POS"
//                                                               delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
//                
//                [alert show];
//                
//            }
//        }
//    }
//    if ([title isEqualToString:@"Quick Order Mode"]){
//        if (netStatus!=ReachableViaWiFi){
//            
//            // UITextField *guests = [alertView textFieldAtIndex:0];
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No WIFI available!", @"AlertView")
//                                                                message:NSLocalizedString(@"You have no wifi connection available. Please connect to a WIFI network.", @"AlertView")
//                                                               delegate:self
//                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
//                                                      otherButtonTitles:NSLocalizedString(@"Check Your Settings", @"AlertView"), nil];
//            [alertView show];
//        }
//        else{
//            [ShareableData sharedInstance].isQuickOrder=@"1";
//            NSDictionary* ttemp = [self recallTableRaptor:[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"]];
//            
//            if ([[ttemp objectForKey:@"ErrCode"] isEqualToString:@"03"]){
//                
//                
//                [[ShareableData sharedInstance].OrderItemID removeAllObjects];
//                [[ShareableData sharedInstance].OrderItemName removeAllObjects];
//                [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
//                [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
//                
//                [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
//                [[ShareableData sharedInstance].OrderCatId removeAllObjects];
//                //[[ShareableData sharedInstance].OrderBeverageContainerId removeAllObjects];
//                [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
//                [[ShareableData sharedInstance].confirmOrder removeAllObjects];
//                [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
//
//                if (numberOfGuests.text.intValue >0 ){
//                    [[ShareableData sharedInstance].IsEditOrder isEqualToString:@"0"];
//                    [self AssignData:numberOfGuests.text];
//                    
//                    //[self presentModalViewController:homeView animated:YES];
//                    // [self presentViewController:homeView animated:YES completion:Nil];
//                    [self.navigationController pushViewController:homeView animated:YES];
//                }
//            }
//            
//            else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Table has already been assigned by another device/POS"
//                                                               delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
//                
//                [alert show];
//                
//            }
//        }
//    }
    if ([title isEqualToString:@"Change Cover"]){
        if (netStatus!=ReachableViaWiFi){
            
            // UITextField *guests = [alertView textFieldAtIndex:0];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No WIFI available!", @"AlertView")
                                                                message:NSLocalizedString(@"You have no wifi connection available. Please connect to a WIFI network.", @"AlertView")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
                                                      otherButtonTitles:NSLocalizedString(@"Check Your Settings", @"AlertView"), nil];
            [alertView show];
        }
        else{
            
        
        [self getSalesNumber:[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"]];
        UITextField *guests = [alertView textFieldAtIndex:0];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:kURL@"Raptor/ChangeCover.php?POSID=POS011&OperatorNo=1&TableNo=%@&SalesNo=%@&SplitNo=0&NewCover=%@",[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"], [ShareableData sharedInstance].salesNo,guests.text]]];
        
        NSError *error;
        NSURLResponse *response;
        NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
        
        
        // if ([json count]!=0){
        NSArray* returnVal = [json objectForKey:@"returnVal"];
        
        // for (int i=0;i<[returnedNodes count];i++){
        NSDictionary* node = [returnVal objectAtIndex:0];
        if (![[node objectForKey:@"ErrCode"] isEqualToString:@"01"]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[node objectForKey:@"ErrMsg"]                                                         delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Cover Change Successfull"                                  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
        }
        
    }
    if ([title isEqualToString:@"View table order details"]){
        
        NSDictionary* ttemp = [self recallTableRaptor:[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"]];
        
        if ([[ttemp objectForKey:@"ErrCode"] isEqualToString:@"01"]){
        tablestatusView.tableNumber=[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"];
        
        [self.navigationController pushViewController:tablestatusView animated:YES];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[ttemp objectForKey:@"ErrMsg"]
                                                           delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
    }
    if ([title isEqualToString:@"Reassign iPad to this table"]){
        if (netStatus!=ReachableViaWiFi){
            
            // UITextField *guests = [alertView textFieldAtIndex:0];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No WIFI available!", @"AlertView")
                                                                message:NSLocalizedString(@"You have no wifi connection available. Please connect to a WIFI network.", @"AlertView")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
                                                      otherButtonTitles:NSLocalizedString(@"Check Your Settings", @"AlertView"), nil];
            [alertView show];
        }
        else{
            //
            [ShareableData sharedInstance].ViewMode = 2;
            NSString *tb_no = [NSString stringWithFormat:@"%@", [[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"]];
            if(fixed_mode) {
                tb_no = [NSString stringWithFormat:@"%@", [ShareableData sharedInstance].currentTable];
            }
            
            [[ShareableData sharedInstance] setCurrentTable:[NSString stringWithFormat:@"%@", tb_no]];
            
            NSDictionary* ttemp = [self recallTableRaptor:tb_no];
            if ([[ttemp objectForKey:@"ErrCode"] isEqualToString:@"01"]){
                
                [[ShareableData sharedInstance] setCurrentTable:[NSString stringWithFormat:@"%@", tb_no]];
                
        [ShareableData sharedInstance].AddItemFromTakeaway=@"0";
        
        [[ShareableData sharedInstance].OrderItemID removeAllObjects];
        [[ShareableData sharedInstance].OrderItemName removeAllObjects];
        [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
        [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
        
        [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
        [[ShareableData sharedInstance].OrderCatId removeAllObjects];
        [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
        [[ShareableData sharedInstance].confirmOrder removeAllObjects];
        [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
        
               
        //[super viewDidLoad];
      
           // [self getTableDetails:[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"]]; //Change
                [self getTableDetails:tb_no];
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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

                
        [self gotoDishMenuLIst2];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[ttemp objectForKey:@"ErrMsg"]
                                                               delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                
                [alert show];
                
            }

        }
        
    }
    if ([title isEqualToString:@"Switch table"]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please tap on empty table to assign."
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Choose Table", nil];
        
        [alert show];
        
    }
    if ([title isEqualToString:@"Change Pax"]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter no. of Pax"
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Change Cover", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        [alert show];
        
        
        
    }
    
    if ([title isEqualToString:@"Choose Table"]){
        
        oldTableNumber = [tableNumber copy];
        
        switchMode = 1;
    }
    if ([title isEqualToString:@"Confirm"]){
        switchMode = 0;
        NSDictionary* ttemp = [self recallTableRaptor:[[TotalFreeTables objectAtIndex:oldTableNumber.intValue] objectForKey:@"TBLNo"]];
        
        if ([[ttemp objectForKey:@"ErrCode"] isEqualToString:@"01"]){
            
        [self getSalesNumber:[[TotalFreeTables objectAtIndex:oldTableNumber.intValue] objectForKey:@"TBLNo"]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
       [request setURL:[NSURL URLWithString:[NSString stringWithFormat:kURL@"Raptor/ChangeTable.php?POSID=POS011&OperatorNo=1&TableNo=%@&SalesNo=%@&SplitNo=0&NewTableNo=%@",[[TotalFreeTables objectAtIndex:oldTableNumber.intValue] objectForKey:@"TBLNo"], [ShareableData sharedInstance].salesNo,[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"]]]];
        
        NSError *error;
        NSURLResponse *response;
        NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
        
        
        // if ([json count]!=0){
        NSArray* returnVal = [json objectForKey:@"returnVal"];
        
        // for (int i=0;i<[returnedNodes count];i++){
        NSDictionary* node = [returnVal objectAtIndex:0];
        if ([[node objectForKey:@"ErrCode"] isEqualToString:@"01"]){
            [self getSalesNumber:[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"]];
            [self holdTableRaptor:[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"]];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[node objectForKey:@"ErrMsg"]                                                         delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
//            
//            [alert show];
            
        }
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[ttemp objectForKey:@"ErrMsg"]
                                                           delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
        
    }
    if ([title isEqualToString:@"Cancel"]){
        switchMode = 0;
        
        
    }
    
    
    
}
 /*   -(void)createHomeView{
        homeView=[[TabSquareHomeController alloc]initWithNibName:@"TabSquareHomeController" bundle:nil];
    }*/
-(void)getBillNumber:(NSString*)SearchTableNumber
{
    NSString *post =[NSString stringWithFormat:@"table_id=%@&key=%@",SearchTableNumber, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_temp_order_id", [ShareableData serverURL]];
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
    
    [ShareableData sharedInstance].OrderId=data;
    DLog(@"Bill Number :%@",data);
    [self getSalesNumber:SearchTableNumber];
    
    
}
-(void)getSalesNumber:(NSString*)SearchTableNumber
{
    NSString *post =[NSString stringWithFormat:@"table_id=%@&key=%@",SearchTableNumber, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_temp_sales_id", [ShareableData serverURL]];
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
    
    [ShareableData sharedInstance].salesNo=data;
    [ShareableData sharedInstance].splitNo = @"0";
   // DLog(@"Bill Number :%@",data);
    
}


-(void)getTableDetails:(NSString*)SearchTableNumber
{
    DLog(@"Table Number : %@",SearchTableNumber);
    
    [self getBillNumber:SearchTableNumber];
    
    [ShareableData sharedInstance].assignedTable1=SearchTableNumber;
    
    [[ShareableData sharedInstance].DishId removeAllObjects];
    [[ShareableData sharedInstance].DishName removeAllObjects];
    [[ShareableData sharedInstance].DishQuantity removeAllObjects];
    [[ShareableData sharedInstance].DishRate removeAllObjects];
    [[ShareableData sharedInstance].TempOrderID removeAllObjects];
    
    [[ShareableData sharedInstance].TDishName removeAllObjects];
    [[ShareableData sharedInstance].TDishQuantity removeAllObjects];
    [[ShareableData sharedInstance].TDishRate removeAllObjects];
    [[ShareableData sharedInstance].OrderItemID removeAllObjects];
    [[ShareableData sharedInstance].OrderItemName removeAllObjects];
    [[ShareableData sharedInstance].OrderItemQuantity removeAllObjects];
    [[ShareableData sharedInstance].OrderItemRate removeAllObjects];
    
    [[ShareableData sharedInstance].OrderSpecialRequest removeAllObjects];
    [[ShareableData sharedInstance].OrderCatId removeAllObjects];
    [[ShareableData sharedInstance].OrderBeverageContainerId removeAllObjects];
    [[ShareableData sharedInstance].OrderCustomizationDetail removeAllObjects];
    [[ShareableData sharedInstance].confirmOrder removeAllObjects];
    [[ShareableData sharedInstance].IsOrderCustomization removeAllObjects];
    
    NSString *post =[NSString stringWithFormat:@"table_id=%@",SearchTableNumber];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:kURL@"central/webs/get_temp_order"]];
    
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
    
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableArray *resultFromPost = [parser objectWithString:data error:nil];
    DLog(@"Data from GetTable :%@",resultFromPost);
    
    
    for(int i=0;i<[resultFromPost count];i++)
    {
        NSMutableDictionary *dataitem=resultFromPost[i];
        
        [[ShareableData sharedInstance].DishId addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_id"]]];
        [[ShareableData sharedInstance].DishName addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_name"]]];
        [[ShareableData sharedInstance].DishQuantity addObject:[NSString stringWithFormat:@"%@",dataitem[@"quantity"]]];
        [[ShareableData sharedInstance].TempOrderID addObject:[NSString stringWithFormat:@"%@",dataitem[@"id"]]];
        
        //        NSString *quantity=[NSString stringWithFormat:@"%@",dataitem[@"quantity"]];
        //        int qquantity=[quantity intValue];
        //        NSString *price=[NSString stringWithFormat:@"%@",dataitem[@"price"]];
        //        float fprice=[price floatValue]/qquantity;
        
        [[ShareableData sharedInstance].DishRate addObject:dataitem[@"price"]];
        //[[ShareableData sharedInstance].DishRate addObject:[NSString stringWithFormat:@"%@",[dataitem objectForKey:@"price"]]];
        
        [[ShareableData sharedInstance].OrderItemID addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_id"]]];
        [[ShareableData sharedInstance].OrderItemName addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_name"]]];
        [[ShareableData sharedInstance].OrderItemQuantity addObject:[NSString stringWithFormat:@"%@",dataitem[@"quantity"]]];
        [[ShareableData sharedInstance].OrderItemRate addObject:[NSString stringWithFormat:@"%.2f",[dataitem[@"price"] floatValue]*[dataitem[@"quantity"] floatValue]]];
        
        [[ShareableData sharedInstance].confirmOrder addObject:[NSString stringWithFormat:@"%@",dataitem[@"1"]]];
        
        
        
        NSArray* customString = [[NSString stringWithFormat:@"%@",dataitem[@"customisations"]] componentsSeparatedByString:@"^"];
        
        [[ShareableData sharedInstance].IsOrderCustomization addObject:[NSString stringWithFormat:@"%@",dataitem[@"is_order_customisation"]]];
        
        //[[ShareableData sharedInstance].IsOrderCustomization addObject:[NSString stringWithFormat:@"%@",[dataitem objectForKey:@"is_order_customisation"]]];
        
        NSString *trimmedString = [[NSString stringWithFormat:@"%@",dataitem[@"order_cat_id"]] stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [[ShareableData sharedInstance].OrderCatId addObject:trimmedString];
        [[ShareableData sharedInstance].OrderSpecialRequest addObject:[NSString stringWithFormat:@"%@",dataitem[@"order_special_request"]]];
        NSString *orderId = dataitem[@"dish_id"];
        if ([customString count]>1){
            NSMutableArray *tempCust= [[NSMutableArray alloc]init];
            NSMutableArray *customizationDetail=[[NSMutableArray alloc]init];
            for(int i=0;i<[customString count]-1;i++)
            {
                //NSMutableDictionary *dataitem=DishC[i][0];
                NSMutableDictionary *customizations=customString[i];
                
                NSMutableDictionary *cust=[NSMutableDictionary dictionary];
                cust[@"Customisation"] = customizations;
                cust[@"Option"] = customString[i];
                [customizationDetail addObject:cust];
                
                
            }
            [[ShareableData sharedInstance].OrderCustomizationDetail addObject:customizationDetail];
            DLog(@"WTF: %@",customizationDetail);
        }else{
            [[ShareableData sharedInstance].OrderCustomizationDetail addObject:[NSString stringWithFormat:@"%@",dataitem[@"order_customisation_detail"]]];
        }
        
        
        
        
        DLog(@"dish_id = %@",dataitem[@"dish_id"]);
        DLog(@"dish_name = %@",dataitem[@"dish_name"]);
        DLog(@"quantity = %@",dataitem[@"quantity"]);
        DLog(@"price = %@",dataitem[@"price"]);
        
        DLog(@"order_special_request = %@",dataitem[@"order_special_request"]);
        DLog(@"order_customisation_detail = %@",dataitem[@"order_customisation_detail"]);
        // DLog(@"order_beverage_container_id = %@",[dataitem objectForKey:@"order_beverage_container_id"]);
        DLog(@"order_cat_id = %@",dataitem[@"order_cat_id"]);
        DLog(@"confirm_order = %@",dataitem[@"confirm_order"]);
        DLog(@"is_order_customisation = %@",dataitem[@"is_order_customisation"]);
        
        [[ShareableData sharedInstance].TDishName addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_name"]]];
        [[ShareableData sharedInstance].TDishQuantity addObject:[NSString stringWithFormat:@"%@",dataitem[@"quantity"]]];
        [[ShareableData sharedInstance].TDishRate addObject:[NSString stringWithFormat:@"%@",dataitem[@"price"]]];
    }
    
    //[ReportSummaryTable reloadData];
}

-(NSMutableArray*)getSelectedCustomization:(NSMutableArray*)DishC
{
    NSMutableArray *customizationDetail=[[NSMutableArray alloc]init];
    for(int i=0;i<[DishC count];++i)
    {
        NSMutableDictionary *dataitem=DishC[i][0];
        NSMutableDictionary *customizations=dataitem[@"Customisation"];
        NSMutableArray *Option=dataitem[@"Option"];
        NSMutableArray *optionData=[[NSMutableArray alloc]init];
        for(int j=0;j<[Option count];++j)
        {
            NSMutableDictionary *optionDic=Option[j];
            NSString *quantity=optionDic[@"quantity"];
            if([quantity intValue]>=1)
            {
                [optionData addObject:optionDic];
            }
        }
        if([optionData count]!=0)
        {
            NSMutableDictionary *cust=[NSMutableDictionary dictionary];
            cust[@"Customisation"] = customizations;
            cust[@"Option"] = optionData;
            [customizationDetail addObject:cust];
        }
        
    }
    return customizationDetail;
    //DLog(@"%@",[[ShareableData sharedInstance]OrderCustomizationDetail]);
}


-(void)AssignData:(NSString*)guests{
    [ShareableData sharedInstance].ViewMode = 2;
    [[ShareableData sharedInstance].IsEditOrder isEqualToString:@"0"];
    [ShareableData sharedInstance].assignedTable1=[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"];
    [ShareableData sharedInstance].assignedTable2=@"-1";
    [ShareableData sharedInstance].assignedTable3=@"-1";
    [ShareableData sharedInstance].assignedTable4=@"-1";
    [self assignTableRaptor:guests ];
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

    NSString *post =[NSString stringWithFormat:@"table1=%@&table2=%@&table3=%@&table4=%@&ipad_id=%@&no_of_guests=%@&key=%@",[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"],@"-1",@"-1",@"-1",@"0",guests, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/set_order", [ShareableData serverURL]];
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
    [ShareableData sharedInstance].OrderId=data;
    
    
    
        //DLog(@"%@",data);
    }
-(NSArray*)assignTableRaptor:(NSString*)user {
    NSArray* returnVal;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:kURL@"Raptor/OpenTable.php?POSID=%@&OperatorNo=%@&TableNo=%@&CustFirstName=%@&CustLastName=%@&CustAddress=%@&CustRemark=%@&OrderRemark=%@&Cover=%@",@"POS001",@"1",[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"],@"",@"",@"",@"",@"",user]]];
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //  NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
    //////NSLOG(@"json = %@",json);
    
    if ([json count]!=0){
        returnVal = [json objectForKey:@"returnVal"];
    }
    // for (int i=0;i<[returnedNodes count];i++){
    NSDictionary* node = [returnVal objectAtIndex:0];
    [ShareableData sharedInstance].salesNo= [node objectForKey:@"SalesNo"];
    [ShareableData sharedInstance].splitNo= [node objectForKey:@"SplitNo"];
    //  }
    [self holdTableRaptor:[[TotalFreeTables objectAtIndex:tableNumber.intValue] objectForKey:@"TBLNo"]];
    
    return returnVal;
    
}
-(NSArray*)holdTableRaptor:(NSString*)table{
    NSArray* returnVal;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:kURL@"Raptor/HoldTable.php?POSID=%@&OperatorNo=%@&TableNo=%@&SalesNo=%@&SplitNo=%@",@"POS011",@"1",table,[ShareableData sharedInstance].salesNo,[ShareableData sharedInstance].splitNo]]];
    NSError *error;
    NSURLResponse *response;
    NSData *uData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //  NSString *data=[[NSString alloc]initWithData:uData encoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:uData options:kNilOptions error:&error];
    //////NSLOG(@"json = %@",json);
    
    if ([json count]!=0){
        returnVal = [json objectForKey:@"returnVal"];
    }
    // for (int i=0;i<[returnedNodes count];i++){
    
    //  }
    
    return returnVal;
    

    
}



- (void)myTask
{
    [self getBackgroundImage];
    
    if(taskType==1)
    {
        int tag=[tableNumber intValue];
        if (tag>=1233){
            
            tablestatusView.tableNumber=[NSString stringWithFormat:@"%d",tag+1];
            // [self presentModalViewController:tablestatusView animated:YES];
            //[self.navigationController pushViewController:tablestatusView animated:YES];
            // [self presentViewController:tablestatusView animated:YES completion:Nil];
            [self.navigationController pushViewController:tablestatusView animated:YES];
        }else{
            if([[[TotalFreeTables objectAtIndex:tag] objectForKey:@"TBLStatus"] isEqualToString:@"A"])
            { if (switchMode == 0){
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
              
                
//                TSAlertView* av = [[TSAlertView alloc] init];
//                av.title = @"manoj";
//                av.message =@"bamabm";
//                
//                for ( int i = 0 ; i < 2 ; i++ )
//                {
//                    [av addButtonWithTitle: [NSString stringWithFormat: @"Button %d", i]];
//                }
//                
//                av.style =  TSAlertViewStyleInput ;
//                av.buttonLayout = TSAlertViewButtonLayoutStacked;
//                av.usesMessageTextView = _usesTextViewSwitch.on;
//                
//                av.width = [@"300" floatValue];
//                av.maxHeight = [@"180" floatValue];
//                [self.view addSubview:av];
//                [self.view bringSubviewToFront:av];
//                
//                [av show];

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"\n\n\n\n\n\n"
                                                               delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Assign", nil];
                ///seting up the UIimage on UIalert box
                UIImage *alertBoxImage = [UIImage imageNamed:@"paxbox.png"];
                
                UIImageView *_backgroundImageView = [[UIImageView alloc] initWithImage:alertBoxImage];
                _backgroundImageView.frame = CGRectMake(0, 0, 282, 205);
                _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
                [alert addSubview:_backgroundImageView];
                [alert sendSubviewToBack:_backgroundImageView];
                
                 myTextField = [[UITextField alloc] initWithFrame:CGRectMake(116.0, 115.0, 45.0, 25.0)];
                [myTextField setBackgroundColor:[UIColor whiteColor]];
                myTextField.keyboardType = UIKeyboardTypeNumberPad;
                myTextField.tag=3698;
                myTextField.textAlignment = 	NSTextAlignmentCenter;
                myTextField.delegate=self;
                [myTextField becomeFirstResponder];
                [alert addSubview:myTextField];
                
                
               // UITextField * alertTextField = [alert textFieldAtIndex:0];
                
                //alertTextField.placeholder=@"Please enter no. of Guests";
                //alertTextField.frame = CGRectMake(1, 1, 10, 10);
                //[alertTextField sizeThatFits:CGSizeMake(10, 10)];
                [alert show];
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Confirm switch to this table?"
                                                               delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"No",@"Confirm", nil];
                
                [alert show];
                
                
            }
            }
            else
            {
                if (switchMode == 0){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Go To:"
                                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reassign iPad to this table",@"View table order details",@"Switch table",@"Change Pax", nil];
                    
                    [alert show];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"You cannot switch a table to another occupied table."
                                                                   delegate:self cancelButtonTitle:@"Choose Again" otherButtonTitles: nil];
                    
                    [alert show];
                }
                
                // [ShareableData sharedInstance].isTakeaway=@"1";
                
                
                //  [self presentViewController:tablestatusView animated:YES completion:nil];
            }
        }
    }
    else if(taskType==2)
    {
        
    }
    else if(taskType==3)
    {
        // TakeWayEditOrder *taEdit=[[TakeWayEditOrder alloc]initWithNibName:@"TakeWayEditOrder" bundle:nil];
        [ShareableData sharedInstance].isTakeaway=@"1";
        //[self presentModalViewController:SalesReport1 animated:YES];
        //  [self.navigationController pushViewController:SalesReport1 animated:YES];
        //  [self presentViewController:SalesReport1 animated:YES completion:Nil];
        //  [self.navigationController pushViewController:taEdit animated:YES];
    }
    else if(taskType==4)
    {
        //[self dismissModalViewControllerAnimated:NO];
        // SalesReport *SalesReport1=[[SalesReport alloc]initWithNibName:@"SalesReport" bundle:nil];
        // [self presentModalViewController:SalesReport1 animated:YES];
        //[self.navigationController pushViewController:SalesReport1 animated:YES];
        //  [self presentViewController:SalesReport1 animated:YES completion:Nil];
        [self.navigationController pushViewController:SalesReport1 animated:YES];
    }
    else
    {
        [self getTotalNumberofTable];
        [self checkSections];
        [self getTables];
        //[self performSelector:@selector(getTables) withObject:nil afterDelay:0.3];

      //  [self getTableStatusView];
        //[self getTaxesList];
        [tableNoView reloadData];
        // [tableStatusView reloadData];
    }
    
}


-(IBAction)infoButton:(id)sender
{
    NSString *img_name = [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, PLANOGRAM_IMAGE, [ShareableData appKey]];
    UIImage *img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    
    if(img == nil || img == NULL) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:PLANOGRAM_IMAGE];
        
        [[TabSquareDBFile sharedDatabase] updateUIImages:arr];
        
        img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    }
    
    if(img == nil || img == NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Error in loading data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        TabSquarePlaogramView *planogram = [[TabSquarePlaogramView alloc] initWithFrame:self.view.bounds image:img];
        [self.view addSubview:planogram];
    }
}


-(void)getBackgroundImage
{
    /*
    CGPoint _point = [self.view center];
    CGRect _frm = CGRectMake(_point.x-11, _point.y-12, 25, 25);
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithFrame:_frm];
	[self.view addSubview:act];
	[act startAnimating];
     */

    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT
                                             //, 0), ^{
        
    NSString *img_name = [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, BACKGROUND_IMAGE, [ShareableData appKey]];
        
    UIImage *img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
        
    if(img == nil || img == NULL) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:BACKGROUND_IMAGE];
            
        [[TabSquareDBFile sharedDatabase] updateUIImages:arr];
            
        img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    }
    
    [self.bgImage setImage:img];
        /*
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self.bgImage setImage:img];
            [act removeFromSuperview];
        });
         */
        
    //});
    
    
}
#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [TotalFreeTables count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"NewCell" forIndexPath:indexPath];
    
    if (cell ==nil){
        
      //  cell = [cv dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"NewCell%@",sectionID ] forIndexPath:indexPath]];
       // UICollectionViewCell *cell =
        //CGRect frame=CGRectMake(indexPath.section,indexPath.row, 103,100);
         cell.backgroundColor = [UIColor clearColor];
       // UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
   // add.tag=totalData;
       // add.frame = cell.frame;
        UILabel *tableName=[[UILabel alloc]init];
        tableName.tag = indexPath.row + 1000;
        tableName.frame=cell.frame;
    
    
    
    //frame.origin.x=(frame.size.width+32)*i;
   // add.frame=frame;
       if ([[[TotalFreeTables objectAtIndex:totalData] objectForKey:@"TBLStatus"] isEqualToString:@"A"]){
        tableName.backgroundColor=[UIColor whiteColor];
    }else{
        tableName.backgroundColor=[UIColor orangeColor];
    }
    /*  if([TableStatus[totalData]isEqualToString:@"0"])
     {
     tableName.backgroundColor=[UIColor whiteColor];
     }
     else if([TableStatus[totalData]isEqualToString:@"1"])
     {
     tableName.backgroundColor=[UIColor orangeColor];
     }*/
    tableName.layer.cornerRadius=10.0;
    tableName.text=[[TotalFreeTables objectAtIndex:totalData] objectForKey:@"TBLNo"];//[NSString stringWithFormat:@"%d",totalData+1];
    tableName.textAlignment=NSTextAlignmentCenter;
    tableName.font=[UIFont boldSystemFontOfSize:25];
    [cell.contentView addSubview:tableName];
    //[add addTarget:self action:@selector(tableDetailView:) forControlEvents:UIControlEventTouchUpInside];
   // [cell.contentView addSubview:add];
    cell.contentView.contentMode=UIViewContentModeCenter;
    
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
    [self tableDetailView2:indexPath.row+1];
   // [self addClicked:indexPath.row];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    if(textField.tag == FIXED_VIEW_ALERT) {
    
        return TRUE;
    }
    
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT));
}



-(IBAction)fixedViewClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter Table Number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    [alert setTag:FIXED_VIEW_ALERT];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *txt = (UITextField *)[alert textFieldAtIndex:0];
    [txt setTag:FIXED_VIEW_ALERT];
    [txt setDelegate:self];
    
    [alert show];
}


@end


