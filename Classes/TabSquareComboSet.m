
#import "TabSquareComboSet.h"
#import <QuartzCore/QuartzCore.h>
#import "TabSquareCommonClass.h"
#import "ComboSetDishIcon.h"
#import "TabSquareCommonClass.h"
#import "TabSquareDBFile.h"
#import "ShareableData.h"
#import "TabMainCourseMenuListViewController.h"
#import "TabMainDetailView.h"

#define NAME_TAG        550
#define DESCRIPTION_TAG 560

#define PRE_X   384
#define PRE_Y   161

@interface TabSquareComboSet ()

@end

@implementation TabSquareComboSet


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:227.0/255.0 green:222.0/255.0 blue:172.0/255.0 alpha:1.0]];
    
    opened  = FALSE;
    touched = FALSE;
    group_data_array = [[NSMutableArray alloc] init];
    
    [self addObjects];
    [self loadComboData];
}

-(void)setComboId:(int)_id categoryId:(int)_category_id
{
    combo_id = _id;
    category_id = _category_id;
    
    ////NSLOG(@"combo_id = %d, category_id=%d", _id, _category_id);
}

-(void)setRootController:(TabMainCourseMenuListViewController *)_root
{
    root = _root;
    
}

-(void)setDetailRootController:(TabMainDetailView *)_detailRoot
{
    detailRoot = _detailRoot;
    root = nil;
    
}

