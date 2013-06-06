
#import "TabSquareMenuDetailController.h"
#import <QuartzCore/QuartzCore.h>
#import "TabSquareSoupViewController.h"
#import "ShareableData.h"
#import "UnPaidCellList.h"
#import "PaidCellList.h"


@implementation TabSquareMenuDetailController

@synthesize detailImageView,requestView,soupMenu,menuView;
@synthesize KKselectedID,KKselectedName,KKselectedRate,KKselectedCatId,KKselectedImage,DishCustomization;
@synthesize customizationView,unpaidCell,paidCell,swipeIndicator,tableContent;
@synthesize isView,backImage;
@synthesize bgBlackView,mParent,headerSectionLabel,headerLabel,crossBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame=CGRectMake(13, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    return self;
}
-(void)setParent:(id)sender{
    
    mParent=sender;
}
-(void)createSoupView
{
    soupMenu=[[TabSquareSoupViewController alloc]initWithNibName:@"TabSquareSoupViewController" bundle:nil];
    soupMenu.menuDetail=self;
}

- (void)viewDidLoad
{
    detailImageView.layer.borderWidth=2.5;

    detailImageView.layer.borderColor=[UIColor colorWithRed:220.0f/255.0f green:208.0f/255.0f blue:156.0f/255.0f alpha:0.0].CGColor;
    [detailImageView.layer setShadowOpacity:0.85];
    [detailImageView.layer setShadowOffset:CGSizeMake(3.0, 2.5)];

    requestView.layer.borderWidth=2.2;
    [requestView.layer setShadowOpacity:0.7];
    [requestView.layer setShadowOffset:CGSizeMake(1.0, 2.0)];
    [requestView.layer setShadowColor:[UIColor blackColor].CGColor];
    [requestView.layer setBorderColor:[UIColor colorWithRed:227.0/255.0 green:191.0/255.0 blue:185.0/255.0 alpha:1.0].CGColor];
    
    
    DishCustomization=[[NSMutableArray alloc]init];
    //create soup view
    if ([[ShareableData sharedInstance].isQuickOrder isEqualToString:@"1"]){
        self.backImage.hidden = YES;
    }else{
        self.backImage.hidden = NO;
    }
    [self createSoupView];
    self.customizationView.opaque=NO;
    [self.customizationView setBackgroundView:nil];
    [self.view addSubview:crossBtn];

  //  self.customizationView.backgroundView.hidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // DLog(@"TabSquareMenuDetailController Load");
}
-(void)viewDidAppear:(BOOL)animated{
    self.requestView.text = @"";
    [self resetOptionQuantity];
    ///manoj//////////
    ///////////////////DishName at the Customization page///////////////
    
    [[detailImageView viewWithTag:999 ] removeFromSuperview];
    
    headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, -170, 400, 400)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.tag=999;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont fontWithName:@"Copperplate" size:30.0];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.lineBreakMode=NSLineBreakByWordWrapping;
    headerLabel.numberOfLines=2;
    headerLabel.text=self.KKselectedName;
    [detailImageView addSubview:headerLabel];
   [customizationView reloadData];
}
-(void)resetOptionQuantity
{
    for (int i=0;i<[DishCustomization count];i++){
        NSMutableDictionary *dataitem=DishCustomization[i];
        NSMutableArray *Option=dataitem[@"Option"];
        for (int j=0;j<[Option count];j++){
            Option[j][@"quantity"] = @"0";
            }
        }
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    bgBlackView=nil;
    mParent=nil;
    headerSectionLabel=nil;
    headerLabel=nil;
    menuView.mparent=nil;///to unable the orderSummaryButton & backButton
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
   // DLog(@"TabSquareMenuDetailController UnLoad");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)manageHelp
{
    if([isView isEqualToString:@"main"])
    {
        ([ShareableData sharedInstance].IsViewPage)[0] = @"main_detail";
    }
    else  if([isView isEqualToString:@"maininfo"])
    {
        ([ShareableData sharedInstance].IsViewPage)[0] = @"main_info";
    }
    else if ([isView isEqualToString:@"beverageinfo"]) 
    {
        ([ShareableData sharedInstance].IsViewPage)[0] = @"beverage_main_info";
    }
}

-(void)removeView
{
    [self manageHelp];
    if([swipeIndicator isEqualToString:@"1"])
    {
        [ShareableData sharedInstance].swipeView.scrollEnabled=YES;
    }
    else 
    {
        [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
    }
    [self.view removeFromSuperview];
    self.view.transform=CGAffineTransformMakeScale(1.0, 1.0);
    self.view.frame=viewFrame;
}

-(void)removeView2:(id)sender
{    menuView.mparent=nil;///to unable the orderSummaryButton & backButton
    [self.mParent unhideTheScrollerAndSubCatBgOnMenuController];

    [sender removeFromSuperview];
}

-(void)addItem
{
    //DLog(@"%@",[[ShareableData sharedInstance].OrderItemID addObject:self.KKselectedID]);
    [[ShareableData sharedInstance].OrderItemID addObject:self.KKselectedID]; 
    [[ShareableData sharedInstance].OrderItemName addObject:self.KKselectedName]; 
    [[ShareableData sharedInstance].OrderItemRate addObject:self.KKselectedRate];
    [[ShareableData sharedInstance].OrderCatId addObject:self.KKselectedCatId];
    //get customization detail
    NSMutableArray *customizationDetail= [self getSelectedCustomization];
    if([customizationDetail count]!=0)
    {
         [[ShareableData sharedInstance].OrderCustomizationDetail addObject:customizationDetail];
         [[ShareableData sharedInstance].IsOrderCustomization addObject:@"1"];
    }
    else
    {
        [[ShareableData sharedInstance].OrderCustomizationDetail addObject:@"0"];
        [[ShareableData sharedInstance].IsOrderCustomization addObject:@"0"];
    }
    if([requestView.text isEqualToString:@""])
    {
         [[ShareableData sharedInstance].OrderSpecialRequest addObject:@"0"];
    }
    else {
        [[ShareableData sharedInstance].OrderSpecialRequest addObject:self.requestView.text];
    }
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

-(bool)checkCustomization:(NSInteger)index
{
    NSString *isorderCustomization=([ShareableData sharedInstance].IsOrderCustomization)[index];
    NSMutableArray *customizationDetail = [self getSelectedCustomization];
    NSString *isneworderCustomization;
    if([customizationDetail count]==0)
    {
        isneworderCustomization=@"0";
    }
    else
    {
        isneworderCustomization=@"1";
    }
    if([isneworderCustomization isEqualToString:@"1"]&&[isorderCustomization isEqualToString:@"1"])
    {
        NSMutableArray *orderCustomization=([ShareableData sharedInstance].OrderCustomizationDetail)[index];
        for(int i=0;i<[orderCustomization count];++i)
        {
            NSMutableDictionary *dataitem=orderCustomization[i];
            NSMutableDictionary *customizations=dataitem[@"Customisation"];
            NSString *custid=customizations[@"id"];
            for(int j=0;j<[customizationDetail count];++j)
            {
                NSMutableDictionary *newdataitem=customizationDetail[i];
                NSMutableDictionary *newcustomizations=newdataitem[@"Customisation"];   
                NSString *newcustid=newcustomizations[@"id"];         
                if(![custid isEqualToString:newcustid])
                {
                    return false;
                }
                else
                {
                    NSMutableArray *Option=dataitem[@"Option"];
                    NSMutableArray *newOption=newdataitem[@"Option"];
                    
                    for(int k=0;k<[Option count];++k)
                    {
                        NSMutableDictionary *optionDic=Option[k];
                        NSString *optionid=optionDic[@"id"];
                        for(int l=0;l<[newOption count];++l)
                        {
                            NSMutableDictionary *newoptionDic=newOption[l];
                            NSString *newoptionid=newoptionDic[@"id"];
                            if(![optionid isEqualToString:newoptionid])
                            {
                                return false;
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
    else if([isneworderCustomization isEqualToString:@"0"]&&[isorderCustomization isEqualToString:@"0"]&&[((NSString*)[ShareableData sharedInstance].OrderSpecialRequest[index]) isEqualToString:@"0"] )
    {
        return true;
    }
    else
    {
        return false;
    }
    return true;
}

-(void)checkItemInOrderList
{
    bool itemExist=false;
    if([self.requestView.text isEqualToString:@""]){
    for(int i=0;i<[[ShareableData sharedInstance].OrderItemID count];++i)
    {
        if([([ShareableData sharedInstance].OrderItemID)[i] isEqualToString:self.KKselectedID]&&[([ShareableData sharedInstance].confirmOrder)[i]isEqualToString:@"0"])
        {
            if([self checkCustomization:i])
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
    }
    }
    if(!itemExist)
    {
        [self addItem];
    }
}


-(void)addItemInOrderSummary
{
    if(![self.requestView.text isEqualToString:@""])
    {
        /*[[ShareableData sharedInstance].OrderItemID addObject:@"SpecialS1"]; 
        [[ShareableData sharedInstance].OrderItemName addObject:self.requestView.text]; 
        [[ShareableData sharedInstance].OrderItemRate addObject:@"0"];
        [[ShareableData sharedInstance].OrderItemQuantity addObject:@"1"];
        [[ShareableData sharedInstance].OrderCatId addObject:@"0"];*/
    }
}


-(IBAction)doneClicked:(id)sender
{
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(77, 578, 350, 300)];
   // imgView = self.KKselectedImage;
    imgView.alpha = 1.0f;
    CGRect imageFrame = imgView.frame;
    imgView.frame = imageFrame;
   // imgView.layer.position = viewOrigin;
    [imgView setImage:self.KKselectedImage];
    
    imgView.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgView];
    [self.view bringSubviewToFront:imgView];
    imgView.clipsToBounds = NO;
    viewFrame=self.view.frame;
    
    
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
    CGPathMoveToPoint(curvedPath, NULL, 77, 578);
    CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, 77, endPoint.x, 578, endPoint.x, endPoint.y);
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
    
    
   /* [UIView beginAnimations:@"animations" context:NULL];
    [UIView setAnimationDuration:0.8];
    imgView.transform=CGAffineTransformMakeScale(0.1, 0.1);    
    imgView.frame=CGRectMake(630,-190, imgView.frame.size.width,imgView.frame.size.height);
    [UIView commitAnimations];  */
    [self performSelector:@selector(removeView) withObject:self afterDelay:0.8];
    
    [self performSelector:@selector(removeView2:) withObject:imgView afterDelay:0.8];
    
    [self checkItemInOrderList];
    //[self addItemInOrderSummary];
       
   // DLog(@"Order Conferm");
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if (CGRectContainsPoint([self.requestView frame], [touch locationInView:self.view])
        )
    {
        
    }
    else
    {
        [self.requestView resignFirstResponder];
    }
    
}

-(void)addgestureInTableView
{
    gestureView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handletap:)];
    gestureView.numberOfTapsRequired=1;
    [customizationView addGestureRecognizer:gestureView];
}

-(void)handletap:(UIGestureRecognizer*)gesture
{
    [requestView resignFirstResponder];
    [customizationView removeGestureRecognizer:gestureView];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self addgestureInTableView];
}


-(IBAction)closeClicked:(id)sender
{
    [self manageHelp];
    if([swipeIndicator isEqualToString:@"1"])
    {
        [ShareableData sharedInstance].swipeView.scrollEnabled=YES;
    }
    else 
    {
       [ShareableData sharedInstance].swipeView.scrollEnabled=NO;
    }
    menuView.mparent=nil;///to unable the orderSummaryButton & backButton
    [self.mParent unhideTheScrollerAndSubCatBgOnMenuController];
    [self.view removeFromSuperview];
}

-(IBAction)minusClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    // int tag=btn.tag;
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
    
    NSString *quan=[self getOptionQuantity:[array[0]intValue] rowIndex:[array[1]intValue]];
    int quantity = [quan intValue];
    if(quantity>0)
    {
        --quantity;
        NSString *updateQ=[NSString stringWithFormat:@"%d",quantity];
        [self replaceOptionQuantity:[array[0]intValue]  rowIndex:[array[1]intValue]  newValue:updateQ];
        [self.customizationView reloadData];
    }
}

-(IBAction)plusClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
   // int tag=btn.tag;
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
    NSString *quan=[self getOptionQuantity:[array[0]intValue] rowIndex:[array[1]intValue]];
    int quantity = [quan intValue];
    
    ++quantity;
    NSString *updateQ=[NSString stringWithFormat:@"%d",quantity];
    [self replaceOptionQuantity:[array[0]intValue]  rowIndex:[array[1]intValue]  newValue:updateQ];
    [self.customizationView reloadData];
    
}

-(IBAction)selectionClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    // int tag=btn.tag;
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
    NSString *quan=[self getOptionQuantity:[array[0]intValue] rowIndex:[array[1]intValue]];
    int quantity = [quan intValue];
    if(quantity==0)
    {
        quantity=1;
        NSString *totalSelection=[self getTotalSelection:[array[0]intValue]];
        int totalSel=[self getTotalSelectedOption:[array[0]intValue]];
        if(totalSel==[totalSelection intValue])
        {
            NSString *updateQ=[NSString stringWithFormat:@"%d",0];
            int optionIndex=[self getSelectedOptionRowIndex:[array[0]intValue]];
            [self replaceOptionQuantity:[array[0]intValue] rowIndex:optionIndex newValue:updateQ]; 
            
        }
        NSString *updateQ=[NSString stringWithFormat:@"%d",quantity];
        [self replaceOptionQuantity:[array[0]intValue] rowIndex:[array[1]intValue]  newValue:updateQ];
        [self.customizationView reloadData];
    }
    else
    {
        quantity=0;
        NSString *updateQ=[NSString stringWithFormat:@"%d",quantity];
        [self replaceOptionQuantity:[array[0]intValue] rowIndex:[array[1]intValue]  newValue:updateQ];
        [self.customizationView reloadData];
    }
   
}

-(int)getSelectedOptionRowIndex:(NSInteger)sectionIndex
{
    NSMutableDictionary *dataitem=DishCustomization[sectionIndex];
    NSMutableArray *Option=dataitem[@"Option"];
    int total=0;
    for(int i=0;i<[Option count];++i)
    {
        NSMutableDictionary *optionDic=Option[i];
        NSString *quantity= optionDic[@"quantity"];
        if([quantity intValue]==1)
        {
            return i;
        }
    }
    return total;
}


-(int)getTotalSelectedOption:(NSInteger)sectionIndex
{
    NSMutableDictionary *dataitem=DishCustomization[sectionIndex];
    NSMutableArray *Option=dataitem[@"Option"];
    int total=0;
    for(int i=0;i<[Option count];++i)
    {
        NSMutableDictionary *optionDic=Option[i];
        NSString *quantity= optionDic[@"quantity"];
        if([quantity intValue]==1)
        {
            total++;
        }
    }
    return total;
}

-(NSMutableArray*)getSelectedCustomization
{
    NSMutableArray *customizationDetail=[NSMutableArray array];//[[NSMutableArray alloc]init];
    for(int i=0;i<[DishCustomization count];++i)
    {
        NSMutableDictionary *dataitem=DishCustomization[i];
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


-(NSString*)getTotalSelection:(NSInteger)sectionIndex
{
    NSMutableDictionary *dataitem=DishCustomization[sectionIndex];
   // DLog(@"%@",dataitem);
    NSMutableDictionary *customizations=dataitem[@"Customisation"];
    return customizations[@"no_of_selection"];
}

-(NSString*)getHeaderTitle:(NSInteger)sectionindex
{
    NSMutableDictionary *dataitem=DishCustomization[sectionindex];
    NSMutableDictionary *customizations=dataitem[@"Customisation"];
    //DLog(@"%@",[customizations objectForKey:@"header_text"]);
    return customizations[@"header_text"];
}

-(NSString*)getOptiontext:(NSInteger)sectionIndex rowIndex:(NSInteger)index
{
    NSMutableDictionary *dataitem=DishCustomization[sectionIndex];
    NSMutableArray *Option=dataitem[@"Option"];
    NSMutableDictionary *optionDic=Option[index];
    return optionDic[@"name"];
}

-(NSString*)getOptionprice:(NSInteger)sectionIndex rowIndex:(NSInteger)index
{
    NSMutableDictionary *dataitem=DishCustomization[sectionIndex];
    NSMutableArray *Option=dataitem[@"Option"];
    NSMutableDictionary *optionDic=Option[index];
    return optionDic[@"price"];
}

-(NSString*)getOptionQuantity:(NSInteger)sectionIndex rowIndex:(NSInteger)index
{
    NSMutableDictionary *dataitem=DishCustomization[sectionIndex];
    NSMutableArray *Option=dataitem[@"Option"];
    NSMutableDictionary *optionDic=Option[index];
    return optionDic[@"quantity"];
}

-(void)replaceOptionQuantity:(NSInteger)sectionIndex rowIndex:(NSInteger)index newValue:(NSString*)value
{
    NSMutableDictionary *dataitem=DishCustomization[sectionIndex];
    NSMutableArray *Option=dataitem[@"Option"];
    Option[index][@"quantity"] = value;
   // DLog(@"%@",[DishCustomization objectAtIndex:sectionIndex]);
       
}

-(int)getCustomizationType:(NSInteger)sectionindex
{
    NSMutableDictionary *dataitem=DishCustomization[sectionindex];
    NSMutableDictionary *customizations=dataitem[@"Customisation"];
    return [customizations[@"type"]intValue];
}


// TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //DLog(@"%@",DishCustomization);
    return [DishCustomization count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headertext=[self getHeaderTitle:section];
    return headertext;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(8.0, 0.0,tableView.bounds.size.width, 27)];
    customView.backgroundColor=[UIColor clearColor];
    headerSectionLabel = [[MSLabel alloc] initWithFrame:CGRectZero];
    headerSectionLabel.backgroundColor = [UIColor clearColor];
    headerSectionLabel.opaque = NO;
    headerSectionLabel.textColor = [UIColor blackColor];
    headerSectionLabel.font = [UIFont fontWithName:@"Copperplate" size:22.0];
    headerSectionLabel.frame = CGRectMake(28,15,tableView.bounds.size.width, 37.0);
    headerSectionLabel.lineBreakMode=NSLineBreakByWordWrapping;
    headerSectionLabel.lineHeight = 16;
    headerSectionLabel.numberOfLines=2;
    headerSectionLabel.textAlignment = NSTextAlignmentLeft;
    NSString* headertxt=[self getHeaderTitle:section];
    headerSectionLabel.text=headertxt;
    [customView addSubview:headerSectionLabel];
    return customView;
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary *dataitem=DishCustomization[section];
    NSMutableArray *Option=dataitem[@"Option"];
    //DLog(@"%@",Option);
    return [Option count];
}

-(CustomizationUnPaidCell*)setUnpaidCell:(NSInteger)section rowIndex:(NSInteger)rowindex
{
    static NSString *CellIdentifier = @"CustomizationTableIdentifier";
    CustomizationUnPaidCell *cell = (CustomizationUnPaidCell *)[self.customizationView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        [[NSBundle mainBundle]loadNibNamed:@"UnPaidCellList" owner:self options:nil];
        cell=self.unpaidCell;
        self.unpaidCell=nil;
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.optionName=[self getOptiontext:section rowIndex:rowindex];
    cell.imageTag=[NSString stringWithFormat:@"%d",rowindex];
    cell.imageSelection=[NSString stringWithFormat:@"%@",[self getOptionQuantity:section rowIndex:rowindex]];
    cell.btnTag=[NSString stringWithFormat:@"%d%d",section,rowindex];
    return cell;
}

-(CustomizationPaidCell*)setPaidCell:(NSInteger)section rowIndex:(NSInteger)rowindex
{
    static NSString *CellIdentifier = @"CustomizationTableIdentifier";
    CustomizationPaidCell *cell = (CustomizationPaidCell *)[self.customizationView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        [[NSBundle mainBundle]loadNibNamed:@"PaidCellList" owner:self options:nil];
        cell=self.paidCell;
        self.paidCell=nil;
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.optionName=[self getOptiontext:section rowIndex:rowindex];
    cell.optionPrice=[NSString stringWithFormat:@"$%@",[self getOptionprice:section rowIndex:rowindex]];
    cell.Quantity=[NSString stringWithFormat:@"%@",[self getOptionQuantity:section rowIndex:rowindex]];
    cell.btnTagAdd=[NSString stringWithFormat:@"%d%d",section,rowindex];
    cell.btnTagMinus=[NSString stringWithFormat:@"%d%d",section,rowindex];
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int type=[self getCustomizationType:indexPath.section];
    if(type==0)
    {
        CustomizationUnPaidCell *cell = [self setUnpaidCell:indexPath.section rowIndex:indexPath.row];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView.layer setBorderWidth:1.5];
        [cell.contentView.layer setBorderColor:[UIColor colorWithRed:227.0/255.0 green:191.0/255.0 blue:185.0/255.0 alpha:1.0].CGColor];
        
        return cell;
    }
    else 
    {
        CustomizationPaidCell *cell = [self setPaidCell:indexPath.section rowIndex:indexPath.row];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView.layer setBorderWidth:1.5];
        [cell.contentView.layer setBorderColor:[UIColor colorWithRed:227.0/255.0 green:191.0/255.0 blue:185.0/255.0 alpha:1.0].CGColor];

        return cell;
    }
    

}

- (void)viewWillAppear:(BOOL)animated
{
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
    rect.origin.y -= 85;
    rect.size.height += 85;
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)keyboardWillHide
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    CGRect rect = self.view.frame;
    rect.origin.y += 85;
    rect.size.height -= 85;
    self.view.frame = rect;
    [UIView commitAnimations];
}



@end

//[UIColor colorWithRed:220.0f/255.0f green:208.0f/255.0f blue:156.0f/255.0f alpha:0.8].CGColor;
