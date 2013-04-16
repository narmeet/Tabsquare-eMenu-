
#import "ShareableData.h"

@implementation ShareableData

@synthesize OrderItemID,OrderItemName,OrderItemRate,OrderItemQuantity,categoryIdList,categoryList,SubCategoryList,AllItemData,ViewMode,TaskType;
@synthesize OrderCatId,isConfermOrder,SearchAllItemData,HomeCatId,HomeSubCatId,OrderSubCatId;
@synthesize tableData,tableStatus,swipeView;
@synthesize confirmOrder,OrderId;
@synthesize TaxNameValue,TaxList,Discount,TaxID,isDeduction,inFormat,isLogin;
@synthesize DishQuantity,DishName,DishRate,DishId;
@synthesize TDishQuantity,TDishName,TDishRate;
@synthesize assignedTable1,assignedTable2,assignedTable3,assignedTable4,isConfromHomePage,isTakeaway,Customer,performUpdateCheck;
@synthesize OrderCustomizationDetail,IsOrderCustomization,OrderBeverageContainerId,IsDBUpdated,isFeedbackDone;
@synthesize IsGetCMSData,IsViewPage,isFBLogin,OrderSpecialRequest;
@synthesize feedDishName,feedDishRating,feedDishImage,isInternetConnected,AddItemFromTakeaway,isTwitterLogin,OrderDishImage;
@synthesize IsEditOrder,tableNumber,TempOrderID,isQuickOrder,rootLoaded,salesNo,splitNo;
@synthesize serverUrl, dishTag, categoryID,bevCat,isSpecialReq;


static ShareableData *abc;

+(ShareableData*) sharedInstance
{
    if(!abc)
    {
        abc=[[ShareableData alloc]init];
    }
    return abc;
}

-(void) allocateArray
{
    
    isInternetConnected=FALSE;
    
    OrderItemID=[[NSMutableArray alloc]init];
    OrderItemName=[[NSMutableArray alloc]init];
    OrderItemRate=[[NSMutableArray alloc]init];
    IsOrderCustomization=[[NSMutableArray alloc]init];
    OrderItemQuantity=[[NSMutableArray alloc]init];
    OrderCustomizationDetail=[[NSMutableArray alloc]init];
    IsViewPage=[[NSMutableArray alloc]init];
    OrderCatId=[[NSMutableArray alloc]init];
    OrderSubCatId=[[NSMutableArray alloc]init];
    confirmOrder=[[NSMutableArray alloc]init];
    OrderBeverageContainerId=[[NSMutableArray alloc]init];
    categoryList=[[NSMutableArray alloc]init];
    categoryIdList=[[NSMutableArray alloc]init];
    OrderDishImage=[[NSMutableArray alloc]init];
    IsGetCMSData=[[NSMutableArray alloc]init];
    TempOrderID=[[NSMutableArray alloc]init];
    IsEditOrder=[[NSString alloc]init];
    isSpecialReq=[[NSString alloc]init];
    
    OrderSpecialRequest=[[NSMutableArray alloc]init];
    [IsGetCMSData addObject:@"0"];
    ViewMode=2;  
    isConfermOrder=FALSE;
    SubCategoryList=[[NSMutableArray alloc]init];
    AllItemData=[[NSMutableArray alloc]init];
    HomeCatId=[[NSMutableArray alloc]init];
    HomeSubCatId=[[NSMutableArray alloc]init];
    tableData=[[NSMutableArray alloc]init];
    tableStatus=[[NSMutableArray alloc]init];
    SearchAllItemData=[[NSMutableArray alloc]init];
    OrderId=[[NSString alloc]init];
    TaskType=@"1";
    isLogin=[[NSString alloc]init];
    isQuickOrder = [[NSString alloc]init];
    isFBLogin=[[NSString alloc]init];
    IsDBUpdated=[[NSMutableArray alloc]init];
    DishName=[[NSMutableArray alloc]init];
    DishId=[[NSMutableArray alloc]init];
    
    TDishName=[[NSMutableArray alloc]init];
    
    feedDishName=[[NSString alloc]init];
    feedDishRating=[[NSString alloc]init];
    feedDishImage=[[NSString alloc]init];
    DishQuantity=[[NSMutableArray alloc]init];
    TDishQuantity=[[NSMutableArray alloc]init];

    DishRate=[[NSMutableArray alloc]init];
    TDishRate=[[NSMutableArray alloc]init];
    
    TaxList=[[NSMutableArray alloc]init];;
    TaxNameValue=[[NSMutableArray alloc]init];;
    TaxID=[[NSMutableArray alloc]init];
    isDeduction=[[NSMutableArray alloc]init];
    inFormat=[[NSMutableArray alloc]init];
    tableNumber=[[NSString alloc]init];
    salesNo=[[NSString alloc]init];
    splitNo=[[NSString alloc]init];
    bevCat=[[NSString alloc]init];
    
    Discount=@"0";
    
    OrderId=@"-1";
    
    isLogin=@"0";
    isFBLogin=@"0";
    isTwitterLogin=@"0";
    IsEditOrder=@"0";
    assignedTable1=@"-1";
    assignedTable2=@"-1";
    assignedTable3=@"-1";
    assignedTable4=@"-1";
    performUpdateCheck=@"0";
    isQuickOrder=@"0";
    rootLoaded=@"0";
    
    isConfromHomePage=@"0";
    isSpecialReq=@"0";
    
    isTakeaway=@"0";
    AddItemFromTakeaway=@"0";
    Customer=@"";
    isFeedbackDone=@"0";
    categoryID=@"1";
    bevCat=@"-1";
    
}


+(NSString *)serverURL
{
    NSString *url_string = [[NSUserDefaults standardUserDefaults] valueForKey:SERVER_URL];
    
    if([url_string length] == 0) {
        url_string = [NSString stringWithFormat:@"%@", DEFAULT_URL];
    }
    
    return url_string;
}

+(NSString *)appKey
{
    NSString *url_string = [[NSUserDefaults standardUserDefaults] valueForKey:APP_KEY];
    
    if([url_string length] == 0) {
        url_string = [NSString stringWithFormat:@"%@", DEFAULT_KEY];
    }
    
    return url_string;
}


+(BOOL)dishTagStatus
{
    BOOL value = TRUE;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:DISH_TAG] != nil) {
        
        value = [[NSUserDefaults standardUserDefaults] boolForKey:DISH_TAG];
    }
    else {
        value = TRUE;
    }
    
    
    return value;
}


+(BOOL)hasAccess:(NSString *)password level:(NSString *)access
{
    BOOL status = TRUE;//FALSE;
    
    NSMutableDictionary *access_dict = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_DICTIONARY];
    
    if(access_dict == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Error in performing operation." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        return FALSE;
    }
    
    BOOL contains_password = [[access_dict allKeys] containsObject:password];
    
    if(contains_password) {
        
        NSMutableDictionary *user_access_dict = [access_dict objectForKey:password];
        NSString *value = [NSString stringWithFormat:@"%@", user_access_dict[access]];
        
        if([value intValue] == 1)
            status = TRUE;
    }
    else {
        status = FALSE;
    }
    
    
    if(!status) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Sorry, you are not an authorized user." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    return status;
}


@end