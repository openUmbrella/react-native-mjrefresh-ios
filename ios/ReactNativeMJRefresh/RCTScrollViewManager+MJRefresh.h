//
//  RCTScrollViewManager+MJRefresh.h
//  ReactNativeMJRefresh
//
//  Created by jeff.Li on 2019/9/11.
//  Copyright © 2019 opu. All rights reserved.
//

#if __has_include(<React/RCTScrollViewManager.h>)
#import <React/RCTScrollViewManager.h>
#elif __has_include("RCTScrollViewManager.h")
#import "RCTScrollViewManager.h"
#else
#import "React/RCTScrollViewManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface RCTScrollViewManager (MJRefresh)

@end

NS_ASSUME_NONNULL_END
