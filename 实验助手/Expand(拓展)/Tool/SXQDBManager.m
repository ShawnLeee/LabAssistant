//
//  SXQDBManager.m
//  实验助手
//
//  Created by sxq on 15/9/25.
//  Copyright © 2015年 SXQ. All rights reserved.
//
@import UIKit;

#import "SXQExpInstruction.h"
#import "SXQExpConsumable.h"
#import "SXQExpEquipment.h"
#import "SXQExpReagent.h"
#import "SXQExpStep.h"
#import "SXQMyExperiment.h"

#import "SXQInstructionData.h"
#import <FMDB/FMDB.h>
#import "SXQDBManager.h"
#import "NSString+Date.h"
#import "SXQExpInstruction.h"
#import "SXQInstructionStep.h"
#import "SXQSupplier.h"
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
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_dbManager setupDataBase];
        });
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
    //试剂表
    NSString *reagentSQL = @"create table if not exists t_reagent(reagentID text primary key,reagentName text,reagentCommonName text,levelOneSortID text,levelTwoSortID text,originalPlace text,productNo text,agents text,specification text,price integer,chemicalName text,CASNo text,arriveDate numeric,memo text)";
    //试剂厂商关联表;                 
    NSString *reagentMapSQL = @"create table if not exists t_reagentMap(reagentMapID text primary key,reagentID text,supplierID text,isSuggestion integer)";
    //耗材表;                     
    NSString *consumableSQL = @"create table if not exists t_consumable(consumableID text primary key,consumableName text,consumableType text)";
    //耗材厂商关联表;                 
    NSString *consumableMapSQL = @"create table if not exists t_consumableMap(consumableMapID text primary key,consumableID text,supplierID text,isSuggestion integer)";
    //设备表;                     
    NSString *equipmentSQL = @"create table if not exists t_equipment (equipmentID text primary key,equipmentName text)";
    //设备厂商关联表;                 
    NSString *equipmentMapSQL = @"create table if not exists t_quipmentMap (quipmentMapID text primary key,equipmentID text,supplierID text ,isSuggestion integer)";
    //供应商
    NSString *supplierSQL = @"create table if not exists t_supplier (supplierID text primary key,supplierName text,supplierType integer,contacts text,telNo text,mobilePhone text,email text,address text)";
    return @[instuctionMainSQL,expReagentSQL,expProcessSQL,expEquipmetnSQL,expConsumableSQL,reagentSQL,reagentMapSQL,consumableSQL,consumableMapSQL,equipmentSQL,equipmentMapSQL,supplierSQL];
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

