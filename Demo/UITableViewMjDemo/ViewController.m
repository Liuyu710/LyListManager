//
//  ViewController.m
//  UITableViewMjDemo
//
//  Created by CanLeHui on 16/2/24.
//  Copyright © 2016年 LiuYu. All rights reserved.
//

#import "ViewController.h"
#import "LyListManager.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, LyListManagerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LyListManager *listManager;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.listManager = [[LyListManager alloc] initWithDelegate:self pageCount:10 inTableView:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listManager.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"Ly";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = self.listManager.datas[indexPath.row];
    
    return cell;
}

#pragma mark - LyListManagerDelegate

- (void)lyListManager:(LyListManager *)listManager loadDataWithPageNo:(NSUInteger)pageNo pageCount:(NSUInteger)pageCount completion:(void (^)(NSArray *, NSError *))completion {
    
    // 测试数据
    
    // 第5页是最后一页
    if (pageNo == 5) {
        NSUInteger pageCount2 = arc4random()%pageCount;
        NSMutableArray *array = [NSMutableArray array];
        for (NSUInteger i = 0; i < pageCount2; i++) {
            [array addObject:[@(pageNo*pageCount + i + 1) description]];
        }
        
        completion(array, nil);
    }
    else {
        NSMutableArray *array = [NSMutableArray array];
        for (NSUInteger i = 0; i < pageCount; i++) {
            [array addObject:[@(pageNo*pageCount + i + 1) description]];
        }
        
        completion(array, nil);
    }
}

- (void)lyListManagerBeginLoading:(LyListManager *)listManager {
    NSLog(@"加载数据开始");
}

- (void)lyListManagerEndLoading:(LyListManager *)listManager {
    NSLog(@"加载数据完成");
}

- (void)lyListManagerFailure:(LyListManager *)listManager error:(NSError *)error {
    NSLog(@"加载数据失败：%@", error);
}

@end
