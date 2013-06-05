
#import "TabSquareHomeController.h"
#import <QuartzCore/QuartzCore.h>
#import "TabSquareHome2Controller.h"
#import "TabSquareDBFile.h"
#import "SBJSON.h"
#import "ShareableData.h"
#import "TabSquareMenuController.h"
#import "Flurry.h"
#import "TabSquarePlaogramView.h"
#import "TabSquareCommonClass.h"

@implementation TabSquareHomeController

@synthesize homeView1,homeView2,categoryList,categoryIdList,backView,homeview,menu;

int toUpdate = 0;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        // Custom initialization
    }
    return self;
}


-(void)moveDoor
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.2];
    homeView1.frame=CGRectMake(-384, homeView1.frame.origin.y, homeView1.frame.size.width, homeView1.frame.size.height);
    homeView2.frame=CGRectMake(768, homeView2.frame.origin.y, homeView2.frame.size.width, homeView2.frame.size.height);
    [UIView commitAnimations];
    
}

-(IBAction)doorOpenClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    btn.hidden=YES;
    [self.view setUserInteractionEnabled:FALSE];
    
    homeView1.layer.anchorPoint = CGPointMake(0, 0.5); // hinge around the left edge
    homeView1.frame = CGRectMake(0, 0, 384, 1004); //reset view position
    
    homeView2.layer.anchorPoint = CGPointMake(1.0, 0.5); //hinge around the right edge
    homeView2.frame = CGRectMake(384, 0, 384, 1004); //reset view position
    
    [UIView animateWithDuration:1.75 animations:^{
        CATransform3D leftTransform = CATransform3DIdentity;
        leftTransform.m34 = -1.0f/500; //dark magic to set the 3D perspective
        leftTransform = CATransform3DRotate(leftTransform, -M_PI_2, 0, 1, 0);
        homeView1.layer.transform = leftTransform;
        
        CATransform3D rightTransform = CATransform3DIdentity;
        rightTransform.m34 = -1.0f/500; //dark magic to set the 3D perspective
        rightTransform = CATransform3DRotate(rightTransform, M_PI_2, 0, 1, 0);
        homeView2.layer.transform = rightTransform;
    }];
    
    [self performSelector:@selector(enableView) withObject:nil afterDelay:1.74];
    
}

-(void)enableView
{
    [self.view setUserInteractionEnabled:TRUE];
}

-(void)getHomeImageInDB
{
    // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    /* if (toUpdate ==1){
       NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://108.178.27.242/luigi/img/product/front/image_front1.png"]];
       [[TabSquareDBFile sharedDatabase]insertIntoHomeImageTableWithRecord:@"1" imageName:@"image1" imageData:imageData];
       
       NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://108.178.27.242/luigi/img/product/front/image_front2.png"]];
       [[TabSquareDBFile sharedDatabase]insertIntoHomeImageTableWithRecord:@"2" imageName:@"image2" imageData:imageData1];
    }*/
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
    NSString *libraryDirectory = [paths lastObject];
    NSString *location = [NSString stringWithFormat:@"%@/%@%@_%@.png",libraryDirectory, PRE_NAME,HOME_IMAGE1, [ShareableData appKey]];
    // NSData *image=[[TabSquareDBFile sharedDatabase]getHomeImageData:@"1"];
    UIImage *img = [UIImage imageWithContentsOfFile:location];
    
    backView.image=img;
    
    // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
}


