//
//  SXQDBManager.m
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//
@import UIKit;
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
        
        [[self setupMyInstruction] enumerateObjectsUsingBlock:^(NSString *sql, NSUInteger idx, BOOL * _Nonnull stop) {
            [db executeUpdate:sql];
        }];
        
        [[self setupMyExp] enumerateObjectsUsingBlock:^(NSString *sql, NSUInteger idx, BOOL * _Nonnull stop) {
            [db executeUpdate:sql];
        }];
    }];
    [_queue close];
}
- (NSArray *)setupMyInstruction
{
    //实验说明书主表
    NSString *instuctionMainSQL = @"create table if not exists t_expinstructionsMain(expinstructionid text primary key,experimentname text,experimentdesc text,experimenttheory text,provideuser text,supplierid text,suppliername text,productnum text,expcategoryid text,expsubcategoryid text,createdate numeric,expversion integer,allowdownload integer,filterstr text,reviewcount integer,downloadcount integer,uploadTime text,editTime text);";
    //实验试剂表
    NSString *expReagentSQL = @"create table if not exists t_expreaget (createMethod text,expInstructionID text,expReagentID text primary key,reagentCommonName text,reagentID text,reagentName text,reagentSpec text,useAmount integer);";
    //实验流程表
    NSString *expProcessSQL = @"create table if not exists t_expProcess (expInstructionID text,expStepDesc text,expStepID text primary key,expStepTime integer,stepNum integer);";
    //实验设备表
    NSString *expEquipmetnSQL = @"create table if not exists t_expEquipment (equipmentID text ,equipmentFactory text,equipmentName text,expEquipmentID text primary key,expInstructionID text);";
    //实验耗材表
    NSString *expConsumableSQL = @"create table if not exists t_expConsumable (consumableCount integer,consumableFactory text,consumableID text,consumableType text,expConsumableID text primary key,expInstructionID text);";
    return @[instuctionMainSQL,expReagentSQL,expProcessSQL,expEquipmetnSQL,expConsumableSQL];
}
- (NSArray *)setupMyExp
{
    //我的说明书表
    NSString *myExpInstruction = @"create table if not exists t_myExpInstruction (MyExpInstructionID text,ExpInstructionID text,UserID text,DownloadTime numeric);";
    //我的实验主表
    NSString *myExpSQL = @"create table if not exists t_myExp( MyExpID text primary key, ExpInstructionID text, UserID text, CreateTime numeric, CreateYear integer,CreateMonth  integer, FinishTime numeric, ExpVersion integer, IsReviewed integer,IsCreateReport  integer, IsUpload integer, ReportName text, ReportLocation text,ReportServerPath  text,  ExpState integer,ExpMemo  text);";
    //我的实验试剂表
    NSString *myExpReageneSQL = @"create table if not exists t_myExpReagent( MyExpReagentID text primary key, MyExpID text, ExpInstructionID text,ReagentID  text, SupplierID text);";
    //我的实验耗材表
    NSString *myExpConsumableSQL = @"create table if not exists t_myExpConsumable(MyExpConsumableID text primary key,MyExpID text,ExpInstructionID text,ConsumableID text,SupplierID text);";
    //我的实验设备表
    NSString *myExpEquimentSQL = @"create table if not exists t_myExpEquipment(MyExpEquipmentID text primary key,MyExpID text,ExpInstructionID text,EquipmentID text,SupplierID text);";
    //我的实验步骤表
    NSString *myExpProcessSQL = @"create table if not exists t_myExpProcess( MyExpProcessID text primary key,MyExpID text,ExpInstructionID text,ExpStepID text,StepNum integer,ExpStepDesc text,ExpStepTime integer,IsUseTimer integer,ProcessMemo text,IsActiveStep integer);";
    //我的实验步骤附件表
    NSString *myExpProcessAttchSQL = @"create table if not exists t_myExpProcessAttch(MyExpProcessAttchID text primary key, MyExpID text,ExpInstructionID text,ExpStepID text,AttchmentName text,AttchmentLocation text,AttchmentServerPath text,IsUpload integer);";
    //我的实验计划表
    NSString *myExpPlanSQL = @"create table if not exists t_myExpPlan (MyExpPlanID text primary key,UserID text,PlanDate numeric,PlanOfYear integer,PlanOfDate integer,ExpInstructionID text,ExperimentName text);";
    NSArray *sqlArr = @[myExpInstruction,myExpSQL,myExpReageneSQL,myExpConsumableSQL,myExpEquimentSQL,myExpProcessSQL,myExpProcessAttchSQL,myExpPlanSQL];
    return sqlArr;
}
- (void)insertInstruciton:(id)instruction completion:(CompletionHandler)completion
{
     NSDictionary *expMain = instruction[@"expInstructionMain"];
    if ([self expInstrucitonExist:expMain[@"expInstructionID"]]) {
        completion(NO,@{@"msg" :@"说明书已下载"});
        return;
    }
    [_queue inDatabase:^(FMDatabase *db) {
        [self insertIntoInstructionMain:expMain db:db];
        NSArray *consumableArr = instruction[@"expConsumable"];
        [consumableArr enumerateObjectsUsingBlock:^(NSDictionary *expConsumable, NSUInteger idx, BOOL * _Nonnull stop) {
            [self insertIntoConsumable:expConsumable database:db];
        }];
        NSArray *equipmentArr = instruction[@"expEquipment"];
        [equipmentArr enumerateObjectsUsingBlock:^(NSDictionary *expEquipment, NSUInteger idx, BOOL * _Nonnull stop) {
            [self insertIntoExpEquipment:expEquipment database:db];
        }];
        NSArray *expProcessArr = instruction[@"expProcess"];
        [expProcessArr enumerateObjectsUsingBlock:^(NSDictionary *expProcess, NSUInteger idx, BOOL * _Nonnull stop) {
            [self insertIntoProcess:expProcess database:db];
        }];
        NSArray *expReagentArr = instruction[@"expReagent"];
        [expReagentArr enumerateObjectsUsingBlock:^(NSDictionary *expReagent, NSUInteger idx, BOOL * _Nonnull stop) {
            [self insertIntoExpReagent:expReagent dataBase:db];
        }];
    }];
    [_queue close];
}
/**
 *  写入一条数据到说明书主表
 */
