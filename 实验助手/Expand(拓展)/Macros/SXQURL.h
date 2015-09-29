//
//  SXQURL.h
//  实验助手
//
//  Created by sxq on 15/9/11.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//

#ifndef _____SXQURL_h
#define _____SXQURL_h
////////////////////////////////////////////实验部分////////////////////////////////////
//获取实验或说明书下所有的实验步骤
#define ExperimentStepURL @"http://hualang.wicp.net:8090/LabAssistant/lab/getAllProcessExceptComplete?userID=4028c681494b994701494b99aba50000"
//附近的试剂交换
#define AdjacentReagentURL @"http://hualang.wicp.net:8090/LabAssistant/map/around"
//正在进行的实验
#define DoingExpURL @"http://hualang.wicp.net:8090/LabAssistant/lab/getDoing?userID=4028c681494b994701494b99aba50000"
//已完成的实验
#define DoneExpURL @"http://hualang.wicp.net:8090/LabAssistant/lab/getComplete?userID=4028c681494b994701494b99aba50000"
////////////////////////////////////////////实验部分////////////////////////////////////

//////////////////////////////说明书//////////////////////////////////////////////////////

//所有说明书
#define AllExpURL @"http://hualang.wicp.net:8090/LabAssistant/expCategory/allExpCategory"
//二级分类
#define SubExpURL @"http://hualang.wicp.net:8090/LabAssistant/expCategory/getSubCategoryByPID"
//说明书列表
#define InstructionListURL @"http://hualang.wicp.net:8090/LabAssistant/lab/getInstructionsBySubCategoryID"
//说明书下载
#define DownloadInstructionURL @"http://hualang.wicp.net:8090/LabAssistant/lab/downloadInstruction"
//说明书详情
#define InstructionDetailURL @"http://hualang.wicp.net:8090/LabAssistant/lab/getInstructionDetail"
//////////////////////////////说明书//////////////////////////////////////////////////////


//////////////////////////////登录/注册//////////////////////////////////////////////////////
#define LoginURL @"http://hualang.wicp.net:8090/LabAssistant/login"
#define SignUpURL @"http://hualang.wicp.net:8090/LabAssistant/register"
//////////////////////////////登录/注册//////////////////////////////////////////////////////
#endif
