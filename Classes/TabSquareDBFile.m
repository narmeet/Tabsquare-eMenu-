
#import "TabSquareDBFile.h"
#import "ZIMSqlSdk.h"
#import "ZIMDbSdk.h"
#import "TabSquareCommonClass.h"

#import "ShareableData.h"

#define DatabaseName  @"KinaraDataBase.sqlite"

@implementation TabSquareDBFile

@synthesize NewVersion,OldVersion;

static TabSquareDBFile*	singleton;
int enableClose = 1;
+(TabSquareDBFile*) sharedDatabase 
{
   
    
	if (!singleton) 
	{
		singleton = [[TabSquareDBFile alloc] init];
	}
	return singleton;
}




-(void)GetBundleVersionNo
{
    
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSArray *records = [connection query: @"select version from  KinaraVersion  where id=1;"];
    
    for (id element in records){
        NewVersion = (NSString*)[element objectForKey:@"version"];
    }
	
	
}

-(void)GetDircetoryVersionNo
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSArray *records = [connection query: @"select version from  KinaraVersion  where id=1;"];
    
    for (id element in records){
        @try
        {
            OldVersion = (NSString*)[element objectForKey:@"version"];
        }@catch (NSException *exception)
        {
            OldVersion=@"";
        }
    }
	
}

+(NSString*) WritableDBPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths[0]stringByAppendingPathComponent:@"DataBase"];
	[[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:false attributes:nil error:nil];
	
	return [documentsDirectory stringByAppendingPathComponent:DatabaseName];
}

- (void) createEditableCopyOfDatabaseIfNeeded 
{
	DLog(@"Creating editable copy of database");
	
	// First, test for existence.
	NSString *writableDBPath = [TabSquareDBFile WritableDBPath];
	DLog(@"%@",writableDBPath);
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if ([fileManager fileExistsAtPath:writableDBPath])
	{
        return;
        [self GetDircetoryVersionNo];
		[self GetBundleVersionNo];
		
		if([NewVersion isEqualToString:OldVersion])
		{
			return;
		}
		else
		{
			[fileManager removeItemAtPath:writableDBPath error:NULL];		
		}
        
	}
	// The writable database does not exist, so copy the default to the appropriate location.
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DatabaseName];
	NSError *error;
	if (![fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error]) 
	{
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (void) openDatabaseConnection
{
    if (dataBaseConnection ==nil){
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths[0]stringByAppendingPathComponent:@"DataBase"];;
	NSString *path = [documentsDirectory stringByAppendingPathComponent:DatabaseName];
	// Open the database. The database was prepared outside the application.
	if (sqlite3_open([path UTF8String], &dataBaseConnection) == SQLITE_OK)
	{
       // return 1;
		DLog(@"Database Successfully Opened :)");
	} 
	else 
	{
       // return 0;
		DLog(@"Error in opening database :(");
	}
    }else{
       // return 1;
    }
	
}

- (void) closeDatabaseConnection
{
    if (enableClose == 1){
	sqlite3_close(dataBaseConnection);
	DLog(@"Database Successfully Closed :)");
    dataBaseConnection = nil;
    }
}

