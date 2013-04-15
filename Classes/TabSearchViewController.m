#import "TabSearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SBJSON.h"
#import "ShareableData.h"
#import "TabMainCourseMenuListViewController.h"
#import "TabSquareMenuController.h"
#import "TabSquareBeerController.h"
#import "TabSquareDBFile.h"

@implementation TabSearchViewController

@synthesize searchTextView;
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

-(void)getDishData
{
    
    [[ShareableData sharedInstance].SearchAllItemData removeAllObjects];
    
    [ShareableData sharedInstance].TaskType=@"2";
    
  //  [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
    
    [ShareableData sharedInstance].SearchAllItemData =[[TabSquareDBFile sharedDatabase] getDishKeyTag:selectedCatId tagA:selectedSubCatId tagB:selectedDishId tagC:selectedDishPrice];
    //DLog(@"Serach Result : %@",result);
    // for(int i=0;i<[result count];i++)
    {
        // NSMutableDictionary *dataItem=[result objectAtIndex:i];
        // DLog(@"Data : %@",dataItem);
    }
  //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
    
    if([[ShareableData sharedInstance].SearchAllItemData count]==0)
    {
        UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:nil message:@"Items not found"
                                                        delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert4 show];
    }
    else
    {
        int totalfound=[[ShareableData sharedInstance].SearchAllItemData count];
        
        UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%d Items Found",totalfound]
                                                        delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert4 show];
        
      /*  if([selectedCatId isEqualToString:[ShareableData sharedInstance].bevCat])
        {
            [self.view addSubview:BeverageView.view];
            [BeverageView reloadDataOfSubCat:@"0" cat:selectedCatId];  
            [BeverageView.beverageView reloadData]; 
        }
        else
        {*/
        //[self.view removeFromSuperview];
            //[HomePage.view addSubview:menulistView1.view];
            menulistView1.view.frame=CGRectMake(-10, 10, menulistView1.view.frame.size.width, menulistView1.view.frame.size.height);
            [menulistView1 reloadDataOfSubCat:@"0" cat:selectedCatId];
        
            [self.view.superview addSubview:menulistView1.view];
        [menulistView1.DishList reloadData];
        [self.view removeFromSuperview];
            //[menulistView1 reloadDataOfSubCat:@"0" cat:selectedCatId];
            
       // }
        
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
    searchTextView.layer.cornerRadius=3.0;
    [self createArrayData];
    [super viewDidLoad];
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
    [searchTextView resignFirstResponder];
    [self getDishData];
}


-(void)getDishDataByText
{
    NSString *trimmedString = [searchTextView.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([trimmedString isEqualToString:@""])
    {
        UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter any word"
                                                        delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert4 show];
    }
    else
    {
        
     //   [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
        
        [ShareableData sharedInstance].SearchAllItemData=[[TabSquareDBFile sharedDatabase] getDishKeyData:trimmedString];
        //DLog(@"Serach Result : %@",result);
        // for(int i=0;i<[result count];i++)
        {
            // NSMutableDictionary *dataItem=[result objectAtIndex:i];
            // DLog(@"Data : %@",dataItem);
        }
       // [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
        
        [ShareableData sharedInstance].TaskType=@"2";
        int total=[[ShareableData sharedInstance].SearchAllItemData count];
        if(total>0)
        {
            menulistView1.view.frame=CGRectMake(-10, 10, menulistView1.view.frame.size.width, menulistView1.view.frame.size.height);
            [menulistView1 reloadDataOfSubCat:@"0" cat:selectedCatId];
            [self.view addSubview:menulistView1.view];
            //[menulistView1 reloadDataOfSubCat:@"0" cat:selectedCatId];
            [menulistView1.DishList reloadData];
            
            UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%d Records Found",total]
                                                            delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            
            [alert4 show];
        }
        else 
        {
            UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:nil message:@"Records not found"
                                                            delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert4 show];
            
        }
        
        
    }
}
-(IBAction)searchClicked1:(id)sender
{
    [searchTextView resignFirstResponder];
    [self getDishDataByText];
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