-(void)updateHomeImageInDB
{
    /*
    NSString *nn =[NSString stringWithFormat:@"%@/img/product/front/image_front1.png", [ShareableData serverURL]];
    NSString *nn2 = [NSString stringWithFormat:@"%@/img/product/front/image_front2.png", [ShareableData serverURL]];
    
    UIImage  *imageData = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nn]]];
    UIImage  *imageData2 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nn2]]];
    
   // UIImage  *imageData  = [UIImage imageNamed:@"bar_shelf.png"];
   // UIImage  *imageData2 = [UIImage imageNamed:@"bar_shelf.png"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
    NSString *libraryDirectory = paths[0];
    NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,@"image_front1.png"];//
    NSString *location2 = [NSString stringWithFormat:@"%@/%@",libraryDirectory,@"image_front2.png"];//[libraryDirectory stringByAppendingString:@"/@%",dishImage];
    
    */
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
    NSString *libraryDirectory = [paths lastObject];
    NSString *location = [NSString stringWithFormat:@"%@/%@/%@_%@.png",libraryDirectory, PRE_NAME,HOME_IMAGE1, [ShareableData appKey]];//
    NSString *location2 = [NSString stringWithFormat:@"%@/%@/%@_%@.png",libraryDirectory,PRE_NAME,HOME_IMAGE2, [ShareableData appKey]];//[libraryDirectory stringByAppendingString:@"/@%",dishImage];

    //NSLOG(@"Home img path = %@", [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, HOME_IMAGE1, [ShareableData appKey]]);
    UIImage *imageData = [[TabSquareDBFile sharedDatabase] getImage:[NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, HOME_IMAGE1, [ShareableData appKey]]];

    UIImage *imageData2 = [[TabSquareDBFile sharedDatabase] getImage:[NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, HOME_IMAGE2, [ShareableData appKey]]];

    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(imageData)];
    NSData *data2 = [NSData dataWithData:UIImagePNGRepresentation(imageData2)];
    [data1 writeToFile:location atomically:YES];
    [data2 writeToFile:location2 atomically:YES];
    
    
    /* NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://108.178.27.242/luigi/img/product/front/image_front1.png"]];
     NSData *imageData2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://108.178.27.242/luigi/img/product/front/image_front2.png"]];
    
   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    [[TabSquareDBFile sharedDatabase]updateHomeImageRecordTable:@"1" imageData:imageData1];
    [[TabSquareDBFile sharedDatabase]updateHomeImageRecordTable:@"2" imageData:imageData2];*/
    
  //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
}

-(void)viewDidAppear:(BOOL)animated{
   /* if ([[ShareableData sharedInstance].isQuickOrder isEqualToString:@"1"]){
        if([([ShareableData sharedInstance].IsGetCMSData)[0]isEqualToString:@"0"])
        {
            ([ShareableData sharedInstance].IsGetCMSData)[0] = @"1";
            [self GetCategoryData];
            [self GetHomeCategoryData];
            [ShareableData sharedInstance].categoryList=categoryList;
            [ShareableData sharedInstance].categoryIdList=categoryIdList;
        }
        [self.navigationController pushViewController:homeview animated:YES];
        menu=[[TabSquareMenuController alloc]initWithNibName:@"TabSquareMenuController" bundle:nil];
        // menu = [[TabSquareQuickOrder alloc] initWithNibName:@"TabSquareQuickOrder" bundle:nil];
        menu.view.frame=CGRectMake(0,[UIScreen mainScreen].bounds.size.width, menu.view.frame.size.width, menu.view.frame.size.height);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        menu.view.frame=CGRectMake(0,0, menu.view.frame.size.width, menu.view.frame.size.height);
        [UIView commitAnimations];
       // [self presentViewController:menu animated:YES completion:nil];
        
        //[self.view addSubview:menu.view];
        homeview=[[TabSquareHome2Controller alloc]initWithNibName:@"TabSquareHome2Controller" bundle:nil];
        homeview.view.frame=CGRectMake(768, homeview.view.frame.origin.y, homeview.view.frame.size.width, homeview.view.frame.size.height);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        homeview.view.frame=CGRectMake(0, homeview.view.frame.origin.y, homeview.view.frame.size.width, homeview.view.frame.size.height);
        [UIView commitAnimations];
        [self.view addSubview:homeview.view];
    }*/
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
            
    NSString *img_name = [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, HOME_IMAGE1, [ShareableData appKey]];
    UIImage *img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    
    if(img != nil)
        backView.image = img;
    /*
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Home Page",
     @"Item Purchased", nil];
    [Flurry logEvent:@"Home opened" withParameters:params];
     */
    
    homeview=[[TabSquareHome2Controller alloc]initWithNibName:@"TabSquareHome2Controller" bundle:nil];
    /* // DLog(@"Tab Square Home Controller");
    Delete After First Launch
    NSString *data=[self GetDishTableData:@"0"];
    //DLog(@"%@",data);
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableDictionary *resultFromPost = [parser objectWithString:data error:nil];
    //[self insertDishCustData:resultFromPost];
    NSMutableArray *dishitem=[resultFromPost objectForKey:@"Dish"];
    [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    [self insertDishData:dishitem];
    [[TabSquareDBFile sharedDatabase]closeDatabaseConnection]; */
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.delegate = self;
    [hud setLabelText:@"Loading Menu Updates"];
    [hud setDetailsLabelText:@"This may take a while"];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        
        //[ShareableData sharedInstance].performUpdateCheck = @"0";
        if ([[ShareableData sharedInstance].performUpdateCheck isEqualToString:@"0"]){
            if([([ShareableData sharedInstance].IsDBUpdated)[0] isEqualToString:@"0"])
            {
                [self CheckDatabase];
                [self updateHomeImageInDB];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getHomeImageInDB];
            
            categoryIdList=[[NSMutableArray alloc]init];
            categoryList=[[NSMutableArray alloc]init];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self viewDidAppear:YES];
            if ([[ShareableData sharedInstance].isQuickOrder isEqualToString:@"1"]){
                if([([ShareableData sharedInstance].IsGetCMSData)[0]isEqualToString:@"0"])
                {
                    ([ShareableData sharedInstance].IsGetCMSData)[0] = @"1";
                    [self GetCategoryData];
                    [self GetHomeCategoryData];
                    [ShareableData sharedInstance].categoryList=categoryList;
                    [ShareableData sharedInstance].categoryIdList=categoryIdList;
                }
                //[self.navigationController pushViewController:homeview animated:YES];
            }
        });
    });
    

    
    
    //get home image from DB
   
    //[self performSelector:@selector(moveDoor) withObject:nil afterDelay:0.5];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // DLog(@"Tab Square Home Controller viewDidUnload ");
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