-(int)getTotalRows
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSArray *records = [connection query: @"select count(*) from kinaraVersion;"];
    int totalRecord=0;
    for (id element in records){
        totalRecord = ((NSString*)[element objectForKey:@"count(*)"]).intValue;
    }
    	return totalRecord;
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)insertIntoCategoryTableWithRecord:(NSString*)Id categoryName:(NSString*)catName categorySequence:(NSString*)catSeq catImage:(NSString *)catImage is_beverage:(NSString *)is_beverage
{
    [self saveImage:catImage];
    catName = [catName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO Categories(id,name,sequence) VALUES (?,?,?);" withValues: Id,catName,catSeq, nil];
     NSString *statement = [NSString stringWithFormat:@"INSERT INTO Categories(id,name,sequence,'image',is_beverage) VALUES (%@,'%@',%@,'%@',%@);",Id,catName,catSeq,catImage,is_beverage];
    ////NSLOG(@"query Logg 1 = %@", statement);
    
    [connection execute: statement];
    ////NSLOG(@"Logg 2");
   }
-(void)optimizeDB{
    [self openDatabaseConnection];
    if (sqlite3_exec(dataBaseConnection, "PRAGMA PAGE_SIZE=512;", NULL, NULL, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to set cache size with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    if (sqlite3_exec(dataBaseConnection, "PRAGMA CACHE_SIZE=20;", NULL, NULL, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to set cache size with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    if(sqlite3_exec(dataBaseConnection, "VACUUM;", 0, 0, NULL)==SQLITE_OK) {      DLog(@"Vacuumed DataBase");    }
    [self closeDatabaseConnection];
    const char *sql =[[NSString stringWithFormat:@"CREATE INDEX sub_sub_category_index ON Dishes(name,category,sub_category,sub_sub_category ASC)"]cStringUsingEncoding:NSUTF8StringEncoding];
    const char *sql2 =[[NSString stringWithFormat:@"CREATE INDEX sub_category_index ON Dishes(category,sub_category,sub_sub_category ASC)"]cStringUsingEncoding:NSUTF8StringEncoding];
    const char *sql3 =[[NSString stringWithFormat:@"CREATE INDEX category_index ON Dishes(category,sub_category ASC)"]cStringUsingEncoding:NSUTF8StringEncoding];
    const char *sql4 =[[NSString stringWithFormat:@"CREATE INDEX sub_category_index_2 ON Dishes(sub_category,sub_sub_category ASC)"]cStringUsingEncoding:NSUTF8StringEncoding];
      const char *sql5 =[[NSString stringWithFormat:@"CREATE INDEX sub_category_index_3 ON Dishes(name ASC)"]cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *deleteStmt = nil;
    sqlite3_stmt *deleteStmt2 = nil;
    sqlite3_stmt *deleteStmt3 = nil;
    sqlite3_stmt *deleteStmt4 = nil;
    sqlite3_stmt *deleteStmt5 = nil;
	
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
    if (sqlite3_prepare_v2(dataBaseConnection, sql2, -1, &deleteStmt2, NULL) != SQLITE_OK)
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
    if (sqlite3_prepare_v2(dataBaseConnection, sql3, -1, &deleteStmt3, NULL) != SQLITE_OK)
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
    if (sqlite3_prepare_v2(dataBaseConnection, sql4, -1, &deleteStmt4, NULL) != SQLITE_OK)
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
    if (sqlite3_prepare_v2(dataBaseConnection, sql5, -1, &deleteStmt5, NULL) != SQLITE_OK)
	{
    DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
    
    int success = sqlite3_step(deleteStmt);
    int success2 = sqlite3_step(deleteStmt2);
    int success3 = sqlite3_step(deleteStmt3);
    int success4 = sqlite3_step(deleteStmt4);
     int success5 = sqlite3_step(deleteStmt5);
	DLog(@"success full Indexed==%d",success);
    DLog(@"success full Indexed2==%d",success2);
    DLog(@"success full Indexed3==%d",success3);
    DLog(@"success full Indexed4==%d",success4);
    DLog(@"success full Indexed5==%d",success5);
	sqlite3_reset(deleteStmt);
    sqlite3_reset(deleteStmt2);
    sqlite3_reset(deleteStmt3);
    sqlite3_reset(deleteStmt4);
    sqlite3_reset(deleteStmt5);
	sqlite3_finalize(deleteStmt);
    sqlite3_finalize(deleteStmt2);
    sqlite3_finalize(deleteStmt3);
    sqlite3_finalize(deleteStmt4);
    sqlite3_finalize(deleteStmt5);

    
   // sqlite3_exec
}

-(void)deleteCategoryRecordTable:(NSString*)catid
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    //NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"delete from Categories where id = ?;" withValues: catid, nil];
    NSString *statement = [NSString stringWithFormat:@"delete from Categories where id = %@;",catid ];
    [connection execute: statement];
  }


-(void)updateCategoryRecordTable:(NSString*)Id categoryName:(NSString*)catName categorySequence:(NSString*)catSeq catImage:(NSString *)catImage is_beverage:(NSString *)is_beverage
{
    [self saveImage:catImage];
    catName = [catName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    //NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update Categories set name = ?,sequence = ? where id = ? ;" withValues: catName,catSeq,Id, nil];
    NSString *statement = [NSString stringWithFormat:@"Update Categories set name = '%@',sequence = %@,image = '%@' , is_beverage = %@ where id = %@ ;",catName,catSeq, catImage,is_beverage,Id ];
    [connection execute: statement];
    
   }

-(void)insertIntoSubCategoryTableWithRecord:(NSString*)Id SubcategoryName:(NSString*)subcatName categoryId:(NSString*)catId subCatSequence:(NSString*)catSeq displayType:(NSString*)display catImage:(NSString *)catImage
{
    [self saveImage:catImage];
    subcatName = [subcatName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
  //  NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO SubCategories(id,name,category_id,sequence,display) VALUES ( ? , ? , ? , ? , ? ) ;" withValues: Id,subcatName,catId,catSeq,display, nil];
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO SubCategories(id,name,category_id,sequence,display,'image') VALUES ( %@ , '%@' , %@ , %@ , %@, '%@') ;",Id,subcatName,catId,catSeq,display,catImage];
    [connection execute: statement];
    
}

-(void)deleteSubCategoryRecordTable:(NSString*)Subcatid
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"delete from SubCategories where id = ? ;" withValues: Subcatid, nil];
     NSString *statement = [NSString stringWithFormat:@"delete from SubCategories where id = %@ ;",Subcatid ];
    [connection execute: statement];
    
   
}

-(void)updateSubCategoryRecordTable:(NSString*)Id SubcategoryName:(NSString*)subcatName categoryId:(NSString*)catId subCatSequence:(NSString*)catSeq displayType:(NSString*)display catImage:(NSString *)catImage
{
    [self saveImage:catImage];
    subcatName = [subcatName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
  //  NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update SubCategories set name = ?,category_id = ?,sequence = ?,display = ? where id = ? ;" withValues: subcatName,catId,catSeq,display,Id, nil];
     NSString *statement = [NSString stringWithFormat:@"Update SubCategories set name = '%@',category_id = %@,sequence = %@,display = %@,image = '%@' where id = %@ ;",subcatName,catId,catSeq,display,catImage,Id ];
    [connection execute: statement];
    
  
    
}

-(void)insertIntoSubSubCategoryTableWithRecord:(NSString*)Id SubSubcategoryName:(NSString*)subcatName categoryId:(NSString*)catId subCatId:(NSString*)subcatId sequence:(NSString*)seq catImage:(NSString *)catImage
{
    [self saveImage:catImage];
    subcatName = [subcatName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
  //  NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO Sub_Sub_Categories(id,name,category_id,sub_category_id) VALUES ( ? , ? , ? , ? ) ;" withValues: Id,subcatName,catId,subcatId, nil];
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO Sub_Sub_Categories(id,name,category_id,sub_category_id,sequence,'image') VALUES ( %@ , '%@' , %@ , %@ , %@, '%@') ;",Id,subcatName,catId,subcatId,seq,catImage];
    [connection execute: statement];
      
}

-(void)deleteSubSubCategoryRecordTable:(NSString*)Subcatid
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
  //  NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"delete from Sub_Sub_Categories where id = ? ;" withValues: Subcatid, nil];
     NSString *statement = [NSString stringWithFormat:@"delete from Sub_Sub_Categories where id = %@ ;",Subcatid ];
    [connection execute: statement];
   
}

-(void)updateSubSubCategoryRecordTable:(NSString*)Id SubSubcategoryName:(NSString*)subcatName categoryId:(NSString*)catId subCatId:(NSString*)subcatId sequence:(NSString*)seq catImage:(NSString *)catImage
{
    subcatName = [subcatName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    [self saveImage:catImage];
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update Sub_Sub_Categories set name = ? ,category_id = ? ,sub_category_id= ? where id = ? ;" withValues: subcatName,catId,subcatId,Id, nil];
     NSString *statement = [NSString stringWithFormat:@"Update Sub_Sub_Categories set name = '%@' ,category_id = %@ ,sub_category_id= %@ , sequence = %@,image = '%@' where id = %@ ;",subcatName,catId,subcatId,seq,catImage,Id ];
    [connection execute: statement];
    
   
}





-(void)InsertkinaraVersion
{
    NSString *versionName=@"Kinara1";
    NSDate *today=[NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:today];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
  //  NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO KinaraVersion(version,datetime) VALUES ( ? , ? ) ;" withValues: versionName,dateString, nil];
     NSString *statement = [NSString stringWithFormat:@"INSERT INTO KinaraVersion(version,datetime) VALUES ( '%@' , '%@' ) ;",versionName,dateString ];
    [connection execute: statement];
    
	
}

-(void)insertIntoDishTableWithRecord:(NSString*)DishId DishName:(NSString*)name DishImage:(NSString*)imagedata CategoryId:(NSString*)category SubCategoryId:(NSString*)subcategory price:(NSString*)price price2:(NSString*)price2 description:(NSString*) description customization:(NSString*)cust itemtags:(NSString*)tags DishSequence:(NSString*)dishSeq SubSubCatId:(NSString*)sub_sub_id
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO Dishes(id,name,image,category,sub_category,price,price2,description,customization,tags,sequence,sub_sub_category) VALUES ( ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? ) ;" withValues: DishId,name,imagedata,category,subcategory,price,price2,description,cust,tags,dishSeq,sub_sub_id, nil];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    description = [description stringByReplacingOccurrencesOfString:@"'" withString:@""];
    tags = [tags stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO Dishes(id,name,image,category,sub_category,price,price2,description,customization,tags,sequence,sub_sub_category) VALUES ( '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' ) ;",DishId,name,imagedata,category,subcategory,price,price2,description,cust,tags,dishSeq,sub_sub_id ];
    
    [connection execute: statement];
    
   
}

-(void)deleteDishRecordTable:(NSString*)Dishid
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"delete from Dishes where id = ? ;" withValues: Dishid, nil];
     NSString *statement = [NSString stringWithFormat:@"delete from Dishes where id = '%@' ;",Dishid ];
    [connection execute: statement];
    

}

-(void)updateDishImageRecordTable:(NSString*)DishId DishName:(NSString*)name DishImage:(NSString*)imagedata CategoryId:(NSString*)category SubCategoryId:(NSString*)subcategory price:(NSString*)price price2:(NSString*)price2 description:(NSString*)description customization:(NSString*)cust itemtags:(NSString*)tag DishSequence:(NSString*)dishSeq SubSubCatId:(NSString*)sub_sub_id
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update Dishes set name = ?,image = ?,category= ? ,sub_category = ?,price = ?,price2 = ?,description = ?,customization = ?,tags = ?,sequence = ?,sub_sub_category = ? where id = ? ;" withValues: name,imagedata,category,subcategory,price,price2,description,cust,tag,dishSeq,sub_sub_id,DishId, nil];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    description = [description stringByReplacingOccurrencesOfString:@"'" withString:@""];
    tag = [tag stringByReplacingOccurrencesOfString:@"'" withString:@""];
     NSString *statement = [NSString stringWithFormat:@"Update Dishes set name = '%@',image = '%@',category= '%@' ,sub_category = '%@',price = '%@',price2 = '%@',description = '%@',customization = '%@',tags = '%@',sequence = '%@',sub_sub_category = '%@' where id = '%@' ;",name,imagedata,category,subcategory,price,price2,description,cust,tag,dishSeq,sub_sub_id,DishId ];
    [connection execute: statement];
  
}

-(void)updateDishRecordTable:(NSString*)DishId DishName:(NSString*)name  CategoryId:(NSString*)category SubCategoryId:(NSString*)subcategory price:(NSString*)price price2:(NSString*)price2 description:(NSString*)description customization:(NSString*)cust itemtags:(NSString*)tag DishSequence:(NSString*)dishSeq SubSubCatId:(NSString*)sub_sub_id
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update Dishes set name = ?,category= ? ,sub_category = ?,price = ?,price2 = ?,description = ?,customization = ?,tags = ?,sequence = ?,sub_sub_category = ? where id = ? ;" withValues: name,category,subcategory,price,price2,description,cust,tag,dishSeq,sub_sub_id,DishId, nil];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    description = [description stringByReplacingOccurrencesOfString:@"'" withString:@""];
    tag = [tag stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *statement = [NSString stringWithFormat:@"Update Dishes set name = '%@',category= '%@' ,sub_category = '%@',price = '%@',price2 = '%@',description = '%@',customization = '%@',tags = '%@',sequence = '%@',sub_sub_category = '%@' where id = '%@' ;",name,category,subcategory,price,price2,description,cust,tag,dishSeq,sub_sub_id,DishId ];
    [connection execute: statement];
    
 
}

-(void)insertIntoCustomizationTableWithRecord:(NSString*)custId CustName:(NSString*)name Custheader:(NSString*)headertxt custType:(NSString*)type totalSelection:(NSString*)selection 
{
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    headertxt = [headertxt stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO Customization(id,name,header_text,type,no_of_selection) VALUES ( ? , ? , ? , ? , ? ) ;" withValues: custId,name,headertxt,type,selection, nil];
    [connection execute: statement];
   
}

-(void)deleteCustomizationRecordTable:(NSString*)Custid
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"delete from Customization where id = ? ;" withValues: Custid, nil];
    NSString *statement = [NSString stringWithFormat:@"delete from Customization where id = '%@' ;",Custid ];
    [connection execute: statement];
    
	
}

-(void)updateCustomizationRecordTable:(NSString*)custId CustName:(NSString*)name Custheader:(NSString*)headertxt custType:(NSString*)type totalSelection:(NSString*)selection 
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
  //  NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update Customization set name = ? ,header_text = ? ,type = ? ,no_of_selection = ? where id = ? ;" withValues: name,headertxt,type,selection,custId, nil];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    headertxt = [headertxt stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *statement = [NSString stringWithFormat:@"Update Customization set name = '%@' ,header_text = '%@' ,type = '%@' ,no_of_selection = '%@' where id = '%@' ;",name,headertxt,type,selection,custId ];
    [connection execute: statement];
   
}

-(void)insertIntoOptionTableWithRecord:(NSString*)optionId optionName:(NSString*)name optionprice:(NSString*)price custId:(NSString*)custid optionQty:(NSString*)qty 
{
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO CustOptions(id,name,price,customization_id,quantity) VALUES ( '%@' , '%@' , '%@' , '%@' , '%@' ) ;",optionId,name,price,custid,qty ];//, [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO CustOptions(id,name,price,customization_id,quantity) VALUES ( ? , ? , ? , ? , ? ) ;" withValues: optionId,name,price,custid,qty, nil];
    [connection execute: statement];
    
   
}

-(void)deleteOptionRecordTable:(NSString*)optionid
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"delete from CustOptions where id = '%@' ;",optionid ];//[ZIMSqlPreparedStatement preparedStatement: @"delete from CustOptions where id = ? ;" withValues: optionid, nil];
    [connection execute: statement];
    
    
}

