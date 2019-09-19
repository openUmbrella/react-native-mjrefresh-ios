//
//  RCTWebViewManager+MJRefresh.h
//  ReactNativeMJRefresh
//
//  Created by jeff.Li on 2019/9/11.
//  Copyright © 2019 opu. All rights reserved.
//

#if __has_include(<react-native-webview/RNCWebViewManager.h>)
#import <react-native-webview/RNCWebViewManager.h>
#elif __has_include("react-native-webview/RNCWebViewManager.h")
#import "react-native-webview/RNCWebViewManager.h"
#else __has_include("RNCWebViewManager.h")
#import "RNCWebViewManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface RNCWebViewManager (MJRefresh)

@end

NS_ASSUME_NONNULL_END
