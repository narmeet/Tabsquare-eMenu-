
#import "TabSquareRemoteActivation.h"
#import "ShareableData.h"
//#import "TabSquareUserAccess.h"
#import "TabSquareDBFile.h"
#import "SBJSON.h"
#import <QuartzCore/QuartzCore.h>

#define VIEW_MODE   1
#define EDIT_MODE   2

#define OPENED      @"H"
#define AVAILABLE   @"A"

@implementation TabSquareRemoteActivation


static TabSquareRemoteActivation *_activation = nil;

/*=============Singletone Class ==============*/
+(TabSquareRemoteActivation *)remoteActivation
{
	if (_activation == nil) {
        _activation = [[TabSquareRemoteActivation alloc] init];

    }
    return _activation;
}

-(void)setPopupSuperView:(UIView *)_view
{
    popupSuperView = _view;
}


-(void)setEditModeData
{
    /*========================Setting Logs Data=======================*/
    /*
    TabSquareUserAccess *user_access = [TabSquareUserAccess userAccess];
    [user_access setTableNo:[NSString stringWithFormat:@"%@", [ShareableData sharedInstance].currentTable]];
    [user_access setAction:[NSString stringWithFormat:@"%@", LOG_REASSIGN_IPAD]];
    [user_access sendLogsToServer];
    */
    /*=================================================================*/
    
    
    [self getTableDetails:[ShareableData sharedInstance].currentTable];
    
    
}


/*========Modifying the original array only when anything is changed else not=========*/
-(void)filterArray:(NSMutableArray *)original withDuplicate:(NSMutableArray *)duplicate
{
    NSLock *obj_lock = [[NSLock alloc] init];
    [obj_lock lock];
    
    if(![original isEqualToArray:duplicate]) {
        original = duplicate;
    }

    [obj_lock unlock];
}