-(void)updateOptionRecordTable:(NSString*)optionId optionName:(NSString*)name optionprice:(NSString*)price custId:(NSString*)custid optionQty:(NSString*)qty 
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update CustOptions set name = ? ,price = ? ,customization_id = ? ,quantity = ? where id = ? ;" withValues: name,price,custid,qty,optionId, nil];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *statement = [NSString stringWithFormat:@"Update CustOptions set name = '%@' ,price = '%@' ,customization_id = '%@' ,quantity = '%@' where id = '%@' ;",name,price,custid,qty,optionId ];
    [connection execute: statement];
    
 
}


-(void)insertIntoContainersTableWithRecord:(NSString*)containerId ContainerName:(NSString*)name 
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO Containers(id,name) VALUES ( ? , ? ) ;" withValues: containerId,name, nil];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO Containers(id,name) VALUES ( '%@' , '%@' ) ;",containerId,name ];
   [connection execute: statement];
    
  
    
}

-(void)deleteContainersRecordTable:(NSString*)Containerid
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    //NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"delete from Containers where id = ? ;" withValues: Containerid, nil];
    NSString *statement = [NSString stringWithFormat:@"delete from Containers where id = '%@' ;",Containerid ];
    [connection execute: statement];
    
	
}

-(void)updateContainersRecordTable:(NSString*)containerId ContainerName:(NSString*)name
{
    
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
  //  NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update Containers set name = ? where id = ? ;" withValues: name,containerId, nil];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
      NSString *statement = [NSString stringWithFormat:@"Update Containers set name = '%@' where id = '%@' ;",name,containerId ];
    [connection execute: statement];
    

}


-(void)insertIntoBeverageContainerTableWithRecord:(NSString*)Id beverageId:(NSString*)beverageid containerId:(NSString*)containerid price:(NSString*)price 
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO BeverageContainers(id,beverage_id,container_id,price) VALUES ( ? , ? , ? , ? ) ;" withValues: Id,beverageid,containerid,price, nil];
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO BeverageContainers(id,beverage_id,container_id,price) VALUES ( '%@' , '%@' , '%@' , '%@' ) ;",Id,beverageid,containerid,price ];
    [connection execute: statement];
    
}

-(void)deleteBeverageContainerRecordTable:(NSString*)bevid
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"delete from BeverageContainers where id = ? ;" withValues: bevid, nil];
    NSString *statement = [NSString stringWithFormat:@"delete from BeverageContainers where id = '%@' ;",bevid ];
    [connection execute: statement];
    
    

}

-(void)updateBeverageContainerRecordTable:(NSString*)Id beverageId:(NSString*)beverageid containerId:(NSString*)containerid price:(NSString*)price  
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update BeverageContainers set beverage_id = ? ,container_id = ? ,price = ? where id = ? ;" withValues: beverageid,containerid,price,Id, nil];
    NSString *statement = [NSString stringWithFormat:@"Update BeverageContainers set beverage_id = '%@' ,container_id = '%@' ,price = '%@' where id = '%@' ;",beverageid,containerid,price,Id ];
    [connection execute: statement];
   
}

-(void)insertIntoHomeImageTableWithRecord:(NSString*)imageid imageName:(NSString*)name imageData:(NSData*)imagedata 
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO HomeImage(id,name,image) VALUES ( ? , ? , ? ) ;" withValues: imageid,name,imagedata, nil];
    [connection execute: statement];
    
 
}

-(void)updateHomeImageRecordTable:(NSString*)Id imageData:(NSData*)imagedata
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update HomeImage set image = ? where id = ? ;" withValues: imagedata,Id, nil];
    [connection execute: statement];
    
  
}
-(void)insertHomeCategoryRecordTable:homeid categoryId:(NSString*)catId subcategoryId:(NSString*)SubcatId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"insert into HomePage (id,category,subcategory) values ( ? , ? , ? );" withValues: homeid,catId,SubcatId, nil];
    [connection execute: statement];
    
  
}

-(void)updateHomeCategoryRecordTable:(NSString*)Id categoryId:(NSString*)catId subcategoryId:(NSString*)SubcatId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update HomePage set category = ? ,subcategory = ? where id = ? ;" withValues: catId,SubcatId,Id, nil];
    [connection execute: statement];
  
}

-(NSMutableArray*)getHomeCategoryData:(NSString*)HomeId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT * FROM HomePage where id = ? ;" withValues: HomeId, nil];
    NSArray *records = [connection query: statement];
    NSMutableArray *HomeCategoryData=[[NSMutableArray alloc]init];
    for (id element in records){
        
       // NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
      //  NSString *dishId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSMutableDictionary *homecatDic=[NSMutableDictionary dictionary];
        NSString *catid=(NSString*)[element objectForKey:@"category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSString *subid=(NSString*)[element objectForKey:@"subcategory"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
        
        
        homecatDic[@"cat"] = catid;
        homecatDic[@"subcat"] = subid;
        [HomeCategoryData addObject:homecatDic];
        
        
    }
    
    
    
   	return HomeCategoryData;
}


-(NSData*)getHomeImageData:(NSString*)imageId
{
    NSData *imageData;
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"select image from HomeImage where id = ? ;" withValues: imageId, nil];
    NSArray *records = [connection query: statement];
    NSMutableArray *HomeCategoryData=[[NSMutableArray alloc]init];
    for (id element in records){
        
        // NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
        //  NSString *dishId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        imageData = (NSData*)[element objectForKey:@"image"];//[NSData initWithBytes:sqlite3_column_blob(addStmt, 0) length:sqlite3_column_bytes(addStmt,0)];
        
        
    }
    
    
  
	return imageData;
}



-(void)updateKinaraVersionDate:(NSString *)time
{
    int versionid=1;
   
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
    NSString *statement = [NSString stringWithFormat:@"Update KinaraVersion set datetime = '%@' where id = %d ;",time,versionid];//[ZIMSqlPreparedStatement preparedStatement: @"Update KinaraVersion set datetime = '?' where id = ? ;" withValues: dateString,1, nil];
    [connection execute: statement];

    
}


-(NSString*)getUpdateDateTime
{
    NSString* datetime=@"";
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"select datetime from KinaraVersion ;" withValues: imageId, nil];
    NSArray *records = [connection query: @"select datetime from KinaraVersion ;"];
  //  NSMutableArray *HomeCategoryData=[[NSMutableArray alloc]init];
    for (id element in records){
        
        // NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
        //  NSString *dishId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        datetime=(NSString*)[element objectForKey:@"datetime"];

        //[NSData initWithBytes:sqlite3_column_blob(addStmt, 0) length:sqlite3_column_bytes(addStmt,0)];
        
        
    }
  
    return datetime;
}