-(IBAction)tapClicked:(id)sender
{
    if([([ShareableData sharedInstance].IsGetCMSData)[0]isEqualToString:@"0"])
    {
        ([ShareableData sharedInstance].IsGetCMSData)[0] = @"1";
        [self GetCategoryData];
        [self GetHomeCategoryData];
        [ShareableData sharedInstance].categoryList=categoryList;
        [ShareableData sharedInstance].categoryIdList=categoryIdList;
    }
    
    
    homeview.view.frame=CGRectMake(768, homeview.view.frame.origin.y, homeview.view.frame.size.width, homeview.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    homeview.view.frame=CGRectMake(0, homeview.view.frame.origin.y, homeview.view.frame.size.width, homeview.view.frame.size.height);
    [UIView commitAnimations];
     // [self presentViewController:homeview animated:YES completion:nil];
    [self.navigationController pushViewController:homeview animated:YES];
  //  [self.view addSubview:homeview.view];
    //[self showIndicator];
}

-(void)insertCategoryData:(NSMutableArray*)categoryData
{
    [TabSquareCommonClass setValueInUserDefault:@"from_cat" value:@"1"];
    
    for(int i=0;i<[categoryData count];i++)
    {
        NSMutableDictionary *dataitem=categoryData[i];
        NSString *catId= [NSString stringWithFormat:@"%@",dataitem[@"id"]];

        NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"is_deleted"]];
        if ([querytype isEqualToString:@"0"]){
            
            if([[TabSquareDBFile sharedDatabase]recordExists:[NSString stringWithFormat:@"SELECT * from Categories where id = '%@' ;",catId ]]==0){
                querytype = @"0";
            }else{
                querytype = @"2";        }
        }
        

        if([querytype isEqualToString:@"0"])
        {
            [[TabSquareDBFile sharedDatabase]insertIntoCategoryTableWithRecord:dataitem];
        }
        else if([querytype isEqualToString:@"2"])
        {
            [[TabSquareDBFile sharedDatabase]updateCategoryRecordTable:dataitem];
        }
        else if ([querytype isEqualToString:@"1"]) 
        {
            [[TabSquareDBFile sharedDatabase]deleteCategoryRecordTable:catId];
            [[TabSquareDBFile sharedDatabase] deleteImage:dataitem[@"image"]];
        }
    }
    
}

-(void)insertSubCategoryData:(NSMutableArray*)subCategoryData
{
    [TabSquareCommonClass setValueInUserDefault:@"from_cat" value:@"0"];
    for(int i=0;i<[subCategoryData count];i++)
    {
        NSMutableDictionary *dataitem=subCategoryData[i];
        NSString *subId= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
        //NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"query_type"]];
        NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"is_deleted"]];
        if ([querytype isEqualToString:@"0"]){
            
            if([[TabSquareDBFile sharedDatabase]recordExists:[NSString stringWithFormat:@"SELECT * from SubCategories where id = '%@' ;",subId ]]==0){
                querytype = @"0";
            }else{
                querytype = @"2";        }
        }
        
        if([querytype isEqualToString:@"0"])
        {
            [[TabSquareDBFile sharedDatabase]insertIntoSubCategoryTableWithRecord:dataitem];
        }
        else if([querytype isEqualToString:@"2"])
        {
            [[TabSquareDBFile sharedDatabase]updateSubCategoryRecordTable:dataitem];
        }
        else if ([querytype isEqualToString:@"1"])
        {
            [[TabSquareDBFile sharedDatabase]deleteSubCategoryRecordTable:subId];
            [[TabSquareDBFile sharedDatabase] deleteImage:dataitem[@"image"]];
        }
        
    }
}