-(void)loadComboData
{
    NSMutableDictionary *dic = [[TabSquareDBFile sharedDatabase] getComboDataById:combo_id];
    [combo_title setText:dic[@"name"]];
    price    = [dic[@"price"] floatValue];
    
    NSString *groups = dic[@"group"];
    NSArray *group_ids = [groups componentsSeparatedByString:@","];
    ////NSLOG(@"group_ids = %@", group_ids);
    group_dish = [[NSMutableArray alloc] init];
    for(NSString *grp in group_ids) {
        NSMutableArray *arr = [[TabSquareDBFile sharedDatabase] getGroupDishDataById:[grp intValue] preSelected:TRUE];
        
        if(arr != nil) {
            for(int i = 0; i < [arr count]; i++) {
                [group_dish addObject:[arr objectAtIndex:i]];
            }
        }
    }
    
    ////NSLOG(@"groupdishes = %@", group_dish);
    [self addDishButtons:group_ids];
    
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)addObjects
{
    
    UIImageView *img_view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_image.png"]];
    [img_view setFrame:CGRectMake(0, 0, img_view.frame.size.width/2, img_view.frame.size.height/2)];
    [self.view addSubview:img_view];
    
    combo_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 18.0, self.view.frame.size.width, 42.0)];
    [combo_title setBackgroundColor:[UIColor clearColor]];
    [combo_title setTextAlignment:NSTextAlignmentCenter];
    [combo_title setText:@"Combo Set A"];
    [combo_title setFont:[UIFont fontWithName:@"Copperplate" size:29.0]];
    [self.view addSubview:combo_title];
    
    
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(45, 120, 701, 793)];
    //[scroller setBackgroundColor:[UIColor redColor]];
    [scroller setShowsVerticalScrollIndicator:TRUE];
    [self.view addSubview:scroller];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setFrame:CGRectMake(134, 942, 202, 40)];
    [cancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancel setBackgroundImage:[UIImage imageNamed:@"plane_btn.png"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
    [done setFrame:CGRectMake(425, 942, 202, 40)];
    [done setTitle:@"DONE" forState:UIControlStateNormal];
    [done setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [done setBackgroundImage:[UIImage imageNamed:@"plane_btn.png"] forState:UIControlStateNormal];
    [done addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancel];
    [self.view addSubview:done];
    
}


-(void)cancelAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

/*Cpmpleted the order selection*/
-(void)doneAction
{
    NSString *orderData = @"";
    BOOL selection_status = TRUE;
    
    /*Collecting all dish objects here*/
    NSArray *subViews = scroller.subviews;
    for(int i = 0; i < [subViews count]; i++)
    {
        UIView *sub_view = [subViews objectAtIndex:i];
        if([sub_view isMemberOfClass:[ComboSetDishIcon class]])
        {
            ComboSetDishIcon *icon = (ComboSetDishIcon *)sub_view;
            
            if([icon.preSelected intValue] != 1 && [icon.dishType intValue] != 1) {
                selection_status = FALSE;
                break;
            }
            
            if([icon.preSelected isEqualToString:@"1"] || [icon.dishType isEqualToString:@"1"])
            {
                NSString *separator = (i == [subViews count]-1) ? @"": @"^" ;
                NSString *str = [NSString stringWithFormat:@"%@%@", icon.dishTitle, separator];
                orderData = [NSString stringWithFormat:@"%@%@", orderData, str];
                
                
            }
            
        }
    }
    
    if(!selection_status) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select one item from each group." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    [self addItem:orderData];
    ////NSLOG(@"order data = %@", orderData);
    [self dismissViewControllerAnimated:NO completion:^{
        
        if(root == nil) {
            [detailRoot orderAddAnimation];
        }
        else {
            [root orderAddAnimation];
        }
    }];
}

-(void)addItem: (NSString*) data
{
    [[ShareableData sharedInstance].OrderItemID addObject:[ NSString stringWithFormat:@"%d",combo_id ] ];
    DLog([ NSString stringWithFormat:@"%d",combo_id ]);
    [[ShareableData sharedInstance].OrderItemName addObject:[ NSString stringWithFormat:@"^%@",combo_title.text ]];
    DLog(combo_title.text);
    [[ShareableData sharedInstance].OrderItemRate addObject:[ NSString stringWithFormat:@"%.02f",price ]];
    DLog([ NSString stringWithFormat:@"%f",price ]);
    [[ShareableData sharedInstance].OrderCatId addObject:[ NSString stringWithFormat:@"%d",category_id ]];
    DLog([ NSString stringWithFormat:@"%d",category_id ]);
    [[ShareableData sharedInstance].IsOrderCustomization addObject:@"0"];
    [[ShareableData sharedInstance].OrderCustomizationDetail addObject:@"0"];
    [[ShareableData sharedInstance].OrderSpecialRequest addObject:data];
    [[ShareableData sharedInstance].OrderItemQuantity addObject:@"1"];
    [[ShareableData sharedInstance].confirmOrder addObject:@"0"];
    // [menuview badgeRefresh];
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
    
    /*  TabSquareFlurryTracking *flurry = [TabSquareFlurryTracking flurryTracking];
     NSMutableArray *orders = [ShareableData sharedInstance].OrderItemName;
     NSString *item_name = [orders objectAtIndex:[orders count]-1];
     [flurry trackItem:item_name eventName:DISH_PURCHASE_EVENT category:[TabSquareCommonClass getValueInUserDefault:@"current_menu"]];*/
    
}

-(void)addDishButtons:(NSArray *)dishButtons
{
    //int count         = [dishButtons count] + [group_dish count];
    int count           = [group_dish count];
    int icon_per_row    = 3;
    int h_gap           = 37;
    int v_gap           = 34;
    
    int total_rows      = count/icon_per_row;
    int last_icons      = count%icon_per_row;
    
    if(last_icons > 0)
        total_rows++;
    
    CGSize icon_size = CGSizeMake(201.0, 165.0);
    float last_y = 0;
    
    for(int i = 0; i < total_rows; i++)
    {
        int icons_in_row = 3;
        
        /* Checking if row has all three icons or not */
        if((i+1 == total_rows) && last_icons > 0)
            icons_in_row = last_icons;
        
        for(int j = 0; j < icons_in_row; j++)
        {
            float x = (j * icon_size.width) + (j * h_gap);
            float y = (i * icon_size.height) + (i * v_gap);
            last_y  = y;
            
            ComboSetDishIcon *dish_icon = [[ComboSetDishIcon alloc] initWithFrame:CGRectMake(x, y, icon_size.width , icon_size.height)];
            
            int group_index = (i*icon_per_row)+j;
            NSMutableDictionary *dict = nil;
            
            {
                dict = [group_dish objectAtIndex:group_index];
                NSMutableArray *all_dishes = nil;
                
                NSString *pre_sel = dict[@"pre_select_option"];
                
                /* Forced item */
                BOOL forced_item = FALSE;
                if([pre_sel intValue] > 0)
                {
                    forced_item = TRUE;
                    all_dishes = [[TabSquareDBFile sharedDatabase] getGroupDishes:[pre_sel intValue]];
                }
                else
                {
                    all_dishes = [[TabSquareDBFile sharedDatabase] getGroupDishes:[dict[@"id"] intValue]];
                    
                    if([all_dishes count] == 1)
                        forced_item = TRUE;
                }
                
                
                if(forced_item) {
                    NSMutableDictionary *local_dict = (NSMutableDictionary *)all_dishes[0];
                    UIImage *img = [[TabSquareDBFile sharedDatabase] getImage:local_dict[@"image"]];
                    if(img == nil)
                        img = [UIImage imageNamed:@"dummy.png"];
                    
                    [dish_icon setDishImage:img];
                    
                    [dish_icon setDishType:@"1"];
                    [dish_icon setPreSelected:@"1"];
                    [dish_icon setDishTitle:[dict[@"name"] uppercaseString]];
                    [dish_icon setDishID:local_dict[@"id"]];
                    
                    
                }
                else {
                    [dish_icon setDishImage:[UIImage imageNamed:@"plane_dish_btn.png"]];
                    [dish_icon setDishType:@"0"];
                    [dish_icon setPreSelected:@"0"];
                    [dish_icon setDishTitle:[self getTitle:dict[@"name"]]];
                    [dish_icon setDishID:dict[@"id"]];
                }
                
                [dish_icon setTag:[dict[@"id"] intValue]];
                [dish_icon setDishHeader:[dict[@"name"] uppercaseString]];
                
            }
            
            
            
            [dish_icon addTarget:self action:@selector(dishIconPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [dish_icon.layer setShadowOffset:CGSizeMake(4.0, 2.5)];
            [dish_icon.layer setShadowOpacity:1.0];
            
            
            [dish_icon customizeIcon];
            
            [scroller addSubview:dish_icon];
        }
    }
    
    [scroller setContentSize:CGSizeMake(scroller.contentSize.width, last_y+icon_size.height)];
}


-(void)dishIconPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btn setUserInteractionEnabled:FALSE];
    
    /*
     ComboSetDishIcon *icon = (ComboSetDishIcon *)btn;
     if([icon.preSelected isEqualToString:@"1"])
     return;
     */
    
    if(opened) {
        [scroller addSubview:selected_btn];
        [selected_btn setFrame:old_frame];
        [self closeAnimation];
        return;
    }
    
    selected_btn  = btn;
    old_frame     = btn.frame;
    selected_tag  = [btn tag];
    
    
    /*============== Updation in Logic =============*/
    
    folder_arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 61, 52)];
    [folder_arrow setImage:[UIImage imageNamed:@"folder_arrow.png"]];
    
    CGPoint btn_point = btn.frame.origin;
    CGPoint pnt = [self.view convertPoint:btn_point fromView:scroller];
    CGPoint tmp_pnt = CGPointMake(pnt.x, pnt.y);
    pnt = CGPointMake(pnt.x, pnt.y+btn.frame.size.height+folder_arrow.frame.size.height);
    
    [folder_arrow setFrame:CGRectMake(pnt.x+(btn.frame.size.width/2 - (folder_arrow.frame.size.width/2)), pnt.y - folder_arrow.frame.size.height+1, folder_arrow.frame.size.width, folder_arrow.frame.size.height)];
    
    UIImage *screen_image = [TabSquareCommonClass imageFromView:self.view];
    
    UIImageView *main_img_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_image.size.width, screen_image.size.height)];
    [main_img_view setImage:screen_image];
    
    UIView *dummy = [[UIView alloc] initWithFrame:main_img_view.bounds];
    [dummy setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    [main_img_view addSubview:dummy];
    
    screen_image = [TabSquareCommonClass imageFromView:main_img_view];
    //dfdfd
    firstImage  = [self crop:screen_image area:CGRectMake(0, 0, screen_image.size.width, pnt.y-17)];
    secondImage = [self crop:screen_image area:CGRectMake(0, pnt.y+1, screen_image.size.width, screen_image.size.height - pnt.y)];
    
    /*==================*/
    // middle.frame = CGRectMake(0, 286, self.view.frame.size.width, 525.0);
    middle = [[UIView alloc] initWithFrame:CGRectMake(0, 286, self.view.frame.size.width, 525.0)];
    [middle setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *xx = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sliderbg.png"]];
    [xx setFrame:CGRectMake(0, 0, middle.frame.size.width, 507)];
    [middle addSubview:xx];
    [middle sendSubviewToBack:xx];
    
    [self.view addSubview:middle];
    //[self addMiddleView];
    [self performSelectorInBackground:@selector(addMiddleView) withObject:nil];
    /*==================*/
    
    first_section = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    UIImageView *i1 = [[UIImageView alloc] initWithFrame:first_section.bounds];
    [i1 setImage:firstImage];
    [first_section addSubview:i1];
    [self.view addSubview:first_section];
    [first_section addSubview:folder_arrow];
    [folder_arrow setAlpha:0.0];
    
    [first_section addSubview:btn];
    [btn setFrame:CGRectMake(tmp_pnt.x, tmp_pnt.y, btn.frame.size.width, btn.frame.size.height)];
    
    second_section = [[UIControl alloc] initWithFrame:CGRectMake(0, firstImage.size.height, secondImage.size.width, secondImage.size.height)];
    UIImageView *i2 = [[UIImageView alloc] initWithFrame:second_section.bounds];
    [i2 setImage:secondImage];
    [second_section addSubview:i2];
    [self.view addSubview:second_section];
    
    /*=================*/
    //[first_section.layer setShadowOpacity:0.5];
    //[first_section.layer setShadowOffset:CGSizeMake(0.0, 3.0)];
    
    //[second_section.layer setShadowOpacity:0.5];
    //[second_section.layer setShadowOffset:CGSizeMake(0.0, -3.0)];
    
    /*=================*/
    
    
    [first_section addTarget:self action:@selector(didTapAnywhere) forControlEvents:UIControlEventTouchUpInside];
    
    [second_section addTarget:self action:@selector(didTapAnywhere) forControlEvents:UIControlEventTouchUpInside];
    
    opened = TRUE;
    
    /*=========================================*/
    
    
    //[self shiftAnimation];
    [self performSelector:@selector(shiftAnimation)];
    
    [btn setUserInteractionEnabled:TRUE];
    
}

-(void)didTapAnywhere
{
    [selected_btn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)afterDatafetched
{
    ComboSetDishIcon *icon = (ComboSetDishIcon *)selected_btn;
    NSString *header = icon.dishHeader;
    
    UILabel *header_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 16.0, middle.frame.size.width, 26.0)];
    [header_lbl setBackgroundColor:[UIColor clearColor]];
    [header_lbl setTextAlignment:NSTextAlignmentCenter];
    [header_lbl setText:header];
    [header_lbl setFont:[UIFont fontWithName:@"Copperplate" size:23.0]];
    [middle addSubview:header_lbl];
    
    UILabel *help_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 40.0, middle.frame.size.width, 26.0)];
    [help_lbl setBackgroundColor:[UIColor clearColor]];
    [help_lbl setTextAlignment:NSTextAlignmentCenter];
    [help_lbl setText:@"TAP THE IMAGE TO SELECT"];
    [help_lbl setFont:[UIFont fontWithName:@"Copperplate-Light" size:14.0]];
    [middle addSubview:help_lbl];
    
    
    BOOL button_status = TRUE;
    
    if([group_data_array count] == 1 || [icon.preSelected isEqualToString:@"1"])
        button_status = FALSE;
    
    CGRect _frame = CGRectMake(0, 66.0, middle.frame.size.width, 345.0);
    
    /*===========================*/
    TabSquareComboScroller *image_scroller = [[TabSquareComboScroller alloc] initWithFrame:_frame];
    image_scroller.type = iCarouselTypeCoverFlow;
    [image_scroller setDelegate:self];
    [image_scroller setDataSource:self];
    [image_scroller setExclusiveTouch:TRUE];
    
    [middle addSubview:image_scroller];
    /*===========================*/
    
    
    /*=====Bottom Tow Lables======*/
    
    UILabel *name_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 430.0, middle.frame.size.width, 28.0)];
    [name_lbl setBackgroundColor:[UIColor clearColor]];
    [name_lbl setTextAlignment:NSTextAlignmentCenter];
    //[name_lbl setText:header];
    [name_lbl setTag:NAME_TAG];
    [name_lbl setFont:[UIFont fontWithName:@"Copperplate" size:24.0]];
    [middle addSubview:name_lbl];
    
    UILabel *descritpion_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 461.0, middle.frame.size.width, 26.0)];
    [descritpion_lbl setBackgroundColor:[UIColor clearColor]];
    [descritpion_lbl setTextAlignment:NSTextAlignmentCenter];
    //[descritpion_lbl setText:@"TAP THE IMAGE TO SELECT"];
    [descritpion_lbl setTag:DESCRIPTION_TAG];
    [descritpion_lbl setFont:[UIFont fontWithName:@"Copperplate-Light" size:14.0]];
    [middle addSubview:descritpion_lbl];
    
}


