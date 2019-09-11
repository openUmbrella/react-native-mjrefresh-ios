//
//  RCTScrollView+MJRefresh.h
//  ReactNativeMJRefresh
//
//  Created by jeff.Li on 2019/9/11.
//  Copyright © 2019 opu. All rights reserved.
//

#import "RCTScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCTScrollView (MJRefresh)

// 下拉刷新
@property (nonatomic, assign) BOOL enableMJRefresh;

@property (nonatomic, assign) BOOL mjRefreshing;

@property (nonatomic, strong) NSDictionary *mjHeaderStyle;

@property (nonatomic, copy) RCTBubblingEventBlock onMJRefresh;

//上拉加载更多
@property (nonatomic, assign) BOOL enableMJLoadMore;

@property (nonatomic, assign) BOOL mjLoadingMore;

@property (nonatomic, assign) BOOL mjLoadAll;

@property (nonatomic, strong) NSDictionary *mjFooterStyle;

@property (nonatomic, copy) RCTBubblingEventBlock onMJLoadMore;

@end

NS_ASSUME_NONNULL_END

