//
//  TabSquareDBFile.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/11/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import<sqlite3.h>
//#import "ZIMSqlSdk.h"

@interface TabSquareDBFile : NSObject
{
     sqlite3 *dataBaseConnection;
    //int enableClose;
}

@property(nonatomic,strong)NSString* OldVersion;
@property(nonatomic,strong)NSString* NewVersion;

+ (TabSquareDBFile*) sharedDatabase;
-(void) createEditableCopyOfDatabaseIfNeeded;
-(void) openDatabaseConnection ;
-(void) closeDatabaseConnection;
-(int)getTotalRows;

-(void)InsertkinaraVersion;

-(void)insertIntoDishTableWithRecord:(NSMutableDictionary *)dataitem;

-(void)insertIntoCustomizationTableWithRecord:(NSMutableDictionary *)dataitem;

-(void)insertIntoOptionTableWithRecord:(NSMutableDictionary *)dataitem;

-(void)insertIntoContainersTableWithRecord:(NSMutableDictionary *)dataitem;

-(void)insertIntoBeverageContainerTableWithRecord:(NSMutableDictionary *)dataitem;

-(UIImage *)getImage2:(NSString *)image_name;
-(void)insertIntoHomeImageTableWithRecord:(NSString*)imageid imageName:(NSString*)name imageData:(NSData*)imagedata ;

-(void)insertIntoSubCategoryTableWithRecord:(NSMutableDictionary *)dataitem;

-(void)insertIntoSubSubCategoryTableWithRecord:(NSMutableDictionary *)dataitem;

-(void)insertHomeCategoryRecordTable:homeid categoryId:(NSString*)catId subcategoryId:(NSString*)SubcatId;

-(void)updateDishImageRecordTable:(NSMutableDictionary *)dataitem;

-(void)updateDishRecordTable:(NSMutableDictionary *)dataitem;

-(void)updateCategoryRecordTable:(NSMutableDictionary *)dataitem;

-(void)updateCustomizationRecordTable:(NSMutableDictionary *)dataitem;

-(void)updateOptionRecordTable:(NSMutableDictionary *)dataitem;

-(void)updateContainersRecordTable:(NSMutableDictionary *)dataitem;

-(void)updateBeverageContainerRecordTable:(NSMutableDictionary *)dataitem;

-(void)updateHomeImageRecordTable:(NSString*)Id imageData:(NSData*)imagedata;

-(void)updateSubCategoryRecordTable:(NSMutableDictionary *)dataitem;

-(void)insertIntoCategoryTableWithRecord:(NSMutableDictionary *)dataitem;

-(void)updateHomeCategoryRecordTable:(NSString*)Id categoryId:(NSString*)catId subcategoryId:(NSString*)SubcatId;

-(void)updateSubSubCategoryRecordTable:(NSMutableDictionary *)dataitem;

-(NSData*)getHomeImageData:(NSString*)imageId;
-(NSMutableArray*)getSubSubCategoryData:(NSString*)catId subCatId:(NSString*)subId;
-(NSString*)getComboSubCategoryIdData:(NSString*)catId;

-(void)deleteDishRecordTable:(NSString*)Dishid;
-(void)deleteCustomizationRecordTable:(NSString*)Custid;
-(void)deleteOptionRecordTable:(NSString*)optionid;
-(void)deleteContainersRecordTable:(NSString*)Containerid;
-(void)deleteBeverageContainerRecordTable:(NSString*)bevid;
-(void)deleteSubCategoryRecordTable:(NSString*)Subcatid;
-(void)deleteCategoryRecordTable:(NSString*)catid;
-(void)deleteSubSubCategoryRecordTable:(NSString*)Subcatid;
-(void)optimizeDB;

-(NSString*)getUpdateDateTime;
-(void)updateKinaraVersionDate:(NSString *)time;
-(NSMutableArray*)getDishDataDetail:(NSString*)DishId;
-(NSMutableArray*)getBeverageSkuDetail:(NSString*)beverageId;
-(NSMutableArray*)getDishData:(NSString*)catId subCatId:(NSString*)subCatId;
-(NSMutableArray*)getDishKeyData:(NSString*)key;
-(NSString*)getBeverageId:(NSString*)beverageContainerId;

-(NSMutableArray*)getDishKeyTag:(NSString*)catID tagA:(NSString*)tag1 tagB:(NSString*)tag2 tagC:(NSString*)tag3 ;
-(NSMutableArray*)getDishKeyData:(NSString*)key;
-(NSMutableArray*)getCategoryData;
-(NSMutableArray*)getSubCategoryData:(NSString*)catId;
-(NSMutableArray*)getHomeCategoryData:(NSString*)HomeId;
-(NSString*)getSubCategoryIdData:(NSString*)catId;
-(NSMutableArray *)getFirstImages:(NSMutableArray *)catIds;
-(int)getFirstSubCategoryId:(NSString *)catId;

-(void)updateComboData:(NSMutableDictionary *)data type:(NSString *)query_type;
-(void)updateGroupData:(NSMutableDictionary *)data type:(NSString *)query_type;
-(void)updateGroupDishData:(NSMutableDictionary *)data type:(NSString *)query_type;
-(void)updateDishTagData:(NSMutableDictionary *)data type:(NSString *)query_type;
-(void)updateUIImages:(NSMutableArray *)array;
-(void)saveImage:(NSString *)dishImage;
-(UIImage *)getImage:(NSString *)image_name;
-(void)deleteImage:(NSString *)image;

-(NSMutableArray *)getCombodata:(NSString *)sub_cat_id;
-(NSMutableDictionary *)getComboDataById:(int)combo_id;
-(NSMutableDictionary *)getGroupDataById:(int)group_id;
-(NSMutableArray *)getGroupDishDataById:(int)groupdish_id preSelected:(BOOL)status;
-(void)updateComboValueData:(NSMutableDictionary *)data type:(NSString *)query_type;
-(NSMutableArray *)getGroupDishes:(int)group_id;
-(int)recordExists:(NSString *)statement;
-(NSMutableArray *)getFeedbackData:(NSMutableArray *)array;
-(NSMutableArray *)getActiveDishNames:(NSMutableArray *)array;
-(NSString *)getActiveOption:(NSString *)optionId;
-(void)printData:(NSString *)query;
-(NSMutableDictionary *)bestSellerNames:(NSString *)name;
-(NSMutableArray *)getDishItemsBy:(NSMutableArray *)array;
-(NSMutableArray *)getDishIdsByAmount:(float)amount data:(NSMutableArray *)array;
-(void)deleteData:(NSString *)tableName;



@end
