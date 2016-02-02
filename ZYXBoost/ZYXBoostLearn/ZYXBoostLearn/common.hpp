//
//  common.hpp
//  ZYXBoostLearn
//
//  Created by 7road on 15/9/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#ifndef common_hpp
#define common_hpp

#include <stdio.h>
#include <log4cplus/logger.h>	//定义Log对象
#include <log4cplus/configurator.h>
#include <log4cplus/consoleappender.h>	//输出到控制台
#include <log4cplus/fileappender.h>	//输出到文件
#include <log4cplus/layout.h>	//输出格式
extern log4cplus::Logger g_logger;

#define PRINT_TRACE(s) LOG4CPLUS_TRACE(g_logger, s);
#define PRINT_DEBUG(s) LOG4CPLUS_DEBUG(g_logger, s);
#define PRINT_INFO(s) LOG4CPLUS_INFO(g_logger, s);
#define PRINT_ERROR(s) LOG4CPLUS_ERROR(g_logger, s);
#define PRINT_FATAL(s) LOG4CPLUS_FATAL(g_logger, s);

#endif /* common_hpp */