-(void)insertSubSubCategoryData:(NSMutableArray*)subCategoryData
{
    [TabSquareCommonClass setValueInUserDefault:@"from_cat" value:@"0"];
    for(int i=0;i<[subCategoryData count];i++)
    {
        
        NSMutableDictionary *dataitem=subCategoryData[i];
        NSString *subId= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
        //NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"query_type"]];
        NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"is_deleted"]];
        
        if ([querytype isEqualToString:@"0"]){
            
            if([[TabSquareDBFile sharedDatabase]recordExists:[NSString stringWithFormat:@"SELECT * from Sub_Sub_Categories where id = '%@' ;",subId ]]==0){
                querytype = @"0";
            }else{
                querytype = @"2";        }
        }
        
        if([querytype isEqualToString:@"0"])
        {
            [[TabSquareDBFile sharedDatabase]insertIntoSubSubCategoryTableWithRecord:dataitem];
        }
       else if([querytype isEqualToString:@"2"])
        {
            [[TabSquareDBFile sharedDatabase]updateSubSubCategoryRecordTable:dataitem];
        }
        else if ([querytype isEqualToString:@"1"])
        {
            [[TabSquareDBFile sharedDatabase]deleteSubCategoryRecordTable:subId];
            [[TabSquareDBFile sharedDatabase] deleteImage:dataitem[@"image"]];
        }
        
    }
}

- (BOOL)isImageValid:(NSData *)data
{
    BOOL val = YES;
    
    if ([data length] < 4)
        val = NO;
    
   /* const char * bytes = (const char *)[data bytes];
    @try{
        if (bytes){
    if (bytes[0] != 0x89 || bytes[1] != 0x50)
        val = NO;
    if (bytes[[data length] - 2] != 0x60 ||
        bytes[[data length] - 1] != 0x82)
        val = NO;
        }else{
            val = NO;
        }
    }@catch (NSException* eer){
        val = NO;
    }*/
    
    return val;
}


