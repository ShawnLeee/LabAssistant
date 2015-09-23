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
#define ExperimentStepURL @"http://172.18.0.55:8080/LabAssistant/lab/getAllProcessExceptComplete?userID=4028c681494b994701494b99aba50000"
//附近的试剂交换
#define AdjacentReagentURL @"http://172.18.3.117:8080/LabAssistant/map/around"
////////////////////////////////////////////实验部分////////////////////////////////////

//////////////////////////////说明书//////////////////////////////////////////////////////

//所有说明书
#define AllExpURL @"http://172.18.0.55:8080/LabAssistant/expCategory/allExpCategory"
//二级分类
#define SubExpURL @"http://172.18.0.55:8080/LabAssistant/expCategory/getSubCategoryByPID"
//说明书列表
#define InstructionListURL @"http://172.18.0.55:8080/LabAssistant/lab/getInstructionsBySubCategoryID"
//说明书下载
#define DownloadInstructionURL @"http://172.18.0.55:8080/LabAssistant/lab/downloadInstruction"
//说明书详情
#define InstructionDetailURL @"http://172.18.0.55:8080/LabAssistant/lab/getInstructionDetail"
//////////////////////////////说明书//////////////////////////////////////////////////////


//////////////////////////////登录/注册//////////////////////////////////////////////////////
#define LoginURL @"http://172.18.0.55:8080/LabAssistant/login"
#define SignUpURL @"http://172.18.0.55:8080/LabAssistant/register"
//////////////////////////////登录/注册//////////////////////////////////////////////////////
#endif
