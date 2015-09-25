//
//  SXQDBManager.m
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//

#import <FMDB/FMDB.h>
//#import <FMDB/FMDatabaseQueue.h>
#import "SXQDBManager.h"

#define InstructionDBName @"instruction.sqlite"

static SXQDBManager *_dbManager = nil;

@interface SXQDBManager ()
@property (nonatomic,strong) FMDatabaseQueue *queue;
@end
@implementation SXQDBManager
+ (instancetype)sharedManager
{
    return [[self alloc] init];
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_dbManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _dbManager = [super allocWithZone:zone];
        });
    }
    return _dbManager;
}
- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dbManager = [super init];
        [_dbManager setupDataBase];
    });
    return _dbManager;
}
/**
 *  初始化数据库
 */
- (void)setupDataBase
{
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask ,YES) lastObject] stringByAppendingPathComponent:InstructionDBName];
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    [_queue inDatabase:^(FMDatabase *db) {
        //实验说明书主表
        NSString *instuctionMainSQL = @"create table if not exists t_expinstructionsMain(expinstructionid text primary key,experimentname text,experimentdesc text,experimenttheory text,provideuser text,supplierid text,suppliername text,productnum text,expcategoryid text,expsubcategoryid text,createdate numeric,expversion integer,allowdownload integer,filterstr text,reviewcount integer,downloadcount integer);";
        //实验试剂表
        NSString *expReagentSQL = @"create table if not exists t_expreaget (createMethod text,expInstructionID text,expReagentID text primary key,reagentCommonName p,reagentID text,reagentName text,reagentSpec text,useAmount integer);";
        //实验流程表
        NSString *expProcessSQL = @"create table if not exists t_expProcess (expInstructionID text,expStepDesc text,expStepID text primary key,expStepTime integer,stepNum integer);";
        //实验设备表
        NSString *expEquipmetnSQL = @"create table if not exists t_expEquipment (equipmentID text ,equipmentFactory text,equipmentName text,expEquipmentID text primary key,expInstructionID text);";
        NSString *expConsumableSQL = @"create table if not exists t_expConsumable (consumableCount integer,consumableFactory text,consumableID text,consumableType text,expConsumableID text primary key,expInstructionID text);";
        [db executeUpdate:instuctionMainSQL];
        [db executeUpdate:expReagentSQL];
        [db executeUpdate:expProcessSQL];
        [db executeUpdate:expEquipmetnSQL];
        [db executeUpdate:expConsumableSQL];
    }];
}
- (void)insertInstruciton:(id)instruction completion:(CompletionHandler)completion
{
    
}
/**
 *  写入一条数据到说明书主表
 */
- (BOOL)insertIntoInstructionMain:(NSDictionary *)expInstructionMain
{
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db) {
     success = [db executeUpdate:@"insert into t_expinstructionsMain (expinstructionid ,experimentname ,experimentdesc ,experimenttheory ,provideuser ,supplierid ,suppliername ,productnum ,expcategoryid ,expsubcategoryid ,createdate ,expversion ,allowdownload ,filterstr ,reviewcount ,downloadcount) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",expInstructionMain[@"expInstructionID"],expInstructionMain[@"experimentName"],expInstructionMain[@"experimentDesc"],expInstructionMain[@"experimentTheory"],expInstructionMain[@"provideUser"],expInstructionMain[@"supplierID"],expInstructionMain[@"supplierName"],expInstructionMain[@"productNum"],expInstructionMain[@"expCategoryID"],expInstructionMain[@"expSubCategoryID"],expInstructionMain[@"createDate"],expInstructionMain[@"expVersion"],expInstructionMain[@"allowDownload"],expInstructionMain[@"filterStr"],expInstructionMain[@"reviewCount"],expInstructionMain[@"downloadCount"]];
    }];
    [_queue close];
    return success;
}
- (BOOL)expInstrucitonExist:(NSString *)expInstrucitonID
{
    BOOL exist;
    
    return exist;
}

/**
 *  写入一条数据到说明书试剂表
 */
- (BOOL)insertIntoExpReagent:(NSDictionary *)expReagent
{
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        
    }];
    [_queue close];
    return success;
}
/**
 *  写入一条数据到耗材表
 */
- (BOOL)insertIntoConsumable:(NSDictionary *)consumable
{
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        
    }];
    [_queue close];
    return success;
}
/**
 *  写入一条数据到流程
 */
- (BOOL)insertIntoProcess:(NSDictionary *)expProcess
{
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        
    }];
    [_queue close];
    return success;
}
/**
 *  写入一条数据到设备表
 */
- (BOOL)insertIntoExpEquipment:(NSDictionary *)expEquipment
{
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        
    }];
    [_queue close];
    return success;
}
@end