- (BOOL)insertIntoInstructionMain:(NSDictionary *)expInstructionMain db:(FMDatabase *)db
{
    __block BOOL success = NO;
     success = [db executeUpdate:@"insert into t_expinstructionsMain (expinstructionid ,experimentname ,experimentdesc ,experimenttheory ,provideuser ,supplierid ,suppliername ,productnum ,expcategoryid ,expsubcategoryid ,createdate ,expversion ,allowdownload ,filterstr ,reviewcount ,downloadcount) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",expInstructionMain[@"expInstructionID"],expInstructionMain[@"experimentName"],expInstructionMain[@"experimentDesc"],expInstructionMain[@"experimentTheory"],expInstructionMain[@"provideUser"],expInstructionMain[@"supplierID"],expInstructionMain[@"supplierName"],expInstructionMain[@"productNum"],expInstructionMain[@"expCategoryID"],expInstructionMain[@"expSubCategoryID"],expInstructionMain[@"createDate"],expInstructionMain[@"expVersion"],expInstructionMain[@"allowDownload"],expInstructionMain[@"filterStr"],expInstructionMain[@"reviewCount"],expInstructionMain[@"downloadCount"]];
    return success;
}
- (BOOL)expInstrucitonExist:(NSString *)expInstructionID
{
    __block BOOL exist = NO;
    [_queue  inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT t_expinstructionsMain.expinstructionid FROM t_expinstructionsMain WHERE expinstructionid == ?",expInstructionID];
        exist = rs.next;
    }];
    [_queue close];
    return exist;
}