-(NSMutableArray*)getOptionData:(NSString*)custId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"select * from CustOptions where customization_id in(%@)",custId];//[ZIMSqlPreparedStatement preparedStatement: @"select * from CustOptions where customization_id in( ? );" withValues: custId, nil];
    NSArray *records = [connection query: statement];
   NSMutableArray *optionData=[[NSMutableArray alloc]init];
    for (id element in records){
        NSString *optionId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSString *optionName=(NSString*)[element objectForKey:@"name"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSString *optionPrice=(NSString*)[element objectForKey:@"price"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
        NSString *optionCustid=(NSString*)[element objectForKey:@"customization_id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
        NSString *optionQuantity=(NSString*)[element objectForKey:@"quantity"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
        NSMutableDictionary *optionDic=[NSMutableDictionary dictionary];
        optionDic[@"id"] = optionId;
        optionDic[@"name"] = optionName;
        optionDic[@"price"] = optionPrice;
        optionDic[@"customisation_id"] = optionCustid;
        optionDic[@"quantity"] = optionQuantity;
        [optionData addObject:optionDic];

    }
    
    
	return optionData;
}




-(NSMutableArray*)getCustomizationData:(NSString*)custId
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"select * from Customization where id in(%@)",custId];//[ZIMSqlPreparedStatement  preparedStatement: @"select * from Customization where id in( ? );" withValues: custId, nil];
    NSArray *records = [connection query: statement];
    NSMutableArray *finalCust=[[NSMutableArray alloc]init];
    for (id element in records){
        NSString *custId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSString *custname=(NSString*)[element objectForKey:@"name"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSString *custheader=(NSString*)[element objectForKey:@"header_text"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
        NSString *custtype=(NSString*)[element objectForKey:@"type"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
        NSString *custselection=(NSString*)[element objectForKey:@"no_of_selection"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
        NSMutableDictionary *custDic=[NSMutableDictionary dictionary];
        custDic[@"id"] = custId;
        custDic[@"name"] = custname;
        custDic[@"header_text"] = custheader;
        custDic[@"type"] = custtype;
        custDic[@"no_of_selection"] = custselection;
       // enableClose = 0;
        //  [custData addObject:custDic];
        NSMutableArray *optionData=[self getOptionData:custId];
      //  enableClose = 1;
        NSMutableDictionary *cust=[NSMutableDictionary dictionary];
        cust[@"Customisation"] = custDic;
        cust[@"Option"] = optionData;
        
        //[customization addObject:cust];
        [finalCust addObject:cust];
    }
    
	return finalCust;
}


-(NSMutableArray*)getDishData:(NSString*)catId subCatId:(NSString*)subCatId
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString* statement;
   
    
    NSString *query = @"SELECT id, name,image, category, sub_category, price, description, customization, sub_sub_category, tags,0 AS jugaad from dishes WHERE category=? AND sub_category=? UNION ALL SELECT id, name,image, category, sub_category, price,0 AS customization, description, sub_sub_category, tags,1 AS jugad from combos WHERE category=? AND sub_category=? order by sub_sub_category,name;";
    
    if([catId intValue] == 8)
        statement = [ZIMSqlPreparedStatement preparedStatement: @"select * from Dishes where category = ? and sub_category = ? order by sub_sub_category,name;" withValues: catId,subCatId, nil];
    else
        statement = [ZIMSqlPreparedStatement preparedStatement:query  withValues: catId,subCatId, catId, subCatId, nil];
    
    // }
    NSArray *records = [connection query: statement];
    
    
    if([catId intValue] == 8)
    {
        NSMutableArray *dishData=[[NSMutableArray alloc]init];
        for (id element in records){
            
            
            NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
            NSString *dishId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
            NSString *dishname=(NSString*)[element objectForKey:@"name"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
            NSString *libraryDirectory = [paths lastObject];
            NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,(NSString*)[element objectForKey:@"image"] ];
            NSString *dishdata = location;//[UIImage imageNamed:location]; //[NSData dataWithContentsOfFile:location];//(NSString*)[element objectForKey:@"image"];//[NSData dataWithBytes:sqlite3_column_blob(addStmt, 2) length:sqlite3_column_bytes(addStmt,2)];
            NSString *dishcat=(NSString*)[element objectForKey:@"category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
            NSString *dishsubcat=(NSString*)[element objectForKey:@"sub_category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
            NSString *dishprice=(NSString*)[element objectForKey:@"price"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,5)];
            NSString *dishprice2=(NSString*)[element objectForKey:@"price2"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,6)];
            NSString *dishdescription=(NSString*)[element objectForKey:@"description"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,7)];
            NSString *dishcustomization=(NSString*)[element objectForKey:@"customization"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,8)];
            NSString *dishSubSubId=(NSString*)[element objectForKey:@"sub_sub_category"];//[NSString
            if ([[dishcustomization lowercaseString] isEqualToString:@"<null>"] || dishcustomization==NULL) {
                
                dishcustomization =@"";
            }
            NSMutableArray *customizationdata= [self getCustomizationData:dishcustomization];
            // enableClose = 1;
            
            NSString *tag_str = (NSString *)[element objectForKey:@"tags"];
            //////NSLOG(@"tag str = %@", tag_str);
            /*==========Fetching dish tag items============*/
            NSMutableArray *tag_array = [[NSMutableArray alloc] init];
            NSMutableArray *tag_names = [[NSMutableArray alloc] init];
            
            if(tag_str != NULL && ![tag_str isEqualToString:@"<null>"] && [tag_str length] > 0) {
                
                NSString *val = [NSString stringWithFormat:@"0%@0", tag_str];
                
                ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
                NSString *query = [NSString stringWithFormat:@"select icon, name FROM tags WHERE id IN(%@) and icon!='' AND icon!='<null>' order by name ;", val];
                
                
                NSArray *records2 = [connection query: query];
                
                for(id dat in records2)
                {
                    [tag_array addObject:[dat objectForKey:@"icon"]];
                    [tag_names addObject:[dat objectForKey:@"name"]];
                }
            }
            /*============================================*/
            
            
            NSString *cust=@"0";
            
            if(![dishcustomization isEqualToString:@""])
            {
                cust=@"1";
            }
            
            dishDic[@"cust"] = cust;
            dishDic[@"id"] = dishId;
            dishDic[@"name"] = dishname;
            dishDic[@"images"] = dishdata;
            dishDic[@"category"] = dishcat;
            dishDic[@"sub_category"] = dishsubcat;
            dishDic[@"price"] = dishprice;
            dishDic[@"price2"] = dishprice2;
            dishDic[@"description"] = dishdescription;
            dishDic[@"customisations"] = customizationdata;
            dishDic[@"sub_sub_category"] = dishSubSubId;
            [dishDic setObject:tag_array forKey:@"tag_icons"];
            [dishDic setObject:tag_names forKey:@"tag_names"];
            
            [dishData addObject:dishDic];
            
        }
        return dishData;
    }
    
    NSMutableArray *dishData = [[NSMutableArray alloc]init];
    //NSMutableArray * tags = [[NSMutableArray alloc]init];
    
    for (id element in records){
        
        
        NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
        NSString *dishId=(NSString*)[element objectForKey:@"[id]"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        
        NSString *dishname=(NSString*)[element objectForKey:@"[name]"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSString *jugad_key = [element objectForKey:@"jugaad"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        
        NSString *libraryDirectory = [paths lastObject];
        
        NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,(NSString*)[element objectForKey:@"[image]"] ];
        
        NSString *dishdata = location;//[UIImage imageNamed:location]; //[NSData dataWithContentsOfFile:location];//(NSString*)[element objectForKey:@"image"];//[NSData dataWithBytes:sqlite3_column_blob(addStmt, 2) length:sqlite3_column_bytes(addStmt,2)];
        
        NSString *dishcat=(NSString*)[element objectForKey:@"[category]"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
        
        NSString *dishsubcat=(NSString*)[element objectForKey:@"[sub_category]"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
        
        NSString *dishprice=(NSString*)[element objectForKey:@"[price]"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,5)];
        
        //NSString *dishprice2=(NSString*)[element objectForKey:@"price2"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,6)];
        
        NSString *dishprice2 = @"0.0";
        
        NSString *dishdescription=(NSString*)[element objectForKey:@"[description]"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,7)];
        
        
        NSString *dishcustomization=(NSString*)[element objectForKey:@"[customization]"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,8)];
        
        // NSString *dishcustomization = @"";
        if ([dishcustomization isEqualToString:@"<null>"]) {
            
            dishcustomization =@"";
        }
        
        NSString *dishSubSubId=(NSString*)[element objectForKey:@"[sub_sub_category]"];//[NSString stringWithFormat:@"%s",(char*)(char*)sqlite3_column_text(addStmt,11)];
        //  enableClose = 0;
        
        NSMutableArray *customizationdata= [self getCustomizationData:dishcustomization];
        // enableClose = 1;
        NSString *tag_str = (NSString *)[element objectForKey:@"[tags]"];
        
        /*==========Fetching dish tag items============*/
        NSMutableArray *tag_array = [[NSMutableArray alloc] init];
        NSMutableArray *tag_names = [[NSMutableArray alloc] init];
        
        if(tag_str != NULL && ![tag_str isEqualToString:@"<null>"] && [tag_str length] > 0) {
            //////NSLOG(@"cat=%@, subcat=%@, tag_str = %@", catId, subCatId, tag_str);
            
            NSString *val = [NSString stringWithFormat:@"0%@0", tag_str];
            ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
            NSString *query = [NSString stringWithFormat:@"select icon, name FROM tags WHERE id IN(%@) and icon!='' AND icon!='<null>' ;", val];
            NSArray *records2 = [connection query: query];
            
            for(id dat in records2)
            {
                [tag_array addObject:[dat objectForKey:@"icon"]];
                [tag_names addObject:[dat objectForKey:@"name"]];
            }
            
        }
        //[tags addObject:tag_array];
        /*============================================*/
        
        
        NSString *cust=@"0";
        
        if(![dishcustomization isEqualToString:@""])
        {
            cust=@"1";
        }
        
        dishDic[@"cust"] = cust;
        dishDic[@"id"] = dishId;
        dishDic[@"name"] = dishname;
        dishDic[@"images"] = dishdata;
        dishDic[@"category"] = dishcat;
        dishDic[@"sub_category"] = dishsubcat;
        dishDic[@"price"] = dishprice;
        dishDic[@"price2"] = dishprice2;
        dishDic[@"description"] = dishdescription;
        dishDic[@"customisations"] = customizationdata;
        dishDic[@"sub_sub_category"] = dishSubSubId;
        [dishDic setObject:jugad_key forKey:@"is_set"];
        [dishDic setObject:tag_array forKey:@"tag_icons"];
        [dishDic setObject:tag_names forKey:@"tag_names"];
        
        [dishData addObject:dishDic];
        // [dishDic release];
        // dishdata = nil;
    }
    
    return dishData;
    
}

-(NSMutableArray*)getDishDataDetail:(NSString*)DishId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
  //  NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"select * from Dishes where id = ? ;" withValues: DishId, nil];
    NSString *statement = [NSString stringWithFormat:@"select * from Dishes where id = '%@' ;",DishId ];
    NSArray *records = [connection query: statement];
   NSMutableArray *dishData=[[NSMutableArray alloc]init];
    for (id element in records){
        NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
        NSString *dishId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSString *dishname=(NSString*)[element objectForKey:@"name"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        NSString *libraryDirectory = [paths lastObject];
        NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,(NSString*)[element objectForKey:@"image"] ];
        NSString *dishdata = location;//[NSData dataWithContentsOfFile:location];//[NSData dataWithBytes:sqlite3_column_blob(addStmt, 2) length:sqlite3_column_bytes(addStmt,2)];
        NSString *dishcat=(NSString*)[element objectForKey:@"category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
        NSString *dishsubcat=(NSString*)[element objectForKey:@"sub_category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
        NSString *dishprice=(NSString*)[element objectForKey:@"price"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,5)];
        NSString *dishprice2=(NSString*)[element objectForKey:@"price2"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,6)];
        NSString *dishdescription=(NSString*)[element objectForKey:@"description"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,7)];
        NSString *dishcustomization=(NSString*)[element objectForKey:@"customization"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,8)];
        NSString *dishSubSubId=(NSString*)[element objectForKey:@"sub_sub_category"];//[NSString stringWithFormat:@"%s",(char*)(char*)sqlite3_column_text(addStmt,11)];
       // enableClose = 0;
        if ([dishcustomization isEqualToString:@"<null>"]) {
            dishcustomization=@"";
        }
        
        NSMutableArray *customizationdata= [self getCustomizationData:dishcustomization];
       // enableClose = 1;
        NSString *cust=@"0";
        if(![dishcustomization isEqualToString:@""])
        {
            cust=@"1";
        }
        dishDic[@"cust"] = cust;
        dishDic[@"id"] = dishId;
        dishDic[@"name"] = dishname;
        dishDic[@"images"] = dishdata;
        dishDic[@"category"] = dishcat;
        dishDic[@"sub_category"] = dishsubcat;
        dishDic[@"price"] = dishprice;
        dishDic[@"price2"] = dishprice2;
        dishDic[@"description"] = dishdescription;
        dishDic[@"customisations"] = customizationdata;
        dishDic[@"sub_sub_category"] = dishSubSubId;
        [dishData addObject:dishDic];
        
        
    }
    
    
		return dishData;
}

