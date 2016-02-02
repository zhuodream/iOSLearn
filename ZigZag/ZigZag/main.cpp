//
//  main.cpp
//  ZigZag
//
//  Created by 7road on 15/9/18.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#include <iostream>
using namespace std;
class Solution {
public:
    string convert(string s, int numRows) {
        if(s.empty()||numRows<=1) return s;
        int len = s.length();
        string *p = new string[numRows];
        int row = 0;
        int delta = 1;//代表正向 反向
        for(int i= 0; i < len; i++)
        {
            p[row] += s[i];
            cout << p[row] << endl;
            row += delta;
            if(row >= numRows)
            {
                row = numRows - 2;
                delta = -1;
            }
            
            if(row < 0)
            {
                row = 1;
                delta = 1;
            }
        }
        
        string ret = "";
        for(int i = 0; i < numRows; i++)
        {
            ret += p[i];
        }
        
        delete [] p;
        
        return ret;
    }
};

int main(int argc, const char * argv[]) {
    
    string s = "PAYPALISHIRING";
    Solution solve;
    string t = solve.convert(s, 3);
    cout << "t==" << t << endl;
    
    return 0;
}
