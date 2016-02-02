//
//  main.cpp
//  ZYXBoostAsio
//
//  Created by 7road on 15/9/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#include <iostream>
#include <boost/array.hpp>
#include <boost/asio.hpp>
#include <boost/thread.hpp>
using boost::asio::ip::tcp;

void test_connect(const char * argv[])
{
    try {
        boost::asio::io_service io_service;
        //        //1.解析器方法，常用来解析域名，如将www.baidu.com解析为ip地址
        //        tcp::resolver resolver(io_service);
        //        //解析器查询服务器名称和服务的名称
        //        tcp::resolver::query query(argv[1], "5000");
        //        tcp::resolver::iterator endpoint_iterator = resolver.resolve(query);
        //        tcp::socket socket(io_service);
        //        boost::asio::connect(socket, endpoint_iterator);
        
        //2.简便方法
        tcp::socket socket(io_service);
        tcp::endpoint endpoint(boost::asio::ip::address_v4::from_string("127.0.0.1"), 5000);
        socket.connect(endpoint);
        for (; ; )
        {
            boost::array<char, 128> buf;
            boost::system::error_code error;
            
            size_t len = socket.read_some(boost::asio::buffer(buf), error);
            
            if (error == boost::asio::error::eof)
            {
                break;
            }
            else if(error)
            {
                throw boost::system::system_error(error);
            }
            
            std::cout.write(buf.data(), len);
        }
    } catch (std::exception & e)
    {
        std::cerr << e.what() << std::endl;
    }

}

int main(int argc, const char * argv[]) {
    std::cout << "argc = " << argc << std::endl;
    if (argc != 2) {
        std::cerr << "Usage: client <host>" << std::endl;
        return 1;
    }
    boost::thread t1(boost::bind(test_connect,argv));
    boost::thread t2(boost::bind(test_connect,argv));
    
    t1.join();
    t2.join();
    return 0;
}
