

#import <Foundation/Foundation.h>

#define DISH_TAG      @"dishtagkey"
#define SERVER_URL    @"serverurlkey"
#define APP_KEY       @"appkey"
#define PRE_NAME      @"tabsquare_"

#define DEFAULT_DISCOUNT    @"10"
#define DICSOUNT            @"discount"

/*==========UI Images===========*/
#define THUMBNAIL   @"thumbnail"

#define HOME_IMAGE1                 @"front_image1"
#define HOME_IMAGE2                 @"front_image2"
#define BACKGROUND_IMAGE            @"bg"
#define LOGO_IMAGE                  @"logo"
#define MENU_BUTTON_IMAGE           @"main_menu_btn"
#define HEADER_IMAGE                @"header_bg"
#define ORDER_SUMMURY_BUTTON_IMAGE  @"order_summary_btn"
#define POPUP_IMAGE                 @"pop_up_bg"
#define CATEGORY_IMAGE              @"category_bg"
#define SUBCATEGORY_IMAGE           @"item_bg"
#define PLANOGRAM_IMAGE             @"planogram_bg"

/*==============================*/
#define FONT_DICTIONARY             @"font_dict"
/*========Access Control========*/
#define ACCESS_DICTIONARY           @"access_dict"

#define VOID_TABLE                  @"void_table"
#define VOID_ITEM                   @"void_item"
#define REDUCE_ITEMS                @"reduce_item"
#define CHECKOUT                    @"checkout"
#define PRESENT_BILL                @"present_bill"
#define EDIT_ORDER                  @"edit_order"
#define ACCESS_TABLE_NAMAGEMENT     @"access_table_management"
#define MODIFY_DISCOUNTS            @"modify_discounts"

/*==============================*/
#define SEARCH_DATA          @"search_data"
#define BEST_SELLERS         @"Bestsellers"
#define BEST_SELLER_DATA     @"best_seller"

/*==========Language Tags===========*/
#define MULTILANGUAGE   @"multilanguagekey"
#define STATIC_TEXTS    @"static_texts"

#define LANGUAGE_CHANGED    @"languagechanged"

#define ENGLISH             @"english"
#define CHINESE             @"china"
#define JAPANESE            @"japan"
#define KOREAN              @"korea"
#define INDONESIAN          @"indonesia"
#define FRENCH              @"france"

/*==================================*/

/*========Remote Activation=========*/
#define DEFAULT_TABLE       @"-1"
#define SWITCHED_VIEW_MODE  @"switched_to_view_mode"
#define SWITCHED_EDIT_MODE  @"switched_to_edit_mode"
/*==================================*/



@interface ShareableData : NSObject
{
    NSString *currentLanguage;
    NSString *currentTable;
}

@property (nonatomic,strong) NSMutableArray *OrderSpecialRequest;
@property (nonatomic,strong) NSMutableArray *OrderItemID;
@property (nonatomic,strong) NSMutableArray *OrderItemName;
@property (nonatomic,strong) NSMutableArray *OrderItemRate;
@property (nonatomic,strong) NSMutableArray *OrderItemQuantity;
@property (nonatomic,strong) NSMutableArray *OrderCatId;
@property (nonatomic,strong) NSMutableArray *OrderSubCatId;
@property (nonatomic,strong) NSMutableArray *OrderCustomizationDetail;
@property (nonatomic,strong) NSMutableArray *IsOrderCustomization;
@property (nonatomic,strong) NSMutableArray *OrderBeverageContainerId;
@property (nonatomic,strong) NSMutableArray *confirmOrder;
@property (nonatomic,strong) NSMutableArray *OrderDishImage;
@property (nonatomic,strong) NSMutableArray *IsDBUpdated;
@property (nonatomic,strong) NSMutableArray *IsViewPage;
 
@property (nonatomic,strong) NSMutableArray *tableData;
@property (nonatomic,strong) NSMutableArray *tableStatus;
@property (nonatomic,strong)UIScrollView *swipeView;
@property(nonatomic,strong)NSMutableArray *categoryList;
@property(nonatomic,strong)NSMutableArray *categoryIdList;

