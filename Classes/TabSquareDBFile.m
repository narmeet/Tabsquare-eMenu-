
#import "TabSquareDBFile.h"
#import "ZIMSqlSdk.h"
#import "ZIMDbSdk.h"
#import "TabSquareCommonClass.h"

#import "ShareableData.h"
#import "LanguageControler.h"

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

/*+ (sqlite3*) getNewDBConnection
{
	sqlite3 *newDBconnection;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
	NSString *documentsDirectory = [paths[0]stringByAppendingPathComponent:@"DataBase"];
	
	NSString *path = [documentsDirectory stringByAppendingPathComponent:DatabaseName];
	// Open the database. The database was prepared outside the application.
	if (sqlite3_open([path UTF8String], &newDBconnection) == SQLITE_OK)
	{
		DLog(@"Database Successfully Opened :)");
	} 
	else 
	{
		DLog(@"Error in opening database :(");
	}
	return newDBconnection; 
}*/

/*- (void) openBundleDatabaseConnection
{
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DatabaseName];	// Open the database. The database was prepared outside the application.
	if (sqlite3_open([defaultDBPath UTF8String], &dataBaseConnection) == SQLITE_OK)
	{
		DLog(@"Database Successfully Opened :)");
	} 
	else 
	{
		DLog(@"Error in opening database :(");
	}
	
}*/


-(void)GetBundleVersionNo
{
    
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSArray *records = [connection query: @"select version from  KinaraVersion  where id=1;"];
    
    for (id element in records){
        NewVersion = (NSString*)[element objectForKey:@"version"];
    }
	/*[self openDatabaseConnection];
	
	NSString *query;
	query = @"select version from  KinaraVersion  where id=1 ";  
	const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *addStmt;
	
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		while (sqlite3_step(addStmt) == SQLITE_ROW)
		{
			NewVersion= [NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
		}
	}
	sqlite3_finalize(addStmt);
	[self closeDatabaseConnection];*/
	
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
	/*[self openDatabaseConnection];
	NSString *query;
	query = @"select version from  KinaraVersion  where id=1 ";
	const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *addStmt;
	
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error:failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		while (sqlite3_step(addStmt) == SQLITE_ROW)
		{
			@try
			{
				OldVersion= [NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
			}
			@catch (NSException *exception) 
			{
				OldVersion=@"";
			}
		}
	}
	sqlite3_finalize(addStmt);
	[self closeDatabaseConnection];*/
	
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
    /*
    [self openDatabaseConnection];
    
	const char *sql =[[NSString stringWithFormat:@"select count(*) from kinaraVersion"]cStringUsingEncoding:NSUTF8StringEncoding];	
	sqlite3_stmt *addStmt = nil;		
	
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		while (sqlite3_step(addStmt) == SQLITE_ROW)
		{
			totalRecord=sqlite3_column_int(addStmt, 0);
		}
		
	}
	sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
	return totalRecord;
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//-(void)insertIntoCategoryTableWithRecord:(NSString*)Id categoryName:(NSString*)catName categorySequence:(NSString*)catSeq catImage:(NSString *)catImage

-(void)insertIntoCategoryTableWithRecord:(NSMutableDictionary *)dataitem
{
    NSString *Id= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *catName= [NSString stringWithFormat:@"%@",dataitem[@"name"]];
    NSString *catSeq= [NSString stringWithFormat:@"%@",dataitem[@"sequence"]];
    NSString *catImage = [NSString stringWithFormat:@"%@",dataitem[@"image"]];

    [self saveImage:catImage];
    catName = [catName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO Categories(id,name,sequence) VALUES (?,?,?);" withValues: Id,catName,catSeq, nil];
     NSString *statement = [NSString stringWithFormat:@"INSERT INTO Categories(id,name,sequence,'image', 'ch_name','fr_name','in_name','ja_name','ko_name') VALUES (%@,'%@',%@,'%@','%@','%@','%@','%@','%@');",Id,catName,catSeq,catImage, dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"]];
    ////NSLOG(@"query Logg 1 = %@", statement);
    
    [connection execute: statement];
    ////NSLOG(@"Logg 2");
    
    /*
    [self openDatabaseConnection];
    sqlite3_stmt *addStmt;
    NSString *query;
    query = @"INSERT INTO Categories(id,name,sequence) VALUES (?,?,?)";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	catid = [Id UTF8String];
    sqlite3_bind_text(addStmt,1,catid, -1, SQLITE_TRANSIENT);
    
    const char*	catname = [catName UTF8String];
    sqlite3_bind_text(addStmt,2, catname, -1, SQLITE_TRANSIENT);
    
    const char*	catsequence = [catSeq UTF8String];
    sqlite3_bind_text(addStmt,3,catsequence, -1, SQLITE_TRANSIENT);    
    
    if(SQLITE_DONE != sqlite3_step(addStmt)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(dataBaseConnection));
    }
    sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
    
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
   /* const char *sql =[[NSString stringWithFormat:@"CREATE INDEX sub_sub_category_index ON Dishes(name,category,sub_category,sub_sub_category ASC)"]cStringUsingEncoding:NSUTF8StringEncoding];
    const char *sql2 =[[NSString stringWithFormat:@"CREATE INDEX sub_category_index ON Dishes(category,sub_category,sub_sub_category ASC)"]cStringUsingEncoding:NSUTF8StringEncoding];
    const char *sql3 =[[NSString stringWithFormat:@"CREATE INDEX category_index ON Dishes(category,sub_category ASC)"]cStringUsingEncoding:NSUTF8StringEncoding];
    const char *sql4 =[[NSString stringWithFormat:@"CREATE INDEX sub_category_index_2 ON Dishes(sub_category,sub_sub_category ASC)"]cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *deleteStmt = nil;
    sqlite3_stmt *deleteStmt2 = nil;
    sqlite3_stmt *deleteStmt3 = nil;
    sqlite3_stmt *deleteStmt4 = nil;
	
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
    
    int success = sqlite3_step(deleteStmt);
    int success2 = sqlite3_step(deleteStmt2);
    int success3 = sqlite3_step(deleteStmt3);
    int success4 = sqlite3_step(deleteStmt4);
	DLog(@"success full Indexed==%d",success);
    DLog(@"success full Indexed2==%d",success2);
    DLog(@"success full Indexed3==%d",success3);
    DLog(@"success full Indexed4==%d",success4);
	sqlite3_reset(deleteStmt);
    sqlite3_reset(deleteStmt2);
    sqlite3_reset(deleteStmt3);
    sqlite3_reset(deleteStmt4);
	sqlite3_finalize(deleteStmt);
    sqlite3_finalize(deleteStmt2);
    sqlite3_finalize(deleteStmt3);
    sqlite3_finalize(deleteStmt4);*/

    
   // sqlite3_exec
}

-(void)deleteCategoryRecordTable:(NSString*)catid
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    //NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"delete from Categories where id = ?;" withValues: catid, nil];
    NSString *statement = [NSString stringWithFormat:@"delete from Categories where id = %@;",catid ];
    [connection execute: statement];
   /*
	const char *sql =[[NSString stringWithFormat:@"delete from Categories where id=%@",catid]cStringUsingEncoding:NSUTF8StringEncoding];	
	sqlite3_stmt *deleteStmt;
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &deleteStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
    
    int success = sqlite3_step(deleteStmt);
	DLog(@"success full deleted==%d",success);
	sqlite3_reset(deleteStmt);	
	sqlite3_finalize(deleteStmt);
    [self closeDatabaseConnection];
    */
}


