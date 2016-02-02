//
//  main.cpp
//  ZYXSyncUDPServer
//
//  Created by 7road on 15/9/30.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#include <iostream>
#include <string>
#include <ctime>
#include <boost/array.hpp>
#include <boost/asio.hpp>

using boost::asio::ip::udp;

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
        udp::socket socket(io_service, udp::endpoint(udp::v4(), 5000));
        for (; ; )
        {
            boost::array<char, 1> recv_buf;
            udp::endpoint remote_endpoint;
            boost::system::error_code error;
            socket.receive_from(boost::asio::buffer(recv_buf), remote_endpoint, 0, error);
            std::cout << "recv_buf = " << recv_buf[0] << std::endl;
            
            if (error && error != boost::asio::error::message_size)
                throw boost::system::system_error(error);
            std::string message = make_daytime_string();
            boost::system::error_code ignored_error;
            socket.send_to(boost::asio::buffer(message), remote_endpoint, 0, ignored_error);
        }
    }
    catch (std::exception &e)
    {
        std::cerr << e.what() << std::endl;
    }
    
    return 0;
}
