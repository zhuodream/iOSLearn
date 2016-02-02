//
//  main.cpp
//  Medianoftwosorted
//
//  Created by 7road on 15/9/8.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#include <iostream>
#include <vector>
using namespace std;

int findKth(vector<int>& num1,vector<int>& num2,int k)
{
    if(num1.size()>num2.size())
    {
        return findKth(num2,num1,k);
    }
    if(num1.size()==0)
    {
        cout<<num2[k-1]<<endl;
        return num2[k-1];
    }
    if(k==1)
        return min(num1[0],num2[0]);
    //采用二分法
    int pa=min(k/2,(int)num1.size()),pb=k-pa;
    if(num1[pa-1]<num2[pb-1])
    {
        vector<int> n((num1.begin()+pa),num1.end() );
        return findKth(n,num2,k-pa);
    }
    else if(num1[pa-1]>num2[pb-1])
    {
        vector<int> n(num2.begin()+pb,num2.end());
        return findKth(num1,n,k-pb);
    }
    else
    {
        return num1[pa-1];
    }
}
double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {
    int total=(int)nums1.size()+(int)nums2.size();
    if(total & 0x1)
        return findKth(nums1,nums2,total/2+1);
    else
        return (findKth(nums1,nums2,total/2)+findKth(nums1,nums2,total/2+1))/2.0;
}


int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    vector<int> num1={1,2,3,4,5,6};
    vector<int> num2={4,6,8,10,11};
    
    double a=findMedianSortedArrays(num1, num2);
    cout<<a<<endl;
    return 0;
}