//-(void)updateCategoryRecordTable:(NSString*)Id categoryName:(NSString*)catName categorySequence:(NSString*)catSeq catImage:(NSString *)catImage
-(void)updateCategoryRecordTable:(NSMutableDictionary *)dataitem
{
    
    NSString *Id= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *catName= [NSString stringWithFormat:@"%@",dataitem[@"name"]];
    NSString *catSeq= [NSString stringWithFormat:@"%@",dataitem[@"sequence"]];
    NSString *catImage = [NSString stringWithFormat:@"%@",dataitem[@"image"]];

    [self saveImage:catImage];
    catName = [catName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    //NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update Categories set name = ?,sequence = ? where id = ? ;" withValues: catName,catSeq,Id, nil];
    NSString *statement = [NSString stringWithFormat:@"Update Categories set name = '%@',sequence = %@,image = '%@', ch_name = '%@', fr_name = '%@', in_name = '%@', ja_name = '%@', ko_name = '%@' where id = %@ ;",catName,catSeq, catImage, dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"],Id ];
    [connection execute: statement];
    
    
   /* NSString *query;
    
    query = @"Update Categories set name=?,sequence=? where id=?";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	catname = [catName UTF8String];
    sqlite3_bind_text(addStmt,1, catname, -1, SQLITE_TRANSIENT);    
    
    const char*	catsequence = [catSeq UTF8String];
    sqlite3_bind_text(addStmt,2,catsequence, -1, SQLITE_TRANSIENT);     
    
    const char*	catid = [Id UTF8String];
    sqlite3_bind_text(addStmt,3,catid, -1, SQLITE_TRANSIENT);
    
    int success = sqlite3_step(addStmt);
    // DLog(@"success full inserted==%d",success);
    // Because we want to reuse the addStmt, we "reset" it instead of "finalizing" it.
    sqlite3_finalize(addStmt);
    
    if(success == SQLITE_ERROR) 
    {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
[self closeDatabaseConnection];*/
}

//-(void)insertIntoSubCategoryTableWithRecord:(NSString*)Id SubcategoryName:(NSString*)subcatName categoryId:(NSString*)catId subCatSequence:(NSString*)catSeq displayType:(NSString*)display catImage:(NSString *)catImage isHidden:(NSString *)isHidden0
-(void)insertIntoSubCategoryTableWithRecord:(NSMutableDictionary *)dataitem
{
    
    
    NSString *Id= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *subcatName= [NSString stringWithFormat:@"%@",dataitem[@"name"]];
    NSString *catId= [NSString stringWithFormat:@"%@",dataitem[@"category_id"]];
    NSString *catSeq= [NSString stringWithFormat:@"%@",dataitem[@"sequence"]];
    NSString *display=[NSString stringWithFormat:@"%@",dataitem[@"display"]];
    NSString *catImage = [NSString stringWithFormat:@"%@",dataitem[@"image"]];
    NSString *isHidden = [NSString stringWithFormat:@"%@", dataitem[@"is_hidden"]];

    [self saveImage:catImage];
    
    if(isHidden == NULL || [isHidden isEqualToString:@"<null>"] ||[isHidden length] == 0)
        isHidden = @"0";
    
    subcatName = [subcatName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
  //  NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO SubCategories(id,name,category_id,sequence,display) VALUES ( ? , ? , ? , ? , ? ) ;" withValues: Id,subcatName,catId,catSeq,display, nil];
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO SubCategories(id,name,category_id,sequence,display,'image', 'ch_name','fr_name','in_name','ja_name','ko_name',is_hidden) VALUES ( %@ , '%@' , %@ , %@ , %@, '%@', '%@','%@','%@','%@','%@','%@') ;",Id,subcatName,catId,catSeq,display,catImage, dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"], isHidden];
    [connection execute: statement];
    
    /*
    sqlite3_stmt *addStmt;
    NSString *query;
    query = @"INSERT INTO SubCategories(id,name,category_id,sequence,display) VALUES (?,?,?,?,?)";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	subid = [Id UTF8String];
    sqlite3_bind_text(addStmt,1,subid, -1, SQLITE_TRANSIENT);
    
    const char*	subcatname = [subcatName UTF8String];
    sqlite3_bind_text(addStmt,2, subcatname, -1, SQLITE_TRANSIENT);
    
    const char*	categoryId = [catId UTF8String];
    sqlite3_bind_text(addStmt,3, categoryId, -1, SQLITE_TRANSIENT);    
    
    const char*	catsequence = [catSeq UTF8String];
    sqlite3_bind_text(addStmt,4,catsequence, -1, SQLITE_TRANSIENT);       
    
    const char*	displayType = [display UTF8String];
    sqlite3_bind_text(addStmt,5,displayType, -1, SQLITE_TRANSIENT);       
    
    
    if(SQLITE_DONE != sqlite3_step(addStmt))
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(dataBaseConnection));
    sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
}

-(void)deleteSubCategoryRecordTable:(NSString*)Subcatid
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"delete from SubCategories where id = ? ;" withValues: Subcatid, nil];
     NSString *statement = [NSString stringWithFormat:@"delete from SubCategories where id = %@ ;",Subcatid ];
    [connection execute: statement];
    
    
	/*const char *sql =[[NSString stringWithFormat:@"delete from SubCategories where id=%@",Subcatid]cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *deleteStmt;
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &deleteStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
    
    int success = sqlite3_step(deleteStmt);
	DLog(@"success full deleted==%d",success);
	sqlite3_reset(deleteStmt);	
	sqlite3_finalize(deleteStmt);
    [self closeDatabaseConnection];*/
}

//-(void)updateSubCategoryRecordTable:(NSString*)Id SubcategoryName:(NSString*)subcatName categoryId:(NSString*)catId subCatSequence:(NSString*)catSeq displayType:(NSString*)display catImage:(NSString *)catImage isHidden:(NSString *)isHidden
-(void)updateSubCategoryRecordTable:(NSMutableDictionary *)dataitem
{
    
    NSString *Id= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *subcatName= [NSString stringWithFormat:@"%@",dataitem[@"name"]];
    NSString *catId= [NSString stringWithFormat:@"%@",dataitem[@"category_id"]];
    NSString *catSeq= [NSString stringWithFormat:@"%@",dataitem[@"sequence"]];
    NSString *display=[NSString stringWithFormat:@"%@",dataitem[@"display"]];
    NSString *catImage = [NSString stringWithFormat:@"%@",dataitem[@"image"]];
    NSString *isHidden = [NSString stringWithFormat:@"%@", dataitem[@"is_hidden"]];

    [self saveImage:catImage];
    subcatName = [subcatName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
  //  NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update SubCategories set name = ?,category_id = ?,sequence = ?,display = ? where id = ? ;" withValues: subcatName,catId,catSeq,display,Id, nil];
     NSString *statement = [NSString stringWithFormat:@"Update SubCategories set name = '%@',category_id = %@,sequence = %@,display = %@,image = '%@', ch_name = '%@', fr_name = '%@', in_name = '%@', ja_name = '%@', ko_name = '%@' ,is_hidden = '%@' where id = %@ ;",subcatName,catId,catSeq,display,catImage, dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"], isHidden,Id ];
    [connection execute: statement];
    
  /*  NSString *query;
    
    query = @"Update SubCategories set name=?,category_id=?,sequence=?,display=? where id=?";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	subcatname = [subcatName UTF8String];
    sqlite3_bind_text(addStmt,1, subcatname, -1, SQLITE_TRANSIENT);
    
    const char*	categoryId = [catId UTF8String];
    sqlite3_bind_text(addStmt,2, categoryId, -1, SQLITE_TRANSIENT);    
    
    const char*	catsequence = [catSeq UTF8String];
    sqlite3_bind_text(addStmt,3,catsequence, -1, SQLITE_TRANSIENT);     
    
    const char*	displayType = [display UTF8String];
    sqlite3_bind_text(addStmt,4,displayType, -1, SQLITE_TRANSIENT);       
    
    const char*	subid = [Id UTF8String];
    sqlite3_bind_text(addStmt,5,subid, -1, SQLITE_TRANSIENT);
    
    int success = sqlite3_step(addStmt);
    // DLog(@"success full inserted==%d",success);
    // Because we want to reuse the addStmt, we "reset" it instead of "finalizing" it.
    sqlite3_finalize(addStmt);
    
    if(success == SQLITE_ERROR) 
    {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    [self closeDatabaseConnection];*/
    
}

//-(void)insertIntoSubSubCategoryTableWithRecord:(NSString*)Id SubSubcategoryName:(NSString*)subcatName categoryId:(NSString*)catId subCatId:(NSString*)subcatId sequence:(NSString*)seq catImage:(NSString *)catImage
-(void)insertIntoSubSubCategoryTableWithRecord:(NSMutableDictionary *)dataitem
{
    
    NSString *Id= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *subcatName= [NSString stringWithFormat:@"%@",dataitem[@"name"]];
    NSString *catId= [NSString stringWithFormat:@"%@",dataitem[@"category_id"]];
    NSString *subcatId= [NSString stringWithFormat:@"%@",dataitem[@"sub_category_id"]];
    NSString *seq = [NSString stringWithFormat:@"%@",dataitem[@"sequence"]];
    NSString *catImage = [NSString stringWithFormat:@"%@",dataitem[@"image"]];

    [self saveImage:catImage];
    subcatName = [subcatName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
  //  NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO Sub_Sub_Categories(id,name,category_id,sub_category_id) VALUES ( ? , ? , ? , ? ) ;" withValues: Id,subcatName,catId,subcatId, nil];
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO Sub_Sub_Categories(id,name,category_id,sub_category_id,sequence,'image', 'ch_name','fr_name','in_name','ja_name','ko_name') VALUES ( %@ , '%@' , %@ , %@ , %@, '%@','%@','%@','%@','%@','%@') ;",Id,subcatName,catId,subcatId,seq,catImage, dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"]];
    [connection execute: statement];
    
   /* sqlite3_stmt *addStmt;
    NSString *query;
    query = @"INSERT INTO Sub_Sub_Categories(id,name,category_id,sub_category_id) VALUES (?,?,?,?)";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	subid = [Id UTF8String];
    sqlite3_bind_text(addStmt,1,subid, -1, SQLITE_TRANSIENT);
    
    const char*	subcatname = [subcatName UTF8String];
    sqlite3_bind_text(addStmt,2, subcatname, -1, SQLITE_TRANSIENT);
    
    const char*	categoryId = [catId UTF8String];
    sqlite3_bind_text(addStmt,3, categoryId, -1, SQLITE_TRANSIENT);    
    
    const char*	subcategoryid = [subcatId UTF8String];
    sqlite3_bind_text(addStmt,4,subcategoryid, -1, SQLITE_TRANSIENT);       
    
    if(SQLITE_DONE != sqlite3_step(addStmt))
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(dataBaseConnection));
    sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
    
}

-(void)deleteSubSubCategoryRecordTable:(NSString*)Subcatid
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
  //  NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"delete from Sub_Sub_Categories where id = ? ;" withValues: Subcatid, nil];
     NSString *statement = [NSString stringWithFormat:@"delete from Sub_Sub_Categories where id = %@ ;",Subcatid ];
    [connection execute: statement];
    
	/*const char *sql =[[NSString stringWithFormat:@"delete from Sub_Sub_Categories where id=%@",Subcatid]cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *deleteStmt = nil;		
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &deleteStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
    
    int success = sqlite3_step(deleteStmt);
	DLog(@"success full deleted==%d",success);
	sqlite3_reset(deleteStmt);	
	sqlite3_finalize(deleteStmt);
    [self closeDatabaseConnection];*/
}

//-(void)updateSubSubCategoryRecordTable:(NSString*)Id SubSubcategoryName:(NSString*)subcatName categoryId:(NSString*)catId subCatId:(NSString*)subcatId sequence:(NSString*)seq catImage:(NSString *)catImage
-(void)updateSubSubCategoryRecordTable:(NSMutableDictionary *)dataitem
{
    
    NSString *Id= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *subcatName= [NSString stringWithFormat:@"%@",dataitem[@"name"]];
    NSString *catId= [NSString stringWithFormat:@"%@",dataitem[@"category_id"]];
    NSString *subcatId= [NSString stringWithFormat:@"%@",dataitem[@"sub_category_id"]];
    NSString *seq = [NSString stringWithFormat:@"%@",dataitem[@"sequence"]];
    NSString *catImage = [NSString stringWithFormat:@"%@",dataitem[@"image"]];

    subcatName = [subcatName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    [self saveImage:catImage];
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update Sub_Sub_Categories set name = ? ,category_id = ? ,sub_category_id= ? where id = ? ;" withValues: subcatName,catId,subcatId,Id, nil];
     NSString *statement = [NSString stringWithFormat:@"Update Sub_Sub_Categories set name = '%@' ,category_id = %@ ,sub_category_id= %@ , sequence = %@,image = '%@', ch_name = '%@', fr_name = '%@', in_name = '%@', ja_name = '%@', ko_name = '%@'  where id = %@ ;",subcatName,catId,subcatId,seq,catImage, dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"], Id ];
    [connection execute: statement];
    
   /* NSString *query;
    
    query = @"Update Sub_Sub_Categories set name=?,category_id=?,sub_category_id=? where id=?";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	subcatname = [subcatName UTF8String];
    sqlite3_bind_text(addStmt,1, subcatname, -1, SQLITE_TRANSIENT);
    
    const char*	categoryId = [catId UTF8String];
    sqlite3_bind_text(addStmt,2, categoryId, -1, SQLITE_TRANSIENT);    
    
    const char*	subCategoryId = [subcatId UTF8String];
    sqlite3_bind_text(addStmt,3,subCategoryId, -1, SQLITE_TRANSIENT);     
    
    const char*	subid = [Id UTF8String];
    sqlite3_bind_text(addStmt,4,subid, -1, SQLITE_TRANSIENT);
    
    int success = sqlite3_step(addStmt);
    // DLog(@"success full inserted==%d",success);
    // Because we want to reuse the addStmt, we "reset" it instead of "finalizing" it.
    sqlite3_finalize(addStmt);
    
    if(success == SQLITE_ERROR) 
    {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    [self closeDatabaseConnection];*/
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
    
	/*NSString *query;
    NSString *versionName=@"Kinara1";
	query = @"INSERT INTO KinaraVersion(version,datetime) VALUES (?,?)";  
	const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *addStmt;
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}*/
   /* NSDate *today=[NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:today];
    const char*	version = [versionName UTF8String];
	sqlite3_bind_text(addStmt,1, version, -1, SQLITE_TRANSIENT);
    
    const char*	date = [dateString UTF8String];
	sqlite3_bind_text(addStmt,2, date, -1, SQLITE_TRANSIENT);    
    
    if(SQLITE_DONE != sqlite3_step(addStmt))
		
    NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(dataBaseConnection));
	sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
}

//-(void)insertIntoDishTableWithRecord:(NSString*)DishId DishName:(NSString*)name DishImage:(NSString*)imagedata CategoryId:(NSString*)category SubCategoryId:(NSString*)subcategory price:(NSString*)price price2:(NSString*)price2 description:(NSString*) description customization:(NSString*)cust itemtags:(NSString*)tags DishSequence:(NSString*)dishSeq SubSubCatId:(NSString*)sub_sub_id
-(void)insertIntoDishTableWithRecord:(NSMutableDictionary *)dataitem
{
    
    NSString *DishId= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *name= [NSString stringWithFormat:@"%@",dataitem[@"name"]];
    NSString *imagedata= [NSString stringWithFormat:@"%@",dataitem[@"images"]];
    NSString *sub_sub_id=[NSString stringWithFormat:@"%@",dataitem[@"sub_sub_category"]];
    NSString *dishSeq= [NSString stringWithFormat:@"%@",dataitem[@"sequence"]];

    NSString *category= [NSString stringWithFormat:@"%@",dataitem[@"category"]];
    NSString *subcategory= [NSString stringWithFormat:@"%@",dataitem[@"sub_category"]];
    NSString *price= [NSString stringWithFormat:@"%@",dataitem[@"price"]];
    NSString *price2= [NSString stringWithFormat:@"%@",dataitem[@"price2"]];
    NSString *description= [NSString stringWithFormat:@"%@",dataitem[@"description"]];
    NSString *cust= [NSString stringWithFormat:@"%@",dataitem[@"customisations"]];
    NSString *tags= [NSString stringWithFormat:@"%@",dataitem[@"tags"]];

    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO Dishes(id,name,image,category,sub_category,price,price2,description,customization,tags,sequence,sub_sub_category) VALUES ( ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? ) ;" withValues: DishId,name,imagedata,category,subcategory,price,price2,description,cust,tags,dishSeq,sub_sub_id, nil];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    description = [description stringByReplacingOccurrencesOfString:@"'" withString:@""];
    tags = [tags stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO Dishes(id,name,image,category,sub_category,price,price2,description,customization,tags,sequence,sub_sub_category, 'ch_name','fr_name','in_name','ja_name','ko_name', 'ch_description','fr_description','in_description','ja_description','ko_description') VALUES ( '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@') ;",DishId,name,imagedata,category,subcategory,price,price2,description,cust,tags,dishSeq,sub_sub_id, dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"], dataitem[@"ch_description"], dataitem[@"fr_description"], dataitem[@"in_description"], dataitem[@"ja_description"], dataitem[@"ko_description"]];
    
    [connection execute: statement];
    
   /* sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
    @try {
        NSString *query;
        query = @"INSERT INTO Dishes(id,name,image,category,sub_category,price,price2,description,customization,tags,sequence,sub_sub_category) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";  
        const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
        
        
        if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
        {
            DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
        }
        
        const char*	dishid = [DishId UTF8String];
        sqlite3_bind_text(addStmt,1, dishid, -1, SQLITE_TRANSIENT);
        
        const char*	dishname = [name UTF8String];
        sqlite3_bind_text(addStmt,2, dishname, -1, SQLITE_TRANSIENT);
        
        
        sqlite3_bind_blob(addStmt, 3, [imagedata bytes], [imagedata length], NULL);
        
        const char*	cat = [category UTF8String];
        sqlite3_bind_text(addStmt,4, cat, -1, SQLITE_TRANSIENT);
        
        const char*	subcat = [subcategory UTF8String];
        sqlite3_bind_text(addStmt,5, subcat, -1, SQLITE_TRANSIENT);    
        
        const char*	dishprice = [price UTF8String];
        sqlite3_bind_text(addStmt,6, dishprice, -1, SQLITE_TRANSIENT);
        
        const char*	dishprice2 = [price2 UTF8String];
        sqlite3_bind_text(addStmt,7, dishprice2, -1, SQLITE_TRANSIENT);    
        
        const char*	dishdescription = [description UTF8String];
        sqlite3_bind_text(addStmt,8, dishdescription, -1, SQLITE_TRANSIENT);
        
        const char*	custId = [cust UTF8String];
        sqlite3_bind_text(addStmt,9,custId, -1, SQLITE_TRANSIENT);    
        
        const char*	itemtag = [tags UTF8String];
        sqlite3_bind_text(addStmt,10,itemtag, -1, SQLITE_TRANSIENT);            
        
        const char*	dishsequence = [dishSeq UTF8String];
        sqlite3_bind_text(addStmt,11,dishsequence, -1, SQLITE_TRANSIENT);         
        
        const char*	subsubid = [sub_sub_id UTF8String];
        sqlite3_bind_text(addStmt,12,subsubid, -1, SQLITE_TRANSIENT); 
        
        if(SQLITE_DONE != sqlite3_step(addStmt))
            
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(dataBaseConnection));
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        sqlite3_finalize(addStmt);
    }
    [self closeDatabaseConnection];*/
}

-(void)deleteDishRecordTable:(NSString*)Dishid
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"delete from Dishes where id = ? ;" withValues: Dishid, nil];
     NSString *statement = [NSString stringWithFormat:@"delete from Dishes where id = '%@' ;",Dishid ];
    [connection execute: statement];
    
	/*const char *sql =[[NSString stringWithFormat:@"delete from Dishes where id=%@",Dishid]cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *deleteStmt;
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &deleteStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
    
    sqlite3_step(deleteStmt);
	//DLog(@"success full deleted==%d",success);
	sqlite3_reset(deleteStmt);	
	sqlite3_finalize(deleteStmt);
[self closeDatabaseConnection];*/
}

//-(void)updateDishImageRecordTable:(NSString*)DishId DishName:(NSString*)name DishImage:(NSString*)imagedata CategoryId:(NSString*)category SubCategoryId:(NSString*)subcategory price:(NSString*)price price2:(NSString*)price2 description:(NSString*)description customization:(NSString*)cust itemtags:(NSString*)tag DishSequence:(NSString*)dishSeq SubSubCatId:(NSString*)sub_sub_id
-(void)updateDishImageRecordTable:(NSMutableDictionary *)dataitem
{
    NSString *DishId= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *name= [NSString stringWithFormat:@"%@",dataitem[@"name"]];
    NSString *imagedata= [NSString stringWithFormat:@"%@",dataitem[@"images"]];
    NSString *sub_sub_id=[NSString stringWithFormat:@"%@",dataitem[@"sub_sub_category"]];
    NSString *dishSeq= [NSString stringWithFormat:@"%@",dataitem[@"sequence"]];
    
    NSString *category= [NSString stringWithFormat:@"%@",dataitem[@"category"]];
    NSString *subcategory= [NSString stringWithFormat:@"%@",dataitem[@"sub_category"]];
    NSString *price= [NSString stringWithFormat:@"%@",dataitem[@"price"]];
    NSString *price2= [NSString stringWithFormat:@"%@",dataitem[@"price2"]];
    NSString *description= [NSString stringWithFormat:@"%@",dataitem[@"description"]];
    NSString *cust= [NSString stringWithFormat:@"%@",dataitem[@"customisations"]];
    NSString *tag= [NSString stringWithFormat:@"%@",dataitem[@"tags"]];

    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update Dishes set name = ?,image = ?,category= ? ,sub_category = ?,price = ?,price2 = ?,description = ?,customization = ?,tags = ?,sequence = ?,sub_sub_category = ? where id = ? ;" withValues: name,imagedata,category,subcategory,price,price2,description,cust,tag,dishSeq,sub_sub_id,DishId, nil];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    description = [description stringByReplacingOccurrencesOfString:@"'" withString:@""];
    tag = [tag stringByReplacingOccurrencesOfString:@"'" withString:@""];
     NSString *statement = [NSString stringWithFormat:@"Update Dishes set name = '%@',image = '%@',category= '%@' ,sub_category = '%@',price = '%@',price2 = '%@',description = '%@',customization = '%@',tags = '%@',sequence = '%@',sub_sub_category = '%@', ch_name = '%@', fr_name = '%@', in_name = '%@', ja_name = '%@', ko_name = '%@', ch_description = '%@', fr_description = '%@', in_description = '%@', ja_description = '%@', ko_description = '%@' where id = '%@' ;",name,imagedata,category,subcategory,price,price2,description,cust,tag,dishSeq,sub_sub_id, dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"], dataitem[@"ch_description"], dataitem[@"fr_description"], dataitem[@"in_description"], dataitem[@"ja_description"], dataitem[@"ko_description"],DishId ];
    [connection execute: statement];
    
   /* NSString *query;
    
    query = @"Update Dishes set name=?,image=?,category=?,sub_category=?,price=?,price2=?,description=?,customization=?,tags=?,sequence=?,sub_sub_category=? where  id=?";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	dishname = [name UTF8String];
    sqlite3_bind_text(addStmt,1, dishname, -1, SQLITE_TRANSIENT);
    
    
    sqlite3_bind_blob(addStmt, 2, [imagedata bytes], [imagedata length], NULL);
    
    const char*	cat = [category UTF8String];
    sqlite3_bind_text(addStmt,3, cat, -1, SQLITE_TRANSIENT);
    
    const char*	subcat = [subcategory UTF8String];
    sqlite3_bind_text(addStmt,4, subcat, -1, SQLITE_TRANSIENT);    
    
    const char*	dishprice = [price UTF8String];
    sqlite3_bind_text(addStmt,5, dishprice, -1, SQLITE_TRANSIENT);
    
    const char*	dishprice2 = [price2 UTF8String];
    sqlite3_bind_text(addStmt,6, dishprice2, -1, SQLITE_TRANSIENT);    
    
    const char*	dishdescription = [description UTF8String];
    sqlite3_bind_text(addStmt,7, dishdescription, -1, SQLITE_TRANSIENT);
    
    const char*	custId = [cust UTF8String];
    sqlite3_bind_text(addStmt,8,custId, -1, SQLITE_TRANSIENT);    

    const char*	itemtag = [tag UTF8String];
    sqlite3_bind_text(addStmt,9,itemtag, -1, SQLITE_TRANSIENT);       
    
    const char*	dishsequence = [dishSeq UTF8String];
    sqlite3_bind_text(addStmt,10,dishsequence, -1, SQLITE_TRANSIENT);             
    
    const char*	subsubid = [sub_sub_id UTF8String];
    sqlite3_bind_text(addStmt,11,subsubid, -1, SQLITE_TRANSIENT); 
    
    const char*	dishid = [DishId UTF8String];
    sqlite3_bind_text(addStmt,12, dishid, -1, SQLITE_TRANSIENT);
    
    
    
    
    int success= sqlite3_step(addStmt);
    
    //DLog(@"success full inserted==%d",success);
    // Because we want to reuse the addStmt, we "reset" it instead of "finalizing" it.
    sqlite3_finalize(addStmt);
    
    if(success == SQLITE_ERROR) 
    {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    [self closeDatabaseConnection];*/
}

//-(void)updateDishRecordTable:(NSString*)DishId DishName:(NSString*)name  CategoryId:(NSString*)category SubCategoryId:(NSString*)subcategory price:(NSString*)price price2:(NSString*)price2 description:(NSString*)description customization:(NSString*)cust itemtags:(NSString*)tag DishSequence:(NSString*)dishSeq SubSubCatId:(NSString*)sub_sub_id
-(void)updateDishRecordTable:(NSMutableDictionary *)dataitem
{
    
    NSString *DishId= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *name= [NSString stringWithFormat:@"%@",dataitem[@"name"]];
    NSString *sub_sub_id=[NSString stringWithFormat:@"%@",dataitem[@"sub_sub_category"]];
    NSString *dishSeq= [NSString stringWithFormat:@"%@",dataitem[@"sequence"]];
    
    NSString *category= [NSString stringWithFormat:@"%@",dataitem[@"category"]];
    NSString *subcategory= [NSString stringWithFormat:@"%@",dataitem[@"sub_category"]];
    NSString *price= [NSString stringWithFormat:@"%@",dataitem[@"price"]];
    NSString *price2= [NSString stringWithFormat:@"%@",dataitem[@"price2"]];
    NSString *description= [NSString stringWithFormat:@"%@",dataitem[@"description"]];
    NSString *cust= [NSString stringWithFormat:@"%@",dataitem[@"customisations"]];
    NSString *tag= [NSString stringWithFormat:@"%@",dataitem[@"tags"]];

    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update Dishes set name = ?,category= ? ,sub_category = ?,price = ?,price2 = ?,description = ?,customization = ?,tags = ?,sequence = ?,sub_sub_category = ? where id = ? ;" withValues: name,category,subcategory,price,price2,description,cust,tag,dishSeq,sub_sub_id,DishId, nil];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    description = [description stringByReplacingOccurrencesOfString:@"'" withString:@""];
    tag = [tag stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *statement = [NSString stringWithFormat:@"Update Dishes set name = '%@',category= '%@' ,sub_category = '%@',price = '%@',price2 = '%@',description = '%@',customization = '%@',tags = '%@',sequence = '%@',sub_sub_category = '%@', ch_name = '%@', fr_name = '%@', in_name = '%@', ja_name = '%@', ko_name = '%@', ch_description = '%@', fr_description = '%@', in_description = '%@', ja_description = '%@', ko_description = '%@' where id = '%@' ;",name,category,subcategory,price,price2,description,cust,tag,dishSeq,sub_sub_id, dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"], dataitem[@"ch_description"], dataitem[@"fr_description"], dataitem[@"in_description"], dataitem[@"ja_description"], dataitem[@"ko_description"],DishId ];
    [connection execute: statement];
    
    
   /* NSString *query;
    
    query = @"Update Dishes set name=?,category=?,sub_category=?,price=?,price2=?,description=?,customization=?,tags=?,sequence=?,sub_sub_category=? where id=?";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *addStmt ;
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	dishname = [name UTF8String];
    sqlite3_bind_text(addStmt,1, dishname, -1, SQLITE_TRANSIENT);
    
    const char*	cat = [category UTF8String];
    sqlite3_bind_text(addStmt,2, cat, -1, SQLITE_TRANSIENT);
    
    const char*	subcat = [subcategory UTF8String];
    sqlite3_bind_text(addStmt,3, subcat, -1, SQLITE_TRANSIENT);    
    
    const char*	dishprice = [price UTF8String];
    sqlite3_bind_text(addStmt,4, dishprice, -1, SQLITE_TRANSIENT);
    
    const char*	dishprice2 = [price2 UTF8String];
    sqlite3_bind_text(addStmt,5, dishprice2, -1, SQLITE_TRANSIENT);    
    
    const char*	dishdescription = [description UTF8String];
    sqlite3_bind_text(addStmt,6, dishdescription, -1, SQLITE_TRANSIENT);
    
    const char*	custId = [cust UTF8String];
    sqlite3_bind_text(addStmt,7,custId, -1, SQLITE_TRANSIENT);    
    
    const char*	itemtag = [tag UTF8String];
    sqlite3_bind_text(addStmt,8,itemtag, -1, SQLITE_TRANSIENT);           
    
    const char*	dishsequence = [dishSeq UTF8String];
    sqlite3_bind_text(addStmt,9,dishsequence, -1, SQLITE_TRANSIENT);  
    
    const char*	subsubid = [sub_sub_id UTF8String];
    sqlite3_bind_text(addStmt,10,subsubid, -1, SQLITE_TRANSIENT); 
    
    const char*	dishid = [DishId UTF8String];
    sqlite3_bind_text(addStmt,11, dishid, -1, SQLITE_TRANSIENT);
    
    int success= sqlite3_step(addStmt);
    
    //DLog(@"success full inserted==%d",success);
    // Because we want to reuse the addStmt, we "reset" it instead of "finalizing" it.
    sqlite3_finalize(addStmt);
    
    if(success == SQLITE_ERROR) 
    {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    [self closeDatabaseConnection];*/
}

//-(void)insertIntoCustomizationTableWithRecord:(NSString*)custId CustName:(NSString*)name Custheader:(NSString*)headertxt custType:(NSString*)type totalSelection:(NSString*)selection
-(void)insertIntoCustomizationTableWithRecord:(NSMutableDictionary *)dataitem
{
    
    NSString *custId= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *name= [NSString stringWithFormat:@"%@",dataitem[@"name"]];
    NSString *headertxt= [NSString stringWithFormat:@"%@",dataitem[@"header_text"]];
    NSString *type= [NSString stringWithFormat:@"%@",dataitem[@"type"]];
    NSString *selection= [NSString stringWithFormat:@"%@",dataitem[@"no_of_selection"]];

    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    headertxt = [headertxt stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO Customization(id,name,header_text,type,no_of_selection, ch_name,fr_name,in_name,ja_name,ko_name, ch_header_text,fr_header_text,in_header_text,ja_header_text,ko_header_text) VALUES ( ? , ? , ? , ? , ? ,? , ? , ? , ? , ? ,? , ? , ? , ? , ? ) ;" withValues: custId,name,headertxt,type,selection, dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"], dataitem[@"ch_header_text"], dataitem[@"fr_header_text"], dataitem[@"in_header_text"], dataitem[@"ja_header_text"], dataitem[@"ko_header_text"], nil];
    [connection execute: statement];
    
  /*  sqlite3_stmt *addStmt;
    NSString *query;
    query = @"INSERT INTO Customization(id,name,header_text,type,no_of_selection) VALUES (?,?,?,?,?)";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	custid = [custId UTF8String];
    sqlite3_bind_text(addStmt,1, custid, -1, SQLITE_TRANSIENT);
    
    const char*	custname = [name UTF8String];
    sqlite3_bind_text(addStmt,2, custname, -1, SQLITE_TRANSIENT);
    
    const char*	header = [headertxt UTF8String];
    sqlite3_bind_text(addStmt,3,header, -1, SQLITE_TRANSIENT);
    
    const char*	custtype = [type UTF8String];
    sqlite3_bind_text(addStmt,4, custtype, -1, SQLITE_TRANSIENT);    
    
    const char*	totalselection = [selection UTF8String];
    sqlite3_bind_text(addStmt,5, totalselection, -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(addStmt))
        
    NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(dataBaseConnection));
    sqlite3_finalize(addStmt);
[self closeDatabaseConnection];*/
}

-(void)deleteCustomizationRecordTable:(NSString*)Custid
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"delete from Customization where id = ? ;" withValues: Custid, nil];
    NSString *statement = [NSString stringWithFormat:@"delete from Customization where id = '%@' ;",Custid ];
    [connection execute: statement];
    
	/*const char *sql =[[NSString stringWithFormat:@"delete from Customization where id=%@",Custid]cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *deleteStmt;
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &deleteStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
    
    sqlite3_step(deleteStmt);
	//DLog(@"success full deleted==%d",success);
	sqlite3_reset(deleteStmt);	
	sqlite3_finalize(deleteStmt);
    [self closeDatabaseConnection];*/
}

//-(void)updateCustomizationRecordTable:(NSString*)custId CustName:(NSString*)name Custheader:(NSString*)headertxt custType:(NSString*)type totalSelection:(NSString*)selection
-(void)updateCustomizationRecordTable:(NSMutableDictionary *)dataitem
{
    
    NSString *custId= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *name= [NSString stringWithFormat:@"%@",dataitem[@"name"]];
    NSString *headertxt= [NSString stringWithFormat:@"%@",dataitem[@"header_text"]];
    NSString *type= [NSString stringWithFormat:@"%@",dataitem[@"type"]];
    NSString *selection= [NSString stringWithFormat:@"%@",dataitem[@"no_of_selection"]];

    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
  //  NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update Customization set name = ? ,header_text = ? ,type = ? ,no_of_selection = ? where id = ? ;" withValues: name,headertxt,type,selection,custId, nil];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    headertxt = [headertxt stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *statement = [NSString stringWithFormat:@"Update Customization set name = '%@' ,header_text = '%@' ,type = '%@' ,no_of_selection = '%@', ch_name = '%@', fr_name = '%@', in_name = '%@', ja_name = '%@', ko_name = '%@', ch_header_text = '%@', fr_header_text = '%@', in_header_text = '%@', ja_header_text = '%@', ko_header_text = '%@' where id = '%@' ;",name,headertxt,type,selection, dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"], dataitem[@"ch_header_text"], dataitem[@"fr_header_text"], dataitem[@"in_header_text"], dataitem[@"ja_header_text"], dataitem[@"ko_header_text"],custId ];
    [connection execute: statement];
    
   /* NSString *query;
    
    query = @"Update Customization set name=?,header_text=?,type=?,no_of_selection=? where id=?";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	custname = [name UTF8String];
    sqlite3_bind_text(addStmt,1, custname, -1, SQLITE_TRANSIENT);
    
    const char*	header = [headertxt UTF8String];
    sqlite3_bind_text(addStmt,2,header, -1, SQLITE_TRANSIENT);
    
    const char*	custtype = [type UTF8String];
    sqlite3_bind_text(addStmt,3, custtype, -1, SQLITE_TRANSIENT);    
    
    const char*	totalselection = [selection UTF8String];
    sqlite3_bind_text(addStmt,4, totalselection, -1, SQLITE_TRANSIENT);    

    const char*	custid = [custId UTF8String];
    sqlite3_bind_text(addStmt,5, custid, -1, SQLITE_TRANSIENT);    
    
    int success = sqlite3_step(addStmt);
    //DLog(@"success full inserted==%d",success);
    // Because we want to reuse the addStmt, we "reset" it instead of "finalizing" it.
    sqlite3_finalize(addStmt);
    
    if(success == SQLITE_ERROR) 
    {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    [self closeDatabaseConnection];*/
}

//-(void)insertIntoOptionTableWithRecord:(NSString*)optionId optionName:(NSString*)name optionprice:(NSString*)price custId:(NSString*)custid optionQty:(NSString*)qty
-(void)insertIntoOptionTableWithRecord:(NSMutableDictionary *)dataitem
{
    NSString *optionId= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *name= [NSString stringWithFormat:@"%@",dataitem[@"name"]];
    NSString *price= [NSString stringWithFormat:@"%@",dataitem[@"price"]];
    NSString *custid= [NSString stringWithFormat:@"%@",dataitem[@"customisation_id"]];
    NSString *qty= [NSString stringWithFormat:@"%@",dataitem[@"quantity"]];

    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO CustOptions(id,name,price,customization_id,quantity, 'ch_name','fr_name','in_name','ja_name','ko_name') VALUES ( '%@' , '%@' , '%@' , '%@' , '%@' ,'%@','%@','%@','%@','%@') ;",optionId,name,price,custid,qty , dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"]];//, [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO CustOptions(id,name,price,customization_id,quantity) VALUES ( ? , ? , ? , ? , ? ) ;" withValues: optionId,name,price,custid,qty, nil];
    [connection execute: statement];
    
    
  /*  sqlite3_stmt *addStmt ;
    NSString *query;
    query = @"INSERT INTO CustOptions(id,name,price,customization_id,quantity) VALUES (?,?,?,?,?)";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    [self openDatabaseConnection];
    
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	optionid = [optionId UTF8String];
    sqlite3_bind_text(addStmt,1, optionid, -1, SQLITE_TRANSIENT);
    
    const char*	optionname = [name UTF8String];
    sqlite3_bind_text(addStmt,2, optionname, -1, SQLITE_TRANSIENT);
    
    const char*	optionprice = [price UTF8String];
    sqlite3_bind_text(addStmt,3,optionprice, -1, SQLITE_TRANSIENT);
    
    const char*	custId = [custid UTF8String];
    sqlite3_bind_text(addStmt,4, custId, -1, SQLITE_TRANSIENT);    
    
    const char*	quantity = [qty UTF8String];
    sqlite3_bind_text(addStmt,5, quantity, -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(addStmt))
        
    NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(dataBaseConnection));
    sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
}

-(void)deleteOptionRecordTable:(NSString*)optionid
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"delete from CustOptions where id = '%@' ;",optionid ];//[ZIMSqlPreparedStatement preparedStatement: @"delete from CustOptions where id = ? ;" withValues: optionid, nil];
    [connection execute: statement];
    
    
	/*const char *sql =[[NSString stringWithFormat:@"delete from CustOptions where id=%@",optionid]cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *deleteStmt;
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &deleteStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
    
    sqlite3_step(deleteStmt);
	//DLog(@"success full deleted==%d",success);
	sqlite3_reset(deleteStmt);	
	sqlite3_finalize(deleteStmt);
    [self closeDatabaseConnection];*/
}

