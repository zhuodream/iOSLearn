//
//  main.cpp
//  longeststr
//
//  Created by 7road on 15/9/15.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#include <iostream>
using namespace std;
//判断传递的字符串是否是回文，并返回回文长度
int count(string s)
{
    if(s.length()==1) return 1;
    int low=0;
    int high=s.length();
   // cout<<"high=="<<high<<endl;
    while(low<=high)
    {
        //cout<<"s"<<"["<<low<<"]"<<s[low]<<" "<<"s"<<"["<<high-1<<"]"<<s[high-1]<<endl;
        //cout<<"low=="<<low<<" "<<"high=="<<high<<endl;
        if(s[low]!=s[high-1]) return 0;
        low++;
        high--;
    }
    return s.length();
}
string findLong(int length,string s)
{
    string cop="";
    int len=0;
    int max=0;
    string lstr="";
    for(int i=length;i<s.length();i++)
    {
        cop=cop+s[i];
        //cout<<cop<<endl;
        len=count(cop);
        //cout<<"length=="<<len<<endl;
        if(len>max)
        {
            max=len;
            lstr=cop;
        }
        
    }
    return lstr;
}

string longestPalindrome(string s) {
    if(s.length()==0||s.empty()) return nullptr;
    string cop="";
    string lstr="";
    for(int i=0;i<s.length();i++)
    {
        cop=findLong(i,s);
        if(cop.length()>lstr.length()) lstr=cop;
    }
    
    return lstr;
}

int main(int argc, const char * argv[]) {
   
    string str="abbaacbbca";
    cout<<longestPalindrome(str)<<endl;
    return 0;
}
