//
//  LyListManager.m
//  
//
//  Created by LiuYu on 16/2/24.
//  Copyright © 2015年 LiuYu. All rights reserved.
//

#import "LyListManager.h"

@interface LyListManager ()

/// 数据中心
@property (nonatomic, readwrite) NSMutableArray *datas;
/// 分页页数 【第一页是0】
@property (nonatomic, readwrite) NSUInteger pageNo;
/// 分页每页显示多少条
@property (nonatomic, readwrite) NSUInteger pageCount;
/// 是否还有更多数据
@property (nonatomic, readwrite) BOOL haveMoreData;
/// 是否正在加载数据
@property (nonatomic, readwrite) BOOL isLoading;

@end

@implementation LyListManager

- (instancetype)initWithDelegate:(id<LyListManagerDelegate>)delegate pageCount:(NSUInteger)pageCount inTableView:(UITableView *)tableView; {
    self = [self init];
    if (self) {
        self.delegate = delegate;
        self.pageCount = pageCount;
        self.tableView = tableView;
        self.haveMoreData = YES;
    }
    return self;
}

#pragma mark - Getter & Setter

- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadDatas)];
    [header setTitle:@"LiuYu正在帮你加载数据 ..." forState:MJRefreshStateRefreshing];
    _tableView.header = header;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];
    [footer setTitle:@"LiuYu正在帮你加载数据 ..." forState:MJRefreshStateRefreshing];
    _tableView.footer = footer;
}

#pragma mark - 数据加载

- (void)reloadDatas {
    if (self.isLoading) { return ; }
    
    [self reloadDataWithCompletion:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        if (error == nil) {
            if (self.haveMoreData) {
                [self.tableView.footer resetNoMoreData];
            }
            else {
                [self.tableView.footer noticeNoMoreData];
            }
            [self.tableView reloadData];
        }
        else {
            [self loadFailure:error];
        }
    }];
}

- (void)loadMoreDatas {
    if (self.isLoading) { return ; }
    
    [self loadMoreDataWithCompletion:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        if (error == nil) {
            if (!self.haveMoreData) {
                [self.tableView.footer noticeNoMoreData];
            }
            
            [self.tableView reloadData];
        }
        else {
            [self loadFailure:error];
        }
    }];
}

/// 重新加载数据
- (void)reloadDataWithCompletion:(void (^)(NSError *error)) completion; {
    [self loadDataWithCompletion:completion isReload:YES];
}

/// 加载更多数据
- (void)loadMoreDataWithCompletion:(void (^)(NSError *error))completion; {
    [self loadDataWithCompletion:completion isReload:NO];
}

- (void)loadDataWithCompletion:(void (^)(NSError *error))completion isReload:(BOOL)isReload {
    if (self.isLoading) {
        completion(nil);
        return ;
    }
    
    if (isReload) {
        self.haveMoreData = YES;
    }
        
    if (!self.haveMoreData) {
        completion(nil);
        return ;
    }
    
    if ([self.delegate respondsToSelector:@selector(lyListManager:loadDataWithPageNo:pageCount:completion:)]) {
        [self beginLoading];
        [self.delegate lyListManager:self loadDataWithPageNo:isReload ? 0 : self.pageNo pageCount:self.pageCount completion:^(NSArray *datas, NSError *error) {
            if (datas != nil) {
                if (isReload) {
                    self.pageNo = 1;
                    [self.datas removeAllObjects];
                }
                else {
                    self.pageNo++;
                }
                [self.datas addObjectsFromArray:datas];
                if (datas.count < self.pageCount) {
                    self.haveMoreData = NO;
                }
            }
            
            completion(error);
            [self endLoading];
        }];
    }
}

- (void)beginLoading {
    self.isLoading = YES;
    if ([self.delegate respondsToSelector:@selector(lyListManagerBeginLoading:)]) {
        [self.delegate lyListManagerBeginLoading:self];
    }
}

- (void)endLoading {
    self.isLoading = NO;
    if ([self.delegate respondsToSelector:@selector(lyListManagerEndLoading:)]) {
        [self.delegate lyListManagerEndLoading:self];
    }
}

- (void)loadFailure:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(lyListManagerFailure:error:)]) {
        [self.delegate lyListManagerFailure:self error:error];
    }
}


@end