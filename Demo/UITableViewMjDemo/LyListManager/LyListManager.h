//
//  LyListManager.h
//
//
//  Created by LiuYu on 16/2/24.
//  Copyright © 2015年 LiuYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"

/// 分页显示列表数据处理器
@protocol LyListManagerDelegate;


@interface LyListManager : NSObject

- (instancetype)initWithDelegate:(id<LyListManagerDelegate>)delegate pageCount:(NSUInteger)pageCount inTableView:(UITableView *)tableView;

/// 绑定UITableView
@property (nonatomic, weak) UITableView *tableView;
/// 数据回掉
@property (nonatomic, weak) id<LyListManagerDelegate> delegate;

/// 数据中心
@property (nonatomic, readonly) NSMutableArray *datas;
/// 分页页数 【第一页是0】
@property (nonatomic, readonly) NSUInteger pageNo;
/// 分页每页显示多少条
@property (nonatomic, readonly) NSUInteger pageCount;
/// 是否还有更多数据
@property (nonatomic, readonly) BOOL haveMoreData;
/// 是否正在加载数据
@property (nonatomic, readonly) BOOL isLoading;

@property (nonatomic, assign) NSInteger tag;


@end


/**
 *  分页显示列表数据处理器
 */
@protocol LyListManagerDelegate <NSObject>

/// 加载数据
- (void)lyListManager:(LyListManager *)listManager loadDataWithPageNo:(NSUInteger)pageNo pageCount:(NSUInteger)pageCount completion:(void (^)(NSArray *datas, NSError *error))completion;


@optional

/// 加载数据开始
- (void)lyListManagerBeginLoading:(LyListManager *)listManager;
/// 加载数据完成
- (void)lyListManagerEndLoading:(LyListManager *)listManager;

/// 加载数据失败
- (void)lyListManagerFailure:(LyListManager *)listManager error:(NSError *)error;


@end