//-(void)updateOptionRecordTable:(NSString*)optionId optionName:(NSString*)name optionprice:(NSString*)price custId:(NSString*)custid optionQty:(NSString*)qty
-(void)updateOptionRecordTable:(NSMutableDictionary *)dataitem
{
    
    NSString *optionId= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *name= [NSString stringWithFormat:@"%@",dataitem[@"name"]];
    NSString *price= [NSString stringWithFormat:@"%@",dataitem[@"price"]];
    NSString *custid= [NSString stringWithFormat:@"%@",dataitem[@"customisation_id"]];
    NSString *qty= [NSString stringWithFormat:@"%@",dataitem[@"quantity"]];

    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update CustOptions set name = ? ,price = ? ,customization_id = ? ,quantity = ? where id = ? ;" withValues: name,price,custid,qty,optionId, nil];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *statement = [NSString stringWithFormat:@"Update CustOptions set name = '%@' ,price = '%@' ,customization_id = '%@' ,quantity = '%@', ch_name = '%@', fr_name = '%@', in_name = '%@', ja_name = '%@', ko_name = '%@'  where id = '%@' ;",name,price,custid,qty, dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"],optionId ];
    [connection execute: statement];
    
 /*   NSString *query;
    
    query = @"Update CustOptions set name=?,price=?,customization_id=?,quantity=? where id=?";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	optionname = [name UTF8String];
    sqlite3_bind_text(addStmt,1, optionname, -1, SQLITE_TRANSIENT);
    
    const char*	optionprice = [price UTF8String];
    sqlite3_bind_text(addStmt,2,optionprice, -1, SQLITE_TRANSIENT);
    
    const char*	custId = [custid UTF8String];
    sqlite3_bind_text(addStmt,3, custId, -1, SQLITE_TRANSIENT);    
    
    const char*	quantity = [qty UTF8String];
    sqlite3_bind_text(addStmt,4, quantity, -1, SQLITE_TRANSIENT);
    
    const char*	optionid = [optionId UTF8String];
    sqlite3_bind_text(addStmt,5, optionid, -1, SQLITE_TRANSIENT);
    
    int success = sqlite3_step(addStmt);
   // DLog(@"success full inserted==%d",success);
    // Because we want to reuse the addStmt, we "reset" it instead of "finalizing" it.
    sqlite3_finalize(addStmt);
    
    if(success == SQLITE_ERROR) 
    {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    [self closeDatabaseConnection];*/
}


