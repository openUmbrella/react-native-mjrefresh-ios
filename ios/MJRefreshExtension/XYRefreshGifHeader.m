//
//  XYRefreshGifHeader.m
//  ReactNativeMJRefresh
//
//  Created by jeff.Li on  2019/9/11.
//  Copyright © 2019 opu. All rights reserved.
//

#import "XYRefreshGifHeader.h"

@interface XYRefreshGifHeader ()

@property (nonatomic, assign) CGFloat imageH;

@property (nonatomic, assign) CGFloat stateH;

@property (nonatomic, assign) CGFloat timeH;


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

  self.gifView.frame = self.bounds;
  self.gifView.contentMode = UIViewContentModeCenter;
  [self relayouView];
  
}

- (void)relayouView{
  
  if (![_style[@"headerType"] isEqualToString:@"gifTop"]) {
      return;
  }
  // 定义高度余量
  NSInteger gapHeight = 6;
  if (!self.imageH) {
    NSArray *idleimageArr = _style[@"gifImages"][@"idle"];
    if (!idleimageArr || idleimageArr.count == 0) {
      return;
    }
    // 获取图片高度
    NSString *idle0 = idleimageArr.firstObject;
    UIImage *idleImage = [UIImage imageNamed:idle0];
    if (!idleImage) {
      return;
    }
    
    // 图片的高度
    NSInteger imageH = idleImage.size.height + gapHeight;
    self.imageH = imageH;
  }
  if (!self.stateH) {
    NSInteger stateFontSize = [(NSNumber *)_style[@"stateLabelStyle"][@"fontSize"] integerValue] ?: 14; // 默认是14
    NSString *stateText = _style[@"stateTitle"][@"idle"] ?: @"下拉可以刷新";
    CGFloat stateH = [stateText boundingRectWithSize: CGSizeMake(MAXFLOAT, MAXFLOAT)
       options:NSStringDrawingUsesLineFragmentOrigin
    attributes:@{
      NSFontAttributeName: [UIFont systemFontOfSize: stateFontSize]
    }
      context:nil].size.height;
    self.stateH = stateH + gapHeight;
  }
  if (!self.timeH) {
    NSInteger fontSize = [(NSNumber *)_style[@"timeLabelStyle"][@"fontSize"] integerValue] ?: 14;
    NSString *text = @"时间";
    CGFloat height = [text boundingRectWithSize: CGSizeMake(MAXFLOAT, MAXFLOAT)
       options:NSStringDrawingUsesLineFragmentOrigin
    attributes:@{
      NSFontAttributeName: [UIFont systemFontOfSize: fontSize]
    }
      context:nil].size.height;
    self.timeH = height + gapHeight;
  }
    
    // 判断状态
    BOOL hideStateLabel = [(NSNumber *)_style[@"hideStateLabel"] boolValue];
    BOOL hideTimeLabel = [(NSNumber *)_style[@"hideTimeLabel"] boolValue];
    
    // 0.状态标签和时间标签都没有
    if (hideStateLabel && hideTimeLabel) {
      // 如果图片的高度小于MJ的初始高度, 则使用MJ的高度
      if (self.imageH > MJRefreshHeaderHeight) {
        self.mj_h = self.imageH;
        self.gifView.mj_h = self.imageH;
      }
    }
    // 1. 状态标签和时间标签都有
    else if (!hideStateLabel && !hideTimeLabel) {
      // 设置frame
      self.gifView.mj_h = self.imageH;
      self.stateLabel.frame = CGRectMake(0, self.imageH + self.labelLeftInset, self.mj_w, self.stateH);
      self.lastUpdatedTimeLabel.frame = CGRectMake(0, self.imageH + self.labelLeftInset + self.stateH, self.mj_w, self.timeH);
      self.mj_h = self.imageH + self.stateH + self.timeH + self.labelLeftInset;
       // 要设置y值, 否着首次拖拽时布局会出问题
      self.mj_y = - self.mj_h - self.ignoredScrollViewContentInsetTop;
    }
    // 2. 时间标签和状态标签有一个显示
    else  {
      CGFloat height = 0;
      UILabel *showLabel = nil;
      if (!hideStateLabel) {
        height = self.stateH;
        showLabel = self.stateLabel;
      } else {
        height = self.timeH;
        showLabel = self.lastUpdatedTimeLabel;
      }
      
      self.gifView.mj_h = self.imageH;
      showLabel.frame = CGRectMake(0, self.imageH + self.labelLeftInset, self.mj_w, height);
      self.mj_h = self.imageH + height  + self.labelLeftInset;
      // 要设置y值, 否着首次拖拽时布局会出问题
      self.mj_y = - self.mj_h - self.ignoredScrollViewContentInsetTop;
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
