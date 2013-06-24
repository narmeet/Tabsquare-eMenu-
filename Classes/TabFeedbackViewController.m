#import "TabFeedbackViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ShareableData.h"
#import "SBJSON.h"
#import "FacebookViewC.h"
#import "TabSquareDBFile.h"
#import "TabSquareMenuController.h"
#import "MSLabel.h"
#import "TabSquareFeedbackLLViewController.h"

@implementation TabFeedbackViewController

@synthesize foodView,commentView,cleanRateView,menuRateView,waitRateView,FeedbackQuestionTable;
@synthesize c_rate,w_rate,e_rate,favouriteView;
@synthesize objFacebookViewC;
@synthesize DishName,DishRating,feedItemId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.view.frame=CGRectMake(0, 160, self.view.frame.size.width, self.view.frame.size.height);
    }
    return self;
}

-(void)addFoodData
{
    @try 
    {
        [foodId removeAllObjects];
        [foodList removeAllObjects];
        [FoodQuantity removeAllObjects];
        [FoodRating removeAllObjects];
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        for(int i=0;i<[[ShareableData sharedInstance].OrderItemID count];++i)
        {
            bool flag=false;
            NSString *ItemId=([ShareableData sharedInstance].OrderItemID)[i];
            if([[TabSquareDBFile sharedDatabase] isBevCheck:([ShareableData sharedInstance].OrderCatId)[i]])
            {
               // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
                ItemId=[[TabSquareDBFile sharedDatabase]getBeverageId:ItemId];
               // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
            }
            for(int j=0;j<[feedItemId count];++j)
            {
                if([feedItemId[j] isEqualToString:ItemId])
                {
                    flag=true;
                    break;
                }
            }
            if(flag==false)
            {
                NSString *dishId=([ShareableData sharedInstance].OrderItemID)[i];
                if([[TabSquareDBFile sharedDatabase] isBevCheck:([ShareableData sharedInstance].OrderCatId)[i]])
                {
                  //  [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
                    dishId=[[TabSquareDBFile sharedDatabase]getBeverageId:dishId];
                  //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
                }
                [foodId addObject:([ShareableData sharedInstance].OrderItemID)[i]];
                [FoodQuantity addObject:([ShareableData sharedInstance].OrderItemQuantity)[i]];
                [foodList addObject:([ShareableData sharedInstance].OrderItemName)[i]];
                [FoodRating addObject:@"0"];
            }
        }
        
    }
}