/**
 *  写入一条数据到说明书试剂表
 */
- (BOOL)insertIntoExpReagent:(NSDictionary *)expReagent dataBase:(FMDatabase *)db
{
    __block BOOL success = NO;
            success = [db executeUpdate:@"insert into t_expreaget (createMethod,expInstructionID ,expReagentID ,reagentCommonName,reagentID ,reagentName ,reagentSpec ,useAmount) values (?,?,?,?,?,?,?,?)",expReagent[@"createMethod"],expReagent[@"expInstructionID"],expReagent[@"expReagentID"],expReagent[@"reagentCommonName"],expReagent[@"reagentID"],expReagent[@"reagentName"],expReagent[@"reagentSpec"],expReagent[@"useAmount"]];
    return success;
}
/**
 *  写入一条数据到耗材表
 */
- (BOOL)insertIntoConsumable:(NSDictionary *)consumable database:(FMDatabase *)db
{
    __block BOOL success = NO;
        success = [db executeUpdate:@"insert into t_expConsumable (consumableCount ,consumableFactory ,consumableID,consumableType,expConsumableID,expInstructionID) values (?,?,?,?,?,?)",consumable[@"consumableCount"],consumable[@"consumableFactory"],consumable[@"consumableID"],consumable[@"consumableType"],consumable[@"expConsumableID"],consumable[@"expInstructionID"]];
    return success;
}
/**
 *  写入一条数据到流程
 */
- (BOOL)insertIntoProcess:(NSDictionary *)expProcess database:(FMDatabase *)db
{
    __block BOOL success = NO;
        success = [db executeUpdate:@"insert into t_expProcess (expInstructionID ,expStepDesc ,expStepID ,expStepTime ,stepNum ) values (?,?,?,?,?)",expProcess[@"expInstructionID"],expProcess[@"expStepDesc"],expProcess[@"expStepID"],expProcess[@"expStepTime"],expProcess[@"stepNum"]];
    return success;
}
/**
 *  写入一条数据到设备表
 */
- (BOOL)insertIntoExpEquipment:(NSDictionary *)expEquipment database:(FMDatabase *)db
{
    __block BOOL success = NO;
        success = [db executeUpdate:@"insert into  t_expEquipment (equipmentID ,equipmentFactory ,equipmentName ,expEquipmentID ,expInstructionID ) values (?,?,?,?,?)",expEquipment[@"equipmentID"],expEquipment[@"equipmentFactory"],expEquipment[@"equipmentName"],expEquipment[@"expEquipmentID"],expEquipment[@"expInstructionID"]];
    return success;
}
- (NSArray *)chechAllInstuction
{
    __block NSArray *resultArr = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *tmpArr = [NSMutableArray array];
        FMResultSet *rs = [db executeQuery:@"select * from t_expinstructionsMain"];
        while (rs.next) {
            //"create table if not exists t_expinstructionsMain(expinstructionid text primary key,experimentname text,experimentdesc text,experimenttheory text,provideuser text,supplierid text,suppliername text,productnum text,expcategoryid text,expsubcategoryid text,createdate numeric,expversion integer,allowdownload integer,filterstr text,reviewcount integer,downloadcount integer);";
            NSString *expinstructionid = [rs stringForColumn:@"expinstructionid"];
            NSString *experimentname = [rs stringForColumn:@"experimentname"];
            NSString *uploadTime = [rs stringForColumn:@"uploadTime"];
            NSString *editTime = [rs stringForColumn:@"editTime"];
            NSDictionary *instruction =  @{@"expInstructionID" : expinstructionid ,@"experimentName" : experimentname };
            [tmpArr addObject:instruction];
        }
        resultArr = [tmpArr copy];
    }];
    [_queue close];
    
    return resultArr;
}
@end
