//
//  main.cpp
//  ZYXBoostLearn
//
//  Created by 7road on 15/9/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#include <iostream>
#include <boost/thread.hpp>
#include <boost/thread/mutex.hpp>
#include <boost/thread/recursive_mutex.hpp>
namespace {
    boost::mutex g_mutex;
    
    void threadfun1()
    {
        printf("enter threadfun1...");
        boost::lock_guard<boost::mutex> lock(g_mutex);
        printf("execute threadfun1...");
    }
    
    void threadfun2()
    {
        printf("enter threadfun2...");
        boost::lock_guard<boost::mutex> lock(g_mutex);
        threadfun1();
        printf("execute threadfun2...");
    }
}

namespace {
    boost::recursive_mutex g_rec_mutex;
    
    void threadfun3()
    {
        printf("enter threadfun3...");
        boost::recursive_mutex::scoped_lock lock(g_rec_mutex);
        // 当然这种写法也可以
        // boost::lock_guard<boost::recursive_mutex> lock(g_rec_mutex);
        printf("execute threadfun3...");
    }
    
    void threadfun4()
    {
        printf("enter threadfun4...");
        boost::recursive_mutex::scoped_lock lock(g_rec_mutex);
        threadfun3();
        printf("execute threadfun4...");
    }
}

// 死锁的例子
void test_thread_deadlock()
{
    threadfun2();
}

// 利用递归式互斥量来避免这个问题
void test_thread_recursivelock()
{
    threadfun4();
}

//int main()
//{
//    test_thread_recursivelock();
//    return 0;
//}