-(void)getTableDetails:(NSString*)SearchTableNumber
{
    [self getBillNumber:SearchTableNumber];
    
    [ShareableData sharedInstance].assignedTable1=SearchTableNumber;
        
    /*========================================*/
    NSMutableArray *DishId_local = [NSMutableArray new];
    NSMutableArray *DishName_local = [NSMutableArray new];
    NSMutableArray *DishQuantity_local = [NSMutableArray new];
    NSMutableArray *DishRate_local = [NSMutableArray new];
    NSMutableArray *TempOrderID_local = [NSMutableArray new];
    NSMutableArray *TDishName_local = [NSMutableArray new];
    NSMutableArray *TDishQuantity_local = [NSMutableArray new];
    NSMutableArray *TDishRate_local = [NSMutableArray new];
    NSMutableArray *OrderItemID_local = [NSMutableArray new];
    NSMutableArray *OrderItemName_local = [NSMutableArray new];
    NSMutableArray *OrderItemQuantity_local = [NSMutableArray new];
    NSMutableArray *OrderItemRate_local = [NSMutableArray new];
    NSMutableArray *OrderSpecialRequest_local = [NSMutableArray new];
    NSMutableArray *OrderCatId_local = [NSMutableArray new];
    //NSMutableArray *OrderBeverageContainerId_local = [NSMutableArray new];
    NSMutableArray *OrderCustomizationDetail_local = [NSMutableArray new];
    NSMutableArray *confirmOrder_local = [NSMutableArray new];
    NSMutableArray *IsOrderCustomization_local = [NSMutableArray new];
    /*========================================*/
    
    
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
    
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableArray *resultFromPost = [parser objectWithString:data error:nil];
    
    
    for(int i=0;i<[resultFromPost count];i++)
    {
        NSMutableDictionary *dataitem=resultFromPost[i];
        
        [DishId_local addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_id"]]];
        [DishName_local addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_name"]]];
        [DishQuantity_local addObject:[NSString stringWithFormat:@"%@",dataitem[@"quantity"]]];
        [TempOrderID_local addObject:[NSString stringWithFormat:@"%@",dataitem[@"id"]]];
        [DishRate_local addObject:dataitem[@"price"]];
        
        [OrderItemID_local addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_id"]]];
        [OrderItemName_local addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_name"]]];
        [OrderItemQuantity_local addObject:[NSString stringWithFormat:@"%@",dataitem[@"quantity"]]];
        [OrderItemRate_local addObject:[NSString stringWithFormat:@"%.2f",[dataitem[@"price"] floatValue]*[dataitem[@"quantity"] floatValue]]];
        
        [confirmOrder_local addObject:[NSString stringWithFormat:@"%@",dataitem[@"1"]]];
        
        
        NSArray* customString = [[NSString stringWithFormat:@"%@",dataitem[@"customisations"]] componentsSeparatedByString:@"^"];
        
        [IsOrderCustomization_local addObject:[NSString stringWithFormat:@"%@",dataitem[@"is_order_customisation"]]];
        
        NSString *trimmedString = [[NSString stringWithFormat:@"%@",dataitem[@"order_cat_id"]] stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [OrderCatId_local addObject:trimmedString];
        [OrderSpecialRequest_local addObject:[NSString stringWithFormat:@"%@",dataitem[@"order_special_request"]]];
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
            [OrderCustomizationDetail_local addObject:customizationDetail];
        }
        else
        {
            [OrderCustomizationDetail_local addObject:[NSString stringWithFormat:@"%@",dataitem[@"order_customisation_detail"]]];
        }
        
        [TDishName_local addObject:[NSString stringWithFormat:@"%@",dataitem[@"dish_name"]]];
        [TDishQuantity_local addObject:[NSString stringWithFormat:@"%@",dataitem[@"quantity"]]];
        [TDishRate_local addObject:[NSString stringWithFormat:@"%@",dataitem[@"price"]]];
    }
    
    
    
    /*========================================*/
    [self filterArray:[ShareableData sharedInstance].DishId withDuplicate:DishId_local];
    [self filterArray:[ShareableData sharedInstance].DishName withDuplicate:DishName_local];
    [self filterArray:[ShareableData sharedInstance].DishQuantity withDuplicate:DishQuantity_local];
    [self filterArray:[ShareableData sharedInstance].DishRate withDuplicate:DishRate_local];
    [self filterArray:[ShareableData sharedInstance].TempOrderID withDuplicate:TempOrderID_local];
    [self filterArray:[ShareableData sharedInstance].TDishName withDuplicate:TDishName_local];
    [self filterArray:[ShareableData sharedInstance].TDishQuantity withDuplicate:TDishQuantity_local];
    [self filterArray:[ShareableData sharedInstance].TDishRate withDuplicate:TDishRate_local];
    [self filterArray:[ShareableData sharedInstance].OrderItemID withDuplicate:OrderItemID_local];
    [self filterArray:[ShareableData sharedInstance].OrderItemName withDuplicate:OrderItemName_local];
    [self filterArray:[ShareableData sharedInstance].OrderItemQuantity withDuplicate:OrderItemQuantity_local];
    [self filterArray:[ShareableData sharedInstance].OrderItemRate withDuplicate:OrderItemRate_local];
    [self filterArray:[ShareableData sharedInstance].OrderSpecialRequest withDuplicate:OrderSpecialRequest_local];
    [self filterArray:[ShareableData sharedInstance].OrderCatId withDuplicate:OrderCatId_local];
    [self filterArray:[ShareableData sharedInstance].OrderCustomizationDetail withDuplicate:OrderCustomizationDetail_local];
    [self filterArray:[ShareableData sharedInstance].confirmOrder withDuplicate:confirmOrder_local];
    [self filterArray:[ShareableData sharedInstance].IsOrderCustomization withDuplicate:IsOrderCustomization_local];
    
}


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


-(void)switchToEditMode
{
    //int mode_type = [ShareableData sharedInstance].ViewMode;

    /*
    if(mode_type == EDIT_MODE) {
        return;
    }
    */
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH
                                             , 0), ^{
        [self setEditModeData];

        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if([ShareableData sharedInstance].ViewMode != EDIT_MODE) {
                [self performSelectorOnMainThread:@selector(addInfoPopup:) withObject:@"Edit Mode Activated" waitUntilDone:NO];
            }

            [ShareableData sharedInstance].ViewMode = EDIT_MODE;
            /*===========Send switch to Edit Mode Signal To Regitered Classes=============*/
            [[NSNotificationCenter defaultCenter] postNotificationName:SWITCHED_EDIT_MODE object:self];

        });
        
    });

}


