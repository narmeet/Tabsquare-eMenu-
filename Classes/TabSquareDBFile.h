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

-(void)insertIntoDishTableWithRecord:(NSString*)DishId DishName:(NSString*)name DishImage:(NSString*)imagedata CategoryId:(NSString*)category SubCategoryId:(NSString*)subcategory price:(NSString*)price price2:(NSString*)price2 description:(NSString*) description customization:(NSString*)cust itemtags:(NSString*)tags DishSequence:(NSString*)dishSeq SubSubCatId:(NSString*)sub_sub_id;

-(void)insertIntoCustomizationTableWithRecord:(NSString*)custId CustName:(NSString*)name Custheader:(NSString*)headertxt custType:(NSString*)type totalSelection:(NSString*)selection ;

-(void)insertIntoOptionTableWithRecord:(NSString*)optionId optionName:(NSString*)name optionprice:(NSString*)price custId:(NSString*)custid optionQty:(NSString*)qty ;

-(void)insertIntoContainersTableWithRecord:(NSString*)containerId ContainerName:(NSString*)name ;

-(void)insertIntoBeverageContainerTableWithRecord:(NSString*)Id beverageId:(NSString*)beverageid containerId:(NSString*)containerid price:(NSString*)price ;
-(void)insertIntoHomeImageTableWithRecord:(NSString*)imageid imageName:(NSString*)name imageData:(NSData*)imagedata ;
-(void)insertIntoSubCategoryTableWithRecord:(NSString*)Id SubcategoryName:(NSString*)subcatName categoryId:(NSString*)catId subCatSequence:(NSString*)catSeq displayType:(NSString*)display catImage:(NSString *)catImage;
-(void)insertIntoSubSubCategoryTableWithRecord:(NSString*)Id SubSubcategoryName:(NSString*)subcatName categoryId:(NSString*)catId subCatId:(NSString*)subcatId sequence:(NSString*)seq catImage:(NSString *)catImage;
-(void)insertHomeCategoryRecordTable:homeid categoryId:(NSString*)catId subcategoryId:(NSString*)SubcatId;
-(void)updateDishImageRecordTable:(NSString*)DishId DishName:(NSString*)name DishImage:(NSString*)imagedata CategoryId:(NSString*)category SubCategoryId:(NSString*)subcategory price:(NSString*)price price2:(NSString*)price2 description:(NSString*)description customization:(NSString*)cust itemtags:(NSString*)tag DishSequence:(NSString*)dishSeq SubSubCatId:(NSString*)sub_sub_id;

-(void)updateDishRecordTable:(NSString*)DishId DishName:(NSString*)name  CategoryId:(NSString*)category SubCategoryId:(NSString*)subcategory price:(NSString*)price price2:(NSString*)price2 description:(NSString*)description customization:(NSString*)cust itemtags:(NSString*)tag DishSequence:(NSString*)dishSeq SubSubCatId:(NSString*)sub_sub_id;

-(void)updateCategoryRecordTable:(NSString*)Id categoryName:(NSString*)catName categorySequence:(NSString*)catSeq catImage:(NSString *)catImage is_beverage:(NSString *)is_beverage;
-(void)updateCustomizationRecordTable:(NSString*)custId CustName:(NSString*)name Custheader:(NSString*)headertxt custType:(NSString*)type totalSelection:(NSString*)selection ;

-(void)updateOptionRecordTable:(NSString*)optionId optionName:(NSString*)name optionprice:(NSString*)price custId:(NSString*)custid optionQty:(NSString*)qty;
-(void)updateContainersRecordTable:(NSString*)containerId ContainerName:(NSString*)name;

-(void)updateBeverageContainerRecordTable:(NSString*)Id beverageId:(NSString*)beverageid containerId:(NSString*)containerid price:(NSString*)price  ;
-(void)updateHomeImageRecordTable:(NSString*)Id imageData:(NSData*)imagedata;
-(void)updateSubCategoryRecordTable:(NSString*)Id SubcategoryName:(NSString*)subcatName categoryId:(NSString*)catId subCatSequence:(NSString*)catSeq displayType:(NSString*)display catImage:(NSString *)catImage;
-(void)insertIntoCategoryTableWithRecord:(NSString*)Id categoryName:(NSString*)catName categorySequence:(NSString*)catSeq catImage:(NSString *)catImage is_beverage:(NSString *)is_beverage;
-(void)updateHomeCategoryRecordTable:(NSString*)Id categoryId:(NSString*)catId subcategoryId:(NSString*)SubcatId;
-(void)updateSubSubCategoryRecordTable:(NSString*)Id SubSubcategoryName:(NSString*)subcatName categoryId:(NSString*)catId subCatId:(NSString*)subcatId sequence:(NSString*)seq catImage:(NSString *)catImage;
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


@end
