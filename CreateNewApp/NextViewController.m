//
//  NextViewController.m
//  CreateNewApp
//
//  Created by MAC Mini on 16/2/15.
//  Copyright © 2016年 test. All rights reserved.
//

#import "NextViewController.h"
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>
#import <PassKit/PassKit.h>
#import "NewViewController.h"

#define Width   self.view.frame.size.width
#define Height  self.view.frame.size.height


@interface NextViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITextField * textField;
@property (nonatomic ,strong)UITableView * tableView;
@property (nonatomic ,strong)NSArray * dataArray;
@end

@implementation NextViewController

-(UITableView *)tableView {

    if (!_tableView) {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(200, 0, 100, Height) style:UITableViewStyleGrouped];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorColor = [UIColor redColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundColor = [UIColor lightGrayColor];
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(20, 100, 50, 20);
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(missSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton * webViewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    webViewBtn.frame = CGRectMake(20, 200, 50, 20);
    [webViewBtn setBackgroundColor:[UIColor blueColor]];
    [webViewBtn addTarget:self action:@selector(loadingPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:webViewBtn];
    
    [self.view addSubview:self.tableView];
    
    self.dataArray = @[@"第0行",@"第1行",@"第2行",@"第3行",@"第4行",@"第5行",@"第6行",@"第7行",@"第8行",];
}

-(void)missSelf {


    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
//        WKWebView  * webView = [[WKWebView alloc] initWithFrame:self.view.frame];
//        NSURL * url = [NSURL URLWithString:@"http://www.baidu.com"];
//        NSURLRequest * request = [NSURLRequest requestWithURL:url];
//        [webView loadRequest:request];
//        [self.view addSubview:webView];
    
  
}

-(void)loadingPage {

   

    
    NSURL * url = [NSURL URLWithString:@"http://www.baidu.com"];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
    [self showViewController:safariVC sender:nil];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma  UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor greenColor];
    cell.textLabel.font = [UIFont systemFontOfSize:24.0f];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewViewController * VC = [[NewViewController alloc] init];
    [self presentViewController:VC animated:YES completion:^{
        
    }];

}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {


    return 60;
}
@end