/*====================================================*/

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(TabSquareComboScroller *)carousel
{
    return [group_data_array count];
}

- (UIView *)carousel:(TabSquareComboScroller *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create a numbered view
    //view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 595.0f, 342.0f)];
    
    UIButton *img_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [img_btn setFrame:CGRectMake(0, 0, 595.0f, 342.0f)];
    NSMutableDictionary *dict = [group_data_array objectAtIndex:index];
    NSString *image_name = dict[@"image"];
    UIImage *img = [[TabSquareDBFile sharedDatabase] getImage:image_name];
    
    if([image_name length] == 0 || img == nil)
        img = [UIImage imageNamed:@"dummy.png"];

    [img_btn setBackgroundImage:img forState:UIControlStateNormal];
    
    [img_btn setTag:[dict[@"id"] intValue]];
    [img_btn setTitle:dict[@"name"] forState:UIControlStateDisabled];
    [img_btn addTarget:self action:@selector(dishClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //[view addSubview:img_btn];
    
    return img_btn;
}

-(void)updateLabels:(NSMutableDictionary *)dict
{
    
    UILabel *name = (UILabel *)[middle viewWithTag:NAME_TAG];
    [name setText:dict[@"name"]];
    
    UILabel *desc = (UILabel *)[middle viewWithTag:DESCRIPTION_TAG];
    [desc setText:dict[@"description"]];
    
    
}

- (CGFloat)carousel:(TabSquareComboScroller *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return YES;
        }
        default:
        {
            return value;
        }
    }
}



