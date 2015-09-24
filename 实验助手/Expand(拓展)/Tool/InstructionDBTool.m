//
//  InstructionDBTool.m
//  实验助手
//
//  Created by sxq on 15/9/24.
//  Copyright © 2015年 SXQ. All rights reserved.
//
#import <FMDB/FMDB.h>
#import <FMDB/FMDatabaseQueue.h>
#import "InstructionDBTool.h"
#define InstructionDBName @"instruction.sqlite"
static FMDatabaseQueue *_queue;
@implementation InstructionDBTool
+ (void)setup
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
+ (void)downloadInstruction:(NSDictionary *)instructionData completion:(CompletionBlock)completion
{
    [self setup];
    //插入实验主表数据
    NSDictionary *expInstructionMain = instructionData[@"expInstructionMain"];
    if ([self downloadedInstruction:expInstructionMain]) {
        completion(NO,@{@"msg" :@"Insruction already download"});
        return;
    }
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"insert into t_expinstructionsMain (expinstructionid ,experimentname ,experimentdesc ,experimenttheory ,provideuser ,supplierid ,suppliername ,productnum ,expcategoryid ,expsubcategoryid ,createdate ,expversion ,allowdownload ,filterstr ,reviewcount ,downloadcount) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",expInstructionMain[@"expInstructionID"],expInstructionMain[@"experimentName"],expInstructionMain[@"experimentDesc"],expInstructionMain[@"experimentTheory"],expInstructionMain[@"provideUser"],expInstructionMain[@"supplierID"],expInstructionMain[@"supplierName"],expInstructionMain[@"productNum"],expInstructionMain[@"expCategoryID"],expInstructionMain[@"expSubCategoryID"],expInstructionMain[@"createDate"],expInstructionMain[@"expVersion"],expInstructionMain[@"allowDownload"],expInstructionMain[@"filterStr"],expInstructionMain[@"reviewCount"],expInstructionMain[@"downloadCount"]];
    }];
}
/**
 *  说明书是否下载
 */
+ (BOOL)downloadedInstruction:(NSDictionary *)expInstructionMain
{
    NSString *expInstructionID = expInstructionMain[@"expInstructionID"];
    __block FMResultSet *rs = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        rs = [db executeQuery:@"SELECT t_expinstructionsMain.expinstructionid FROM t_expinstructionsMain WHERE expinstructionid == ?",expInstructionID];
    }];
    return rs.next;
}
@end