@property(nonatomic,strong)NSMutableArray *SubCategoryList;

@property(nonatomic,strong)NSMutableArray *AllItemData;
@property(nonatomic,strong)NSMutableArray *SearchAllItemData;

@property(nonatomic,strong)NSMutableArray *IsGetCMSData;
@property(nonatomic, assign)BOOL isConfermOrder;
@property(nonatomic, assign)NSInteger ViewMode;

@property(nonatomic,strong)NSMutableArray *HomeCatId;
@property(nonatomic,strong)NSMutableArray *HomeSubCatId;

@property(nonatomic,strong)NSString *OrderId;
@property(nonatomic,strong)NSString *TaskType;

@property(nonatomic,strong)NSMutableArray *DishId;
@property(nonatomic,strong)NSMutableArray *DishName;
@property(nonatomic,strong)NSMutableArray *DishQuantity;
@property(nonatomic,strong)NSMutableArray *DishRate;

@property(nonatomic,strong)NSMutableArray *TaxList;
@property(nonatomic,strong)NSMutableArray *TaxNameValue;
@property(nonatomic,strong)NSMutableArray *TaxID;
@property(nonatomic,strong)NSMutableArray *isDeduction;
@property(nonatomic,strong)NSMutableArray *inFormat;
@property(nonatomic,strong)NSMutableArray *TempOrderID;

@property(nonatomic,strong)NSMutableArray *totalFreeTables;

@property(nonatomic,strong)NSMutableArray *TDishName;
@property(nonatomic,strong)NSMutableArray *TDishQuantity;
@property(nonatomic,strong)NSMutableArray *TDishRate;

@property(nonatomic, strong)NSString *currentLanguage;
@property(nonatomic, strong)NSString *currentTable;
@property(nonatomic,strong)NSString *Discount;
@property(nonatomic,strong)NSString *isFBLogin;
@property(nonatomic,strong)NSString *isTwitterLogin;
@property(nonatomic,strong)NSString *isLogin;
@property(nonatomic,strong)NSString *Customer;

@property(nonatomic,strong)NSString *assignedTable1;
@property(nonatomic,strong)NSString *assignedTable2;
@property(nonatomic,strong)NSString *assignedTable3;
@property(nonatomic,strong)NSString *assignedTable4;

@property(nonatomic,strong)NSString *feedDishName;
@property(nonatomic,strong)NSString *feedDishRating;
@property(nonatomic,strong)NSString *feedDishImage;
@property(nonatomic,strong)NSString *performUpdateCheck;
@property(nonatomic,strong)NSString *isQuickOrder;

@property(nonatomic,strong)NSString *isConfromHomePage;
@property(nonatomic,strong)NSString *isFeedbackDone;
@property(nonatomic,strong)NSString *IsEditOrder;

@property(nonatomic,strong)NSString *isTakeaway;
@property(nonatomic,strong)NSString *AddItemFromTakeaway;

@property(nonatomic,strong)NSString *rootLoaded;

@property(nonatomic, assign)BOOL isInternetConnected;
@property(nonatomic,strong)NSString *tableNumber;
@property(nonatomic,strong)NSString *salesNo;
@property(nonatomic,strong)NSString *splitNo;
@property(nonatomic,strong)NSString *isSpecialReq;

@property(nonatomic,strong)NSString *serverUrl;
@property(nonatomic,strong)NSString *dishTag;
@property(nonatomic,strong)NSString *categoryID;
@property(nonatomic,strong)NSString *bevCat;  ////changing the @"8"zugad to "is_beverage" item from database and replace @"8" by [ShareableData sharedInstance].bevCat


+(ShareableData*) sharedInstance;
-(void) allocateArray;
+(NSString *)serverURL;
+(NSString *)appKey;
+(BOOL)dishTagStatus;
+(BOOL)multiLanguageStatus;
+(BOOL)hasAccess:(NSString *)password level:(NSString *)access;
+(NSMutableArray *)activeLanguages;
+(float)discountAmount;
+(BOOL)bestSellersON;
-(void)saveBestsellers;
-(NSString *)activeBestsellerName;
+(void)showAlert:(NSString *)title message:(NSString *)msg;


@end