-(void)insertDishData:(NSMutableArray*)dishData
{
    [TabSquareCommonClass setValueInUserDefault:@"from_cat" value:@"0"];
    
    float progress = 0.0f;
    float devider = 1.0f / [dishData count];
   // while (progress < 1.0f) {
    
  //  }
    for(int i=0;i<[dishData count];i++)
    {//dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [hud setDetailsLabelText:[NSString stringWithFormat:@"Updating Dishes Data %d/%d",i+1,[dishData count]]];
        NSMutableDictionary *dataitem=dishData[i];
        DLog([NSString stringWithFormat:@"Loaded New Dish Data: %d, - %@, - %@",i,dataitem[@"id"],dataitem[@"name"] ]);
        
        NSString *dishId= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
        
        NSString *dishImage= [NSString stringWithFormat:@"%@",dataitem[@"images"]];
        NSString *IsImageupdate=[NSString stringWithFormat:@"%@",dataitem[@"is_image_updated"]];        
        //UIImage *imageData ;
       // NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"query_type"]];
        NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"is_deleted"]]; 

        if([IsImageupdate isEqualToString:@"1"]&&[querytype isEqualToString:@"0"])
        {
           // MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
           // hud.labelText = [NSString stringWithFormat:@"Loading Image %d",i ];
            
                // Do something...
                int x = 0;
                NSString *nn = [NSString stringWithFormat:@"%@/img/product/%@", [ShareableData serverURL],dishImage];
            nn = [nn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                while (x ==0){
                @autoreleasepool {
                 
                    UIImage  *imageData = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nn]]];
                    
                
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
                
                    NSString *libraryDirectory = [paths lastObject];
                    
                
                    NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,dishImage];//[libraryDirectory stringByAppendingString:@"/@%",dishImage];
                
                    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(imageData)];
                
                    [data1 writeToFile:location atomically:YES];
                    
                    /*===Resize for thumbnail display===*/
                    CGSize size = CGSizeMake(258.0, 196.0);
                    UIImage *thmb = [TabSquareCommonClass resizeImage:imageData scaledToSize:size];
                    NSData *data2 = [NSData dataWithData:UIImagePNGRepresentation(thmb)];
                    NSString *location1 = [NSString stringWithFormat:@"%@/%@_%@",libraryDirectory, THUMBNAIL,dishImage];//
                    [data2 writeToFile:location1 atomically:YES];
                    /*=================================*/
                    
                    if ([self isImageValid:[NSData dataWithContentsOfFile:location]]){
                        x = 1;
                    }else{
                        x = 0;
                        dishImage = @"default.png";
                        nn = [NSString stringWithFormat:@"%@/img/product/%@", [ShareableData serverURL],dishImage];
                        nn = [nn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    }
                }
                }
               // dispatch_async(dispatch_get_main_queue(), ^{
                   // [MBProgressHUD hideHUDForView:self.view animated:YES];
               // });
          ////  });
         
            
           // DLog(@"Added to Temp");

        }
        else 
        {
            
             
           // MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
           // hud.labelText = [NSString stringWithFormat:@"Loading Image %d",i ];
         //   dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // Do something...
                int x = 0;
                NSString *nn = [NSString stringWithFormat:@"%@/img/product/%@", [ShareableData serverURL],dishImage];
            nn = [nn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
                while (x ==0){
                @autoreleasepool {
                    
              
                    UIImage  *imageData = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nn]]];
                    
                    
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
                NSString *libraryDirectory = [paths lastObject];
                NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,dishImage];//[libraryDirectory stringByAppendingString:@"/@%",dishImage];
                NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(imageData)];
                [data1 writeToFile:location atomically:YES];
                    
                    /*===Resize for thumbnail display===*/
                    CGSize size = CGSizeMake(258.0, 196.0);
                    UIImage *thmb = [TabSquareCommonClass resizeImage:imageData scaledToSize:size];
                    NSData *data2 = [NSData dataWithData:UIImagePNGRepresentation(thmb)];
                    NSString *location1 = [NSString stringWithFormat:@"%@/%@_%@",libraryDirectory, THUMBNAIL,dishImage];//
                    [data2 writeToFile:location1 atomically:YES];
                    /*=================================*/

                    if ([self isImageValid:[NSData dataWithContentsOfFile:location]]){
                        x = 1;
                    }else{
                        x = 0;
                        dishImage = @"default.png";
                        nn = [NSString stringWithFormat:@"%@/img/product/%@", [ShareableData serverURL],dishImage];
                        nn = [nn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    }
                }
                }
        }
      
        
        if ([querytype isEqualToString:@"0"]){
            
            if([[TabSquareDBFile sharedDatabase]recordExists:[NSString stringWithFormat:@"SELECT * from Dishes where id = '%@' ;",dishId ]]==0){
                querytype = @"0";
            }
            else{
                querytype = @"2";
            }
        }
        
        if([querytype isEqualToString:@"0"])
        {
            [[TabSquareDBFile sharedDatabase]insertIntoDishTableWithRecord:dataitem];
        }
        else if([querytype isEqualToString:@"2"])
        {
            if([IsImageupdate isEqualToString:@"1"])
            {
                [[TabSquareDBFile sharedDatabase]updateDishImageRecordTable:dataitem];

            }
            else
            {
                [[TabSquareDBFile sharedDatabase]updateDishRecordTable:dataitem];
            }
        }
        else if ([querytype isEqualToString:@"1"])
        {
            [[TabSquareDBFile sharedDatabase]deleteDishRecordTable:dishId];
        }
                   // dispatch_async(dispatch_get_main_queue(), ^{
        // [MBProgressHUD hideHUDForView:self.view animated:YES];
  //  });
                  //  });
        progress += devider;
        hud.progress = progress;
    }
}

-(void)insertCustomizationData:(NSMutableArray*)custData
{
    for(int i=0;i<[custData count];i++)
    {
        NSMutableDictionary *dataitem=custData[i];
        NSString *custId= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
       // NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"query_type"]];
        NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"is_deleted"]];
        
        if ([querytype isEqualToString:@"0"]){
            
            if([[TabSquareDBFile sharedDatabase]recordExists:[NSString stringWithFormat:@"SELECT * from Customization where id = '%@' ;",custId ]]==0){
                querytype = @"0";
            }else{
                querytype = @"2";        }
        }
        
        if([querytype isEqualToString:@"0"])
        {
            [[TabSquareDBFile sharedDatabase]insertIntoCustomizationTableWithRecord:dataitem];
        }
       else if([querytype isEqualToString:@"2"])
        {
            [[TabSquareDBFile sharedDatabase]updateCustomizationRecordTable:dataitem];
        }
        else if ([querytype isEqualToString:@"1"])
        {
            [[TabSquareDBFile sharedDatabase]deleteCustomizationRecordTable:custId];
        }
   
    }
}

-(void)insertOptionData:(NSMutableArray*)optionData
{
    for(int i=0;i<[optionData count];i++)
    {
        NSMutableDictionary *dataitem=optionData[i];
        NSString *optionid= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
     //   NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"query_type"]];
        NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"is_deleted"]];
        
        if ([querytype isEqualToString:@"0"]){
            
            if([[TabSquareDBFile sharedDatabase]recordExists:[NSString stringWithFormat:@"SELECT * from CustOptions where id = '%@' ;",optionid ]]==0){
                querytype = @"0";
            }else{
                querytype = @"2";        }
        }
        
        if([querytype isEqualToString:@"0"])
        {
            [[TabSquareDBFile sharedDatabase]insertIntoOptionTableWithRecord:dataitem];
        }
        else if([querytype isEqualToString:@"2"])
        {
            [[TabSquareDBFile sharedDatabase]updateOptionRecordTable:dataitem];
        }
        else if ([querytype isEqualToString:@"1"]) {
            [[TabSquareDBFile sharedDatabase]deleteOptionRecordTable:optionid];
        }
    }
}