-(void)switchToViewMode
{
    int mode_type = [ShareableData sharedInstance].ViewMode;
    
    if(mode_type == VIEW_MODE) {
        return;
    }

    [self performSelectorOnMainThread:@selector(addInfoPopup:) withObject:@"View Mode Activated" waitUntilDone:NO];
    
    [ShareableData sharedInstance].ViewMode = VIEW_MODE;
    /*===========Send switch to View Mode Signal To Regitered Classes=============*/
    [[NSNotificationCenter defaultCenter] postNotificationName:SWITCHED_VIEW_MODE object:self];

}


-(void)tablesUpdated
{
    NSString *current_table = [NSString stringWithFormat:@"%@", [ShareableData sharedInstance].currentTable];
    if([current_table isEqualToString:DEFAULT_TABLE])
        return;
    
    NSMutableArray *free_tables = [ShareableData sharedInstance].totalFreeTables;
    
    BOOL assigned = TRUE;
    
    for(int i = 0; i < [free_tables count]; i++) {
        NSMutableDictionary *dict = (NSMutableDictionary *)free_tables[i];
        
        if([dict[@"TBLNo"] isEqualToString:[ShareableData sharedInstance].currentTable] && [dict[@"TBLStatus"] isEqualToString:AVAILABLE]) {
            assigned = FALSE;
            break;
        }
    }

    
    if(!assigned) {
        [self switchToViewMode];
    }
    else {
        [self switchToEditMode];

    }
    
}


-(void)registerRemoteNotification:(id)obj
{
    /*============Registering to receive Table Status Update signal==============*/
    [[NSNotificationCenter defaultCenter]
     addObserver:obj
     selector:@selector(viewModeActivated:)
     name:SWITCHED_VIEW_MODE
     object:nil];
    
    /*============Registering to receive Table Status Update signal==============*/
    [[NSNotificationCenter defaultCenter]
     addObserver:obj
     selector:@selector(editModeActivated:)
     name:SWITCHED_EDIT_MODE
     object:nil];

}


-(void)setMainMenuButton:(UIButton *)btn
{
    menuButton = btn;
}

-(void)addInfoPopup:(NSString *)text
{
    [menuButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320.0, 56.0)];
    [status setFont:[UIFont boldSystemFontOfSize:25.0]];
    [status setText:text];
    [status setBackgroundColor:[UIColor colorWithRed:5.0/255.0 green:5.0/255.0 blue:5.0/255.0 alpha:0.7]];
    [status.layer setBorderWidth:1.8];
    [status.layer setBorderColor:[UIColor blackColor].CGColor];
    [status.layer setCornerRadius:8.0];
    [status setTextAlignment:NSTextAlignmentCenter];
    [status setTextColor:[UIColor whiteColor]];
    [status setCenter:[popupSuperView center]];
    [popupSuperView addSubview:status];
    [popupSuperView bringSubviewToFront:status];
    [status setAlpha:0.7];
    
    
    [UIView transitionWithView:popupSuperView duration:0.8 options:UIViewAnimationOptionTransitionNone animations:^(void) {
        [popupSuperView setAlpha:0.7];
        [status setAlpha:1.0];
        
        
    } completion:^(BOOL finished){
        
        [UIView transitionWithView:popupSuperView duration:0.6 options:UIViewAnimationOptionTransitionNone animations:^(void) {
            [popupSuperView setAlpha:1.0];
            [status setAlpha:0.5];
            [status removeFromSuperview];
            
        } completion:^(BOOL finished){
        }];
        
        
    }];

}



@end