-(void)getImageUrl:(NSString*)foodid //// posting image to FB
{
    NSString *post =[NSString stringWithFormat:@"id=%@&key=%@",foodid, [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_image_url", [ShareableData serverURL]];
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
    NSString *imageUrl = [NSString stringWithFormat:@"%@/img/product/%@", @"http://54.251.56.111/central",[NSString stringWithFormat:@"%@",data]];  // do not change
    
    [ShareableData sharedInstance].feedDishImage=imageUrl;
    ////NSLOG(@"imageUrl =====%@",imageUrl);
}



-(void)viewWillAppear:(BOOL)animated
{   NSString *img_name1 = [NSString stringWithFormat:@"%@%@_%@", PRE_NAME, POPUP_IMAGE,[ShareableData appKey]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
    NSString *libraryDirectory = [paths lastObject];
    NSString *location = [NSString stringWithFormat:@"%@/%@%@",libraryDirectory,img_name1,@".png"];
    
    UIImage *img1 = [UIImage imageWithContentsOfFile:location];
    
    bgImage.image = img1;
    
    NSLog(@"View will appear in Feedback View Controller");

    @try 
    {
        TaskType=1;
        [super viewWillAppear:YES];
        [self addFoodData];
        [foodView reloadData];
        [self getAllQuestion];          
        //[self showIndicator];
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
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
 }

-(void)configureView:(RateView*)rateView 
{
    // Update the user interface for the detail item.
    rateView.notSelectedImage = [UIImage imageNamed:@"star.png"];
    rateView.halfSelectedImage = [UIImage imageNamed:@"star.png"];
    rateView.fullSelectedImage = [UIImage imageNamed:@"red star.png"];
    rateView.editable = YES;
    rateView.maxRating = 5;
    rateView.delegate = self; 
    rateView.rating = 0;    
    
}

-(void)createFacebookView
{
	objFacebookViewC = [[FacebookViewC alloc] init];
    objFacebookViewC.feedbackView=self;
	objFacebookViewC.loginDelegate1 = self;
}


-(void)viewDidLoad
{
    commentView.layer.cornerRadius=10.0;
    foodList=[[NSMutableArray alloc]init];
    foodId=[[NSMutableArray alloc]init];
    FoodQuantity=[[NSMutableArray alloc]init];
    FeedbackQuestionList=[[NSMutableArray alloc]init];
    feedItemId=[[NSMutableArray alloc]init];
    FeedbackQuestionID=[[NSMutableArray alloc]init];
    FeedbackQuestionRating=[[NSMutableArray alloc]init];
    FoodRating=[[NSMutableArray alloc]init];
    DishName=[[NSString alloc]init];
    DishRating=[[NSString alloc]init];
    i1=0;
    [self addFoodData];
    [self createFacebookView];
    [self initializeFeedItemList];
    [super viewDidLoad];
    TaskType=1;
     favouriteView=[[TabSquareFeedbackLLViewController alloc]initWithNibName:@"TabSquareFeedbackLLViewController" bundle:nil];
    
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark RateViewDelegate

-(void)rateView:(RateView *)rateView ratingDidChange:(float)rating 
{
    
   // DLog(@"Tag:%d Rating : %f",rateView.tag,rating);
    if(rateView.tag>=100)
    {
        FoodRating[rateView.tag-100] = [NSString stringWithFormat:@"%f",rating];
        [foodView reloadData];
    }
    else
    {
        FeedbackQuestionRating[rateView.tag] = [NSString stringWithFormat:@"%f",rating];
    }
   
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(IBAction)skipClicked:(id)sender
{
   // menuView.feedback.selected=NO;
    [ShareableData sharedInstance].isFeedbackDone =@"1";
    [self.view removeFromSuperview];
}

-(IBAction)doneClicked:(id)sender
{
   // if([[ShareableData sharedInstance].isFeedbackDone isEqualToString:@"0"])
  //  {

        TaskType=2;
        [ShareableData sharedInstance].isFeedbackDone =@"1";
        [self showIndicator];
   // }
   /* else
    {
        UIAlertView *alert3=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You have already provided the feedback." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert3 show];
        [alert3 release];    
    }*/
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"YES"]){
       
        favouriteView.view.frame=CGRectMake(13, 0, favouriteView.view.frame.size.width, favouriteView.view.frame.size.height);
        [self.view addSubview:favouriteView.view];
        //[self.view bringSubviewToFront:favouriteView.view];
       // [self.view removeFromSuperview];
        //[self.view removeFromSuperview];
        skipBtn.hidden=YES;
        doneBtn.hidden=YES;
        
    }else{
                [ShareableData sharedInstance].isLogin = @"0";
        [ShareableData sharedInstance].Customer = @"0";
        [ShareableData sharedInstance].isFBLogin = @"0";
        [ShareableData sharedInstance].isTwitterLogin = @"0";
        [self.view removeFromSuperview];
    }
}

-(UILabel*)addfoodName:(UITableViewCell*)cell indexpath:(NSInteger)index
{
    //add label header
    
    MSLabel *foodName = [[MSLabel alloc] initWithFrame:CGRectMake(50, 12, 215, 45)];
     CGSize size=[foodList[index] sizeWithFont:[UIFont fontWithName:@"Lucida Calligraphy" size:17] constrainedToSize:CGSizeMake(215, 100) lineBreakMode:UILineBreakModeClip];
    foodName.frame=CGRectMake(50, 11, size.width+10,size.height);
    foodName.lineHeight = 22;
    foodName.numberOfLines = 2;
    foodName.backgroundColor=[UIColor clearColor];
    foodName.text = foodList[index]; 
    foodName.font=[UIFont fontWithName:@"Lucida Calligraphy" size:17];
    foodName.minimumFontSize = 10.0;
    foodName.textColor=[UIColor blackColor];//////////////////////change according to bg *manoj*
    foodName.adjustsFontSizeToFitWidth = YES;
   // descriptionLabel.numberOfLines = 1;

    return foodName;
}

-(UIButton*)addFacebookButton:(NSInteger)index
{
    UIButton *fbBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    fbBtn.frame=CGRectMake(576, 9, 34, 32);
    fbBtn.tag=index;
    [fbBtn setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
    [fbBtn setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateHighlighted];
    [fbBtn setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateSelected];
    [fbBtn addTarget:self action:@selector(facebookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return fbBtn;
}

-(UIButton*)addTwitterButton:(NSInteger)index
{
    UIButton *twitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    twitBtn.frame=CGRectMake(615, 9, 34, 32);
    twitBtn.tag=index;
    [twitBtn setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    [twitBtn setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateHighlighted];
    [twitBtn setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateSelected];
    [twitBtn addTarget:self action:@selector(twitterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return twitBtn;
}

-(IBAction)facebookBtnClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    [ShareableData sharedInstance].feedDishName=[NSString stringWithFormat:@"I Love the %@ at " kFacebbokNameString,foodList[btn.tag]];
    [ShareableData sharedInstance].feedDishRating=[NSString stringWithFormat:@"I give it a %d star rating", [FoodRating[btn.tag]intValue]];
    [self getImageUrl:foodId[btn.tag]];
    
    
    if([[ShareableData sharedInstance].isFBLogin isEqualToString:@"0"])
    {
        [objFacebookViewC logout];
        [objFacebookViewC login];
    }
    else 
    {
        [objFacebookViewC publish1:[ShareableData sharedInstance].feedDishName rating:[ShareableData sharedInstance].feedDishRating imageUrl:[ShareableData sharedInstance].feedDishImage];
    }
}

-(IBAction)twitterBtnClick:(id)sender
{
    
}

-(RateView*)addRateView:(int)index
{
    RateView *rateView=[[RateView alloc]initWithFrame:CGRectMake(274, 10, 160, 30)];
    [self configureView:rateView];
    rateView.tag=index;
    return rateView;
}


#pragma mark Table view methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == foodView)
    {
        return [foodList count];
    }
    else if (tableView == FeedbackQuestionTable)
    {
        return [FeedbackQuestionList count];
    }
    return 0;
    
}

//-(void)removeSubView:(UIView*)cell
//{
//    NSArray *subviews=[cell.contentView subviews];
//    for(int i=0;i<[subviews count];++i)
//    {
//        UIView *view=subviews[i];
//        if([view isKindOfClass:[UIView class]])
//        {
//            [view removeFromSuperview];
//        }
//        //[view removeFromSuperview];
//    }
//}

-(void)removesuperView:(UITableViewCell*)cell
{
    NSArray *subviews=[cell.contentView subviews];
    for(int i=0;i<[subviews count];++i)
    {
        UIView *view=subviews[i];
        if([view isKindOfClass:[UIButton class]])
        {
           // DLog(@"dfdf");
        }
        [view removeFromSuperview];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"TableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];       
    }
    
    if (tableView == foodView)
    {
         [self removesuperView:cell];
         UILabel *FoodName=[self addfoodName:cell indexpath:indexPath.row];
       
         [cell.contentView addSubview:FoodName];
         RateView  *FoodrateView=[self addRateView:indexPath.row+100];
         FoodrateView.rating=[FoodRating[indexPath.row]intValue];
         [cell.contentView addSubview:FoodrateView];
         if(FoodrateView.rating>=5)
         {
             UIButton   *FbBtn=[self addFacebookButton:indexPath.row];
             [cell.contentView addSubview:FbBtn];
             UIButton *TwiterBtn=[self addTwitterButton:indexPath.row];
             [cell.contentView addSubview:TwiterBtn];
    
         }
                     
    }
    else if (tableView == FeedbackQuestionTable)
    {
        [foodView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        [self removesuperView:cell];
        UILabel *Question=[self addFeedbackQuestion:cell indexpath:indexPath.row];
        [cell.contentView addSubview:Question];
        RateView *rateView=[self addRateView:indexPath.row];
        [cell.contentView addSubview:rateView];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if(tableView==foodView)
    {
       size=[foodList[indexPath.row] sizeWithFont:[UIFont fontWithName:@"Lucida Calligraphy" size:17] constrainedToSize:CGSizeMake(215, 100) lineBreakMode:UILineBreakModeClip];
    }
    else 
    {
        size=[FeedbackQuestionList[indexPath.row] sizeWithFont:[UIFont fontWithName:@"Lucida Calligraphy" size:17] constrainedToSize:CGSizeMake(215, 100) lineBreakMode:UILineBreakModeClip];
    }
    if(size.height>40)
    {
        return size.height+5;
    }
    else 
    {
        return 42;
    }
    
}

-(UILabel*)addFeedbackQuestion:(UITableViewCell*)cell indexpath:(NSInteger)index
{
    //add label header
    MSLabel *FQ=[[MSLabel alloc]initWithFrame:CGRectMake(50, 10, 215, 45)];
    CGSize size=[FeedbackQuestionList[index] sizeWithFont:[UIFont fontWithName:@"Lucida Calligraphy" size:17] constrainedToSize:CGSizeMake(215, 100) lineBreakMode:UILineBreakModeClip];
    FQ.numberOfLines=2;
    FQ.lineHeight=21;
    FQ.frame=CGRectMake(50, 10, size.width+10,size.height);
    FQ.text=FeedbackQuestionList[index];
    DLog(@"text val: %@",FQ.text);
    DLog(@"Raw val: %@",FeedbackQuestionList[index]);
    FQ.backgroundColor=[UIColor clearColor];
    FQ.font=[UIFont fontWithName:@"Lucida Calligraphy" size:17];
    FQ.textAlignment=NSTextAlignmentLeft;
    FQ.minimumFontSize = 10.0;
    FQ.adjustsFontSizeToFitWidth = YES;
    FQ.textColor=[UIColor blackColor];/////change as per the BG *manoj*
    return FQ;
}


-(void)getAllQuestion
{
    //NSString *Key=@"kinara123";
    
    NSString *post =[NSString stringWithFormat:@"key=%@", [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_questions", [ShareableData serverURL]];
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
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableDictionary *resultFromPost = [parser objectWithString:data error:nil];
    //DLog(@"Data :%@",resultFromPost);
    
    @try 
    {
        [FeedbackQuestionList removeAllObjects];
        [FeedbackQuestionID removeAllObjects];
        [FeedbackQuestionRating removeAllObjects];
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        for(int i=0;i<[resultFromPost count];i++)
        {
            NSMutableDictionary *dataitem=resultFromPost[[NSString stringWithFormat:@"%d",i ]];
           // DLog(@"Question : %@",[dataitem objectForKey:@"question"]);
            [FeedbackQuestionList addObject:dataitem[@"question"]];
            [FeedbackQuestionID addObject:dataitem[@"id"]];
            [FeedbackQuestionRating addObject:@"0"];
        }
        
        [FeedbackQuestionTable reloadData];
    }
    
}

-(void)sendFeedback:(NSString*)qid cid:(NSString*)cid rating:(NSString*)rating comments:(NSString*)comments order_id:(NSString*)order_id
{
   // NSString *Key=@"kinara123";
    
    NSString *post =[NSString stringWithFormat:@"key=%@&question_id=%@&customer_id=%@&rating=%@&comments=%@&order_id=%@", [ShareableData appKey],qid,cid,rating,comments,order_id];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/insert_feedback", [ShareableData serverURL]];
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
    
    //DLog(@"Result : %@",data);
}

-(void) showIndicator
{
//    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0,187, self.view.frame.size.width, self.view.frame.size.height)];
//	progressHud= [[MBProgressHUD alloc] initWithView:progressView];
//	[self.view addSubview:progressHud];
//	[self.view bringSubviewToFront:progressHud];
//	//progressHud.dimBackground = YES;
//	progressHud.delegate = self;
//    //progressHud.labelText = @"loading....";
//	[progressHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [self myTask];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = [touch tapCount];
    //CGPoint location = [touch locationInView:self.view];
    
    switch (tapCount)
    {
        case 1:
        {
            [commentView resignFirstResponder];
        }
        break;
    }
}

-(void)initializeFeedItemList{
    NSString *post =[NSString stringWithFormat:@"orderid=%@&key=%@",[ShareableData sharedInstance].OrderId , [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_order_feedback", [ShareableData serverURL]];
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
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableArray *resultFromPost = [parser objectWithString:data error:nil];
    if([resultFromPost count]!=0)
    {
        for(int i=0;i<[resultFromPost count];++i)
        {
            NSMutableDictionary *dataitem=resultFromPost[i];
            [feedItemId addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_id"]]];
        }
        
    }
    
   
}
-(void)sendFeedbackAboutDish:(NSString*)dish_id  dishName:(NSString*)dish_name1 rating:(NSString*)rating1 quantity:(NSString*)qty email:(NSString*)email1 order_id:(NSString*)order_id1
{
   
    DLog(@"ID ,NAME,RATING: %@%@%@",dish_id,dish_name1,rating1);
       
    
    NSString *post =[NSString stringWithFormat:@"dish_id=%@&dish_name=%@&rating=%@&quantity=%@&email=%@&order_id=%@&key=%@", dish_id,dish_name1,rating1,qty,email1,order_id1,[ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/set_dish_feedback", [ShareableData serverURL]];
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
    
    DLog(@"Result : %@",data);
}


-(void)myTask
{
    if(TaskType==1)
    {
        [self addFoodData];
        [foodView reloadData];
        [self getAllQuestion];  
    }
    else 
    {        

        for(int i=0;i<[FeedbackQuestionID count];i++)
        {
            [self sendFeedback:FeedbackQuestionID[i] cid:[ShareableData sharedInstance].isLogin  rating:FeedbackQuestionRating[i] comments:commentView.text order_id:[ShareableData sharedInstance].OrderId];
        }
        
        for(int i=0;i<[foodList count];i++)
        {
            [feedItemId addObject:foodId[i]];
            [self sendFeedbackAboutDish:foodId[i] dishName:foodList[i] rating:FoodRating[i] quantity:FoodQuantity[i]  email:[ShareableData sharedInstance].isLogin order_id:[ShareableData sharedInstance].OrderId];
        }
        

                
        //[self.view removeFromSuperview];
       // menuView.feedback.selected=NO;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Thank you" message:@"Your feedback has been recorded. Would you like to login to your Facebook/Tabsquare account to save your order for your next visit?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag=911;
        [alert show]; 
    
    }
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

#pragma  mark Text View Delegate Method

-(void) textViewDidBeginEditing:(UITextView *)textView{
    
    
    [UIView  beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0.30];
    
    self.view.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}


-(void) textViewDidEndEditing:(UITextView *)textView
{
    [UIView  beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [UIView setAnimationDuration:0.30];
    
    self.view.frame = CGRectMake(0,100, self.view.frame.size.width, self.view.frame.size.height);

    
    [UIView commitAnimations];
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    textView.text=@"";
    return YES;  
}

-(void)keyboardWillShow
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    CGRect rect = self.view.frame;
    CGRect rect2 = foodView.frame;
    CGRect rect3 = FeedbackQuestionTable.frame;
    rect.origin.y -= 150;
    rect.size.height += 150;
    self.view.frame = rect;
    rect2.size.height = 183;
    foodView.frame = rect2;
    rect3.size.height = 163;
    FeedbackQuestionTable.frame = rect3;
    [self.view bringSubviewToFront:skipBtn];
    [self.view bringSubviewToFront:doneBtn];
    [UIView commitAnimations];
}

-(void)keyboardWillHide
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    CGRect rect = self.view.frame;
    CGRect rect2 = foodView.frame;
    CGRect rect3 = FeedbackQuestionTable.frame;
    rect.origin.y += 150;
    rect.size.height -= 150;
    self.view.frame = rect;
    rect2.size.height = 183;
    foodView.frame = rect2;
    rect3.size.height = 163;
    FeedbackQuestionTable.frame = rect3;
    [UIView commitAnimations];
}

@end