- (void)insertInstruciton:(SXQInstructionData *)instructionData completion:(CompletionHandler)completion
{
//     NSDictionary *expMain = instruction[@"expInstructionMain"];
    SXQExpInstruction *instructionMain = instructionData.expInstructionMain;
    if ([self expInstrucitonExist:instructionMain.expInstructionID]) {
        completion(NO,@{@"msg" :@"说明书已下载"});
        return;
    }
    [_queue inDatabase:^(FMDatabase *db) {
#warning changed
        [self insertIntoInstructionMain:instructionData.expInstructionMain db:db];
        
        NSArray *consumableArr = instructionData.expConsumable;
        [consumableArr enumerateObjectsUsingBlock:^(SXQExpConsumable *expConsumable, NSUInteger idx, BOOL * _Nonnull stop) {
            [self insertIntoConsumable:expConsumable database:db];
        }];
        
        NSArray *equipmentArr = instructionData.expEquipment;
        [equipmentArr enumerateObjectsUsingBlock:^(SXQExpEquipment *expEquipment, NSUInteger idx, BOOL * _Nonnull stop) {
            [self insertIntoExpEquipment:expEquipment database:db];
        }];
        
        NSArray *expProcessArr = instructionData.expProcess;
        [expProcessArr enumerateObjectsUsingBlock:^(SXQExpStep *expProcess, NSUInteger idx, BOOL * _Nonnull stop) {
            [self insertIntoProcess:expProcess database:db];
        }];
        
        NSArray *expReagentArr = instructionData.expReagent;
        [expReagentArr enumerateObjectsUsingBlock:^(SXQExpReagent *expReagent, NSUInteger idx, BOOL * _Nonnull stop) {
            [self insertIntoExpReagent:expReagent dataBase:db];
        }];
    }];
    [_queue close];
    completion(YES,@{@"msg" : @"下载成功"});
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




- (NSArray *)chechAllInstuction
{
    __block NSArray *resultArr = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *tmpArr = [NSMutableArray array];
        FMResultSet *rs = [db executeQuery:@"select * from t_expinstructionsMain"];
        while (rs.next) {
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

- (NSArray *)querySupplierWithReagetID:(NSString *)reagentID
{
    __block NSMutableArray *tempArr = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *supplierID = nil;
        FMResultSet *rs = [db executeQuery:@"select * from t_reagentMap  where reagentID == ?", reagentID];
        while (rs.next) {
            supplierID = [rs stringForColumn:@"supplierID"];
            SXQSupplier *supplier = [self fetchSupplierWithSupplierID:supplierID db:db];
            if (supplier) {
                [tempArr addObject:supplier];
            }
        }
    }];
    [_queue close];
    return [tempArr copy];
//    NSString *supplierSQL = @"create table if not exists t_supplier (supplierID text primary key,supplierName text,supplierType integer,contacts text,telNo text,mobilePhone text,email text,address text)";
    
//    NSString *reagentMapSQL = @"create table if not exists t_reagentMap(reagentMapID text primary key,reagentID text,supplierID text,isSuggestion integer)";
}
- (SXQSupplier *)fetchSupplierWithSupplierID:(NSString *)supplierID db:(FMDatabase *)db
{
   SXQSupplier *supplier = [[SXQSupplier alloc] init];
   FMResultSet *rs = [db executeQuery:@"select * from t_supplier where supplierID == ?",supplierID];
    while (rs.next) {
        supplier.supplierID = [rs stringForColumn:@"supplierID"];
        supplier.supplierName = [rs stringForColumn:@"supplierName"];
        supplier.supplierType = [rs intForColumn:@"supplierType"];
        supplier.contacts = [rs stringForColumn:@"contacts"];
        supplier.telNo = [rs stringForColumn:@"telNo"];
        supplier.mobilePhone = [rs stringForColumn:@"mobilePhone"];
        supplier.email = [rs stringForColumn:@"email"];
        supplier.address = [rs stringForColumn:@"address"];
    }
    return supplier;
}
- (void)fetchInstructionDataWithInstructionID:(NSString *)instructionId success:(void (^)(SXQInstructionData *))success
{
    
}
- (void)addExpWithInstructionData:(SXQInstructionData *)instructionData completion:(void (^)(BOOL, NSString *))completion
{
    NSString *myExpId = [self uuid];
    [_queue inDatabase:^(FMDatabase *db) {
        //1.write data to t_myExp
        [self insertIntoMyExp:instructionData.expInstructionMain myExpId:myExpId db:db];
        
        //2.write expconsumable to t_myexpconsumable
        [instructionData.expConsumable enumerateObjectsUsingBlock:^(SXQExpConsumable *consumable, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *myExpConsumableID = [self uuid];
            [self insertIntoMyExpConsumable:consumable myExpConsumabelId:myExpConsumableID myExpId:myExpId db:db];
        }];
        
        //3.write expequipment to t_myexpequipment
        [instructionData.expEquipment enumerateObjectsUsingBlock:^(SXQExpEquipment *expEquipment, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *myEquipmentId = [self uuid];
            [self insertIntoMyExpEquipment:expEquipment myExpId:myExpId myEquipmentID:myEquipmentId db:db];
        }];
        
        //4.write expprocess to t_myexpprocess
        [instructionData.expProcess enumerateObjectsUsingBlock:^(SXQExpStep *expProcess, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *myExpProcessID = [self uuid];
            [self insertIntoMyExpProcess:expProcess myExpProcessId:myExpProcessID myExpId:myExpId db:db];
        }];
        
        //5.write expreagent to t_myexpreagent
        [instructionData.expReagent enumerateObjectsUsingBlock:^(SXQExpReagent *reagent, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *myExpReagentId = [self uuid];
            [self insertIntoMyExpReagent:reagent myExpReagentId:myExpReagentId myExpId:myExpId db:db];
        }];
    }];
    [_queue close];
    completion(YES,myExpId);
}
#pragma mark 说明书操作
/**
 *  写入一条数据到流程
 */
- (BOOL)insertIntoProcess:(SXQExpStep *)expProcess database:(FMDatabase *)db
{
    BOOL success = NO;
    NSString *insertSql = [NSString stringWithFormat:@"insert into t_expProcess (expInstructionID ,expStepDesc ,expStepID ,expStepTime ,stepNum ) values ('%@','%@','%@','%@','%d')",expProcess.expInstructionID,expProcess.expStepDesc,expProcess.expStepID,expProcess.expStepTime,expProcess.stepNum];
        success = [db executeUpdate:insertSql];
    return success;
}
/**
 *  写入一条数据到设备表
 */
- (BOOL)insertIntoExpEquipment:(SXQExpEquipment *)equipment database:(FMDatabase *)db
{
    BOOL success = NO;
    NSString *insertSql = [NSString stringWithFormat:@"insert into  t_expEquipment (equipmentID ,equipmentFactory ,equipmentName ,expEquipmentID ,expInstructionID ) values ('%@','%@','%@','%@','%@')",equipment.equipmentID,equipment.equipmentFactory,equipment.equipmentName,equipment.equipmentID,equipment.expInstructionID];
        success = [db executeUpdate:insertSql];
    return success;
}
/**
 *  写入一条数据到说明书试剂表
 */
- (BOOL)insertIntoExpReagent:(SXQExpReagent *)expReagent dataBase:(FMDatabase *)db
{
    BOOL success = NO;
    NSString *insertSql = [NSString stringWithFormat:@"insert into t_expreaget (createMethod,expInstructionID ,expReagentID ,reagentCommonName,reagentID ,reagentName ,reagentSpec ,useAmount) values ('%@','%@','%@','%@','%@','%@','%@','%@')",expReagent.createMethod,expReagent.expInstructionID,expReagent.expReagentID,expReagent.reagentCommonName,expReagent.reagentID,expReagent.reagentName,expReagent.reagentSpec,expReagent.useAmount   ];
            success = [db executeUpdate:insertSql];
    return success;
}
/**
 *  写入一条数据到耗材表
 */
- (BOOL)insertIntoConsumable:(SXQExpConsumable *)consumable database:(FMDatabase *)db
{
    BOOL success = NO;
    NSString *insertSql = [NSString stringWithFormat:@"insert into t_expConsumable (consumableCount ,consumableFactory ,consumableID,consumableType,expConsumableID,expInstructionID) values ('%d','%@','%@','%@','%@','%@')",consumable.consumableCount,consumable.consumableFactory,consumable.consumableID,consumable.consumableType,consumable.expConsumableID,consumable.expInstructionID];
    
    success = [db executeUpdate:insertSql];
    return success;
}
/**
 *  写入一条数据到说明书主表
 */
- (BOOL)insertIntoInstructionMain:(SXQExpInstruction *)expInstruction db:(FMDatabase *)db
{
    BOOL success = NO;
    NSString *insertSql = [NSString stringWithFormat:@"insert into t_expinstructionsMain (expinstructionid ,experimentname ,experimentdesc ,experimenttheory ,provideuser ,supplierid ,suppliername ,productnum ,expcategoryid ,expsubcategoryid ,createdate ,expversion ,allowdownload ,filterstr ,reviewcount ,downloadcount) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%d','%@','%@','%@','%@')",expInstruction.expInstructionID,expInstruction.experimentName,expInstruction.experimentDesc,expInstruction.experimentTheory,expInstruction.provideUser,expInstruction.supplierID,expInstruction.supplierName,expInstruction.productNum,expInstruction.expCategoryID,expInstruction.expSubCategoryID,expInstruction.createDate,expInstruction.expVersion,expInstruction.allowDownload,expInstruction.filterStr,expInstruction.reviewCount,expInstruction.downloadCount];
    success = [db executeUpdate:insertSql];
    return success;
}
/**
 *  说明书是否已存在
 *
 */
- (BOOL)expInstrucitonExist:(NSString *)expInstructionID
{
    __block BOOL exist = NO;
    NSString *query = [NSString stringWithFormat:@"SELECT t_expinstructionsMain.expinstructionid FROM t_expinstructionsMain WHERE expinstructionid == '%@'",expInstructionID];
    [_queue  inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:query];
        exist = rs.next;
    }];
    [_queue close];
    return exist;
}
#pragma mark 我的实验操作
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
 *  写一条纪录到我的实验主表
 *
 */