//-(void)insertIntoContainersTableWithRecord:(NSString*)containerId ContainerName:(NSString*)name
-(void)insertIntoContainersTableWithRecord:(NSMutableDictionary *)dataitem
{
    
    NSString *containerId= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *name= [NSString stringWithFormat:@"%@",dataitem[@"name"]];

    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO Containers(id,name) VALUES ( ? , ? ) ;" withValues: containerId,name, nil];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO Containers(id,name, 'ch_name','fr_name','in_name','ja_name','ko_name') VALUES ( '%@' , '%@' ,'%@','%@','%@','%@','%@') ;",containerId,name , dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"]];
   [connection execute: statement];
    
   /* sqlite3_stmt *addStmt ;
    NSString *query;
    query = @"INSERT INTO Containers(id,name) VALUES (?,?)";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    [self openDatabaseConnection];
    
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	contid = [containerId UTF8String];
    sqlite3_bind_text(addStmt,1, contid, -1, SQLITE_TRANSIENT);
    
    const char*	contname = [name UTF8String];
    sqlite3_bind_text(addStmt,2, contname, -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(addStmt))
        
    NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(dataBaseConnection));
    sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
    
}

-(void)deleteContainersRecordTable:(NSString*)Containerid
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    //NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"delete from Containers where id = ? ;" withValues: Containerid, nil];
    NSString *statement = [NSString stringWithFormat:@"delete from Containers where id = '%@' ;",Containerid ];
    [connection execute: statement];
    
	/*const char *sql =[[NSString stringWithFormat:@"delete from Containers where id=%@",Containerid]cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *deleteStmt;
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &deleteStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
    
    sqlite3_step(deleteStmt);
	//DLog(@"success full deleted==%d",success);
	sqlite3_reset(deleteStmt);	
	sqlite3_finalize(deleteStmt);
    [self closeDatabaseConnection];*/
}

//-(void)updateContainersRecordTable:(NSString*)containerId ContainerName:(NSString*)name
-(void)updateContainersRecordTable:(NSMutableDictionary *)dataitem
{
    NSString *containerId= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *name= [NSString stringWithFormat:@"%@",dataitem[@"name"]];

    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
  //  NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update Containers set name = ? where id = ? ;" withValues: name,containerId, nil];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
      NSString *statement = [NSString stringWithFormat:@"Update Containers set name = '%@', ch_name = '%@', fr_name = '%@', in_name = '%@', ja_name = '%@', ko_name = '%@' where id = '%@' ;",name, dataitem[@"ch_name"], dataitem[@"fr_name"], dataitem[@"in_name"], dataitem[@"ja_name"], dataitem[@"ko_name"], containerId ];
    [connection execute: statement];
    
   /*NSString *query;
    
    query = @"Update Containers set name=? where id=?";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	containername = [name UTF8String];
    sqlite3_bind_text(addStmt,1,containername, -1, SQLITE_TRANSIENT);
    
    const char*	containerid = [containerId UTF8String];
    sqlite3_bind_text(addStmt,2,containerid, -1, SQLITE_TRANSIENT);
    
    int success = sqlite3_step(addStmt);
    //DLog(@"success full inserted==%d",success);
    // Because we want to reuse the addStmt, we "reset" it instead of "finalizing" it.
    sqlite3_finalize(addStmt);
    
    if(success == SQLITE_ERROR) 
    {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    [self closeDatabaseConnection];*/
}


//-(void)insertIntoBeverageContainerTableWithRecord:(NSString*)Id beverageId:(NSString*)beverageid containerId:(NSString*)containerid price:(NSString*)price
-(void)insertIntoBeverageContainerTableWithRecord:(NSMutableDictionary *)dataitem
{
    NSString *Id= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *beverageid= [NSString stringWithFormat:@"%@",dataitem[@"beverage_id"]];
    NSString *containerid= [NSString stringWithFormat:@"%@",dataitem[@"container_id"]];
    NSString *price= [NSString stringWithFormat:@"%@",dataitem[@"price"]];

    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO BeverageContainers(id,beverage_id,container_id,price) VALUES ( ? , ? , ? , ? ) ;" withValues: Id,beverageid,containerid,price, nil];
    NSString *statement = [NSString stringWithFormat:@"INSERT INTO BeverageContainers(id,beverage_id,container_id,price) VALUES ( '%@' , '%@' , '%@' , '%@' ) ;",Id,beverageid,containerid,price ];
    [connection execute: statement];
    
    /*sqlite3_stmt *addStmt;
    NSString *query;
    query = @"INSERT INTO BeverageContainers(id,beverage_id,container_id,price) VALUES (?,?,?,?)";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	bevid = [Id UTF8String];
    sqlite3_bind_text(addStmt,1,bevid, -1, SQLITE_TRANSIENT);
    
    const char*	beverageId = [beverageid UTF8String];
    sqlite3_bind_text(addStmt,2, beverageId, -1, SQLITE_TRANSIENT);
    
    const char*	containerId = [containerid UTF8String];
    sqlite3_bind_text(addStmt,3,containerId, -1, SQLITE_TRANSIENT);
    
    const char*	bevprice = [price UTF8String];
    sqlite3_bind_text(addStmt,4, bevprice, -1, SQLITE_TRANSIENT);    
    
    if(SQLITE_DONE != sqlite3_step(addStmt))
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(dataBaseConnection));
    sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
}

-(void)deleteBeverageContainerRecordTable:(NSString*)bevid
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"delete from BeverageContainers where id = ? ;" withValues: bevid, nil];
    NSString *statement = [NSString stringWithFormat:@"delete from BeverageContainers where id = '%@' ;",bevid ];
    [connection execute: statement];
    
    
	/*const char *sql =[[NSString stringWithFormat:@"delete from BeverageContainers where id=%@",bevid]cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *deleteStmt;		
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &deleteStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
    
    int success = sqlite3_step(deleteStmt);
	DLog(@"success full deleted==%d",success);
	sqlite3_reset(deleteStmt);	
	sqlite3_finalize(deleteStmt);
    [self closeDatabaseConnection];*/
}

//-(void)updateBeverageContainerRecordTable:(NSString*)Id beverageId:(NSString*)beverageid containerId:(NSString*)containerid price:(NSString*)price
-(void)updateBeverageContainerRecordTable:(NSMutableDictionary *)dataitem
{
    NSString *Id= [NSString stringWithFormat:@"%@",dataitem[@"id"]];
    NSString *beverageid= [NSString stringWithFormat:@"%@",dataitem[@"beverage_id"]];
    NSString *containerid= [NSString stringWithFormat:@"%@",dataitem[@"container_id"]];
    NSString *price= [NSString stringWithFormat:@"%@",dataitem[@"price"]];

    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
   // NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update BeverageContainers set beverage_id = ? ,container_id = ? ,price = ? where id = ? ;" withValues: beverageid,containerid,price,Id, nil];
    NSString *statement = [NSString stringWithFormat:@"Update BeverageContainers set beverage_id = '%@' ,container_id = '%@' ,price = '%@' where id = '%@' ;",beverageid,containerid,price,Id ];
    [connection execute: statement];
    
   /* NSString *query;
    
    query = @"Update BeverageContainers set beverage_id=?,container_id=?,price=? where id=?";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	beverageId = [beverageid UTF8String];
    sqlite3_bind_text(addStmt,1, beverageId, -1, SQLITE_TRANSIENT);
    
    const char*	containerId = [containerid UTF8String];
    sqlite3_bind_text(addStmt,2,containerId, -1, SQLITE_TRANSIENT);
    
    const char*	bevprice = [price UTF8String];
    sqlite3_bind_text(addStmt,3, bevprice, -1, SQLITE_TRANSIENT);    
    
    const char*	bevid = [Id UTF8String];
    sqlite3_bind_text(addStmt,4,bevid, -1, SQLITE_TRANSIENT);
    
    
    int success = sqlite3_step(addStmt);
   // DLog(@"success full inserted==%d",success);
    // Because we want to reuse the addStmt, we "reset" it instead of "finalizing" it.
    sqlite3_finalize(addStmt);
    
    if(success == SQLITE_ERROR) 
    {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    [self closeDatabaseConnection];*/
}

-(void)insertIntoHomeImageTableWithRecord:(NSString*)imageid imageName:(NSString*)name imageData:(NSData*)imagedata 
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO HomeImage(id,name,image) VALUES ( ? , ? , ? ) ;" withValues: imageid,name,imagedata, nil];
    [connection execute: statement];
    
   /* sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
    @try {
        NSString *query;
        query = @"INSERT INTO HomeImage(id,name,image) VALUES (?,?,?)";  
        const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
        
        
        if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
        {
            DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
        }
        
        const char*	imageId = [imageid UTF8String];
        sqlite3_bind_text(addStmt,1, imageId, -1, SQLITE_TRANSIENT);
        
        const char*	imagename = [name UTF8String];
        sqlite3_bind_text(addStmt,2, imagename, -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_blob(addStmt, 3, [imagedata bytes], [imagedata length], NULL);
        
        if(SQLITE_DONE != sqlite3_step(addStmt))
            
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(dataBaseConnection));
    }
    @catch (NSException *exception) 
    {
        
    }
    @finally {
        sqlite3_finalize(addStmt);
    }
    [self closeDatabaseConnection];*/
}

-(void)updateHomeImageRecordTable:(NSString*)Id imageData:(NSData*)imagedata
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update HomeImage set image = ? where id = ? ;" withValues: imagedata,Id, nil];
    [connection execute: statement];
    
    
   /* NSString *query;
    
    query = @"Update HomeImage set image=? where id=?";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    sqlite3_bind_blob(addStmt, 1, [imagedata bytes], [imagedata length], NULL);
    
    const char*	imageid = [Id UTF8String];
    sqlite3_bind_text(addStmt,2,imageid, -1, SQLITE_TRANSIENT);
    
    int success = sqlite3_step(addStmt);
   
    sqlite3_finalize(addStmt);
    
    if(success == SQLITE_ERROR) 
    {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    [self closeDatabaseConnection];*/
}
-(void)insertHomeCategoryRecordTable:homeid categoryId:(NSString*)catId subcategoryId:(NSString*)SubcatId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"insert into HomePage (id,category,subcategory) values ( ? , ? , ? );" withValues: homeid,catId,SubcatId, nil];
    [connection execute: statement];
    
    /* NSString *query;
     
     query = @"Update HomePage set category=?,subcategory=? where id=?";
     const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
     sqlite3_stmt *addStmt;
     [self openDatabaseConnection];
     if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK)
     {
     DLog(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
     }
     
     const char*	catid = [catId UTF8String];
     sqlite3_bind_text(addStmt,1,catid, -1, SQLITE_TRANSIENT);
     
     const char*	subcatid = [SubcatId UTF8String];
     sqlite3_bind_text(addStmt,2,subcatid, -1, SQLITE_TRANSIENT);
     
     const char*	homeid = [Id UTF8String];
     sqlite3_bind_text(addStmt,3,homeid, -1, SQLITE_TRANSIENT);
     
     int success = sqlite3_step(addStmt);
     
     sqlite3_finalize(addStmt);
     
     if(success == SQLITE_ERROR)
     {
     NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(dataBaseConnection));
     }
     [self closeDatabaseConnection];*/
}

