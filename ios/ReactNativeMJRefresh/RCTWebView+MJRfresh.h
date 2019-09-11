//
//  RCTWebView+MJRfresh.h
//  ReactNativeMJRefresh
//
//  Created by jeff.Li on 2019/9/11.
//  Copyright © 2019 opu. All rights reserved.
//

#import "RCTWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCTWebView (MJRfresh)

// 下拉刷新
@property (nonatomic, assign) BOOL enableMJRefresh;

@property (nonatomic, assign) BOOL mjRefreshing;

@property (nonatomic, strong) NSDictionary *mjHeaderStyle;

@property (nonatomic, copy) RCTBubblingEventBlock onMJRefresh;


@end

NS_ASSUME_NONNULL_END
