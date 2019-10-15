//
//  RCTWebViewManager+MJRefresh.h
//  ReactNativeMJRefresh
//
//  Created by jeff.Li on 2019/9/11.
//  Copyright © 2019 opu. All rights reserved.
//

#if __has_include(<React/RCTWebViewManager.h>)
#import <React/RCTWebViewManager.h>
#elif __has_include("RCTWebViewManager.h")
#import "RCTWebViewManager.h"
#else
#import "React/RCTWebViewManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface RCTWebViewManager (MJRefresh)

@end

NS_ASSUME_NONNULL_END