-(void)updateHomeCategoryRecordTable:(NSString*)Id categoryId:(NSString*)catId subcategoryId:(NSString*)SubcatId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [ZIMSqlPreparedStatement preparedStatement: @"Update HomePage set category = ? ,subcategory = ? where id = ? ;" withValues: catId,SubcatId,Id, nil];
    [connection execute: statement];
    
   /* NSString *query;
    
    query = @"Update HomePage set category=?,subcategory=? where id=?";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    const char*	catid = [catId UTF8String];
    sqlite3_bind_text(addStmt,1,catid, -1, SQLITE_TRANSIENT);
    
    const char*	subcatid = [SubcatId UTF8String];
    sqlite3_bind_text(addStmt,2,subcatid, -1, SQLITE_TRANSIENT);
    
    const char*	homeid = [Id UTF8String];
    sqlite3_bind_text(addStmt,3,homeid, -1, SQLITE_TRANSIENT);
   
    int success = sqlite3_step(addStmt);
    
    sqlite3_finalize(addStmt);
    
    if(success == SQLITE_ERROR) 
    {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    [self closeDatabaseConnection];*/
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
    
    
    
    
    /*const char *sql =[[NSString stringWithFormat:@"SELECT * FROM HomePage where id=%@",HomeId]cStringUsingEncoding:NSUTF8StringEncoding];
	NSMutableArray *HomeCategoryData=[[NSMutableArray alloc]init];
    
	sqlite3_stmt *addStmt;
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		while (sqlite3_step(addStmt) == SQLITE_ROW)
		{
            NSMutableDictionary *homecatDic=[NSMutableDictionary dictionary];
            NSString *catid=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];	
            NSString *subid=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
           
            
            homecatDic[@"cat"] = catid;
            homecatDic[@"subcat"] = subid;
            [HomeCategoryData addObject:homecatDic];
            
        }
    }
	sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
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
    
    
   /* const char *sql =[[NSString stringWithFormat:@"select image from HomeImage where id=%@",imageId]cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *imageData;
    sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		while (sqlite3_step(addStmt) == SQLITE_ROW)
        {
           imageData = [[NSData alloc] initWithBytes:sqlite3_column_blob(addStmt, 0) length:sqlite3_column_bytes(addStmt,0)]; 
                              
        }
            
            
    }
        
    sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
	return imageData;
}



-(void)updateKinaraVersionDate:(NSString *)time
{
    int versionid=1;
    
    //NSDate *today=[NSDate date];
    // NSDate *curr=[today dateByAddingTimeInterval:9000];
    
    /*
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:today];
    // const char*	date = [dateString UTF8String];
    */
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
    NSString *statement = [NSString stringWithFormat:@"Update KinaraVersion set datetime = '%@' where id = %d ;",time,versionid];//[ZIMSqlPreparedStatement preparedStatement: @"Update KinaraVersion set datetime = '?' where id = ? ;" withValues: dateString,1, nil];
    [connection execute: statement];

    
    /*NSString *query;
    int versionid=1;
    query = @"Update KinaraVersion set datetime=? where id=?";  
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
    
    if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
    {
        DLog(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    
    NSDate *today=[NSDate date];
   // NSDate *curr=[today dateByAddingTimeInterval:9000];
   
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:today];
    const char*	date = [dateString UTF8String];
	sqlite3_bind_text(addStmt,1, date, -1, SQLITE_TRANSIENT);        
    sqlite3_bind_int(addStmt, 2, versionid);
    
    int success = sqlite3_step(addStmt);
    
    //DLog(@"success full inserted==%d",success);
    // Because we want to reuse the addStmt, we "reset" it instead of "finalizing" it.
    sqlite3_finalize(addStmt);
    
    if(success == SQLITE_ERROR) 
    {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(dataBaseConnection));
    }
    [self closeDatabaseConnection];*/
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
    
   /* NSString* datetime=@"";
    const char *sql =[[NSString stringWithFormat:@"select datetime from KinaraVersion"]cStringUsingEncoding:NSUTF8StringEncoding];	
	sqlite3_stmt *addStmt ;
	[self openDatabaseConnection];
	
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		while (sqlite3_step(addStmt) == SQLITE_ROW)
		{
			datetime=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        }
    }
   
	sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
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
        NSString *optionName=(NSString*)[element objectForKey:[LanguageControler activeLanguage:@"name"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
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
    
    /*
    const char *sql =[[NSString stringWithFormat:@"select * from CustOptions where customization_id in(%@)",custId]cStringUsingEncoding:NSUTF8StringEncoding];
	NSMutableArray *optionData=[[NSMutableArray alloc]init];
    
	sqlite3_stmt *addStmt;
    [self openDatabaseConnection];
	
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		while (sqlite3_step(addStmt) == SQLITE_ROW)
		{
			NSString *optionId=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];	
            NSString *optionName=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
            NSString *optionPrice=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
            NSString *optionCustid=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
            NSString *optionQuantity=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
             NSMutableDictionary *optionDic=[NSMutableDictionary dictionary];           
            optionDic[@"id"] = optionId;
            optionDic[@"name"] = optionName;
            optionDic[@"price"] = optionPrice;
            optionDic[@"customisation_id"] = optionCustid;
            optionDic[@"quantity"] = optionQuantity;
            [optionData addObject:optionDic];
        }
	}
	sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
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
        NSString *custname=(NSString*)[element objectForKey:[LanguageControler activeLanguage:@"name"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSString *custheader=(NSString*)[element objectForKey:[LanguageControler activeLanguage:@"header_text"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
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
    /*
    const char *sql =[[NSString stringWithFormat:@"select * from Customization where id in(%@)",custId]cStringUsingEncoding:NSUTF8StringEncoding];
	//NSMutableArray *custData=[[NSMutableArray alloc]init];
    NSMutableArray *finalCust=[[NSMutableArray alloc]init];
  	sqlite3_stmt *addStmt ;
    [self openDatabaseConnection];
	
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
        
		while (sqlite3_step(addStmt) == SQLITE_ROW)
		{
           // NSMutableArray *customization=[[NSMutableArray alloc]init];
           // [custData removeAllObjects];
			NSString *custId=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];	
            NSString *custname=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
            NSString *custheader=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
            NSString *custtype=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
            NSString *custselection=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
            NSMutableDictionary *custDic=[NSMutableDictionary dictionary];
            custDic[@"id"] = custId;
            custDic[@"name"] = custname;
            custDic[@"header_text"] = custheader;
            custDic[@"type"] = custtype;
            custDic[@"no_of_selection"] = custselection;
            enableClose = 0;
          //  [custData addObject:custDic];
             NSMutableArray *optionData=[self getOptionData:custId];
            enableClose = 1;
            NSMutableDictionary *cust=[NSMutableDictionary dictionary];
            cust[@"Customisation"] = custDic;
            cust[@"Option"] = optionData;
            
            //[customization addObject:cust];
           [finalCust addObject:cust];         
            //DLog(@"%@",finalCust);
        }
        
        
        
        
	}
	sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
	return finalCust;
}

////////////// before sahid code...............///////////

//-(NSMutableArray*)getDishData:(NSString*)catId subCatId:(NSString*)subCatId
//{
//    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
//    NSString* statement;
//   /* if ([subCatId isEqualToString:@"48"]){
//        statement = [ZIMSqlPreparedStatement preparedStatement: @"select * from dishes, sub_sub_categories where dishes.sub_sub_category = sub_sub_categories.id and category = ? and sub_category = ? order by sub_sub_categories.sequence ASC;" withValues: catId,subCatId, nil];
//    }else{*/
//    
//    /*
//     (SELECT col1,col2,col3, from dishes) UNION ALL (select col1,col2,col3 from combos)
//     */
//    
//    //statement = [ZIMSqlPreparedStatement preparedStatement: @"select * from Dishes where category = ? and sub_category = ? order by sub_sub_category,name;" withValues: catId,subCatId, nil];
//    
//    //(SELECT id, name,image, description from dishes WHERE category=? AND sub_category=? AND sub_sub_category=?) UNION ALL (SELECT id, name,image, description from combos WHERE category=? AND sub_category=? AND sub_sub_category=?)
//    
//    //NSString *query = @"SELECT id, name,image, category, sub_category, price, description, sub_sub_category from dishes WHERE category=? AND sub_category=? UNION ALL SELECT id, name,image, category, sub_category, price, description, sub_sub_category from combos WHERE category=? AND sub_category=? order by sub_sub_category,name;";
//    
//    NSString *query = @"SELECT id, name,image, category, sub_category, price, description, sub_sub_category, tags,0 AS jugaad from dishes WHERE category=? AND sub_category=? UNION ALL SELECT id, name,image, category, sub_category, price, description, sub_sub_category, tags,1 AS jugad from combos WHERE category=? AND sub_category=? order by sub_sub_category,name;";
//    
//    if([catId intValue] == 8)
//        statement = [ZIMSqlPreparedStatement preparedStatement: @"select * from Dishes where category = ? and sub_category = ? order by sub_sub_category,name;" withValues: catId,subCatId, nil];
//    else
//        statement = [ZIMSqlPreparedStatement preparedStatement:query  withValues: catId,subCatId, catId, subCatId, nil];
//    
//   // }
//    NSArray *records = [connection query: statement];
//    
//    
//    if([catId intValue] == 8)
//    {
//        NSMutableArray *dishData=[[NSMutableArray alloc]init];
//        for (id element in records){
//            
//            
//            NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
//            NSString *dishId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
//            NSString *dishname=(NSString*)[element objectForKey:@"name"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
//            NSString *libraryDirectory = paths[0];
//            NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,(NSString*)[element objectForKey:@"image"] ];
//            NSString *dishdata = location;//[UIImage imageNamed:location]; //[NSData dataWithContentsOfFile:location];//(NSString*)[element objectForKey:@"image"];//[NSData dataWithBytes:sqlite3_column_blob(addStmt, 2) length:sqlite3_column_bytes(addStmt,2)];
//            NSString *dishcat=(NSString*)[element objectForKey:@"category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
//            NSString *dishsubcat=(NSString*)[element objectForKey:@"sub_category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
//            NSString *dishprice=(NSString*)[element objectForKey:@"price"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,5)];
//            NSString *dishprice2=(NSString*)[element objectForKey:@"price2"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,6)];
//            NSString *dishdescription=(NSString*)[element objectForKey:@"description"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,7)];
//            NSString *dishcustomization=(NSString*)[element objectForKey:@"customization"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,8)];
//            NSString *dishSubSubId=(NSString*)[element objectForKey:@"sub_sub_category"];//[NSString
//            if ([dishcustomization isEqualToString:@"<null>" ]) {
//                
//                dishcustomization =@"";
//            }
//            NSMutableArray *customizationdata= [self getCustomizationData:dishcustomization];
//            // enableClose = 1;
//            
//            NSString *tag_str = (NSString *)[element objectForKey:@"tags"];
//            
//            /*==========Fetching dish tag items============*/
//            NSMutableArray *tag_array = [[NSMutableArray alloc] init];
//            if(tag_str != NULL && ![tag_str isEqualToString:@"<null>"] && [tag_str length] > 0) {
//                
//                NSString *val = [NSString stringWithFormat:@"0%@0", tag_str];
//                
//                ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
//                NSString *query = [NSString stringWithFormat:@"select icon, name FROM tags WHERE id IN(%@) and icon!='' AND icon!='<null>' order by name ;", val];
//                NSArray *records2 = [connection query: query];
//                for(id dat in records2)
//                {
//                    [tag_array addObject:[dat objectForKey:@"icon"]];
//                }
//            }
//            /*============================================*/
//            
//            
//            NSString *cust=@"0";
//            
//            if(![dishcustomization isEqualToString:@""])
//            {
//                cust=@"1";
//            }
//            
//            dishDic[@"cust"] = cust;
//            dishDic[@"id"] = dishId;
//            dishDic[@"name"] = dishname;
//            dishDic[@"images"] = dishdata;
//            dishDic[@"category"] = dishcat;
//            dishDic[@"sub_category"] = dishsubcat;
//            dishDic[@"price"] = dishprice;
//            dishDic[@"price2"] = dishprice2;
//            dishDic[@"description"] = dishdescription;
//            dishDic[@"customisations"] = customizationdata;
//            dishDic[@"sub_sub_category"] = dishSubSubId;
//            [dishDic setObject:tag_array forKey:@"tag_icons"];
//
//            [dishData addObject:dishDic];
//  
//        }
//        return dishData;
//    }
//    
//    NSMutableArray *dishData = [[NSMutableArray alloc]init];
//    //NSMutableArray * tags = [[NSMutableArray alloc]init];
//    
//    for (id element in records){
//        
//
//        NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
//        NSString *dishId=(NSString*)[element objectForKey:@"[id]"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
//        
//        NSString *dishname=(NSString*)[element objectForKey:@"[name]"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
//        NSString *jugad_key = [element objectForKey:@"jugaad"];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
//        
//        NSString *libraryDirectory = paths[0];
//        
//        NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,(NSString*)[element objectForKey:@"[image]"] ];
//        
//        NSString *dishdata = location;//[UIImage imageNamed:location]; //[NSData dataWithContentsOfFile:location];//(NSString*)[element objectForKey:@"image"];//[NSData dataWithBytes:sqlite3_column_blob(addStmt, 2) length:sqlite3_column_bytes(addStmt,2)];
//        
//        NSString *dishcat=(NSString*)[element objectForKey:@"[category]"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
//        
//        NSString *dishsubcat=(NSString*)[element objectForKey:@"[sub_category]"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
//        
//        NSString *dishprice=(NSString*)[element objectForKey:@"[price]"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,5)];
//        
//        //NSString *dishprice2=(NSString*)[element objectForKey:@"price2"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,6)];
//        
//        NSString *dishprice2 = @"0.0";
//       
//        NSString *dishdescription=(NSString*)[element objectForKey:@"[description]"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,7)];
//        
//        
//        NSString *dishcustomization=(NSString*)[element objectForKey:@"customization"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,8)];
//        
//       // NSString *dishcustomization = @"";
//        if ([dishcustomization isEqualToString:@"<null>" ]) {
//            
//            dishcustomization =@"";
//        }
//        
//        NSString *dishSubSubId=(NSString*)[element objectForKey:@"[sub_sub_category]"];//[NSString stringWithFormat:@"%s",(char*)(char*)sqlite3_column_text(addStmt,11)];
//        //  enableClose = 0;
//        
//        NSMutableArray *customizationdata= [self getCustomizationData:dishcustomization];
//        // enableClose = 1;
//        NSString *tag_str = (NSString *)[element objectForKey:@"[tags]"];
//        
//        /*==========Fetching dish tag items============*/
//        NSMutableArray *tag_array = [[NSMutableArray alloc] init];
//        NSMutableArray *tag_names = [[NSMutableArray alloc] init];
//        if(tag_str != NULL && ![tag_str isEqualToString:@"<null>"] && [tag_str length] > 0) {
//            //////NSLOG(@"cat=%@, subcat=%@, tag_str = %@", catId, subCatId, tag_str);
//
//            NSString *val = [NSString stringWithFormat:@"0%@0", tag_str];
//            ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
//            NSString *query = [NSString stringWithFormat:@"select icon, name FROM tags WHERE id IN(%@) and icon!='' AND icon!='<null>' ;", val];
//            NSArray *records2 = [connection query: query];
//
//            for(id dat in records2)
//            {
//                [tag_array addObject:[dat objectForKey:@"icon"]];
//                [tag_names addObject:[dat objectForKey:@"name"]];
//            }
//
//        }
//        //[tags addObject:tag_array];
//        /*============================================*/
//
//        
//        NSString *cust=@"0";
//        
//        if(![dishcustomization isEqualToString:@""])
//        {
//            cust=@"1";
//        }
//        
//        dishDic[@"cust"] = cust;
//        dishDic[@"id"] = dishId;
//        dishDic[@"name"] = dishname;
//        dishDic[@"images"] = dishdata;
//        dishDic[@"category"] = dishcat;
//        dishDic[@"sub_category"] = dishsubcat;
//        dishDic[@"price"] = dishprice;
//        dishDic[@"price2"] = dishprice2;
//        dishDic[@"description"] = dishdescription;
//        dishDic[@"customisations"] = customizationdata;
//        dishDic[@"sub_sub_category"] = dishSubSubId;
//        [dishDic setObject:jugad_key forKey:@"is_set"];
//        [dishDic setObject:tag_array forKey:@"tag_icons"];
//        [dishDic setObject:tag_names forKey:@"tag_names"];
//
//        [dishData addObject:dishDic];
//        // [dishDic release];
//        // dishdata = nil;
//    }
//
//    return dishData;
//
//    /*
//    //@autoreleasepool {
//   // [[TabSquareDBFile sharedDatabase]openDatabaseConnection];
//    [self openDatabaseConnection];
//   
//   const char *sql;
//   // NSString* tmpstr = [NSString stringWithFormat:@"%@%@",catId,subCatId ];
//   
//   // if ([[NSUserDefaults standardUserDefaults] objectForKey:tmpstr] !=nil){
//        
//  //  }else{
//    
//    
//    
//   // if ([catId isEqualToString:@"8"]){
//        sql =[[NSString stringWithFormat:@"select * from Dishes where category=%@ and sub_category='%@' order by sub_sub_category,name",catId,subCatId]cStringUsingEncoding:NSUTF8StringEncoding];
//  //  }else{
//   //     sql =[[NSString stringWithFormat:@"select * from Dishes where category=%@ and sub_category='%@'",catId,subCatId]cStringUsingEncoding:NSUTF8StringEncoding];
//   // }
//    
//	NSMutableArray *dishData=[[NSMutableArray alloc]init];
//     
//	sqlite3_stmt *addStmt;
//	int  i=0;
//	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
//	{
//		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
//	}
//	else
//	{
//        
//		while (sqlite3_step(addStmt) == SQLITE_ROW)
//		{
//            if(i==0)
//            {
//                NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
//                NSString *dishId=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];	
//                NSString *dishname=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
//                NSData *dishdata = [NSData dataWithBytes:sqlite3_column_blob(addStmt, 2) length:sqlite3_column_bytes(addStmt,2)];
//                NSString *dishcat=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
//                NSString *dishsubcat=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
//                NSString *dishprice=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,5)];
//                NSString *dishprice2=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,6)];
//                NSString *dishdescription=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,7)];
//                NSString *dishcustomization=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,8)];
//                NSString *dishSubSubId=[NSString stringWithFormat:@"%s",(char*)(char*)sqlite3_column_text(addStmt,11)];
//                enableClose = 0;
//                NSMutableArray *customizationdata= [self getCustomizationData:dishcustomization];
//                enableClose = 1;
//                NSString *cust=@"0";
//                if(![dishcustomization isEqualToString:@""])
//                {
//                    cust=@"1";
//                }
//                dishDic[@"cust"] = cust;
//                dishDic[@"id"] = dishId;
//                dishDic[@"name"] = dishname;
//                dishDic[@"images"] = dishdata;
//                dishDic[@"category"] = dishcat;
//                dishDic[@"sub_category"] = dishsubcat;
//                dishDic[@"price"] = dishprice;
//                dishDic[@"price2"] = dishprice2;
//                dishDic[@"description"] = dishdescription;
//                dishDic[@"customisations"] = customizationdata;
//                dishDic[@"sub_sub_category"] = dishSubSubId;
//                [dishData addObject:dishDic];
//               // [dishDic release];
//                dishdata = nil;
//                
//            }
//            
//			            
//        }
//        
//		 
//	}
//         
//         //sqlite3_reset(addStmt);
//	sqlite3_finalize(addStmt);
//    addStmt = nil;
//        // sqlite3_free((char*)sql);
//         //sqlite3_free(
//  //  [[TabSquareDBFile sharedDatabase]closeDatabaseConnection];
//    
//  //  [[NSUserDefaults standardUserDefaults] setObject:dishData forKey:tmpstr];
//      //  [[NSUserDefaults standardUserDefaults] synchronize];
//	
//   // }
//    
//    //return [[NSUserDefaults standardUserDefaults] objectForKey:tmpstr];
//    
//   //sqlite3_free((char*)sql);
//    [self closeDatabaseConnection];*/
//   // [connection close];
////}
//}*/