- (BOOL)insertIntoMyExp:(SXQExpInstruction *)instruciton myExpId:(NSString *)myExpId db:(FMDatabase *)db;
{
    BOOL success = NO;
#warning userid
     NSString *addMyExpSql = [NSString stringWithFormat:@"insert into t_myExp ( MyExpID , ExpInstructionID , UserID , CreateTime , CreateYear,CreateMonth , FinishTime , ExpVersion , IsReviewed ,IsCreateReport  , IsUpload , ReportName , ReportLocation ,ReportServerPath ,  ExpState ,ExpMemo ) values('%@','%@','%@','%@','%@','%@','%@','%d','%d','%d','%d','%@','%@','%@','%d','%@')",myExpId,instruciton.expInstructionID,@"4028c681494b994701494b99aba50000",[NSString dw_currentDate],[NSString dw_year],[NSString dw_month],@"",instruciton.expVersion,0,0,0,@"",@"",@"",0,@""];
    success = [db executeUpdate:addMyExpSql];
    return success;
}
/**
 *  添加我的实验耗材
 *
 */
- (BOOL)insertIntoMyExpConsumable:(SXQExpConsumable *)consumable myExpConsumabelId:(NSString *)myExpConsumaleId myExpId:(NSString *)myExpId db:(FMDatabase *)db
{
    BOOL success = NO;
#warning supplierID
    NSString *addConsumableSql = [NSString stringWithFormat:@"insert into t_myExpConsumable(MyExpConsumableID ,MyExpID,ExpInstructionID,ConsumableID,SupplierID) values ('%@','%@','%@','%@','%@')",myExpConsumaleId,myExpId,consumable.expInstructionID,consumable.consumableID,consumable.supplierID];
    success = [db executeUpdate:addConsumableSql];
    return success;
}
/**
 *  添加我的实验试剂
 */