-(void)insertContainerData:(NSMutableArray*)containerData
{
    for(int i=0;i<[containerData count];i++)
    {
        NSMutableDictionary *dataitem=containerData[i];
        NSString *containerid= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
        //NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"query_type"]];
        NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"is_deleted"]];
        if ([querytype isEqualToString:@"0"]){
            
            if([[TabSquareDBFile sharedDatabase]recordExists:[NSString stringWithFormat:@"SELECT * from Containers where id = '%@' ;",containerid ]]==0){
                querytype = @"0";
            }else{
                querytype = @"2";        }
        }
        
        if([querytype isEqualToString:@"0"])
        {
            [[TabSquareDBFile sharedDatabase]insertIntoContainersTableWithRecord:dataitem];
        }
        else if([querytype isEqualToString:@"2"])
        {
            [[TabSquareDBFile sharedDatabase]updateContainersRecordTable:dataitem];
        }
        else if ([querytype isEqualToString:@"1"])
        {
            [[TabSquareDBFile sharedDatabase]deleteContainersRecordTable:containerid];
        }
    }
}

-(void)insertBeverageContainerData:(NSMutableArray*)BeverageContainerData
{
    for(int i=0;i<[BeverageContainerData count];i++)
    {
        NSMutableDictionary *dataitem=BeverageContainerData[i];
        NSString *bevid= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
      //  NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"query_type"]];
        NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"is_deleted"]];
        
        if ([querytype isEqualToString:@"0"]){
            
            if([[TabSquareDBFile sharedDatabase]recordExists:[NSString stringWithFormat:@"SELECT * from BeverageContainers where id = '%@' ;",bevid ]]==0){
                querytype = @"0";
            }else{
                querytype = @"2";        }
        }
        
        if([querytype isEqualToString:@"0"])
        {
            [[TabSquareDBFile sharedDatabase]insertIntoBeverageContainerTableWithRecord:dataitem];
        }
        else if([querytype isEqualToString:@"2"])
        {
            [[TabSquareDBFile sharedDatabase]updateBeverageContainerRecordTable:dataitem];

        }
        else if ([querytype isEqualToString:@"1"])
        {
            [[TabSquareDBFile sharedDatabase]deleteBeverageContainerRecordTable:bevid];
        }
    }
}

/* before sahid conversion this code was open..........
 
-(void)insertHomePageData:(NSMutableArray*)homeData
{
    for(int i=0;i<[homeData count];i++)
    {
        NSMutableDictionary *dataitem=homeData[i];
        NSString *homeid= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
        NSString *catid= [NSString stringWithFormat:@"%@",dataitem[@"cat"]];
        NSString *subcatid= [NSString stringWithFormat:@"%@",dataitem[@"subcat"]];
       
        if (toUpdate == 0){
          [[TabSquareDBFile sharedDatabase]updateHomeCategoryRecordTable:homeid categoryId:catid subcategoryId:subcatid];  
        } else{
           [[TabSquareDBFile sharedDatabase]insertHomeCategoryRecordTable:homeid categoryId:catid subcategoryId:subcatid];
        }
        
       // [[TabSquareDBFile sharedDatabase]updateHomeCategoryRecordTable:homeid categoryId:catid subcategoryId:subcatid];
            
    }
}*/

-(void)insertHomePageData:(NSMutableDictionary *)homeData
{
    NSString *homeid= @"1";
    NSString *catid= [NSString stringWithFormat:@"%@",homeData[@"cat"]];
    NSString *subcatid= [NSString stringWithFormat:@"%@",homeData[@"subcat"]];
    
    if (toUpdate == 0){
        
        [[TabSquareDBFile sharedDatabase]updateHomeCategoryRecordTable:homeid categoryId:catid subcategoryId:subcatid];
        
    }
    else {
        
        [[TabSquareDBFile sharedDatabase]insertHomeCategoryRecordTable:homeid categoryId:catid subcategoryId:subcatid];
        
    }
    
}