-(NSMutableArray*)getDishData:(NSString*)catId subCatId:(NSString*)subCatId
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString* statement;
    /* if ([subCatId isEqualToString:@"48"]){
     statement = [ZIMSqlPreparedStatement preparedStatement: @"select * from dishes, sub_sub_categories where dishes.sub_sub_category = sub_sub_categories.id and category = ? and sub_category = ? order by sub_sub_categories.sequence ASC;" withValues: catId,subCatId, nil];
     }else{*/
    
    /*
     (SELECT col1,col2,col3, from dishes) UNION ALL (select col1,col2,col3 from combos)
     */
    
    //statement = [ZIMSqlPreparedStatement preparedStatement: @"select * from Dishes where category = ? and sub_category = ? order by sub_sub_category,name;" withValues: catId,subCatId, nil];
    
    //(SELECT id, name,image, description from dishes WHERE category=? AND sub_category=? AND sub_sub_category=?) UNION ALL (SELECT id, name,image, description from combos WHERE category=? AND sub_category=? AND sub_sub_category=?)
    
    //NSString *query = @"SELECT id, name,image, category, sub_category, price, description, sub_sub_category from dishes WHERE category=? AND sub_category=? UNION ALL SELECT id, name,image, category, sub_category, price, description, sub_sub_category from combos WHERE category=? AND sub_category=? order by sub_sub_category,name;";
    
    NSString *query = [NSString stringWithFormat:@"SELECT id, %@,image, category, sub_category, price, %@, customization, sub_sub_category, tags,0 AS jugaad from dishes WHERE category=%@ AND sub_category=%@ UNION ALL SELECT id, %@,image, category, sub_category, price, %@,0 AS customization, sub_sub_category, tags,1 AS jugad from combos WHERE category=%@ AND sub_category=%@ order by sub_sub_category,%@;", [LanguageControler activeLanguage:@"name"], [LanguageControler activeLanguage:@"description"], catId, subCatId, [LanguageControler activeLanguage:@"name"], [LanguageControler activeLanguage:@"description"], catId, subCatId, [LanguageControler activeLanguage:@"name"]];
    
    if([catId intValue] == 8)
        statement = [NSString stringWithFormat:@"select * from Dishes where category = %@ and sub_category = %@ order by sub_sub_category,%@;", catId,subCatId, [LanguageControler activeLanguage:@"name"]];
    else
        statement = [NSString stringWithFormat:@"%@", query];

    /*
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSArray *records = [connection query: query];
    //NSLOG(@"Query = %@", records);
     */
    //NSLOG(@"Query = %@", statement);
    // }
    ////NSLOG(@"query = %@", query);
    NSArray *records = [connection query: statement];
    ////NSLOG(@"records = %@", records);
    
    ////NSLOG(@"Query = %@\n\n, records = %@", query, records);
    
    if([catId intValue] == 8)
    {
        NSMutableArray *dishData=[[NSMutableArray alloc]init];
        for (id element in records){
            
            
            NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
            NSString *dishId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
            NSString *dishname=(NSString*)[element objectForKey:[LanguageControler activeLanguage:@"name"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
            NSString *libraryDirectory = [paths lastObject];
            NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,(NSString*)[element objectForKey:@"image"] ];
            NSString *dishdata = location;//[UIImage imageNamed:location]; //[NSData dataWithContentsOfFile:location];//(NSString*)[element objectForKey:@"image"];//[NSData dataWithBytes:sqlite3_column_blob(addStmt, 2) length:sqlite3_column_bytes(addStmt,2)];
            NSString *dishcat=(NSString*)[element objectForKey:@"category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
            NSString *dishsubcat=(NSString*)[element objectForKey:@"sub_category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
            NSString *dishprice=(NSString*)[element objectForKey:@"price"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,5)];
            NSString *dishprice2=(NSString*)[element objectForKey:@"price2"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,6)];
            NSString *dishdescription=(NSString*)[element objectForKey:[LanguageControler activeLanguage:@"description"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,7)];
            NSString *dishcustomization = [NSString stringWithFormat:@"%@", element[@"customization"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,8)];
            NSString *dishSubSubId=(NSString*)[element objectForKey:@"sub_sub_category"];//[NSString
            if ([[dishcustomization lowercaseString] isEqualToString:@"<null>"] || dishcustomization==NULL) {
                
                dishcustomization =@"";
            }
            
            NSMutableArray *customizationdata= nil;
            if([[element objectForKey:@"jugaad"] intValue] == 1)
                customizationdata = [[NSMutableArray alloc] init];
            else
                customizationdata = [self getCustomizationData:dishcustomization];

            // enableClose = 1;
            
            NSString *tag_str = (NSString *)[element objectForKey:@"tags"];
            //////NSLOG(@"tag str = %@", tag_str);
            /*==========Fetching dish tag items============*/
            NSMutableArray *tag_array = [[NSMutableArray alloc] init];
            NSMutableArray *tag_names = [[NSMutableArray alloc] init];
            
            if(tag_str != NULL && ![tag_str isEqualToString:@"<null>"] && [tag_str length] > 0) {
                
                NSString *val = [NSString stringWithFormat:@"0%@0", tag_str];
                
                ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
                NSString *query = [NSString stringWithFormat:@"select icon, %@ FROM tags WHERE id IN(%@) and icon!='' AND icon!='<null>' order by %@ ;", [LanguageControler activeLanguage:@"name"], val, [LanguageControler activeLanguage:@"name"]];
                
                
                NSArray *records2 = [connection query: query];
                
                for(id dat in records2)
                {
                    [tag_array addObject:[dat objectForKey:@"icon"]];
                    [tag_names addObject:[dat objectForKey:[LanguageControler activeLanguage:@"name"]]];
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
        NSString *dishId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        
        NSString *dishname=(NSString*)[element objectForKey:[NSString stringWithFormat:@"%@", [LanguageControler activeLanguage:@"name"]]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSString *jugad_key = [element objectForKey:@"jugaad"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        
        NSString *libraryDirectory = [paths lastObject];
        
        NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,(NSString*)[element objectForKey:@"image"] ];
        
        NSString *dishdata = location;//[UIImage imageNamed:location]; //[NSData dataWithContentsOfFile:location];//(NSString*)[element objectForKey:@"image"];//[NSData dataWithBytes:sqlite3_column_blob(addStmt, 2) length:sqlite3_column_bytes(addStmt,2)];
        
        NSString *dishcat=(NSString*)[element objectForKey:@"category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
        
        NSString *dishsubcat=(NSString*)[element objectForKey:@"sub_category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
        
        NSString *dishprice=(NSString*)[element objectForKey:@"price"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,5)];
        
        //NSString *dishprice2=(NSString*)[element objectForKey:@"price2"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,6)];
        
        NSString *dishprice2 = @"0.0";
        
        NSString *dishdescription=(NSString*)[element objectForKey:[NSString stringWithFormat:@"%@", [LanguageControler activeLanguage:@"description"]]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,7)];
        
        
        NSString *dishcustomization = [NSString stringWithFormat:@"%@", element[@"customization"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,8)];
        
        ////NSLOG(@"dish customization = %@", dishcustomization);
        // NSString *dishcustomization = @"";
        if ([dishcustomization isEqualToString:@"<null>"]) {
            
            dishcustomization =@"";
        }
        
        NSString *dishSubSubId=(NSString*)[element objectForKey:@"sub_sub_category"];//[NSString stringWithFormat:@"%s",(char*)(char*)sqlite3_column_text(addStmt,11)];
        //  enableClose = 0;
        
        
        NSMutableArray *customizationdata= nil;
        if([[element objectForKey:@"jugaad"] intValue] == 1)
            customizationdata = [[NSMutableArray alloc] init];
        else
            customizationdata = [self getCustomizationData:dishcustomization];
        
        ////NSLOG(@"customization = %@", customizationdata);
        // enableClose = 1;
        NSString *tag_str = (NSString *)[element objectForKey:@"tags"];
        
        /*==========Fetching dish tag items============*/
        NSMutableArray *tag_array = [[NSMutableArray alloc] init];
        NSMutableArray *tag_names = [[NSMutableArray alloc] init];
        
        if(tag_str != NULL && ![tag_str isEqualToString:@"<null>"] && [tag_str length] > 0) {
            //////NSLOG(@"cat=%@, subcat=%@, tag_str = %@", catId, subCatId, tag_str);
            
            NSString *val = [NSString stringWithFormat:@"0%@0", tag_str];
            ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
            NSString *query = [NSString stringWithFormat:@"select icon, %@ FROM tags WHERE id IN(%@) and icon!='' AND icon!='<null>' order by %@ ;", [LanguageControler activeLanguage:@"name"], val, [LanguageControler activeLanguage:@"name"]];
            
            
            NSArray *records2 = [connection query: query];
            
            for(id dat in records2)
            {
                [tag_array addObject:[dat objectForKey:@"icon"]];
                [tag_names addObject:[dat objectForKey:[LanguageControler activeLanguage:@"name"]]];
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
  //  NSString *statement = [NSString stringWithFormat:@"select * from Dishes where id = '%@' ;",DishId ];
    NSString *statement = [NSString stringWithFormat:@"SELECT id, %@,image, category, sub_category, price, %@, customization, sub_sub_category, tags,0 AS jugaad from dishes WHERE id = '%@' UNION ALL SELECT id, %@,image, category, sub_category, price, %@,0 AS customization, sub_sub_category, tags,1 AS jugad from combos WHERE id = '%@' order by sub_sub_category,%@;", [LanguageControler activeLanguage:@"name"], [LanguageControler activeLanguage:@"description"],DishId, [LanguageControler activeLanguage:@"name"], [LanguageControler activeLanguage:@"description"],DishId, [LanguageControler activeLanguage:@"name"]];
    NSArray *records = [connection query: statement];
   NSMutableArray *dishData=[[NSMutableArray alloc]init];
    for (id element in records){
        NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
        NSString *dishId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSString *dishname=(NSString*)[element objectForKey:[LanguageControler activeLanguage:@"name"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        NSString *libraryDirectory = [paths lastObject];
        NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,(NSString*)[element objectForKey:@"image"] ];
        NSString *dishdata = location;//[NSData dataWithContentsOfFile:location];//[NSData dataWithBytes:sqlite3_column_blob(addStmt, 2) length:sqlite3_column_bytes(addStmt,2)];
        NSString *dishcat=(NSString*)[element objectForKey:@"category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
        NSString *dishsubcat=(NSString*)[element objectForKey:@"sub_category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
        NSString *dishprice=(NSString*)[element objectForKey:@"price"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,5)];
       // NSString *dishprice2=(NSString*)[element objectForKey:@"price2"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,6)];
        NSString *dishdescription=(NSString*)[element objectForKey:[LanguageControler activeLanguage:@"description"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,7)];
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
       // dishDic[@"price2"] = dishprice2;
        dishDic[@"description"] = dishdescription;
        dishDic[@"customisations"] = customizationdata;
        dishDic[@"sub_sub_category"] = dishSubSubId;
        [dishData addObject:dishDic];
        
        
    }
    
    
	/*const char *sql =[[NSString stringWithFormat:@"select * from Dishes where id='%@'",DishId]cStringUsingEncoding:NSUTF8StringEncoding];
	NSMutableArray *dishData=[[NSMutableArray alloc]init];
    
	sqlite3_stmt *addStmt;
	[self openDatabaseConnection];
	int  i=0;
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		while (sqlite3_step(addStmt) == SQLITE_ROW)
		{
            if(i==0)
            {
                NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
                NSString *dishId=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];	
                NSString *dishname=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
                NSData *dishdata = [NSData dataWithBytes:sqlite3_column_blob(addStmt, 2) length:sqlite3_column_bytes(addStmt,2)];
                NSString *dishcat=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
                NSString *dishsubcat=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
                NSString *dishprice=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,5)];
                NSString *dishprice2=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,6)];
                NSString *dishdescription=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,7)];
                NSString *dishcustomization=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,8)];
                NSString *dishSubSubId=[NSString stringWithFormat:@"%s",(char*)(char*)sqlite3_column_text(addStmt,11)];
                enableClose = 0;
                NSMutableArray *customizationdata= [self getCustomizationData:dishcustomization];
                enableClose = 1;
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
            
            
        }
        
        
	}
	sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
	return dishData;
}

-(NSMutableArray*)getBeverageSkuDetail:(NSString*)beverageId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"select BeverageContainers.id,Containers.%@,BeverageContainers.price from Containers,BeverageContainers WHERE BeverageContainers.beverage_id='%@' and Containers.id=BeverageContainers.container_id group by Containers.%@", [LanguageControler activeLanguage:@"name"],beverageId, [LanguageControler activeLanguage:@"name"]];//[ZIMSqlPreparedStatement preparedStatement: @"select * from CustOptions where customization_id in( ? );" withValues: custId, nil];
    
    NSArray *records = [connection query: statement];
    
    ////NSLOG(@"query = %@", statement);
    ////NSLOG(@"records >>= %@", records);
    
    NSMutableArray *beverageSku=[[NSMutableArray alloc]init];
    for (id element in records){
        //NSString *optionId=(NSString*)[element objectForKey:@"id"];//[NSString
        NSMutableDictionary *SkuDic=[NSMutableDictionary dictionary];
        NSString *skuId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSString *skuName=(NSString*)[element objectForKey:[LanguageControler activeLanguage:@"name"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSString *skuPrice=(NSString*)[element objectForKey:@"price"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
        if(![skuPrice isEqualToString:@"0.00"])
        {
            SkuDic[@"sku_id"] = skuId;
            SkuDic[@"sku_name"] = skuName;
            SkuDic[@"sku_price"] = skuPrice;
            [beverageSku addObject:SkuDic];
        }
        
    }
    
    
   /* const char *sql =[[NSString stringWithFormat:@"select BeverageContainers.id,Containers.name,BeverageContainers.price from Containers,BeverageContainers WHERE BeverageContainers.beverage_id=%@ and Containers.id=BeverageContainers.container_id group by Containers.name",beverageId]cStringUsingEncoding:NSUTF8StringEncoding];
	NSMutableArray *beverageSku=[[NSMutableArray alloc]init];
    
	sqlite3_stmt *addStmt;
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		while (sqlite3_step(addStmt) == SQLITE_ROW)
		{
            NSMutableDictionary *SkuDic=[NSMutableDictionary dictionary];
            NSString *skuId=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)]; 
            NSString *skuName=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];	
            NSString *skuPrice=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
            if(![skuPrice isEqualToString:@"0.00"])
            {
                SkuDic[@"sku_id"] = skuId;
                SkuDic[@"sku_name"] = skuName;
                SkuDic[@"sku_price"] = skuPrice;
                [beverageSku addObject:SkuDic];
            }
        }
	}
    
	sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
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

    
    /*const char *sql =[[NSString stringWithFormat:@"select beverage_id from BeverageContainers where id=%@",beverageContainerId]cStringUsingEncoding:NSUTF8StringEncoding];
	NSString *beverageId=@"";
    
	sqlite3_stmt *addStmt;
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		while (sqlite3_step(addStmt) == SQLITE_ROW)
		{
            beverageId=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)]; 
        }
	}
	sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
	return beverageId;
}


-(NSMutableArray*)getDishKeyData:(NSString*)key
{
    char c = '%';
    NSString *sp_char = [NSString stringWithFormat:@"%c", c];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    //NSString *statement = [NSString stringWithFormat:@"SELECT * FROM 'dishes' WHERE %@ LIKE '%@%@%@' OR %@ LIKE '%@%@%@' OR tags LIKE '%@,' ||(SELECT id FROM 'tags' WHERE %@ LIKE '%@%@' LIMIT 1) || ',%@' ORDER BY category ;", [LanguageControler activeLanguage:@"name"], sp_char, key, sp_char, [LanguageControler activeLanguage:@"description"], sp_char, key, sp_char, sp_char, [LanguageControler activeLanguage:@"name"], key, sp_char, sp_char];
    
    NSString *statement = [NSString stringWithFormat:@"SELECT * FROM 'dishes' WHERE name LIKE '%@%@%@' OR ch_name LIKE '%@%@%@' OR fr_name LIKE '%@%@%@' OR in_name LIKE '%@%@%@' OR ja_name LIKE '%@%@%@' OR ko_name LIKE '%@%@%@' OR description LIKE '%@%@%@' OR ch_description LIKE '%@%@%@' OR fr_description LIKE '%@%@%@' OR in_description LIKE '%@%@%@' OR ja_description LIKE '%@%@%@' OR ko_description LIKE '%@%@%@' OR tags LIKE '%@,' ||(SELECT id FROM 'tags' WHERE name LIKE '%@%@' OR ch_name LIKE '%@%@' OR fr_name LIKE '%@%@' OR in_name LIKE '%@%@' OR ja_name LIKE '%@%@' OR ko_name LIKE '%@%@' LIMIT 1) || ',%@' ORDER BY category ;", sp_char, key, sp_char, sp_char, key, sp_char, sp_char, key, sp_char, sp_char, key, sp_char, sp_char, key, sp_char, sp_char, key, sp_char, sp_char, key, sp_char, sp_char, key, sp_char, sp_char, key, sp_char, sp_char, key, sp_char, sp_char, key, sp_char, sp_char, key, sp_char, sp_char, key, sp_char, key, sp_char, key, sp_char, key, sp_char, key, sp_char, key, sp_char, sp_char];
    
    //[self printData:@"Select * From Dishes"];
    ////NSLOG(@"search query = %@", statement);
    BOOL is_best_seller = FALSE;
    if([key length] == 0 && [[TabSquareCommonClass getValueInUserDefault:BEST_SELLERS] intValue] == 1 && [ShareableData bestSellersON]) {
        
        is_best_seller = TRUE;
        NSString *search_key = [[ShareableData sharedInstance] activeBestsellerName];
        
        statement = [NSString stringWithFormat:@"SELECT * FROM dishes WHERE tags LIKE '%@,' ||(SELECT id FROM tags WHERE name LIKE '%@%@%@' OR ch_name LIKE '%@%@%@' OR fr_name LIKE '%@%@%@' OR in_name LIKE '%@%@%@' OR ja_name LIKE '%@%@%@' OR ko_name LIKE '%@%@%@'  LIMIT 1) || ',%@'", sp_char, sp_char, search_key, sp_char, sp_char, search_key, sp_char, sp_char, search_key, sp_char, sp_char, search_key, sp_char, sp_char, search_key, sp_char, sp_char, search_key, sp_char, sp_char];
    }
    
    NSArray *records = [connection query: statement];
    
    NSMutableArray *dishData=[[NSMutableArray alloc]init];
    
    for (id element in records){
        //NSString *optionId=(NSString*)[element objectForKey:@"id"];//[NSString
        // NSMutableDictionary *SkuDic=[NSMutableDictionary dictionary];
        //NSString *skuId=(NSString*)[element objectForKey:@"id"];//[NSString
        NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
        NSString *dishId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSString *dishname=(NSString*)[element objectForKey:[LanguageControler activeLanguage:@"name"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        NSString *libraryDirectory = [paths lastObject];
        NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,(NSString*)[element objectForKey:@"image"] ];
        NSString *dishdata = location;//[NSData dataWithContentsOfFile:location];
        
        // NSData *dishdata = [[NSData alloc] initWithBytes:sqlite3_column_blob(addStmt, 2) length:sqlite3_column_bytes(addStmt,2)];
        NSString *dishcat=(NSString*)[element objectForKey:@"category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
        NSString *dishsubcat=(NSString*)[element objectForKey:@"sub_category"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
        NSString *dishprice=(NSString*)[element objectForKey:@"price"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,5)];
        NSString *dishprice2=(NSString*)[element objectForKey:@"price2"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,6)];
        NSString *dishdescription=(NSString*)[element objectForKey:[LanguageControler activeLanguage:@"description"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,7)];
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
            NSString *query = [NSString stringWithFormat:@"select icon, %@ FROM tags WHERE id IN(%@) and icon!='' AND icon!='<null>' order by %@ ;", [LanguageControler activeLanguage:@"name"], val, [LanguageControler activeLanguage:@"name"]];
            
            ////NSLOG(@"query = %@", query);
            NSArray *records2 = [connection query: query];
            
            for(id dat in records2)
            {
                [tag_array addObject:[dat objectForKey:@"icon"]];
                [tag_names addObject:[dat objectForKey:[LanguageControler activeLanguage:@"name"]]];
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
        NSString *dishname=(NSString*)[element objectForKey:[LanguageControler activeLanguage:@"name"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
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
    
    
    
   /* const char *sql;
    [self openDatabaseConnection];
    if([tag1 isEqualToString:@"-1"]&&[tag2 isEqualToString:@"-1"]&&[tag3 isEqualToString:@"-1"])
    {
        sql =[[NSString stringWithFormat:@"SELECT * FROM Dishes where category = %@",catID]cStringUsingEncoding:NSUTF8StringEncoding];
    }
    else 
    {
        sql =[[NSString stringWithFormat:@"SELECT * FROM Dishes where category = %@ and (tags like '%%,%@%,%%' or tags like '%%,%@%,%%' or tags like '%%,%@%,%%') ",catID,tag1,tag2,tag3]cStringUsingEncoding:NSUTF8StringEncoding];
    }
   	NSMutableArray *dishData=[[NSMutableArray alloc]init];
    
	sqlite3_stmt *addStmt = nil;		
	int  i=0;
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		while (sqlite3_step(addStmt) == SQLITE_ROW)
		{
            if(i==0)
            {
                NSMutableDictionary *dishDic=[NSMutableDictionary dictionary];
                NSString *dishId=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];	
                NSString *dishname=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
                NSString *libraryDirectory = paths[0];
                NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)] ];
                NSData *dishdata = [NSData dataWithContentsOfFile:location];
                NSString *dishcat=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
                NSString *dishsubcat=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
                NSString *dishprice=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,5)];
                NSString *dishprice2=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,6)];
                NSString *dishdescription=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,7)];
                NSString *dishcustomization=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,8)];
                enableClose = 0;
                NSMutableArray *customizationdata= [self getCustomizationData:dishcustomization];
                enableClose = 1;
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
            
            
        }
    }
	sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
	return dishData;
}

-(NSMutableArray*)getCategoryData
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"SELECT * FROM Categories order by sequence,%@", [LanguageControler activeLanguage:@"name"]];
    
    NSArray *records = [connection query: statement];
    NSMutableArray *CategoryData=[[NSMutableArray alloc]init];
    
    for (id element in records) {

        NSMutableDictionary *catDic=[NSMutableDictionary new];
        NSString *catId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSString *catname=(NSString*)[element objectForKey:[LanguageControler activeLanguage:@"name"]];
        
        catDic[@"id"] = catId;
        catDic[@"name"] = catname;
        
        [CategoryData addObject:catDic];
    }
    
	return CategoryData;
}

-(NSMutableArray*)getSubCategoryData:(NSString*)catId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"SELECT * FROM SubCategories where category_id='%@' order by sequence,%@",catId, [LanguageControler activeLanguage:@"name"]];
        
    NSArray *records = [connection query: statement];
    
    NSMutableArray *SubCategoryData=[[NSMutableArray alloc]init];
    for (id element in records){
        //NSString *optionId=(NSString*)[element objectForKey:@"id"];//[NSString
        NSMutableDictionary *subcatDic=[NSMutableDictionary dictionary];
        NSString *subcatId=(NSString*)[element objectForKey:@"id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
        NSString *subcatname=(NSString*)[element objectForKey:[LanguageControler activeLanguage:@"name"]];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
        NSString *catid=(NSString*)[element objectForKey:@"category_id"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
        NSString *display=(NSString*)[element objectForKey:@"display"];//[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
        
        subcatDic[@"id"] = subcatId;
        subcatDic[@"name"] = subcatname;
        subcatDic[@"category_id"] = catid;
        subcatDic[@"display"] = display;
        [SubCategoryData addObject:subcatDic];
    }
    
    
    /*
    const char *sql =[[NSString stringWithFormat:@"SELECT * FROM SubCategories where category_id=%@ order by sequence,name",catId]cStringUsingEncoding:NSUTF8StringEncoding];
	NSMutableArray *SubCategoryData=[[NSMutableArray alloc]init];
    
	sqlite3_stmt *addStmt;
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		while (sqlite3_step(addStmt) == SQLITE_ROW)
		{
            NSMutableDictionary *subcatDic=[NSMutableDictionary dictionary];
            NSString *subcatId=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];	
            NSString *subcatname=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
            NSString *catid=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
            NSString *display=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,4)];
            
            subcatDic[@"id"] = subcatId;
            subcatDic[@"name"] = subcatname;
            subcatDic[@"category_id"] = catid;
            subcatDic[@"display"] = display;
            [SubCategoryData addObject:subcatDic];
            
        }
    }
	sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
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
    /*
    const char *sql =[[NSString stringWithFormat:@"SELECT sub_category FROM Dishes where id =%@",catId]cStringUsingEncoding:NSUTF8StringEncoding];
	NSString *subId=@"";
    
	sqlite3_stmt *addStmt;
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		while (sqlite3_step(addStmt) == SQLITE_ROW)
		{
           
            subId=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];	
                        
        }
    }
	sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
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
    /*
     const char *sql =[[NSString stringWithFormat:@"SELECT sub_category FROM Dishes where id =%@",catId]cStringUsingEncoding:NSUTF8StringEncoding];
     NSString *subId=@"";
     
     sqlite3_stmt *addStmt;
     [self openDatabaseConnection];
     if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK)
     {
     DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
     }
     else
     {
     while (sqlite3_step(addStmt) == SQLITE_ROW)
     {
     
     subId=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];
     
     }
     }
     sqlite3_finalize(addStmt);
     [self closeDatabaseConnection];*/
	return subId;
}

-(NSMutableArray*)getSubSubCategoryData:(NSString*)catId subCatId:(NSString*)subId
{
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
    
  //  NSString *statement = [NSString stringWithFormat:@"SELECT sub_sub_category,(select name from Sub_Sub_Categories Where Sub_Sub_Categories.id=sub_sub_category order by Sub_Sub_Categories.sequence ASC ) as name, Sub_Sub_Categories.sequence FROM Dishes, Sub_Sub_Categories where category='%@' and sub_category='%@' group by sub_sub_category order by Sub_Sub_Categories.sequence ASC",catId,subId];
    //
   /* NSString* statement2 = [NSString stringWithFormat:@"select name, id as sub_sub_category from sub_sub_categories where  category_id = %@ and sub_category_id = %@ order by sequence ASC",catId,subId];
    NSArray *records2 = [connection query: statement2];
    NSMutableArray *SubCategoryData2=[[NSMutableArray alloc]init];
    
    for (id element in records2){
        
        NSMutableDictionary *subcatDic=[NSMutableDictionary dictionary];
        NSString *subsubcatId=(NSString*)[element objectForKey:@"sub_sub_category"];
        NSString *subcatname=(NSString*)[element objectForKey:@"name"];
        subcatDic[@"id"] = subsubcatId;
        subcatDic[@"name"] = subcatname;
        // [subcatDic setObject:catid forKey:@"category_id"];
        //[subcatDic setObject:subCatId forKey:@"sub_category_id"];
        [SubCategoryData2 addObject:subcatDic];
    }*/
    NSString *statement = [NSString stringWithFormat:@"SELECT sub_sub_category, (select %@ from sub_sub_categories Where sub_sub_categories.id=sub_sub_category order by sub_sub_categories.sequence ASC ) as name,sub_sub_categories.sequence FROM dishes, sub_sub_categories where category = %@ and sub_category = %@ and dishes.sub_sub_category = sub_sub_categories.id group by sub_sub_category order by sub_sub_categories.sequence ASC", [LanguageControler activeLanguage:@"name"],catId,subId];
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
    
    
    /*const char *sql =[[NSString stringWithFormat:@"SELECT sub_sub_category,(select name from Sub_Sub_Categories Where Sub_Sub_Categories.id=sub_sub_category ) as name FROM Dishes, Sub_Sub_Categories where category=%@ and sub_category=%@ group by sub_sub_category",catId,subId]cStringUsingEncoding:NSUTF8StringEncoding];
	NSMutableArray *SubCategoryData=[[NSMutableArray alloc]init];
    
	sqlite3_stmt *addStmt;
	[self openDatabaseConnection];
	if (sqlite3_prepare_v2(dataBaseConnection, sql, -1, &addStmt, NULL) != SQLITE_OK) 
	{
		DLog(0,@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		while (sqlite3_step(addStmt) == SQLITE_ROW)
		{
            NSMutableDictionary *subcatDic=[NSMutableDictionary dictionary];
            NSString *subsubcatId=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,0)];	
            NSString *subcatname=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,1)];
            //NSString *catid=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,2)];
            //NSString *subCatId=[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(addStmt,3)];
            subcatDic[@"id"] = subsubcatId;
            subcatDic[@"name"] = subcatname;
           // [subcatDic setObject:catid forKey:@"category_id"];
            //[subcatDic setObject:subCatId forKey:@"sub_category_id"];
            [SubCategoryData addObject:subcatDic];
            
        }
    }
	sqlite3_finalize(addStmt);
    [self closeDatabaseConnection];*/
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
            NSString *location = [NSString stringWithFormat:@"%@/%@_%@",libraryDirectory, THUMBNAIL,imageName];
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
    
    NSString *statement = [NSString stringWithFormat:@"SELECT * FROM SubCategories where category_id='%@' order by sequence,%@ LIMIT 1",catId, [LanguageControler activeLanguage:@"name"]];
    NSArray *records = [connection query: statement];
    NSString *subcatId = nil;
    
    for (id element in records) {
        subcatId = (NSString*)[element objectForKey:@"id"];
    }
    
    return [subcatId intValue];
}



/*===================================================== code before sahid change the method

-(void)updateUIImages:(NSMutableArray *)array
{
    for(int i = 0; i < [array count]; i++)
    {
        NSString *img = [NSString stringWithFormat:@"%@_%@.png", [array objectAtIndex:i], [ShareableData appKey]];
        NSString *img_name = [NSString stringWithFormat:@"%@%@", PRE_NAME, img];
        NSString *img_url = [NSString stringWithFormat:@"%@/app/webroot/img/product/app_image/%@", [ShareableData serverURL], img];
        
        //////NSLOG(@"Log 3 Image url is = %@", img_url);
        
        //@autoreleasepool
        {
            
            UIImage  *imageData = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]]];
 
            //////NSLOG(@"image obj home 1 = %@", imageData);
            CGSize size = imageData.size;
            BOOL hd_device = [TabSquareCommonClass isHDDevice];
            if(!hd_device) {
                imageData = [TabSquareCommonClass resizeImage:imageData scaledToSize:CGSizeMake(size.width, size.height)];
            }
            
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
            NSString *libraryDirectory = paths[0];
            NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,img_name];//[libraryDirectory stringByAppendingString:@"/@%",dishImage];
            //////NSLOG(@"image location = %@", location);
            //////NSLOG(@"Log 4 img location after downloading = %@", location);
            NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(imageData)];
            [data1 writeToFile:location atomically:YES];
        }
    }
}*/

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
            
        UIImage *imageData = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]]];
                
        CGSize size = imageData.size;
        BOOL hd_device = [TabSquareCommonClass isHDDevice];
        if(!hd_device) {
            imageData = [TabSquareCommonClass resizeImage:imageData scaledToSize:CGSizeMake(size.width/2, size.height/2)];
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

-(void)saveImage:(NSString *)dishImage
{
    @autoreleasepool {
        NSString *nn = [NSString stringWithFormat:@"%@/img/product/%@", [ShareableData serverURL],dishImage];
        UIImage  *imageData = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nn]]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        NSString *libraryDirectory = [paths lastObject];
        NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,dishImage];//[libraryDirectory stringByAppendingString:@"/@%",dishImage];
        
        if(![TabSquareCommonClass isHDDevice]) {
            imageData = [TabSquareCommonClass resizeImage:imageData scaledToSize:CGSizeMake(imageData.size.width/2, imageData.size.height/2)];
        }
        NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(imageData)];
        [data1 writeToFile:location atomically:YES];
        
        [self saveThumbnailImage:imageData location:dishImage];
    }
}


-(void)saveThumbnailImage:(UIImage *)img location:(NSString *)name
{
    CGSize size = CGSizeMake(258.0, 196.0);
    if([[TabSquareCommonClass getValueInUserDefault:@"from_cat"] intValue] == 1) {
        size = CGSizeMake(200.0, 186.0);
    }
    
    UIImage *thmb = [TabSquareCommonClass resizeImage:img scaledToSize:size];
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(thmb)];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
    NSString *libraryDirectory = [paths lastObject];
    NSString *location = [NSString stringWithFormat:@"%@/%@_%@",libraryDirectory, THUMBNAIL,name];//
    
    [data1 writeToFile:location atomically:YES];

}

-(UIImage *)getImage:(NSString *)image_name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
    NSString *libraryDirectory = [paths lastObject];
    NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,image_name];

    UIImage *img = [UIImage imageWithContentsOfFile:location];
    
    return img;
}
-(UIImage *)getImage2:(NSString *)image_name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = paths[0];
    NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,image_name];
    //  [sentence rangeOfString:word].location != NSNotFound
    UIImage *img;
    if ([image_name rangeOfString:@"/"].location !=NSNotFound){
        
        img = [UIImage imageWithContentsOfFile:image_name];
    }else{
        img = [UIImage imageWithContentsOfFile:location];
    }
    
    
    return img;
}
-(void)deleteImage:(NSString *)image
{
    if (image == NULL || [image length]<1)
    {
        
    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);;
        NSString *libraryDirectory = [paths lastObject];
        NSString *location = [NSString stringWithFormat:@"%@/%@",libraryDirectory,image];//
    
        [[NSFileManager defaultManager] removeItemAtPath: location error: NULL];
    }
}


