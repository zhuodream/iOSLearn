//
//  main.cpp
//  ZYXBoostAsionServer
//
//  Created by 7road on 15/9/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#include <iostream>
#include <ctime>
#include <string>
#include <boost/asio.hpp>
using boost::asio::ip::tcp;

std::string make_daytime_string()
{
    using namespace std;
    time_t now = time(0);
    
    return ctime(&now);
}

int main(int argc, const char * argv[]) {
    try
    {
        boost::asio::io_service io_service;
        //接收器
        tcp::acceptor acceptor(io_service, tcp::endpoint(boost::asio::ip::tcp::v4(),5000));
        for (; ; )
        {
            boost::asio::ip::tcp::socket socket(io_service);
            acceptor.accept(socket);
            
            std::string message = make_daytime_string();
            
            boost::system::error_code ignored_error;
            boost::asio::write(socket, boost::asio::buffer(message), ignored_error);
        }
    } catch (std::exception &e)
    {
        std::cerr << e.what() << std::endl;
    }
    
    return 0;
}