-(NSMutableArray*)getBeverageSkuDetail:(NSString*)beverageId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"select BeverageContainers.id,Containers.name,BeverageContainers.price from Containers,BeverageContainers WHERE BeverageContainers.beverage_id='%@' and Containers.id=BeverageContainers.container_id group by Containers.name",beverageId];//[ZIMSqlPreparedStatement preparedStatement: @"select * from CustOptions where customization_id in( ? );" withValues: custId, nil];
    NSArray *records = [connection query: statement];
   NSMutableArray *beverageSku=[[NSMutableArray alloc]init];
    for (id element in records){
        //NSString *optionId=(NSString*)[element objectForKey:@"id"];//[NSString
        NSMutableDictionary *SkuDic=[NSMutableDictionary dictionary];
        NSString *skuId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSString *skuName=(NSString*)[element objectForKey:@"name"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSString *skuPrice=(NSString*)[element objectForKey:@"price"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
        if(![skuPrice isEqualToString:@"0.00"])
        {
            SkuDic[@"sku_id"] = skuId;
            SkuDic[@"sku_name"] = skuName;
            SkuDic[@"sku_price"] = skuPrice;
            [beverageSku addObject:SkuDic];
        }
        
    }
    
  	return beverageSku;
}




-(NSString*)getBeverageId:(NSString*)beverageContainerId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"select beverage_id from BeverageContainers where id='%@'",beverageContainerId];
    NSString *beverageId=@"";
    NSArray *records = [connection query: statement];
    NSMutableArray *beverageSku=[[NSMutableArray alloc]init];
    for (id element in records){
        //NSString *optionId=(NSString*)[element objectForKey:@"id"];//[NSString
       // NSMutableDictionary *SkuDic=[NSMutableDictionary dictionary];
        //NSString *skuId=(NSString*)[element objectForKey:@"id"];//[NSString
        beverageId=(NSString*)[element objectForKey:@"beverage_id"]; 
        
    }

   	return beverageId;
}


-(NSMutableArray*)getDishKeyData:(NSString*)key
{
    char c = '%';
    NSString *sp_char = [NSString stringWithFormat:@"%c", c];
    
        
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"SELECT * FROM 'dishes' WHERE %@ LIKE '%@%@%@' OR %@ LIKE '%@%@%@' OR tags LIKE '%@,' ||(SELECT id FROM 'tags' WHERE %@ LIKE '%@%@' LIMIT 1) || ',%@' ORDER BY category ;", @"name", sp_char, key, sp_char, @"description", sp_char, key, sp_char, sp_char, @"name", key, sp_char, sp_char];
    
    
    
    if([key length] == 0 && [[TabSquareCommonClass getValueInUserDefault:BEST_SELLERS] intValue] == 1 && [ShareableData bestSellersON]) {
        statement = [NSString stringWithFormat:@"SELECT *FROM dishes WHERE tags LIKE '%@,' ||(SELECT id FROM tags WHERE name LIKE '%@Bestseller%@' LIMIT 1) || ',%@'", sp_char, sp_char, sp_char, sp_char];
    }
    
    NSArray *records = [connection query: statement];
    ////NSLOG(@"Search records = %@", records);
    
    NSMutableArray *dishData=[[NSMutableArray alloc]init];
    ////NSLOG(@"dish data searched = %@", records);
    
    for (id element in records){
        //NSString *optionId=(NSString*)[element objectForKey:@"id"];//[NSString
        // NSMutableDictionary *SkuDic=[NSMutableDictionary dictionary];
        //NSString *skuId=(NSString*)[element objectForKey:@"id"];//[NSString
        NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
        NSString *dishId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSString *dishname=(NSString*)[element objectForKey:@"name"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        NSString *libraryDirectory = [paths lastObject];
        NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,(NSString*)[element objectForKey:@"image"] ];
        NSString *dishdata = location;//[NSData dataWithContentsOfFile:location];
        
        // NSData *dishdata = [[NSData alloc] initWithBytes:sqlite3_column_blob(addStmt, 2) length:sqlite3_column_bytes(addStmt,2)];
        NSString *dishcat=(NSString*)[element objectForKey:@"category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
        NSString *dishsubcat=(NSString*)[element objectForKey:@"sub_category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
        NSString *dishprice=(NSString*)[element objectForKey:@"price"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,5)];
        NSString *dishprice2=(NSString*)[element objectForKey:@"price2"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,6)];
        NSString *dishdescription=(NSString*)[element objectForKey:@"description"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,7)];
        NSString *dishcustomization=(NSString*)[element objectForKey:@"customization"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,8)];
        //  enableClose =0;
        if ([dishcustomization isEqualToString:@"<null>"]) {
            dishcustomization=@"";
        }
        NSMutableArray *customizationdata= [self getCustomizationData:dishcustomization];
        // enableClose = 1;
        NSString *cust=@"0";
        if(![dishcustomization isEqualToString:@""])
        {
            cust=@"1";
        }
        
        
        NSString *tag_str = (NSString *)[element objectForKey:@"tags"];
        //////NSLOG(@"tag str = %@", tag_str);
        /*==========Fetching dish tag items============*/
        NSMutableArray *tag_array = [[NSMutableArray alloc] init];
        NSMutableArray *tag_names = [[NSMutableArray alloc] init];
        
        if(tag_str != NULL && ![tag_str isEqualToString:@"<null>"] && [tag_str length] > 0) {
            
            NSString *val = [NSString stringWithFormat:@"0%@0", tag_str];
            
            ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
            NSString *query = [NSString stringWithFormat:@"select icon, name FROM tags WHERE id IN(%@) and icon!='' AND icon!='<null>' order by name ;", val];
            
            
            NSArray *records2 = [connection query: query];
            
            for(id dat in records2)
            {
                [tag_array addObject:[dat objectForKey:@"icon"]];
                [tag_names addObject:[dat objectForKey:@"name"]];
            }
        }
        /*============================================*/
        
        
        
        dishDic[@"cust"] = cust;
        dishDic[@"id"] = dishId;
        dishDic[@"name"] = dishname;
        dishDic[@"images"] = dishdata;
        dishDic[@"category"] = dishcat;
        dishDic[@"sub_category"] = dishsubcat;
        dishDic[@"price"] = dishprice;
        dishDic[@"price2"] = dishprice2;
        dishDic[@"description"] = dishdescription;
        dishDic[@"customisations"] = customizationdata;
        [dishDic setObject:tag_array forKey:@"tag_icons"];
        [dishDic setObject:tag_names forKey:@"tag_names"];
        
        
        [dishData addObject:dishDic];
    }
    
	return dishData;
}

