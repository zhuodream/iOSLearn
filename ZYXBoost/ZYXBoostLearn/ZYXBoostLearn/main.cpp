//
//  main.cpp
//  ZYXBoostLearn
//
//  Created by 7road on 15/9/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#include <iostream>
#include <boost/thread/thread.hpp>

namespace
{
    void wait(int seconds)
    {
        boost::this_thread::sleep(boost::posix_time::seconds(seconds));
    }
    boost::mutex mu;
    boost::condition_variable_any cond;
    
    void test_wait()
    {
        while (true)
        {
           
            boost::mutex::scoped_lock lock(mu);
            //unlock并阻塞当前线程
            cond.wait(mu);
            std::cout << boost::this_thread::get_id() << "收到notify!" << std::endl;
        }
    }
    
    void test_timed_wait()
    {
        while (true)
        {
            boost::mutex::scoped_lock lock(mu);
            if (cond.timed_wait(lock, boost::get_system_time() + boost::posix_time::seconds(3)))
            {
                std::cout << "收到notify" << std::endl;
            }
            else
            {
                std::cout << "超时，没有收到notify" << std::endl;
            }
        }
    }
}


void test_thread_wait()
{
    boost::thread t1(test_wait);
    boost::thread t2(test_wait);
    boost::thread t3(test_wait);
    boost::thread t4(test_wait);
    while (true)
    {
        wait(1);
        std::cout << "zusai" << std::endl;
        cond.notify_one();
    }
}

void test_thread_timed_wait()
{
    boost::thread t1(test_timed_wait);
    while (true)
    {
        int x;
        std::cout << "please input a number : ";
        std::cin>>x;
        cond.notify_one();
    }
}

int main()
{
    test_thread_wait();
    return 0;
}