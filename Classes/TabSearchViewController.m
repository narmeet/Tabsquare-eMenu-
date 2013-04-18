#import "TabSearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SBJSON.h"
#import "ShareableData.h"
#import "TabMainCourseMenuListViewController.h"
#import "TabSquareMenuController.h"
#import "TabSquareBeerController.h"
#import "TabSquareDBFile.h"

@implementation TabSearchViewController

@synthesize searchTextField, backgroundImage, headingLabel, headingLabel2, scroller;
@synthesize filterBtn,keywordBtn,filterPickerView,HomePage;
@synthesize selectedCatId,selectedSubCatId,selectedDishId,selectedDishPrice,menulistView1,BeverageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        self.view.frame=CGRectMake(12, 100, self.view.frame.size.width, self.view.frame.size.height);
    }
    return self;
}
-(void)getCategoryData
{
    for(int i=1;i<[[ShareableData sharedInstance].categoryIdList count];i++)
    {
        [categoryName addObject:([ShareableData sharedInstance].categoryList)[i]];
        [categoryId addObject:([ShareableData sharedInstance].categoryIdList)[i]];
    }
}

-(void)getSubCategoryData:(NSString*)catId
{
    //NSString *Key=@"kinara123";
    selectedCatId=catId;
    NSString *post =[NSString stringWithFormat:@"key=%@", [ShareableData appKey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_all_tags", [ShareableData serverURL]];
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
    //DLog(@"%@",resultFromPost);
    
    @try
    {
        [subCategoryId removeAllObjects];
        [subCategoryName removeAllObjects];
        
        [subCategoryName addObject:[NSString stringWithFormat:@"%@",@"All"]];
        [subCategoryId addObject:[NSString stringWithFormat:@"%@",@"-1"]];
        
        for(int i=0;i<[resultFromPost count];i++)
        {
            NSMutableDictionary *dataitem=resultFromPost[i];
            [subCategoryName addObject:[NSString stringWithFormat:@"%@",dataitem[@"name"]]];
            [subCategoryId addObject:[NSString stringWithFormat:@"%@",dataitem[@"id"]]];
        }
        
        selectedCatId=categoryId[0];
       // selectedCatName=[categoryName objectAtIndex:0];
        selectedSubCatId=subCategoryId[0];
        selectedDishId=subCategoryId[0];
        
        selectedDishPrice=subCategoryId[0];
    }
    @catch (NSException *exception)
    {
        
    }
    
}


-(void)createArrayData
{
    categoryId=[[NSMutableArray alloc]init];
    categoryName=[[NSMutableArray alloc]init];
    subCategoryId=[[NSMutableArray alloc]init];
    subCategoryName=[[NSMutableArray alloc]init];
    dishId=[[NSMutableArray alloc]init];
    dishName=[[NSMutableArray alloc]init];
    dishprice=[[NSMutableArray alloc]init];
    
}

-(void)getPickerData
{
    if([categoryId count]==0)
    {
        [self getCategoryData];
        int catIndex=[categoryId count]/2;
        [self getSubCategoryData:categoryId[catIndex]];
        
    }
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*===============Customizing Font Appearance================*/
    [self.keywordBtn.titleLabel setFont:[UIFont fontWithName:@"Century Gothic" size:20.0]];
    [self.headingLabel setFont:[UIFont fontWithName:@"Century Gothic" size:22.0]];
    [self.headingLabel2 setFont:[UIFont fontWithName:@"Century Gothic" size:22.0]];
    [self.searchTextField.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.searchTextField.layer setBorderWidth:1.0];

    
    if(![self hasTagData]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT
                                             , 0), ^{
                [self getSearchTags];
        
                dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self addQuickSearchButtons];
                [self createArrayData];
            });
        
        });
    }
    else {

        [self addQuickSearchButtons];
        [self createArrayData];
    }
    
    
    NSString *img_name = [NSString stringWithFormat:@"%@%@_%@.png", PRE_NAME, POPUP_IMAGE, [ShareableData appKey]];
    UIImage *img = [[TabSquareDBFile sharedDatabase] getImage:img_name];
    if(img != nil)
        [self.backgroundImage setImage:img];

}


-(void)getSearchTags
{
    NSString *post =[NSString stringWithFormat:@"key=%@", [ShareableData appKey]];
    ////NSLOG(@"request = %@", date);
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/webs/get_all_tags", [ShareableData serverURL]];
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
    ////NSLOG(@"original data = %@", data);
    
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableDictionary *resultFromPost = [parser objectWithString:data error:nil];
    //NSLOG(@"Response data = %@", resultFromPost);
    [[NSUserDefaults standardUserDefaults] setObject:resultFromPost forKey:SEARCH_DATA];
    
}