- (void)carouselDidEndScrollingAnimation:(TabSquareComboScroller *)carousel
{
    NSMutableDictionary *dict = [group_data_array objectAtIndex:carousel.currentItemIndex];
    [self performSelector:@selector(updateLabels:) withObject:dict];
}

/*====================================================*/


-(void)addMiddleView
{
    
    @autoreleasepool {
        
        /*====Fetching Dish Data======*/
        int group_id = [selected_btn tag];
        [group_data_array removeAllObjects];
        group_data_array = [[TabSquareDBFile sharedDatabase] getGroupDishes:group_id];
        /*============================*/
        [self performSelectorOnMainThread:@selector(afterDatafetched) withObject:nil waitUntilDone:NO];
    }
    
}


#pragma mark
#pragma mark scroller and paging delegates



-(void)dishClicked:(UIButton *)btn
{
    UIImage *img = [btn backgroundImageForState:UIControlStateNormal];
    
    //UIImage *img_new = [UIImage imageWithData:img_data];
    //img_new = [TabSquareCommonClass resizeImage:img_new scaledToSize:CGSizeMake(selected_btn.frame.size.width*2, selected_btn.frame.size.height*2)];
    
    ComboSetDishIcon *icon = (ComboSetDishIcon *)selected_btn;
    
    [icon setDishID:[NSString stringWithFormat:@"%d", [btn tag]]];
    [icon setDishType:@"1"];
    [icon setDishImage:img];
    [icon setDishTitle:[btn titleForState:UIControlStateDisabled]];
    [icon customizeIcon];
}