-(void)insertDishCustData:(NSMutableDictionary*)result {
   // DLog(@"%d",[result count]);
    NSMutableDictionary *HomePage=result[@"HomePage"];
    NSMutableArray *categoryitem=result[@"Category"];
    NSMutableArray *subcategoryitem=result[@"SubCategory"];
    NSMutableArray *subSubCategoryitem=result[@"SubSubCategory"];
    NSMutableArray *dishitem=result[@"Dish"];
    NSMutableArray *customizationitem=result[@"Customisation"];
    NSMutableArray *optionitem=result[@"Option"];
    NSMutableArray *containeritem=result[@"Container"];
    NSMutableArray *beverageContaineritem=result[@"BeverageContainer"];
    NSMutableArray *comboValueItem = result[@"ComboValue"];
    NSMutableArray *comboitem = result[@"Combo"];
    NSMutableArray *groupitem = result[@"Group"];
    NSMutableArray *groupDishitem = result[@"GroupDish"];
    NSMutableArray *tagitem = result[@"Tag"];
    NSMutableArray *imagesitem = result[@"Images"];
    NSMutableArray *staticTexts = result[@"StaticText"];
    
    NSMutableDictionary *font_dict = result[@"AppFontSetting"];
    
    if(font_dict != nil)
        [[NSUserDefaults standardUserDefaults] setObject:font_dict forKey:FONT_DICTIONARY];

    if(staticTexts != nil)
        [[NSUserDefaults standardUserDefaults] setObject:staticTexts forKey:STATIC_TEXTS];

        /*===========Apply a temporary check if all data is coming with non 0 Timestamp===========*/
    /*
    if([currentDate intValue] != 0) {
        
        if([dishitem count] > 150)
            return;
    }
    */
    /*=======================================================================================*/
        // hud.mode = 	MBProgressHUDModeIndeterminate;
        
    [hud setDetailsLabelText:@"Updating Category Data"];
    [self insertCategoryData:categoryitem];
    //hud.mode = MBProgressHUDModeIndeterminate;
    [hud setDetailsLabelText:@"Updating SubCategory Data"];
    [self insertSubCategoryData:subcategoryitem];
    //hud.mode = MBProgressHUDModeIndeterminate;
    [hud setDetailsLabelText:@"Updating SubCategory Items"];
    [self insertSubSubCategoryData:subSubCategoryitem];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
     
    
    [hud setDetailsLabelText:@"Updating Dishes Data"];
    [self insertDishData:dishitem];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [hud setDetailsLabelText:@"Updating Customization Data"];
    [self insertCustomizationData:customizationitem];
    
    [hud setDetailsLabelText:@"Updating Option Data"];
    [self insertOptionData:optionitem];
    
    [hud setDetailsLabelText:@"Updating Drink Container Data"];
    [self insertContainerData:containeritem];
    
    [hud setDetailsLabelText:@"Updating Drink Data"];
    [self insertBeverageContainerData:beverageContaineritem];
    
    [hud setDetailsLabelText:@"Updating Promo Data"];
    [self insertHomePageData:HomePage];
    
    [hud setDetailsLabelText:@"Updating Combo Value Data"];
    [self insertComboValueData:comboValueItem];
    
    [hud setDetailsLabelText:@"Updating Combo Data"];
    [self insertComboData:comboitem];
    
    [hud setDetailsLabelText:@"Updating Group Data"];
    [self insertGroupData:groupitem];

    [hud setDetailsLabelText:@"Updating GroupDish Data"];
    [self insertGroupDishData:groupDishitem];

    [hud setDetailsLabelText:@"Updating DishTags Data"];
    [self insertDishTagData:tagitem];
    
    [hud setDetailsLabelText:@"Updating UI Images"];
    [[TabSquareDBFile sharedDatabase] updateUIImages:imagesitem];

    //  if([HomeImageItem count]!=0)
  //  {
       // [self updateHomeImageInDB];
   // }
    //[[TabSquareDBFile sharedDatabase]optimizeDB];
    //Remved temporarily, find way to optimize this process
}




-(void)insertComboValueData:(NSMutableArray *)comboValueItem
{
    for(int i=0;i<[comboValueItem count];i++)
    {
        NSMutableDictionary *dataitem=comboValueItem[i];
        
      //  NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"query_type"]];
        NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"is_deleted"]];
        [[TabSquareDBFile sharedDatabase] updateComboValueData:dataitem type:querytype];
    }

}

-(void)insertComboData:(NSMutableArray *)comboitem
{
    [TabSquareCommonClass setValueInUserDefault:@"from_cat" value:@"0"];
    for(int i=0;i<[comboitem count];i++)
    {
        NSMutableDictionary *dataitem=comboitem[i];
        
       // NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"query_type"]];
        NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"is_deleted"]];
        [[TabSquareDBFile sharedDatabase] updateComboData:dataitem type:querytype];
    }
}