- (BOOL)insertIntoMyExpReagent:(SXQExpReagent *)expReagent myExpReagentId:(NSString *)myExpReagentId myExpId:(NSString *)myExpId db:(FMDatabase *)db
{
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into t_myExpReagent( MyExpReagentID, MyExpID, ExpInstructionID,ReagentID, SupplierID) values ('%@','%@','%@','%@','%@')",myExpReagentId,myExpId,expReagent.expInstructionID,expReagent.reagentID,expReagent.supplierId];
    return [db executeUpdate:insertSql];
}
/**
 *  添加我的实验设备
 *
 */
- (BOOL)insertIntoMyExpEquipment:(SXQExpEquipment *)equipment myExpId:(NSString *)myExpId  myEquipmentID:(NSString *)myEquipmentId db:(FMDatabase *)db
{
    BOOL success = NO;
    NSString *addMyExpEquipmentSql = [NSString stringWithFormat:@"insert into t_myExpEquipment(MyExpEquipmentID ,MyExpID,ExpInstructionID,EquipmentID,SupplierID) values ('%@','%@','%@','%@','%@')",myEquipmentId,myExpId,equipment.expInstructionID,equipment.equipmentID,equipment.supplierId];
    [db executeUpdate:addMyExpEquipmentSql];
    return success;
}
/**
 *  添加我的实验步骤
 */
- (BOOL)insertIntoMyExpProcess:(SXQExpStep *)expProcess myExpProcessId:(NSString *)myExpProcesId myExpId:(NSString *)myExpId db:(FMDatabase *)db
{
    BOOL success = NO;
    NSString *insertSql = [NSString stringWithFormat:@"insert into  t_myExpProcess(MyExpProcessID,MyExpID,ExpInstructionID,ExpStepID,StepNum,ExpStepDesc,ExpStepTime,IsUseTimer,ProcessMemo,IsActiveStep) values ('%@','%@','%@','%@','%d','%@','%@','%d','%@','%d')",myExpProcesId,myExpId,expProcess.expInstructionID,expProcess.expStepID,expProcess.stepNum,expProcess.expStepDesc,expProcess.expStepTime,expProcess.isUserTimer,expProcess.processMemo,expProcess.isActiveStep];
    success = [db executeUpdate:insertSql];
    return success;
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
- (void)loadCurrentDataWithMyExpId:(NSString *)myExpId completion:(void (^)(SXQCurrentExperimentData *))completioin
{
    // 去我的实验表找到实验，创建SXQMyexpEriment
    
    //我的实验步骤表找到实验步骤数组
    
}
- (SXQMyExperiment *)fetchMyExpWithMyExpId:(NSString *)myExpId db:(FMDatabase *)db
{
    
    NSString *myExpSQL = @"create table if not exists t_myExp( MyExpID text primary key, ExpInstructionID text, UserID text, CreateTime numeric, CreateYear integer,CreateMonth  integer, FinishTime numeric, ExpVersion integer, IsReviewed integer,IsCreateReport  integer, IsUpload integer, ReportName text, ReportLocation text,ReportServerPath  text,  ExpState integer,ExpMemo  text);";
    SXQMyExperiment *myExperiment = [[SXQMyExperiment alloc] init];
    FMResultSet *rs = [db executeQuery:@"select * from t_myExp where MyExpID = ?",myExpId];
    while (rs.next) {
        
    }
    return myExperiment;
}
#pragma mark Private Method
@end