-(void)updateComboValueData:(NSMutableDictionary *)data type:(NSString *)query_type
{
    
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
        
        NSString *statement = [NSString stringWithFormat:@"INSERT INTO combos(id,category,sub_category,'sub_sub_category','name','image','price','group','description','on_update', 'tags', 'ch_name','fr_name','in_name','ja_name','ko_name', 'ch_description','fr_description','in_description','ja_description','ko_description') VALUES ( %@ , %@ , %@ , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' ,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",dish_id,category,sub_category,sub_sub_category,name,image,price,group,description,on_update, tags, data[@"ch_name"], data[@"fr_name"], data[@"in_name"], data[@"ja_name"], data[@"ko_name"], data[@"ch_description"], data[@"fr_description"], data[@"in_description"], data[@"ja_description"], data[@"ko_description"]];
        ////NSLOG(@"query = %@", statement);
        [connection execute: statement];
        ////NSLOG(@"status = %@", number);

    }
    else if([query_type isEqualToString:@"2"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        [self saveImage:image];
        
        NSString *statement = [NSString stringWithFormat:@"Update combos set category = %@,sub_category=  '%@',sub_sub_category = '%@',name='%@',image = '%@',price = '%@', 'group' = '%@',description='%@',on_update = '%@',tags='%@', ch_name = '%@', fr_name = '%@', in_name = '%@', ja_name = '%@', ko_name = '%@', ch_description = '%@', fr_description = '%@', in_description = '%@', ja_description = '%@', ko_description = '%@'  where id = '%@' ;",category,sub_category,sub_sub_category,name,image,price,group,description,on_update, tags, data[@"ch_name"], data[@"fr_name"], data[@"in_name"], data[@"ja_name"], data[@"ko_name"], data[@"ch_description"], data[@"fr_description"], data[@"in_description"], data[@"ja_description"], data[@"ko_description"], dish_id];
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
        
        NSString *statement = [NSString stringWithFormat:@"INSERT INTO groups('id','name','category','selection_header','modified','created_by', ch_name,fr_name,in_name,ja_name,ko_name, ch_selection_header,fr_selection_header,in_selection_header,ja_selection_header,ko_selection_header) VALUES ( %@ , '%@' , %@ , '%@' , '%@' , '%@' ,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",dish_id,name,category,selection_header,modified,created_by, data[@"ch_name"], data[@"fr_name"], data[@"in_name"], data[@"ja_name"], data[@"ko_name"], data[@"ch_selection_header"], data[@"fr_selection_header"], data[@"in_selection_header"], data[@"ja_selection_header"], data[@"ko_selection_header"]];
        ////NSLOG(@"query = %@", statement);
        [connection execute: statement];
        ////NSLOG(@"status = %@", number);
        
    }
    else if([query_type isEqualToString:@"2"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        
        NSString *statement = [NSString stringWithFormat:@"Update groups set name = '%@',category= '%@',selection_header = '%@', 'modified' = '%@',created_by='%@', ch_name = '%@', fr_name = '%@', in_name = '%@', ja_name = '%@', ko_name = '%@', ch_selection_header = '%@', fr_selection_header = '%@', in_selection_header = '%@', ja_selection_header = '%@', ko_selection_header = '%@'  where id = '%@' ;",name,category,selection_header,modified,created_by, data[@"ch_name"], data[@"fr_name"], data[@"in_name"], data[@"ja_name"], data[@"ko_name"], data[@"ch_selection_header"], data[@"fr_selection_header"], data[@"in_selection_header"], data[@"ja_selection_header"], data[@"ko_selection_header"], dish_id];
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
        
        NSString *statement = [NSString stringWithFormat:@"INSERT INTO group_dishes(id,'name','image',group_id,'dish_id','description', 'ch_name','fr_name','in_name','ja_name','ko_name', 'ch_description','fr_description','in_description','ja_description','ko_description') VALUES ( %@ , '%@' , '%@' , %@ , '%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",id1,name,image,group_id,dish_id, description, data[@"ch_name"], data[@"fr_name"], data[@"in_name"], data[@"ja_name"], data[@"ko_name"], data[@"ch_description"], data[@"fr_description"], data[@"in_description"], data[@"ja_description"], data[@"ko_description"]];
        
        ////NSLOG(@"query = %@", statement);
        [connection execute: statement];
        ////NSLOG(@"status >>= %@", status);
        
    }
    else if([query_type isEqualToString:@"2"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        [self saveImage:image];
        
        NSString *statement = [NSString stringWithFormat:@"Update group_dishes set name = '%@',image= '%@',group_id = %@,dish_id='%@',description = '%@', ch_name = '%@', fr_name = '%@', in_name = '%@', ja_name = '%@', ko_name = '%@', ch_description = '%@', fr_description = '%@', in_description = '%@', ja_description = '%@', ko_description = '%@'  where id = %@ ;",name,image,group_id,dish_id, description, data[@"ch_name"], data[@"fr_name"], data[@"in_name"], data[@"ja_name"], data[@"ko_name"], data[@"ch_description"], data[@"fr_description"], data[@"in_description"], data[@"ja_description"], data[@"ko_description"], id1];
        ////NSLOG(@"query update = %@", statement);

        [connection execute: statement];
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
        
        NSString *statement = [NSString stringWithFormat:@"INSERT INTO tags(id,'name','icon', 'ch_name','fr_name','in_name','ja_name','ko_name') VALUES ( %@ , '%@' , '%@','%@','%@','%@','%@','%@');",id1,name,icon, data[@"ch_name"], data[@"fr_name"], data[@"in_name"], data[@"ja_name"], data[@"ko_name"]];
        
        ////NSLOG(@"query = %@", statement);
        [connection execute: statement];
        
    }
    else if([query_type isEqualToString:@"2"])
    {
        ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
        [self saveImage:icon];
        
        NSString *statement = [NSString stringWithFormat:@"Update tags set name = '%@',icon= '%@', ch_name = '%@', fr_name = '%@', in_name = '%@', ja_name = '%@', ko_name = '%@' where id = %@ ;", name, icon, data[@"ch_name"], data[@"fr_name"], data[@"in_name"], data[@"ja_name"], data[@"ko_name"], id1];
        
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


-(NSMutableArray *)getDishItemsBy:(NSMutableArray *)array
{
    NSString *dishes = @"";//[array componentsJoinedByString:@","];
    
    for(int i = 0; i < [array count]; i++) {
        
        NSString *sep = @",";
        
        if(i == [array count]-1)
            sep = @"";
        
        dishes = [NSString stringWithFormat:@"%@'%@'%@", dishes, [array objectAtIndex:i], sep];
    }
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Dishes where id IN(%@) ;",dishes];
    
    NSArray *records = [connection query: query];
    
    
    for(id dict in records)
    {
        [data addObject:dict];
    }
    
    return data;
}



-(NSMutableArray *)getDishIdsByAmount:(float)amount data:(NSMutableArray *)array
{
    //NSString *score = [NSString stringWithFormat:@\"%06d\", val];
    
    NSString *dishes = @"";//[array componentsJoinedByString:@","];
    
    for(int i = 0; i < [array count]; i++) {
        
        NSString *sep = @",";
        
        if(i == [array count]-1)
            sep = @"";
        
        NSString *str = [NSString stringWithFormat:@"%015d",[array[i] intValue]];
        
        dishes = [NSString stringWithFormat:@"%@'%@'%@", dishes, str, sep];
    }
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Dishes WHERE CAST(price AS FLOAT)>%f and id IN(%@) ;", amount,dishes];
    
    //NSString *query = [NSString stringWithFormat:@"SELECT * FROM Dishes  WHERE id IN(%@) ;",dishes];
    
    NSArray *records = [connection query: query];
    
    for(id dict in records)
    {
        [data addObject:dict[@"id"]];
    }
    
    return data;
    
}


-(NSMutableArray *)getFeedbackData:(NSMutableArray *)array
{
    
    NSString *dishes = @"";
    
    for(int i = 0; i < [array count]; i++) {
        
        NSString *sep = @",";
        
        if(i == [array count]-1)
            sep = @"";
        
        NSString *str = [NSString stringWithFormat:@"%@", array[i]];
        
        dishes = [NSString stringWithFormat:@"%@'%@'%@", dishes, str, sep];
    }
    
    NSMutableArray *data = nil;
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT GROUP_CONCAT(id) as ids FROM Dishes WHERE sub_category IN (SELECT id FROM SubCategories WHERE is_hidden='0') AND id IN(%@);", dishes];
    
    NSArray *records = [connection query: query];
    
    ////NSLOG(@"feedback data = %@", records);
    
    NSMutableDictionary *dict = nil;
    
    if([records count] > 0)
        dict = [records objectAtIndex:0];
    else
        return nil;
    
    ////NSLOG(@"dict = %@", dict);
    NSString *str = [dict objectForKey:@"ids"];
    
    if(str == nil)
        return nil;
    
    @try {

        NSArray *arr = [str componentsSeparatedByString:@","];
        if([arr count] == 0)
            return nil;
        
        data = [NSMutableArray arrayWithArray:arr];


    }
    @catch (NSException *exception) {
        
        return nil;
    }
    @finally {
        
    }
    
    
    return data;
    
}



-(NSMutableArray *)getActiveDishNames:(NSMutableArray *)array
{
    NSString *dishes = @"";
    
    for(int i = 0; i < [array count]; i++) {
        
        NSString *sep = @",";
        
        if(i == [array count]-1)
            sep = @"";
        
        NSString *str = [NSString stringWithFormat:@"%@",array[i]];
        
        dishes = [NSString stringWithFormat:@"%@'%@'%@", dishes, str, sep];
    }
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
 //   NSString *query = [NSString stringWithFormat:@"Select %@ From Dishes Where id IN(%@) ;", [LanguageControler activeLanguage:@"name"], dishes];
    
    NSString *query = [NSString stringWithFormat:@"SELECT %@ from dishes WHERE id IN(%@) UNION ALL SELECT %@ from combos WHERE id IN(%@) ;", [LanguageControler activeLanguage:@"name"], dishes,[LanguageControler activeLanguage:@"name"],dishes];
    
    
    
    NSArray *records = [connection query: query];
    //NSLOG(@"order active names = %@", records);
    //NSLOG(@"query = %@", query);
    
    for(id element in records) {
        [data addObject:[element objectForKey:[LanguageControler activeLanguage:@"name"]]];
    }
    
    return data;
    
}




-(NSString *)getActiveOption:(NSString *)optionId
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
    NSString *query = [NSString stringWithFormat:@"Select %@ From CustOptions Where id = %015d ;", [LanguageControler activeLanguage:@"name"], [optionId intValue]];
    
    //NSLOG(@"query = %@", query);
    NSArray *records = [connection query: query];
    NSString *option_name = @"";
    
    for(id element in records) {
        option_name = [NSString stringWithFormat:@"%@", [element objectForKey:[LanguageControler activeLanguage:@"name"]]];
    }
    
    return option_name;
    
}

-(void)printData:(NSString *)query
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSArray *records = [connection query: query];
    
    //NSLOG(@"Query Records = %@", records);
}


-(NSMutableDictionary *)bestSellerNames:(NSString *)name
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    
    NSString *query = [NSString stringWithFormat:@"Select * From tags Where lower(name) = '%@' ;", name.lowercaseString];
    
    NSArray *records = [connection query: query];
    //NSLOG(@"Query = %@", query);
    ////NSLOG(@"Best sellers data = %@", records);
    
    NSMutableDictionary *data = nil;
    
    for(id element in records) {
        data = element;
        break;
    }
    
    return data;
}

-(void)deleteData:(NSString *)tableName
{
    ZIMDbConnection *connection = [[ZIMDbConnectionPool sharedInstance] connection: @"live"];
    NSString *statement = [NSString stringWithFormat:@"Delete From %@ ;", tableName];
    [connection execute: statement];
}



@end
