//
//  XYRefreshGifHeader.h
//  ReactNativeMJRefresh
//
//  Created by jeff.Li on 2019/9/11.
//  Copyright © 2019 opu. All rights reserved.
//

#import "MJRefreshGifHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYRefreshGifHeader : MJRefreshGifHeader

@end

NS_ASSUME_NONNULL_END

@interface UILabel(XYRefresh)

/**
 获取label中文本的高度

 @return 高度
 */
- (CGFloat)xy_textHeight;

@end

@interface UIColor (XYColor)

/**
 通过色号返回颜色, 如果格式错误,默认返回黑色
 
 @param color 色号, 格式可以是 @"rgb(12,34,23)"、 @"rgba(12,34,43,0.5)" 也可以是 @“#123456”、 @“0X123456”、 @“123456”
 @return 颜色
 */
+(UIColor *_Nonnull)xy_colorWithColorString: (NSString *_Nonnull)color;

@end
