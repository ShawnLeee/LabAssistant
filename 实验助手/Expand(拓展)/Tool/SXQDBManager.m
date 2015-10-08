//
//  SXQDBManager.m
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//
@import UIKit;
#import <FMDB/FMDB.h>
#import "SXQDBManager.h"
#import "NSString+Date.h"
#import "SXQExpInstruction.h"
#import "SXQInstructionStep.h"
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
#warning changed
//        [self insertIntoInstructionMain:expMain db:db];
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
-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    NSString *resultStr = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(puuid);
    CFRelease(uuidString);
    return resultStr;
}
/**
 *  写一条纪录到我的实验主表
 *
 */
- (BOOL)insertIntoMyExp:(NSString *)instrucitonID;
{
    __block BOOL success = NO;
#warning userid
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *myExpId = [self uuid];
        SXQExpInstruction *instruction = [self fetchInstructionWithInstructionID:instrucitonID db:db];
        NSString *addMyExpSql = [NSString stringWithFormat:@"insert into t_myExp ( MyExpID , ExpInstructionID , UserID , CreateTime , CreateYear,CreateMonth , FinishTime , ExpVersion , IsReviewed ,IsCreateReport  , IsUpload , ReportName , ReportLocation ,ReportServerPath ,  ExpState ,ExpMemo ) values('%@','%@','%@','%@','%@','%@','%@','%d','%d','%d','%d','%@','%@','%@','%d','%@')",myExpId,instruction.expInstructionID,@"4028c681494b994701494b99aba50000",[NSString dw_currentDate],[NSString dw_year],[NSString dw_month],@"",instruction.expVersion,0,0,0,@"",@"",@"",0,@""];
        success = [db executeUpdate:addMyExpSql];
        [self addMyExpProcessInstructionID:instrucitonID myExpId:myExpId db:db];
    }];
    [_queue close];
    return success;
}

/**
 * 根据说明书ID取一条说明书纪录
 */
- (SXQExpInstruction *)fetchInstructionWithInstructionID:(NSString *)instructionID db:(FMDatabase *)db;
{
    __block SXQExpInstruction *expInstruction = [SXQExpInstruction new];
        FMResultSet *rs = [db executeQuery:@"select * from t_expinstructionsMain where expinstructionid == ?",instructionID];
        while (rs.next) {
            expInstruction.expInstructionID = [rs stringForColumn:@"expinstructionid"];
            expInstruction.expVersion = [rs intForColumn:@"expversion"];
        }
    return expInstruction;
}
/**
 *  根据说明书ID取实验流程
 *
 */
- (NSArray *)fetchExpProcessWithInstructionID:(NSString *)instructionId db:(FMDatabase *)db
{
    NSMutableArray *stepArr = [NSMutableArray array];
    FMResultSet *rs = [db executeQuery:@"select * from t_expProcess where  expInstructionID == ?",instructionId];
    while (rs.next) {
        SXQInstructionStep *step = [SXQInstructionStep new];
        step.expInstructionID = instructionId;
        step.expStepID = [rs stringForColumn:@"expStepID"];
        step.expStepDesc = [rs stringForColumn:@"expStepDesc"];
        step.expStepTime = [rs stringForColumn:@"expStepTime"];
        step.stepNum = [rs stringForColumn:@"stepNum"];
        [stepArr addObject:step];
    }
    return [stepArr copy];
    
}
/**
 * 写一条纪录到我的实验步骤
 */
- (BOOL)addMyExpProcessInstructionID:(NSString *)instructionID myExpId:(NSString *)expID db:(FMDatabase *)db
{
    NSArray *stepArr = [self fetchExpProcessWithInstructionID:instructionID db:db];
    [stepArr enumerateObjectsUsingBlock:^(SXQInstructionStep *step, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *addExpProcessSql = [NSString stringWithFormat:@"insert into t_myExpProcess (MyExpProcessID ,MyExpID ,ExpInstructionID ,ExpStepID ,StepNum ,ExpStepDesc ,ExpStepTime ,IsUseTimer ,ProcessMemo ,IsActiveStep) values ('%@','%@','%@','%@','%@','%@','%@','%d','%@','%d')",[self uuid],expID,step.expInstructionID,step.expStepID,step.stepNum,step.expStepDesc,@"",0,@"",0];
        [db executeUpdate:addExpProcessSql];
    }];
    return NO;
}

/**
 *  写入一条数据到说明书主表
 */
- (BOOL)insertIntoInstructionMain:(SXQExpInstruction *)expInstruction db:(FMDatabase *)db
{
    __block BOOL success = NO;
     success = [db executeUpdate:@"insert into t_expinstructionsMain (expinstructionid ,experimentname ,experimentdesc ,experimenttheory ,provideuser ,supplierid ,suppliername ,productnum ,expcategoryid ,expsubcategoryid ,createdate ,expversion ,allowdownload ,filterstr ,reviewcount ,downloadcount) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",expInstruction.expInstructionID, expInstruction.experimentName,expInstruction.experimentDesc,expInstruction.experimentTheory,expInstruction.provideUser,expInstruction.supplierID,expInstruction.supplierName,expInstruction.productNum ,expInstruction.expCategoryID,expInstruction.expSubCategoryID ,expInstruction.createDate,expInstruction.expVersion,expInstruction.allowDownload,expInstruction.filterStr,expInstruction.reviewCount,expInstruction.downloadCount];
    return success;
}
/**
 *  说明书是否已存在
 *
 */
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
 *  我的实验是否已存在
 *
 */
- (BOOL)myExpExist:(NSString *)expId
{
    __block BOOL exist = NO;
    [_queue inDatabase:^(FMDatabase *db) {
         FMResultSet *rs = [db executeQuery:@"SELECT t_myExp.MyExpID FROM t_myExp WHERE MyExpID == ?",expId];
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
            NSDictionary *instruction =  @{@"expInstructionID" : expinstructionid ,@"experimentName" : experimentname ,@"uploadTime" : uploadTime? :@"",@"editTime":editTime ? :@"" };
            [tmpArr addObject:instruction];
        }
        resultArr = [tmpArr copy];
    }];
    [_queue close];
    
    return resultArr;
}
/**
 *  根据实验id,实验步骤ID，写入一条备注
 */
- (BOOL)writeRemark:(NSString *)remark withExpId:(NSString *)expId expProcessID:(NSString *)expProcessId
{
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from t_myExpProcess where MyExpID == ?and MyExpProcessID == ?",expId,expProcessId];
        while (rs.next) {
            success = [db executeUpdate:@"update t_myExpProcess set ProcessMemo=? where MyExpID == ?and MyExpProcessID == ?",remark,expId,expProcessId];
        }
    }];
    return success;
}
@end




