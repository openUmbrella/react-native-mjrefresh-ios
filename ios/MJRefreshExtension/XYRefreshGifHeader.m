//
//  XYRefreshGifHeader.m
//  ReactNativeMJRefresh
//
//  Created by jeff.Li on 2019/9/11.
//  Copyright © 2019 opu. All rights reserved.
//

#import "XYRefreshGifHeader.h"

@interface XYRefreshGifHeader ()


@end

@implementation XYRefreshGifHeader

-(void)prepare{
  [super prepare];
  // 设置默认的图片与文字的间距为0
  self.labelLeftInset = 0;
}

-(void)placeSubviews{
  [super placeSubviews];
  // 以竖向排列控件
  if (self.gifView.constraints.count) return;
  // 如果没有指定图片,就使用父类的布局
  if (self.gifView.image == nil) return;

  self.gifView.frame = self.bounds;
  self.gifView.contentMode = UIViewContentModeCenter;
  // 定义高度余量
  NSInteger gapHeight = 6;
  // 图片的高度
  NSInteger imageH = self.gifView.image.size.height + gapHeight;

  // 0.状态标签和时间标签都没有
  if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
    // 如果图片的高度小于MJ的初始高度, 则使用MJ的高度
    if (imageH > MJRefreshHeaderHeight) {
      self.mj_h = imageH;
      self.gifView.mj_h = imageH;
    }
  }
  // 1. 状态标签和时间标签都有
  else if (!self.stateLabel.hidden && !self.lastUpdatedTimeLabel.hidden) {
    NSInteger stateH = self.stateLabel.xy_textHeight + gapHeight;
    NSInteger timeH = self.lastUpdatedTimeLabel.xy_textHeight + gapHeight;
    // 设置frame
    self.gifView.mj_h = imageH;
    self.mj_h = imageH + stateH + timeH + self.labelLeftInset;
    self.stateLabel.frame = CGRectMake(0, imageH + self.labelLeftInset, self.mj_w, stateH);
    self.lastUpdatedTimeLabel.frame = CGRectMake(0, imageH + self.labelLeftInset + stateH, self.mj_w, timeH);
  }
  // 2. 时间标签和状态标签有一个显示
  else  {
    UILabel *showLabel = nil;
    if (!self.stateLabel.hidden) {
      showLabel = self.stateLabel;
    }else{
      showLabel = self.lastUpdatedTimeLabel;
    }
    // 特别说明: 为什么不用 CGFloat ? 因为用了会崩! EXC_BAD_ACCESS 😂😂
    NSInteger showLabelH = showLabel.xy_textHeight + gapHeight;
    
    self.gifView.mj_h = imageH;
    showLabel.frame = CGRectMake(0, imageH + self.labelLeftInset, self.mj_w, showLabelH);
    self.mj_h = imageH + showLabelH  + self.labelLeftInset;
    
  }
  
}

@end

@implementation UILabel(XYRefresh)

- (CGFloat)xy_textHeight {
  CGFloat stringHeight = 0;
  CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
  if (self.text.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    stringHeight =[self.text
                  boundingRectWithSize:size
                  options:NSStringDrawingUsesLineFragmentOrigin
                  attributes:@{NSFontAttributeName:self.font}
                  context:nil].size.height;
#else
    
    stringHeight = [self.text sizeWithFont:self.font
                        constrainedToSize:size
                            lineBreakMode:NSLineBreakByCharWrapping].height;
#endif
  }
  return stringHeight;
}
@end

@implementation UIColor (XYColor)

+(UIColor *)xy_colorWithColorString: (NSString *)color {
  if ([color hasPrefix:@"rgb"]) {
    return [self xy_colorWithRGBString:color];
  }else{
    return [self xy_colorWithHexString:color];
  }
}

// rgb(12,34,23) rgba(12,34,43,1)
+ (UIColor *)xy_colorWithRGBString:(NSString *)color{
  //删除字符串中的空格
  NSString *rgbString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
  if ([rgbString hasPrefix:@"RGB("] && [rgbString hasSuffix:@")"]) {
    NSRange range;
    range.location = 4;
    range.length = color.length - 5;
    rgbString = [rgbString substringWithRange: range];
  }
  else if ([rgbString hasPrefix:@"RGBA("] && [rgbString hasSuffix:@")"]) {
    NSRange range;
    range.location = 5;
    range.length = color.length - 6;
    rgbString = [rgbString substringWithRange: range];
  }else{
    return [UIColor blackColor];
  }
  NSArray *rgbArr = [rgbString componentsSeparatedByString:@","];
  if (!(rgbArr.count == 3 || rgbArr.count == 4)) {
    return [UIColor blackColor];
  }
  NSString *rString = rgbArr[0];
  NSString *gString = rgbArr[1];
  NSString *bString = rgbArr[2];
  float r = 0.0, g = 0.0, b = 0.0;
  if (!(
        [[NSScanner scannerWithString:rString] scanFloat:&r] &&
        [[NSScanner scannerWithString:gString] scanFloat:&g] &&
        [[NSScanner scannerWithString:bString] scanFloat:&b]
        
        )) {
    return [UIColor blackColor];
  }
  if (rgbArr.count == 4) {
    float a;
    NSString *aString = rgbArr[3];
    if ([[NSScanner scannerWithString:aString] scanFloat:&a]) {
      return [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha: a];
    }else{
      return [UIColor blackColor];
    }
  }else{
    return [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha: 1.0f];
  }
  
}
// 从十六进制字符串获取颜色，
// color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
// 默认alpha值为1
+ (UIColor *)xy_colorWithHexString:(NSString *)color
{
  //删除字符串中的空格
  NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
  // String should be 6 or 8 characters
  if ([cString length] < 6)
  {
    return [UIColor blackColor];
  }
  //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
  if ([cString hasPrefix:@"0X"])
  {
    cString = [cString substringFromIndex:2];
  }
  //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
  if ([cString hasPrefix:@"#"])
  {
    cString = [cString substringFromIndex:1];
  }
  if ([cString length] != 6)
  {
    return [UIColor blackColor];
  }
  
  NSRange range;
  range.location = 0;
  range.length = 2;
  //r
  NSString *rString = [cString substringWithRange:range];
  //g
  range.location = 2;
  NSString *gString = [cString substringWithRange:range];
  //b
  range.location = 4;
  NSString *bString = [cString substringWithRange:range];
  
  unsigned int r, g, b;
  [[NSScanner scannerWithString:rString] scanHexInt:&r];
  [[NSScanner scannerWithString:gString] scanHexInt:&g];
  [[NSScanner scannerWithString:bString] scanHexInt:&b];
  return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1.0f];
}


@end
