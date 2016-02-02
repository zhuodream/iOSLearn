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
#include <boost/thread/shared_mutex.hpp>
namespace
{
    boost::mutex mutex;
    boost::shared_mutex shared_mutex;
    
    void wait(int seconds)
    {
        boost::this_thread::sleep(boost::posix_time::seconds(seconds));
    }
    
    void threadfun1()
    {
        for (int i = 0; i < 5; ++i)
        {
            wait(1);
            mutex.lock();
            printf("%d\n",i);
            mutex.unlock();
        }
    }
    
    void threadfun2()
    {
        for (int i = 0; i < 5; ++i)
        {
            wait(1);
            boost::lock_guard<boost::mutex> lock(mutex);
            printf("%d\n",i);
        }
    }
    
    void threadfun3()
    {
        for (int i = 0; i < 5; ++i)
        {
            wait(1);
            // unique_lock<boost::mutex> = scoped_lock
            boost::unique_lock<boost::mutex> lock(mutex);
            std::cout << lock.owns_lock() << std::endl;
            printf("%d\n",i);
        }
    }
}

// 1. mutex例子
void test_thread_syn1()
{
    boost::thread t1(&threadfun1);
    boost::thread t2(&threadfun1);
    
    t1.join();
    t2.join();
}

//  2. lock_guard例子
void test_thread_syn2()
{
    boost::thread t1(&threadfun2);
    boost::thread t2(&threadfun2);
    
    t1.join();
    t2.join();
}

// 3. scoped_lock例子
void test_thread_syn3()
{
    boost::thread t1(&threadfun3);
    boost::thread t2(&threadfun3);
    
    t1.join();
    t2.join();
}

//int main()
//{
//    test_thread_syn3();
//    return 0;
//}