-(NSMutableArray*)getDishKeyTag:(NSString*)catID tagA:(NSString*)tag1 tagB:(NSString*)tag2 tagC:(NSString*)tag3 
{
    NSString *statement;
    if([tag1 isEqualToString:@"-1"]&&[tag2 isEqualToString:@"-1"]&&[tag3 isEqualToString:@"-1"])
    {
        statement =[NSString stringWithFormat:@"SELECT * FROM Dishes where category = '%@'",catID];
    }
    else
    {
        statement =[NSString stringWithFormat:@"SELECT * FROM Dishes where category = '%@' and (tags like '%%,%@%,%%' or tags like '%%,%@%,%%' or tags like '%%,%@%,%%') ",catID,tag1,tag2,tag3];
    }
   	NSMutableArray *dishData=[[NSMutableArray alloc]init];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    //NSString *statement = [NSString stringWithFormat:@"SELECT * FROM Dishes where name like '%%%@%%%' or description like '%%%@%%%'",key,key];
   // NSString *beverageId=@"";
    NSArray *records = [connection query: statement];
  //  NSMutableArray *dishData=[[NSMutableArray alloc]init];
    for (id element in records){
        //NSString *optionId=(NSString*)[element objectForKey:@"id"];//[NSString
        // NSMutableDictionary *SkuDic=[NSMutableDictionary dictionary];
        //NSString *skuId=(NSString*)[element objectForKey:@"id"];//[NSString
        NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
        NSString *dishId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSString *dishname=(NSString*)[element objectForKey:@"name"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        NSString *libraryDirectory = [paths lastObject];
        NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,(NSString*)[element objectForKey:@"image"] ];
        NSString *dishdata = location;//[NSData dataWithContentsOfFile:location];
        
        // NSData *dishdata = [[NSData alloc] initWithBytes:sqlite3_column_blob(addStmt, 2) length:sqlite3_column_bytes(addStmt,2)];
        NSString *dishcat=(NSString*)[element objectForKey:@"category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
        NSString *dishsubcat=(NSString*)[element objectForKey:@"sub_category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
        NSString *dishprice=(NSString*)[element objectForKey:@"price"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,5)];
        NSString *dishprice2=(NSString*)[element objectForKey:@"price2"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,6)];
        NSString *dishdescription=(NSString*)[element objectForKey:@"description"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,7)];
        NSString *dishcustomization=(NSString*)[element objectForKey:@"customization"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,8)];
        //  enableClose =0;
        if ([dishcustomization isEqualToString:@"<null>"]) {
            dishcustomization=@"";
        }
        NSMutableArray *customizationdata= [self getCustomizationData:dishcustomization];
        // enableClose = 1;
        NSString *cust=@"0";
        if(![dishcustomization isEqualToString:@""])
        {
            cust=@"1";
        }
        dishDic[@"cust"] = cust;
        dishDic[@"id"] = dishId;
        dishDic[@"name"] = dishname;
        dishDic[@"images"] = dishdata;
        dishDic[@"category"] = dishcat;
        dishDic[@"sub_category"] = dishsubcat;
        dishDic[@"price"] = dishprice;
        dishDic[@"price2"] = dishprice2;
        dishDic[@"description"] = dishdescription;
        dishDic[@"customisations"] = customizationdata;
        
        [dishData addObject:dishDic];
    }
    
    	return dishData;
}

-(NSMutableArray*)getCategoryData
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = @"SELECT * FROM Categories order by sequence,name";
    // NSString *beverageId=@"";
    NSArray *records = [connection query: statement];
   NSMutableArray *CategoryData=[[NSMutableArray alloc]init];
    for (id element in records){
        //NSString *optionId=(NSString*)[element objectForKey:@"id"];//[NSString
        // NSMutableDictionary *SkuDic=[NSMutableDictionary dictionary];
        //NSString *skuId=(NSString*)[element objectForKey:@"id"];//[NSString
      //  NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
        //NSString *dishId=(NSString*)[element objectForKey:@"id"];//[NSString
        NSMutableDictionary *catDic=[NSMutableDictionary dictionary];
        NSString *catId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSString *catname=(NSString*)[element objectForKey:@"name"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSString *isBeverage=(NSString*)[element objectForKey:@"is_beverage"];
        
        catDic[@"id"] = catId;
        catDic[@"name"] = catname;
        catDic[@"is_beverage"] = isBeverage;
        
        if ([isBeverage intValue] ==1){
            [ShareableData sharedInstance].bevCat = [catId copy];
        }
        
        [CategoryData addObject:catDic];
    }

  	return CategoryData;
}

-(NSMutableArray*)getSubCategoryData:(NSString*)catId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"SELECT * FROM SubCategories where category_id='%@' order by sequence,name",catId];
    // NSString *beverageId=@"";
    NSArray *records = [connection query: statement];
    NSMutableArray *SubCategoryData=[[NSMutableArray alloc]init];
    for (id element in records){
        //NSString *optionId=(NSString*)[element objectForKey:@"id"];//[NSString
        NSMutableDictionary *subcatDic=[NSMutableDictionary dictionary];
        NSString *subcatId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSString *subcatname=(NSString*)[element objectForKey:@"name"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSString *catid=(NSString*)[element objectForKey:@"category_id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
        NSString *display=(NSString*)[element objectForKey:@"display"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
        
        subcatDic[@"id"] = subcatId;
        subcatDic[@"name"] = subcatname;
        subcatDic[@"category_id"] = catid;
        subcatDic[@"display"] = display;
        [SubCategoryData addObject:subcatDic];
    }
    	return SubCategoryData;
}

-(NSString*)getSubCategoryIdData:(NSString*)catId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"SELECT sub_category FROM Dishes where id ='%@'",catId];
    NSString *subId=@"";
    NSArray *records = [connection query: statement];
   // NSMutableArray *SubCategoryData=[[NSMutableArray alloc]init];
    for (id element in records){
        //NSString *optionId=(NSString*)[element objectForKey:@"id"];//[NSString
      subId=(NSString*)[element objectForKey:@"sub_category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
    }
    
	return subId;
}
-(NSString*)getComboSubCategoryIdData:(NSString*)catId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"SELECT sub_category FROM combos where id ='%@'",catId];
    NSString *subId=@"";
    NSArray *records = [connection query: statement];
    // NSMutableArray *SubCategoryData=[[NSMutableArray alloc]init];
    for (id element in records){
        //NSString *optionId=(NSString*)[element objectForKey:@"id"];//[NSString
        subId=[NSString stringWithFormat:@"%@", [element objectForKey:@"sub_category"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
    }
    
	return subId;
}

-(NSMutableArray*)getSubSubCategoryData:(NSString*)catId subCatId:(NSString*)subId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
    
 
    NSString *statement = [NSString stringWithFormat:@"SELECT sub_sub_category, (select name from sub_sub_categories Where sub_sub_categories.id=sub_sub_category order by sub_sub_categories.sequence ASC ) as name,sub_sub_categories.sequence FROM dishes, sub_sub_categories where category = %@ and sub_category = %@ and dishes.sub_sub_category = sub_sub_categories.id group by sub_sub_category order by sub_sub_categories.sequence ASC",catId,subId];
    //NSString *subId=@"";
    NSArray *records = [connection query: statement];
    NSMutableArray *SubCategoryData=[[NSMutableArray alloc]init];
    for (id element in records){
        //NSString *optionId=(NSString*)[element objectForKey:@"id"];//[NSString
        NSMutableDictionary *subcatDic=[NSMutableDictionary dictionary];
        NSString *subsubcatId=(NSString*)[element objectForKey:@"sub_sub_category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSString *subcatname=(NSString*)[element objectForKey:@"name"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        //NSString *catid=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
        //NSString *subCatId=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
        subcatDic[@"id"] = subsubcatId;
        subcatDic[@"name"] = subcatname;
        // [subcatDic setObject:catid forKey:@"category_id"];
        //[subcatDic setObject:subCatId forKey:@"sub_category_id"];
        [SubCategoryData addObject:subcatDic];
    }
    
    
   
	return SubCategoryData;
}



-(NSMutableArray *)getFirstImages:(NSMutableArray *)catIds
{
    NSMutableArray *dish_images=[[NSMutableArray alloc]init];

    for (NSString *cat_id in catIds) {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        
        NSString *statement = [NSString stringWithFormat:@"SELECT image FROM Categories where id='%@' ;",cat_id];
        NSArray *records = [connection query: statement];
        
        for (id element in records) {
            NSString *imageName=(NSString*)[element objectForKey:@"image"];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
            NSString *libraryDirectory = [paths lastObject];
            NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,imageName];
            ////NSLOG(@"location = %@", location);
            [dish_images addObject:location];
        }
    }
    
    
    return dish_images;
}
-(int)recordExists:(NSString *)statement
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
   // NSString *statement = [NSString stringWithFormat:@"SELECT * FROM SubCategories where category_id='%@' order by sequence,name LIMIT 1",catId];
    NSArray *records = [connection query: statement];
    NSString *subcatId = nil;
    
    if ([records count]>0){
        return 1;
    }else{
        return 0;
    }
    
   // return [subcatId intValue];
}