/*=======================================================*/


-(NSString *)getTitle:(NSString *)string
{
    if(string == NULL || [string length] == 0)
        string = @"XXX";
    
    string = [string uppercaseString];
    NSString *prefix = @"SELECT ";
    char c1 = [string characterAtIndex:0];
    NSString *vowels = @"AEIOU";
    NSString *suffix = @"A ";
    
    for(int i = 0; i < [vowels length]; i++) {
        NSString *str = [NSString stringWithFormat:@"%c", [vowels characterAtIndex:i]];
        if([str isEqualToString:[NSString stringWithFormat:@"%c", c1]]) {
            suffix = @"AN ";
            break;
        }
    }
    
    NSString *title = [NSString stringWithFormat:@"%@%@%@", prefix, suffix, string];
    
    return title;
}

-(UIImage *)crop:(UIImage *)img area:(CGRect)rect
{
    
    if (img.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * img.scale,
                          rect.origin.y * img.scale,
                          rect.size.width * img.scale,
                          rect.size.height * img.scale);
    }
    
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:img.scale orientation:img.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}



-(void)moveLayer:(CALayer*)layer to:(CGPoint)point
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 1.4;
    animation.fromValue = [layer valueForKey:@"position"];
    animation.toValue = [NSValue valueWithCGPoint:point];
    layer.position = point;
    
    [layer addAnimation:animation forKey:@"position"];
}

