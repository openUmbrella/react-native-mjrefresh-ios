//
//  RCTWebViewManager+MJRefresh.h
//  ReactNativeMJRefresh
//
//  Created by jeff.Li on 2019/9/11.
//  Copyright © 2019 opu. All rights reserved.
//

#if __has_include(<RNCWebView/RNCWebViewManager.h>)
#import <RNCWebView/RNCWebViewManager.h>
#elif __has_include("RNCWebViewManager.h")
#import "RNCWebViewManager.h"
#else
#import "RNCWebView/RNCWebViewManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface RNCWebViewManager (MJRefresh)

@end

NS_ASSUME_NONNULL_END
