//
//  main.cpp
//  ZYXAsyncUDPServer
//
//  Created by 7road on 15/9/30.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#include <iostream>
#include <boost/bind.hpp>
#include <boost/asio.hpp>
#include <boost/array.hpp>
#include <ctime>
#include <string>

using boost::asio::ip::udp;

std::string make_daytime_string()
{
    using namespace std;
    time_t now = time(0);
    
    return ctime(&now);
}

class udp_server
{
public:
    udp_server(boost::asio::io_service &io_service):socket_(io_service, udp::endpoint(udp::v4(), 5000))
    {
        start_recieve();
    }
    
private:
    void start_recieve()
    {
        socket_.async_receive_from(boost::asio::buffer(recv_buffer_), remote_endpoint_, boost::bind(&udp_server::handle_recieve, this, boost::asio::placeholders::error, boost::asio::placeholders::bytes_transferred));
    }
    
    void handle_recieve(const boost::system::error_code &error, std::size_t bytes_transfered)
    {
        if (!error || error == boost::asio::error::message_size)
        {
            boost::shared_ptr<std::string> message(new std::string(make_daytime_string()));
            socket_.async_send_to(boost::asio::buffer(*message), remote_endpoint_, boost::bind(&udp_server::handle_send, this, message, boost::asio::placeholders::error, boost::asio::placeholders::bytes_transferred));
            start_recieve();
        }
    }
    
    void handle_send(boost::shared_ptr<std::string> message, const boost::system::error_code &error, std::size_t bytes_transfered)
    {
    }
    
    udp::socket socket_;
    udp::endpoint remote_endpoint_;
    boost::array<char, 1> recv_buffer_;
};

int main(int argc, const char * argv[]) {
    
    try
    {
        boost::asio::io_service io_service;
        udp_server server(io_service);
        io_service.run();
    }
    catch (std::exception &e)
    {
        std::cerr << e.what() << std::endl;
    }
    
    return 0;
}