-(int)getFirstSubCategoryId:(NSString *)catId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
    NSString *statement = [NSString stringWithFormat:@"SELECT * FROM SubCategories where category_id='%@' order by sequence,name LIMIT 1",catId];
    NSArray *records = [connection query: statement];
    NSString *subcatId = nil;
    
    for (id element in records) {
        subcatId = (NSString*)[element objectForKey:@"id"];
    }
    
    return [subcatId intValue];
}


-(void)updateUIImages:(NSMutableArray *)array
{
    for(int i = 0; i < [array count]; i++)
        {
            
            NSString *str = [NSString stringWithFormat:@"%@", [array objectAtIndex:i]];
            NSString *pattern = [NSString stringWithFormat:@"_%@", [ShareableData appKey]];
            str = [TabSquareCommonClass filterString:str pattern:pattern];
            
            NSString *img = [NSString stringWithFormat:@"%@_%@.png", str, [ShareableData appKey]];
            NSString *img_name = [NSString stringWithFormat:@"%@%@", PRE_NAME, img];
            NSString *img_url = [NSString stringWithFormat:@"%@/app/webroot/img/product/app_image/%@", [ShareableData serverURL], img];
            
           {
                
               UIImage *imageData = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]]];
                
                CGSize size = imageData.size;
                BOOL hd_device = [TabSquareCommonClass isHDDevice];
                if(!hd_device) {
                    imageData = [TabSquareCommonClass resizeImage:imageData scaledToSize:CGSizeMake(size.width, size.height)];
                    }
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
                NSString *libraryDirectory = [paths lastObject]; ;
               NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,img_name];
               if (![[NSFileManager defaultManager] fileExistsAtPath:libraryDirectory]){
                   
                   NSError* error;
                   if(  [[NSFileManager defaultManager] createDirectoryAtPath:libraryDirectory withIntermediateDirectories:NO attributes:nil error:&error])
                       ;// success
                   else
                   {
                       //NSLOG(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);
                       NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
                   }
               }
               
                NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(imageData)];
                [data1 writeToFile:location atomically:YES];
                }
            }
}

-(void)saveImage:(NSString *)dishImage
{
    @autoreleasepool {
        NSString *nn = [NSString stringWithFormat:@"%@/img/product/%@", [ShareableData serverURL],dishImage];
        UIImage  *imageData = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nn]]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        NSString *libraryDirectory = [paths lastObject];
        NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,dishImage];//[libraryDirectory stringByAppendingString:@"/@%",dishImage];
            NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(imageData)];
        [data1 writeToFile:location atomically:YES];
    }
}

-(UIImage *)getImage:(NSString *)image_name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
    NSString *libraryDirectory = [paths lastObject];
    NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,image_name];

    UIImage *img = [UIImage imageWithContentsOfFile:location];
    
    return img;
}

-(void)deleteImage:(NSString *)image
{
    if (image == NULL || [image length]<1){
        
    }else{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
    NSString *libraryDirectory = [paths lastObject];
    NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,image];//
    
    [[NSFileManager defaultManager] removeItemAtPath: location error: NULL];
    }
}