-(void)callTosearch:(id)sender
{
    NSString *search_text = @"";
    
    if(sender == nil) {
        search_text = [NSString stringWithFormat:@"%@", self.searchTextField.text];
    }
    else {
        UIButton *btn = (UIButton *)sender;
        search_text = [btn titleForState:UIControlStateNormal];
    }

    search_text = [search_text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *to_filter = @"!@$&%^&(*^(_()*/48";
    NSString *finalSearchString = [NSString stringWithFormat:@"%@", search_text];
    
    for(int i = 0; i < [to_filter length]; i++) {
        NSString *search = [NSString stringWithFormat:@"%c", [to_filter characterAtIndex:i]];
        [finalSearchString stringByReplacingOccurrencesOfString:search withString:@""];
    }

    if([search_text length] == 0 || (![search_text isEqualToString:finalSearchString])) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter any valid keyword !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        return;
    }

    /*===========Preform Search Operation Finally=============*/
    NSMutableArray *search_data = [[TabSquareDBFile sharedDatabase] getDishKeyData:search_text];
    [[ShareableData sharedInstance].SearchAllItemData removeAllObjects];
    [ShareableData sharedInstance].SearchAllItemData= search_data;
    [ShareableData sharedInstance].TaskType=@"2";
    self.searchTextField.text = @"";

    if([search_data count] > 0) {
        menulistView1.view.frame=CGRectMake(0, 191, menulistView1.view.frame.size.width, menulistView1.view.frame.size.height);
        [menulistView1 reloadDataOfSubCat:@"0" cat:selectedCatId];
        [self.HomePage.view addSubview:menulistView1.view];
        [menulistView1.view setHidden:FALSE];
        [self.HomePage setSearchOn:search_text];
        [menulistView1.DishList reloadData];
        [self.view removeFromSuperview];
    }
    else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"No items found !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
    }
}


-(void)addQuickSearchButtons
{
    NSMutableDictionary *tags_data = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_DATA];
  //  NSMutableArray *tags = tags_data[[ShareableData sharedInstance].currentLanguage];
    NSMutableArray *tags = tags_data[@"english"];
    
    /*
    tags = [[NSMutableArray alloc] init];
    [tags addObject:@"Vegetarian"];
    [tags addObject:@"Paneer"];
    [tags addObject:@"Fish"];
    [tags addObject:@"Roti"];
    
    [tags addObject:@"Vegetarian"];
    [tags addObject:@"Paneer"];
    [tags addObject:@"Fish"];
    [tags addObject:@"Roti"];
    [tags addObject:@"Spicy"];
     */

    
    int x_gap = 7;
    int y_gap = 15;
    
    int x_shift = -1;
    int max_in_row = 4;
    float last_y = 0;
    
    CGSize size = CGSizeMake(175.0, 58.0);
    
    for(int i = 0; i < [tags count]; i++)
    {
        if(i > 0 && (i % max_in_row) == 0)
            x_shift -= (max_in_row-1);
        else
            x_shift++;

        float x = (x_shift * x_gap) + (x_shift * size.width);
        int mult = (i/max_in_row);
        float y =  (mult * y_gap) + (mult * size.height);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"quicksearchbutton.png"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(x, y, size.width, size.height)];
        [btn setTitle:tags[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:@"Century Gothic" size:20.0]];
        [btn addTarget:self action:@selector(callTosearch:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn.layer setShadowOpacity:0.8];
        [btn.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
        
        last_y = btn.frame.size.height + btn.frame.origin.y;
        [self.scroller addSubview:btn];
        

    }
    
    [self.scroller setContentSize:CGSizeMake(self.scroller.contentSize.width, last_y)];
    
}


-(BOOL)hasTagData
{
    BOOL status = TRUE;
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_DATA] == nil)
        status = FALSE;
    
    return status;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(IBAction)searchClicked:(id)sender
{
    //[searchTextField resignFirstResponder];
    //[self getDishData];
}


-(IBAction)searchClicked1:(id)sender
{
    [self.searchTextField resignFirstResponder];
    [self callTosearch:nil];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView 
{
    return 4;
}

- (NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component 
{
    if(component==0)
    {
        return [categoryId count];
    }
    else if(component==1)
    {
        return [subCategoryId count];
    }
    else if(component==2)
    {
        return [subCategoryId count];
    }
    else if(component==3)
    {
        return [subCategoryId count];
    }
    return 0;
}


-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0)
    {
        return categoryName[row];
    }
    else if(component==1)
    {
        return subCategoryName[row];
    }
    else if(component==2)
    {
        return subCategoryName[row];
    }
    else if(component==3)
    {
        return subCategoryName[row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component==0)
    {
        //DLog(@"Category : %@",[categoryName objectAtIndex:row]);
        selectedCatId=categoryId[row];
        //selectedCatName=[categoryName objectAtIndex:row];
    }
    else if (component==1)
    {
        //DLog(@"Tag1 : %@",[subCategoryName objectAtIndex:row]);
        selectedSubCatId=subCategoryId[row];
    }
    else if(component==2)
    {
        //DLog(@"Tag2 : %@",[subCategoryName objectAtIndex:row]);
        selectedDishId=subCategoryId[row];
    }
    else if(component==3)
    {
        //DLog(@"Tag3 : %@",[subCategoryName objectAtIndex:row]);
        selectedDishPrice=subCategoryId[row];
    }
    
    [filterPickerView reloadComponent:1];
    [filterPickerView reloadComponent:2];
    [filterPickerView reloadComponent:3];
    
}


@end