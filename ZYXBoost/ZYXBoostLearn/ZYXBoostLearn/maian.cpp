//
//  main.cpp
//  ZYXBoostLearn
//
//  Created by 7road on 15/9/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#include <iostream>
#include <boost/asio.hpp>
#include <boost/bind.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>

void print(const boost::system::error_code & code, boost::asio::deadline_timer *t, int *count);

//int main(int argc, const char * argv[]) {
//    // insert code here.
//    boost::asio::io_service io;
//    int count = 0;
//    boost::asio::deadline_timer t(io, boost::posix_time::seconds(1));
//    
//    //t.wait();//同步操作
//    //异步操作需要有一个回调
//    t.async_wait(boost::bind(print, boost::asio::placeholders::error, &t, &count));
//    io.run();
//  
//    std::cout << "Final count is " << count << std::endl;
//    return 0;
//}

void print(const boost::system::error_code & code, boost::asio::deadline_timer *t, int *count)
{
    if (*count < 5) {
        std::cout << *count <<std::endl;
        ++(*count);
        std::cout << t->expires_at() << std::endl;
        t->expires_at(t->expires_at() + boost::posix_time::seconds(1));
        t->async_wait(boost::bind(print,boost::asio::placeholders::error, t, count));
    }
}
