//
//  main.cpp
//  ZYXBoostLearn
//
//  Created by 7road on 15/9/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#include <iostream>
#include <boost/thread.hpp>

namespace
{
    struct Run
    {
        void operator()(void)
        {
            std::cout << __FUNCTION__ << std::endl;
        }
    };
    
    void run(void)
    {
        std::cout << __FUNCTION__ << std::endl;
    }
}

void test_thread_group2()
{
    Run r;
    boost::thread_group grp;
    
    //两种方法通过线程组增加线程
    boost::thread *t = grp.create_thread(r);//使用create_thread
    grp.add_thread(new boost::thread(run));//使用add_thread
    
    grp.join_all();
    
    //两种方法移除线程
    grp.remove_thread(t);
    //delete t;
}

//int main()
//{
//    test_thread_group2();
//    
//    return 0;
//}