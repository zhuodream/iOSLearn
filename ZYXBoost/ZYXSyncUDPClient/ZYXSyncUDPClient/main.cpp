//
//  main.cpp
//  ZYXSyncUDPClient
//
//  Created by 7road on 15/9/30.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#include <iostream>
#include <boost/asio.hpp>
#include <boost/array.hpp>
#include <boost/thread.hpp>
#include <boost/thread/mutex.hpp>

using boost::asio::ip::udp;

boost::mutex mu;
void test_connect(const char *argv[])
{
    try
    {
        boost::asio::io_service io_service;
        
//        udp::resolver resolver(io_service);
//        boost::asio::ip::udp::resolver::query query(udp::v4(), argv[1], "5000");
//        udp::endpoint receiver_endpoint = *resolver.resolve(query);
        
        udp::socket socket(io_service);
        udp::endpoint receiver_endpoint(boost::asio::ip::address::from_string("127.0.0.1"), 5000);
        socket.open(udp::v4());
        
        boost::array<char, 128> recv_buf = {{ '1' }};
        socket.send_to(boost::asio::buffer(recv_buf), receiver_endpoint);
        
        udp::endpoint sender_point;
        size_t len = socket.receive_from(boost::asio::buffer(recv_buf), sender_point);
        
        mu.lock();
        std::cout.write(recv_buf.data(), len);
        std::cout << "sender_point = " << sender_point << std::endl;
        mu.unlock();
    }
    catch (std::exception &e)
    {
        std::cerr << e.what() << std::endl;
    }

}

int main(int argc, const char * argv[]) {

    
    if (argc != 2)
    {
        std::cerr << "Usage: client <host>" << std::endl;
        return 1;
    }
    boost::thread_group grp;
    grp.add_thread(new boost::thread(boost::bind(test_connect,argv)));
    grp.add_thread(new boost::thread(boost::bind(test_connect,argv)));
    grp.add_thread(new boost::thread(boost::bind(test_connect,argv)));
    grp.add_thread(new boost::thread(boost::bind(test_connect,argv)));
//    boost::thread t1(boost::bind(test_connect,argv));
//    boost::thread t2(boost::bind(test_connect,argv));
//    boost::thread t3(boost::bind(test_connect,argv));
    grp.join_all();
    
    return 0;
}