-(void)insertGroupData:(NSMutableArray *)groupitem
{
    [TabSquareCommonClass setValueInUserDefault:@"from_cat" value:@"0"];
    for(int i=0;i<[groupitem count];i++)
    {
        NSMutableDictionary *dataitem=groupitem[i];
        
       // NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"query_type"]];
        NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"is_deleted"]];
        [[TabSquareDBFile sharedDatabase] updateGroupData:dataitem type:querytype];
    }

}


-(void)insertGroupDishData:(NSMutableArray *)groupdishitem
{
    [TabSquareCommonClass setValueInUserDefault:@"from_cat" value:@"0"];
    for(int i=0;i<[groupdishitem count];i++)
    {
        NSMutableDictionary *dataitem=groupdishitem[i];
        
      //  NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"query_type"]];
        NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"is_deleted"]];
        [[TabSquareDBFile sharedDatabase] updateGroupDishData:dataitem type:querytype];
    }
}


-(void)insertDishTagData:(NSMutableArray *)dishtagitem
{
    [TabSquareCommonClass setValueInUserDefault:@"from_cat" value:@"0"];
    for(int i=0;i<[dishtagitem count];i++)
    {
        NSMutableDictionary *dataitem=dishtagitem[i];
        
       // NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"query_type"]];
        NSString *querytype=[NSString stringWithFormat:@"%@",dataitem[@"is_deleted"]];
        [[TabSquareDBFile sharedDatabase] updateDishTagData:dataitem type:querytype];
    }

}

-(void)CheckDatabase
{
   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    int totalrecords=[[TabSquareDBFile sharedDatabase]getTotalRows];
    NSString *datetime;
    if(totalrecords==0)
    {
        [[TabSquareDBFile sharedDatabase]InsertkinaraVersion];
        datetime=@"0";
        toUpdate = 1;
    }
    else 
    {
        datetime=[[TabSquareDBFile sharedDatabase]getUpdateDateTime];
        //[[TabSquareDBFile sharedDatabase]updateKinaraVersionDate];
        
    }
    
    //datetime = @"0";
    
    currentDate = [NSString stringWithFormat:@"%@", datetime];
    NSString *data=[self GetDishTableData:datetime];
    //NSLog(@"---> %@",data);
    
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableDictionary *resultFromPost = [parser objectWithString:data error:nil];
    NSLog(@"Response data = %@", resultFromPost);
    
    NSString *time = resultFromPost[@"Time"];
    [[TabSquareDBFile sharedDatabase]updateKinaraVersionDate:time];
    [self insertDishCustData:resultFromPost];
    
    ([ShareableData sharedInstance].IsDBUpdated)[0] = @"1";
    // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
}


-(void)GetHomeCategoryData
{
   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    
    NSMutableArray *resultFromPost = [[TabSquareDBFile sharedDatabase]getHomeCategoryData:@"1"];   
    if([resultFromPost count]>=1)
    {
        NSMutableDictionary *dataitem=resultFromPost[0];
        NSString *catId=[NSString stringWithFormat:@"%@",dataitem[@"cat"]];
        NSString *subCatId=[NSString stringWithFormat:@"%@",dataitem[@"subcat"]];
        [[ShareableData sharedInstance].HomeCatId addObject:catId];
        [[ShareableData sharedInstance].HomeSubCatId addObject:subCatId];
    }
       
   // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
}


-(void)GetCategoryData
{
   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    
    NSMutableArray *resultFromPost = [[TabSquareDBFile sharedDatabase]getCategoryData]; 

    //  DLog(@"Data :%@",resultFromPost);
    for(int i=0;i<[resultFromPost count];i++)
    {
        NSMutableDictionary *dataitem=resultFromPost[i];
        [categoryList addObject:[NSString stringWithFormat:@"%@",dataitem[@"name"]]];
        [categoryIdList addObject:[NSString stringWithFormat:@"%@",dataitem[@"id"]]];
        
        //get subcategorydata
         NSMutableArray *subCategoryItem=[[TabSquareDBFile sharedDatabase]getSubCategoryData:categoryIdList[i]];
        [[ShareableData sharedInstance].SubCategoryList addObject:subCategoryItem];
    }
         
  //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
}


-(NSString*)GetDishTableData:(NSString*)date
{
    //NSString *Key=@"kinara123";
    
    NSString *post =[NSString stringWithFormat:@"key=%@&date=%@", [ShareableData appKey],date];
    NSLog(@"request = %@", post);
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/final_get_dishes", [ShareableData serverURL]];
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
    return  [data stringByReplacingOccurrencesOfString:@"'" withString:@""];
}


@end