-(void)shiftAnimation
{
    float y1 = first_section.frame.size.height - 287;
    float y2 = 793;
    [folder_arrow setAlpha:1.0];
    
    CGRect f1 = first_section.frame;
    CGRect f2 = second_section.frame;
    
    /*
     [self moveLayer:first_section.layer to:CGPointMake(384, 161)];
     
     [UIView beginAnimations:@"" context:NULL];
     [UIView setAnimationDuration:0.7];
     
     [folder_arrow setAlpha:1.0];
     [first_section setFrame:CGRectMake(f1.origin.x, -y1, f1.size.width, f1.size.height)];
     [second_section setFrame:CGRectMake(f2.origin.x, y2, f2.size.width, f2.size.height)];
     [UIView commitAnimations];
     */
    
    CGPoint lp1 = first_section.layer.position;
    ////NSLOG(@"layer 1 = %@", NSStringFromCGPoint(first_section.layer.position));
    first_pnt = CGPointMake(lp1.x, lp1.y);
    CGPoint p1 =CGPointMake(lp1.x + f1.origin.x, -y1+lp1.y);
    
    //p1 = [first_section.layer convertPoint:p1 toLayer:self.view.layer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 0.30;
    animation.fromValue = [first_section.layer valueForKey:@"position"];
    animation.toValue = [NSValue valueWithCGPoint:p1];
    first_section.layer.position = p1;
    
    [first_section.layer addAnimation:animation forKey:@"position"];
    
    
    CGPoint lp2 = second_section.layer.position;
    second_pnt = CGPointMake(lp2.x, lp2.y);
    CGPoint p2 =CGPointMake(lp2.x + f2.origin.x, y2+(lp2.y - first_section.frame.size.height));
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position"];
    animation1.duration = 0.30;
    animation1.fromValue = [second_section.layer valueForKey:@"position"];
    animation1.toValue = [NSValue valueWithCGPoint:p2];
    second_section.layer.position = p2;
    
    [second_section.layer addAnimation:animation1 forKey:@"position"];
    
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration = 0.38;
    fadeInAnimation.autoreverses = NO;
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
    [folder_arrow.layer addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    
}

-(void)closeAnimation
{
    float time = 0.2;
    
    [CATransaction begin];
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration = time;
    fadeInAnimation.autoreverses = NO;
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:0.0];
    [folder_arrow.layer addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position"];
    animation1.duration = time;
    animation1.fromValue = [first_section.layer valueForKey:@"position"];
    animation1.toValue = [NSValue valueWithCGPoint:first_pnt];
    first_section.layer.position = first_pnt;
    [first_section.layer addAnimation:animation1 forKey:@"position"];
    
    
    [CATransaction setCompletionBlock:^{
        //[self addShineEffect];
        [selected_btn setUserInteractionEnabled:TRUE];
        firstImage = nil;
        firstImage = nil;
        [middle removeFromSuperview];
        [first_section removeFromSuperview];
        [second_section removeFromSuperview];
        
        selected_btn = nil;
        opened = FALSE;
    }];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = time;
    animation.fromValue = [second_section.layer valueForKey:@"position"];
    animation.toValue = [NSValue valueWithCGPoint:second_pnt];
    second_section.layer.position = second_pnt;
    [second_section.layer addAnimation:animation forKey:@"position"];
    
    [CATransaction commit];
    /*====================*/
    return;
    
    /*
     [UIView animateWithDuration:time
     delay:0.0
     options: UIViewAnimationCurveEaseInOut
     animations:^{
     CGRect f1 = first_section.frame;
     CGRect f2 = second_section.frame;
     
     [first_section setFrame:CGRectMake(f1.origin.x, 0, f1.size.width, f1.size.height)];
     [second_section setFrame:CGRectMake(f2.origin.x, f1.size.height, f2.size.width, f2.size.height)];
     
     [folder_arrow setAlpha:0.0];
     
     }
     completion:^(BOOL finished){
     if(finished) {
     //[self addShineEffect];
     [selected_btn setUserInteractionEnabled:TRUE];
     firstImage = nil;
     firstImage = nil;
     [middle removeFromSuperview];
     [first_section removeFromSuperview];
     [second_section removeFromSuperview];
     
     selected_btn = nil;
     opened = FALSE;
     }
     }];
     */
    
}

-(void)addShineEffect
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, first_section.frame.size.height-3, self.view.frame.size.width, 6.0)];
    [lbl setBackgroundColor:[UIColor colorWithRed:227.0/255.0 green:222.0/255.0 blue:172.0/255.0 alpha:1.0]];
    
    UIColor *color = [UIColor colorWithRed:227.0/255.0 green:222.0/255.0 blue:172.0/255.0 alpha:1.0];
    lbl.layer.shadowColor = [color CGColor];
    lbl.layer.shadowRadius = 6.0f;
    lbl.layer.shadowOpacity = .9;
    lbl.layer.shadowOffset = CGSizeZero;
    lbl.layer.masksToBounds = NO;
    
    [lbl setAlpha:0.0];
    [self.view addSubview:lbl];
    
    [UIView animateWithDuration:0.7
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         [lbl setAlpha:0.65];
                     }
                     completion:^(BOOL finished){
                         if(finished) {
                             [lbl removeFromSuperview];
                         }
                     }];
    
}




@end