-(void)updateComboValueData:(NSMutableDictionary *)data type:(NSString *)query_type
{
    /*
     "combo_id" = 18;
     group = 5;
     id = 23;
     "pre_select_option" = 0;
     "query_type" = insert;

     */
    
    NSString *combo_id = [data objectForKey:@"combo_id"];
    NSString *group = [data objectForKey:@"group"];
    NSString *_id = [data objectForKey:@"id"];
    NSString *pre_select_option = [data objectForKey:@"pre_select_option"];
    
    if ([query_type isEqualToString:@"0"]){
        
        if([self recordExists:[NSString stringWithFormat:@"SELECT * from combo_values where id = '%@' ;",_id ]]==0){
            query_type = @"0";
        }else{
            query_type = @"2";        }
    }
    
    if([query_type isEqualToString:@"0"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        
        NSString *statement = [NSString stringWithFormat:@"INSERT INTO combo_values(id, 'group', 'pre_select_option',combo_id) VALUES ( %@ , '%@' , '%@' , %@ );",_id, group, pre_select_option, combo_id];
        ////NSLOG(@"query = %@", statement);
        [connection execute: statement];
    }
    else if([query_type isEqualToString:@"2"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        
        NSString *statement = [NSString stringWithFormat:@"Update combo_values set combo_id = %@,group=  %@,pre_select_option = '%@' where id = %@ ;", combo_id, group, pre_select_option, _id];
        
        [connection execute: statement];
        
    }
    else if ([query_type isEqualToString:@"1"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        NSString *statement = [NSString stringWithFormat:@"delete from combo_values where id = %@;",_id];
        [connection execute: statement];
    }
}

-(void)updateComboData:(NSMutableDictionary *)data type:(NSString *)query_type
{
    NSString *dish_id = [data objectForKey:@"id"];
    NSString *category = [data objectForKey:@"category"];
    NSString *sub_category = [data objectForKey:@"sub_category"];
    NSString *sub_sub_category = [data objectForKey:@"sub_sub_category"];
    
    if(sub_sub_category == NULL)
        sub_sub_category = @"-1";
        
    NSString *name  = [data objectForKey:@"name"];
    NSString *image = [data objectForKey:@"image"];
    NSString *price = [data objectForKey:@"price"];
    NSString *group = [data objectForKey:@"group"];
    NSString *tags  = [data objectForKey:@"tags"];
    if([group length] == 0)
        group = @" ";
    NSString *description = [data objectForKey:@"description"];
    if([description length] == 0)
        description = @" ";

    NSString *on_update = [data objectForKey:@"on_update"];
    if ([query_type isEqualToString:@"0"]){
        
        if([self recordExists:[NSString stringWithFormat:@"SELECT * from combos where id = '%@' ;",dish_id ]]==0){
            query_type = @"0";
        }else{
            query_type = @"2";        }
    }

    if([query_type isEqualToString:@"0"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        
        
        name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
        description = [description stringByReplacingOccurrencesOfString:@"'" withString:@""];
        [self saveImage:image];
        
        NSString *statement = [NSString stringWithFormat:@"INSERT INTO combos(id,category,sub_category,'sub_sub_category','name','image','price','group','description','on_update', 'tags') VALUES ( %@ , %@ , %@ , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' );",dish_id,category,sub_category,sub_sub_category,name,image,price,group,description,on_update, tags];
        ////NSLOG(@"query = %@", statement);
        NSNumber *number = [connection execute: statement];
        ////NSLOG(@"status = %@", number);

    }
    else if([query_type isEqualToString:@"2"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        [self saveImage:image];
        
        NSString *statement = [NSString stringWithFormat:@"Update combos set category = %@,sub_category=  '%@',sub_sub_category = '%@',name='%@',image = '%@',price = '%@', 'group' = '%@',description='%@',on_update = '%@',tags='%@' where id = '%@' ;",category,sub_category,sub_sub_category,name,image,price,group,description,on_update, tags, dish_id];
        [connection execute: statement];

    }
    else if ([query_type isEqualToString:@"1"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        NSString *statement = [NSString stringWithFormat:@"delete from combos where id = %@;",dish_id ];
        [connection execute: statement];
        [self deleteImage:image];
    }
}



-(void)updateGroupData:(NSMutableDictionary *)data type:(NSString *)query_type
{
    NSString *dish_id = [data objectForKey:@"id"];
    NSString *name = [data objectForKey:@"name"];
    NSString *category = [data objectForKey:@"category"];
    //NSString *sub_category = [data objectForKey:@"sub_category"];
    //NSString *sub_sub_category = [data objectForKey:@"sub_sub_category"];
    NSString *selection_header = [data objectForKey:@"selection_header"];
    NSString *modified = [data objectForKey:@"modified"];
    NSString *created_by = [data objectForKey:@"created_by"];
    if ([query_type isEqualToString:@"0"]){
        
        if([self recordExists:[NSString stringWithFormat:@"SELECT * from groups where id = '%@' ;",dish_id ]]==0){
            query_type = @"0";
        }else{
            query_type = @"2";        }
    }
    
    
    if([query_type isEqualToString:@"0"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        
        name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
        selection_header = [selection_header stringByReplacingOccurrencesOfString:@"'" withString:@""];
        
        NSString *statement = [NSString stringWithFormat:@"INSERT INTO groups('id','name','category','selection_header','modified','created_by') VALUES ( %@ , '%@' , %@ , '%@' , '%@' , '%@' );",dish_id,name,category,selection_header,modified,created_by];
        ////NSLOG(@"query = %@", statement);
        NSNumber *number = [connection execute: statement];
        ////NSLOG(@"status = %@", number);
        
    }
    else if([query_type isEqualToString:@"2"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        
        NSString *statement = [NSString stringWithFormat:@"Update groups set name = '%@',category= '%@',selection_header = '%@', 'modified' = '%@',created_by='%@' where id = '%@' ;",name,category,selection_header,modified,created_by,dish_id];
        [connection execute: statement];
        
    }
    else if ([query_type isEqualToString:@"1"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        NSString *statement = [NSString stringWithFormat:@"delete from groups where id = %@;",dish_id ];
        [connection execute: statement];
    }
}


-(void)updateGroupDishData:(NSMutableDictionary *)data type:(NSString *)query_type
{
    NSString *id1 = [data objectForKey:@"id"];
    NSString *name = [data objectForKey:@"name"];
    NSString *image = [data objectForKey:@"image"];
    NSString *group_id = [data objectForKey:@"group_id"];
    NSString *dish_id = [data objectForKey:@"dish_id"];
    NSString *description = [data objectForKey:@"description"];
    
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    description = [description stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    if ([query_type isEqualToString:@"0"]){
        
        if([self recordExists:[NSString stringWithFormat:@"SELECT * from group_dishes where id = '%@' ;",id1 ]]==0){
            query_type = @"0";
        }else{
            query_type = @"2";        }
    }

    if([query_type isEqualToString:@"0"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        
        
        [self saveImage:image];
        
        NSString *statement = [NSString stringWithFormat:@"INSERT INTO group_dishes(id,'name','image',group_id,'dish_id','description') VALUES ( %@ , '%@' , '%@' , %@ , '%@', '%@');",id1,name,image,group_id,dish_id, description];
        
        ////NSLOG(@"query = %@", statement);
        NSNumber *status = [connection execute: statement];
        ////NSLOG(@"status >>= %@", status);
        
    }
    else if([query_type isEqualToString:@"2"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        [self saveImage:image];
        
        NSString *statement = [NSString stringWithFormat:@"Update group_dishes set name = '%@',image= '%@',group_id = %@,dish_id='%@',description = '%@' where id = %@ ;",name,image,group_id,dish_id, description, id1];
        ////NSLOG(@"query update = %@", statement);

        NSNumber *status = [connection execute: statement];
        ////NSLOG(@"status >>= %@", status);
        
    }
    else if ([query_type isEqualToString:@"1"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        NSString *statement = [NSString stringWithFormat:@"delete from group_dishes where id = %@;",dish_id ];
        [connection execute: statement];
        [self deleteImage:image];
    }
}





-(void)updateDishTagData:(NSMutableDictionary *)data type:(NSString *)query_type
{
    NSString *id1 = [data objectForKey:@"id"];
    NSString *name = [data objectForKey:@"name"];
    NSString *icon = [data objectForKey:@"icon"];
    
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    if ([query_type isEqualToString:@"0"]){
        
        if([self recordExists:[NSString stringWithFormat:@"SELECT * from tags where id = '%@' ;",id1 ]]==0){
            query_type = @"0";
        }else{
            query_type = @"2";        }
    }
    
    if([query_type isEqualToString:@"0"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        
        [self saveImage:icon];
        
        NSString *statement = [NSString stringWithFormat:@"INSERT INTO tags(id,'name','icon') VALUES ( %@ , '%@' , '%@');",id1,name,icon];
        
        ////NSLOG(@"query = %@", statement);
        [connection execute: statement];
        
    }
    else if([query_type isEqualToString:@"2"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        [self saveImage:icon];
        
        NSString *statement = [NSString stringWithFormat:@"Update tags set name = '%@',icon= '%@' where id = %@ ;", name, icon, id1];
        
        ////NSLOG(@"query update = %@", statement);
        [connection execute: statement];
        
    }
    else if ([query_type isEqualToString:@"1"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        NSString *statement = [NSString stringWithFormat:@"delete from tags where id = %@;",id1 ];
        [connection execute: statement];
        [self deleteImage:icon];
    }
}





-(NSMutableArray *)getCombodata:(NSString *)sub_cat_id
{
    NSMutableArray *combo = [[NSMutableArray alloc] init];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        
    NSString *statement = [NSString stringWithFormat:@"SELECT * FROM combos where sub_sub_category=%@ ;",sub_cat_id];
    
    NSArray *records = [connection query: statement];
        
    for (id element in records) {
        [combo addObject:element];
    }
    
    return combo;
}


-(NSMutableDictionary *)getComboDataById:(int)combo_id
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
    NSString *statement = [NSString stringWithFormat:@"SELECT * FROM combos where id=%d ;",combo_id];
    
    NSArray *records = [connection query: statement];
    
    NSString *groups = @"";

    if([records count] == 0)
        return nil;
    else
    {
        ZIMDbConnection *connection1 = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        NSString *statement1 = [NSString stringWithFormat:@"SELECT id FROM combo_values where combo_id=%d ;",combo_id];
        
        NSArray *group_records = [connection1 query: statement1];
        //////NSLOG(@"Log 22 grrep = %@", group_records);
        
        for(int i = 0; i < [group_records count]; i++)
        {
            NSMutableDictionary *dict = (NSMutableDictionary *)[group_records objectAtIndex:i];
            NSString *separator = (i == [group_records count]-1) ? @"": @"," ;
            groups = [NSString stringWithFormat:@"%@%@%@", groups, dict[@"id"], separator];
        }
    }
    
    data = [records objectAtIndex:0];
    [data setObject:groups forKey:@"group"];
    
    return data;
}

-(NSMutableDictionary *)getGroupDataById:(int)group_id
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
    NSString *statement = [NSString stringWithFormat:@"SELECT * FROM groups where id=%d ;",group_id];
    
    NSArray *records = [connection query: statement];
    
    if([records count] == 0)
        return nil;
    
    data = [records objectAtIndex:0];
    
    return data;

}


-(NSMutableArray *)getGroupDishDataById:(int)groupdish_id preSelected:(BOOL)status
{
    int combo_value_id = groupdish_id;
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM combo_values where id=%d ;",combo_value_id];
    /*
    if(status)
        query = [NSString stringWithFormat:@"SELECT * FROM group_dishes where group_id=%d AND is_selected=1 ;",groupdish_id];
     */
    
    NSArray *records1 = [connection query: query];
    NSArray *records  = nil;
    NSString *pre_status = @"0";
    
    if([records1 count] == 0)
        return nil;
    
    else
    {
        NSMutableDictionary *dict1 = (NSMutableDictionary *)records1[0];
        NSString *query1 = nil;
        //////NSLOG(@"pre selected  = %@", dict1[@"pre_select_option"]);
        
        query1 = [NSString stringWithFormat:@"SELECT * FROM groups where id=%@ ;", dict1[@"group"]];
        records = [connection query: query1];
    }
    
    for(int i = 0; i < [records count]; i++) {
        NSMutableDictionary *data_dict = [records objectAtIndex:i];
        //////NSLOG(@"data dict = %@", data_dict);
        [data_dict setObject:pre_status forKey:@"pre_select_option"];
        
        [data addObject:data_dict];
    }
    
    return data;

}


-(NSMutableArray *)getGroupDishes:(int)group_id
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM group_dishes where group_id=%d ;",group_id];

    NSArray *records = [connection query: query];
    
    if([records count] == 0)
        return nil;
    
    for(id dict in records)
    {
        [data addObject:dict];
    }
    
    return data;
}


@end
