//
//  ViewController.m
//  Kline
//
//  Created by FundSmart IOS on 16/5/24.
//  Copyright © 2016年 黄海龙. All rights reserved.
//

#import "ViewController.h"
#import "TimeLineView.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "TimeLineModel.h"

@interface ViewController ()

@property (strong,nonatomic) TimeLineView *line_View;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    TimeLineView *lineView = [[TimeLineView alloc] initWithFrame:CGRectMake(5, 100, UIScreen.mainScreen.bounds.size.width - 10, 200)];
    self.line_View = lineView;
    
    lineView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lineView.layer.borderWidth = 1;
    [self.view addSubview:lineView];

    [self requestData];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(requestData) userInfo:nil repeats:YES];
}


-(void)requestData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://www.fundsmart.com.cn/api/chart_data_json.php?type=stock&chart_type=l&ticker=300478&_=1464101404045" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        TimeLineModel *timelineModel = [TimeLineModel mj_objectWithKeyValues:dic];
        self.line_View.timelines = timelineModel;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        
        
    }];
    
}



@end
