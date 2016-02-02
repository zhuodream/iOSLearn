//
//  main.cpp
//  longestsubstr
//
//  Created by 7road on 15/9/11.
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
    while(low<=high)
    {
        if(s[low++]!=s[high--]) return 0;
    }
    
    return high;
}

string longestPalindrome(string s) {
    if(s.length()==0||s.empty()) return nullptr;
    int max=0;
    int len=0;
    string cop="";
    string lstr="";
    for(int i=0;i<s.length();i++)
    {
        for(int j=0;j<s.length();)
        {
            if(i==s.length()) j++;
            if(j==0) cop=cop+s[i];
            else cop=cop+s[j];
            len=count(cop);
            if(len>max) {
                max=len;
                lstr=cop;
            }
        }
        cop="";
    }
    
    return lstr;
}

int main(int argc, const char * argv[]) {
    
    string s="a";
    string p=longestPalindrome(s);
    cout<<"aaaaa"<<endl;
    cout<<s<<endl;
    
    return 0;
}
