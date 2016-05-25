//
//  TimeLineModel.h
//  Kline
//
//  Created by FundSmart IOS on 16/5/24.
//  Copyright © 2016年 黄海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeLineModel : NSObject

// 均线
@property(nonatomic,strong) NSArray *avg;

// 价格
@property(nonatomic,strong) NSArray *price;

// 涨跌幅
@property(nonatomic,strong) NSArray *change;

// 成交量
@property(nonatomic,strong) NSArray *vol;

// 当前价
@property(nonatomic,copy) NSString *curprice;

// 最高价
@property(nonatomic,copy) NSString *high;

// 昨收
@property(nonatomic,copy) NSString *preclose;

// 最低价
@property(nonatomic,copy) NSString *low;

// 时间
@property(nonatomic,strong) NSArray *date;



@end
