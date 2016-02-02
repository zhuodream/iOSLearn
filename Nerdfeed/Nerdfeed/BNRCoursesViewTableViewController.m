//
//  BNRCoursesViewTableViewController.m
//  Nerdfeed
//
//  Created by 7road on 15/8/3.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "BNRCoursesViewTableViewController.h"
#import "BNRWebViewController.h"

@interface BNRCoursesViewTableViewController ()<NSURLSessionDataDelegate>

@property (nonatomic)NSURLSession *session;

@property (nonatomic,copy)NSArray *courses;

@end

@implementation BNRCoursesViewTableViewController

//覆盖父类的 initWithStyle:方法
-(instancetype)initWithStyle:(UITableViewStyle)style
{
    self=[super initWithStyle:style];
    if(self)
    {
        self.navigationItem.title=@"BNR Courses";
        //配置上传或者下载数据的方案
        NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
        //_session=[NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
        //设置认证要求
        _session=[NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        [self fetchFeed];
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//发出请求连接
-(void)fetchFeed
{
    NSString *requestString=@"https://bookapi.bignerdranch.com/private/courses.json";
    NSURL *url=[NSURL URLWithString:requestString];
    NSURLRequest *req=[NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask=[self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //默认情况下，NSURLSessionDataTask是在后台线程中执行completionHandler
        //        NSString *json=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",json);
        
        //使用NSJSONSerialization解析json数据
        NSDictionary *jsonObject=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.courses=jsonObject[@"courses"];
        NSLog(@"%@",self.courses);
        
        //在主线程中执行reloadData方法
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
       
    }];
    //NSURLSessionTask在刚创建的时候处于暂停状态，所以需手动调用resume方法
    [dataTask resume];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.courses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSDictionary *course=self.courses[indexPath.row];
    cell.textLabel.text=course[@"title"];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *course=self.courses[indexPath.row];
    NSURL *URL=[NSURL URLWithString:course[@"url"]];
    
    self.webViewController.title=course[@"title"];
    self.webViewController.URL=URL;
    if(!self.splitViewController)
    {
        [self.navigationController pushViewController:self.webViewController animated:YES];
    }
}

//处理web服务的认证要求
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    NSURLCredential *cred=[NSURLCredential credentialWithUser:@"BigNerdRanch" password:@"AchieveNerdvana" persistence:NSURLCredentialPersistenceForSession];
    
    completionHandler(NSURLSessionAuthChallengeUseCredential,cred);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
