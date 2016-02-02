//
//  QuizViewController.m
//  Quiz
//
//  Created by 7road on 15/7/21.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()

//添加数组对象
@property (nonatomic) int currentQuestionIndex;
@property (nonatomic,copy) NSArray *questions;
@property (nonatomic,copy) NSArray *answers;


//IBOutlet关键字会告诉Xcode之后会使用interface Builder关联该插座变量

@property (nonatomic,weak) IBOutlet UILabel *questionLabel;
@property (nonatomic,weak) IBOutlet UILabel *answerLabel;

@end

@implementation QuizViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil
                        bundle:(NSBundle *)nibBundleOrNil
{
//调用父类实现的初始化方法
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        //创建两个数组对象，存储所需的问题和答案
        //同时，将question和ansers分别指向问题数组和答案数组
        self.questions=@[@"From what is cognac made?",
                         @"What is 7+7?",
                         @"What is the capital of Vermont?"];
        self.answers=@[@"Grapes",
                       @"14",
                       @"Montpelier"];
        self.tabBarItem.title=@"Quiz";
    }
    
    
    return self;
}


-(IBAction)showQuestion:(id)sender
{
    self.currentQuestionIndex++;
    
    if(self.currentQuestionIndex==[self.questions count])
    {
        //回到第一个问题
        self.currentQuestionIndex=0;
    }
    NSString * question=self.questions[self.currentQuestionIndex];
    self.questionLabel.text=question;
    self.answerLabel.text=@"???";
}

-(IBAction)showAnswer:(id)sender
{
    NSString * answer=self.answers[self.currentQuestionIndex];
    self.answerLabel.text=answer;
}

@end
