//
//  RCTWebView+MJRfresh.m
//  ReactNativeMJRefresh
//
//  Created by jeff.Li on 2019/9/11.
//  Copyright © 2019 opu. All rights reserved.
//

#import "RCTWebView+MJRfresh.h"
#import "XYRefreshGifHeader.h"

#if __has_include(<React/RCTLog.h>)
#import <React/RCTLog.h>
#elif __has_include("RCTLog.h")
#import "RCTLog.h"
#else
#import "React/RCTLog.h"
#endif

#if __has_include(<MJRefresh/MJRefresh.h>)
#import <MJRefresh/MJRefresh.h>
#elif __has_include("MJRefresh.h")
#import "MJRefresh.h"
#else
#import "MJRefresh/MJRefresh.h"
#endif

@interface RCTWebView ()

@property (nonatomic, strong) NSDictionary *headerJSKey2OCMethod;

@property (nonatomic, copy) RCTDirectEventBlock onLoadingFinishOrigin;

@end

@implementation RCTWebView (MJRfresh)
#pragma mark - 样式名-方法映射表

/**
 新增属性的步骤：
 
 1. 为下面的字典添加key/value，key为在RN中的属性， value为OC方法名
 2. 实现value方法
 
 */

-(NSDictionary *)headerJSKey2OCMethod{
  return @{
           // normalHeader的专有属性
           @"indicatorType": @"settingMJHeaderIndicatorType:",
           @"arrowImage": @"settingMJHeaderArrowImage:",
           // gifHeader的专有属性
           @"gifImages": @"settingMJHeaderGifImages:",
           // 共有属性
           @"hideTimeLabel" : @"settingMJHeaderLastUpdatedTimeLabelVisible:",
           @"labelImageGap": @"settingMJHeaderLabelLeftInset:",
           @"hideStateLabel" : @"settingMJHeaderStateLabelVisible:",
           @"stateLabelStyle" : @"settingMJHeaderStateLabelStyle:",
           @"timeLabelStyle" : @"settingMJHeaderTimeLabelStyle:",
           @"stateTitle" : @"settingMJHeaderStateLabelTitle:",
           @"ignoredInsetTop" : @"settingMJHeaderIgnoredScrollViewContentInsetTop:",
           @"autoChangeAlpha" : @"settingMJHeaderAutomaticallyChangeAlpha:",
           };
  
}
#pragma mark - 自定义header样式方法

-(void)settingMJHeaderIndicatorType:(NSString *)type{
  // 只有normal类型才可以设置 菊花样式
  if([[self getMJHeader] isKindOfClass:[MJRefreshNormalHeader class]]){
    MJRefreshNormalHeader *mjheader = (MJRefreshNormalHeader *)[self getMJHeader];
    if (mjheader) {
      if ([type isEqualToString:@"whiteLarge"]){
        mjheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
      }
      else if ([type isEqualToString:@"white"]){
        mjheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
      } else{
        // 默认是 灰色
        mjheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
      }
    }
  }
}
-(void)settingMJHeaderArrowImage:(NSString *)imageName{
  // 只有normal类型才可以设置 箭头图片
  if([[self getMJHeader] isKindOfClass:[MJRefreshNormalHeader class]]){
    MJRefreshNormalHeader *mjheader = (MJRefreshNormalHeader *)[self getMJHeader];
    if (mjheader) {
      if (imageName.length == 0) {
        RCTLogWarn(@"%@", [NSString stringWithFormat:@"arrowImage can't be empty string"]);
        return;
      }
      UIImage *image = [UIImage imageNamed:imageName];
      if (image) {
        [mjheader setValue:image forKeyPath:@"arrowView.image"];
      }else {
        RCTLogWarn(@"%@", [NSString stringWithFormat:@"%@ does not exist in Images.xcassets folder of iOS Project", imageName]);
      }
    }
  }
}
-(void)settingMJHeaderGifImages: (NSDictionary *)imageState{
  //  设置gifHeader头部动画样式
  
  //  imageState数据格式
  //  @{
  //    @"idle": @[@"idle_001", @"idle_002", @"idle_003"],
  //    @"pulling" : @[@"pulling_001",@"pulling_002",@"pulling_003"],
  //    @"refreshing": @[@"refreshing_001", @"refreshing_oo2"],
  //    @"willRefresh": @[],
  //    @"noMoreData": @[]
  //    };
  if ([[self getMJHeader] isKindOfClass:[MJRefreshGifHeader class]]) {
    MJRefreshGifHeader *mjHeader = (MJRefreshGifHeader *)[self getMJHeader];
        NSArray *keys = imageState.allKeys;
        for (NSString *key in keys) {
          if ([imageState[key] isKindOfClass:[NSArray class]]) {
            NSArray *images = imageState[key];
            NSMutableArray *imagesArr = [NSMutableArray arrayWithCapacity:images.count];
            for (NSString *imageName in images) {
              UIImage *image = [UIImage imageNamed:imageName];
              if (image) {
                [imagesArr addObject: image];
              }else{
                // 没有在 Images.xcassets 中找到
                RCTLogWarn(@"%@", [NSString stringWithFormat:@"%@ does not exist in Images.xcassets folder of iOS Project", imageName]);
              }
    
            }
            if ([key isEqualToString:@"idle"]) {
              [mjHeader setImages:imagesArr forState:MJRefreshStateIdle];
            }
            else if ([key isEqualToString:@"pulling"]){
              [mjHeader setImages:imagesArr forState:MJRefreshStatePulling];
            }
            else if ([key isEqualToString:@"refreshing"]){
              [mjHeader setImages:imagesArr forState:MJRefreshStateRefreshing];
            }
            else if ([key isEqualToString:@"willRefresh"]){
              [mjHeader setImages:imagesArr forState:MJRefreshStateWillRefresh];
            }
            else if ([key isEqualToString:@"noMoreData"]){
              [mjHeader setImages:imagesArr forState:MJRefreshStateNoMoreData];
            }
          } else {
            // 值类型不是数组
            RCTLogWarn(@"%@", [NSString stringWithFormat:@"the value of %@ is not array", key]);
          }
        }
  }
}
-(void)settingMJHeaderLastUpdatedTimeLabelVisible: (NSNumber *) hide {
  MJRefreshStateHeader *mjHeader = (MJRefreshStateHeader *)[self getMJHeader];
  if (mjHeader) {
    mjHeader.lastUpdatedTimeLabel.hidden = hide.boolValue;
  }
  
}
-(void)settingMJHeaderLabelLeftInset: (NSNumber *)value{
  MJRefreshStateHeader *mjHeader = (MJRefreshStateHeader *)[self getMJHeader];
  if (mjHeader) {
    mjHeader.labelLeftInset = value.floatValue;
  }
  
}
-(void)settingMJHeaderStateLabelVisible: (NSNumber *)isHide{
  MJRefreshStateHeader *mjHeader = (MJRefreshStateHeader *)[self getMJHeader];
  if (mjHeader) {
    mjHeader.stateLabel.hidden = isHide.boolValue;
  }
  
}
-(void)settingMJHeaderStateLabelStyle: (NSDictionary *)styles{
  MJRefreshStateHeader *mjHeader = (MJRefreshStateHeader *)[self getMJHeader];
  if (mjHeader) {
    [self setLabelStyleWithLable:mjHeader.stateLabel styles:styles];
  }
}
-(void)settingMJHeaderTimeLabelStyle: (NSDictionary *)styles{
  MJRefreshStateHeader *mjHeader = (MJRefreshStateHeader *)[self getMJHeader];
  if (mjHeader) {
    [self setLabelStyleWithLable:mjHeader.lastUpdatedTimeLabel styles:styles];
  }
  
}
-(void)settingMJHeaderStateLabelTitle: (NSDictionary *)stateTitle{
  MJRefreshStateHeader *mjHeader = (MJRefreshStateHeader *)[self getMJHeader];
  NSArray *states = stateTitle.allKeys;
  if (mjHeader) {
    for (NSString *state in states) {
      if (![stateTitle[state] isKindOfClass:[NSString class]]) {
        continue;
      }
      if ([state isEqualToString:@"idle"]) {
        [mjHeader setTitle:stateTitle[state] forState:MJRefreshStateIdle];
      }
      else if ([state isEqualToString:@"pulling"]) {
        [mjHeader setTitle:stateTitle[state] forState:MJRefreshStatePulling];
      }
      else if ([state isEqualToString:@"refreshing"]) {
        [mjHeader setTitle:stateTitle[state] forState:MJRefreshStateRefreshing];
      }
      else if ([state isEqualToString:@"willRefresh"]) {
        [mjHeader setTitle:stateTitle[state] forState:MJRefreshStateWillRefresh];
      }
      else if ([state isEqualToString:@"noMoreData"]) {
        [mjHeader setTitle:stateTitle[state] forState:MJRefreshStateNoMoreData];
      }
    }
  }
}
-(void)settingMJHeaderIgnoredScrollViewContentInsetTop:(NSNumber *)number{
  MJRefreshStateHeader *mjHeader = (MJRefreshStateHeader *)[self getMJHeader];
  if (mjHeader) {
    mjHeader.ignoredScrollViewContentInsetTop = number.floatValue;
  }
}
-(void)settingMJHeaderAutomaticallyChangeAlpha:(NSNumber *)isAuto{
  MJRefreshStateHeader *mjHeader = (MJRefreshStateHeader *)[self getMJHeader];
  if (mjHeader) {
    mjHeader.automaticallyChangeAlpha = isAuto.boolValue;
  }
}
-(void)setLabelStyleWithLable: (UILabel *)label styles: (NSDictionary *)styles{
  // styles里面可用的值只有(暂且) fontSize color
  NSNumber *fontSize = styles[@"fontSize"];
  NSString *color = styles[@"color"];
  if (fontSize) {
    label.font = [UIFont boldSystemFontOfSize:fontSize.floatValue];
  }
  if (color) {
    UIColor *textcolor = [UIColor xy_colorWithColorString: color];
    label.textColor = textcolor;
  }
}
#pragma mark - 设置自定义样式方法

-(void)settingMJHeaderStyle{
  UIScrollView *scrollView = [self getScrollView];
  if (scrollView.mj_header == nil || self.mjHeaderStyle == nil) {
    return;
  }
   // NSLog(@"header的样式:%@",self.mjHeaderStyle);
  [self executeMethodWithDictionary:self.mjHeaderStyle map:self.headerJSKey2OCMethod];
}
-(void)executeMethodWithDictionary: (NSDictionary *)stylesDict map: (NSDictionary *)mapDict{
  
  NSArray *jsKeys = mapDict.allKeys;
  NSArray *styleNameArr = stylesDict.allKeys;
  for (NSString *jskey in styleNameArr) {
    for (NSString *key in jsKeys) {
      if ([jskey isEqualToString: key]) {
        // 执行方法
        NSString *ocMethodName = mapDict[key];
        SEL MethodSEL = NSSelectorFromString(ocMethodName);
        if ([self respondsToSelector:MethodSEL]) {
          // 为什么不直接使用 [self performSelector:MethodSEL withObject:self.mjHeaderStyle[jskey]];
          // 请看: https://www.jianshu.com/p/6517ab655be7
          IMP imp = [self methodForSelector:MethodSEL];
          void (*func)(id, SEL, id) = (void *)imp;
          func(self, MethodSEL, stylesDict[jskey]);
        }else{
          RCTLogError(@"%@", [NSString stringWithFormat:@"you didn't implement method %@ in RCTScrollView+MJRefresh.m file", ocMethodName]);
        }
      }
    }
  }
}


-(UIScrollView *)getScrollView{
  UIWebView * webview = [self valueForKeyPath:@"_webView"];
  if (webview) {
    return webview.scrollView;
  } else {
    RCTLogError(@"%@", [NSString stringWithFormat:@"ohh, shit! can't get WebView"]);
    return nil;
  }
}
-(MJRefreshHeader *)getMJHeader{
  UIScrollView *scrollView = [self getScrollView];
  return scrollView.mj_header;
}



#pragma mark - 刷新方法

-(void)refreshAction{
  // 执行刷新方法
  if (self.onMJRefresh) {
    self.onMJRefresh(@{});
  }
  // 重新刷新
  UIWebView * webview = [self valueForKeyPath:@"_webView"];
  [webview reload];
  
}

#pragma mark - 下拉刷新属性

static const char XYMJEnableRefreshKey = '\0';
-(void)setEnableMJRefresh:(BOOL)enableMJRefresh{
  objc_setAssociatedObject(self, &XYMJEnableRefreshKey,
                           @(enableMJRefresh), OBJC_ASSOCIATION_RETAIN);
  UIScrollView *scrollView = [self getScrollView];

  if (enableMJRefresh == YES) {
    // 如果js端监听了 onMJRefresh 方法, 那么自动停止刷新的操作就由js端来处理
    if (self.onMJRefresh == nil) {
      RCTDirectEventBlock onLoadingFinish = nil;
      if (self.onLoadingFinishOrigin == nil) {
        onLoadingFinish = [self valueForKeyPath:@"_onLoadingFinish"];
        self.onLoadingFinishOrigin = onLoadingFinish;
        
      }else{
        onLoadingFinish = self.onLoadingFinishOrigin;
      }
      RCTDirectEventBlock MiddleBlock = ^(NSDictionary *body){
        // 执行额外的操作: 停止下拉刷新
        [scrollView.mj_header endRefreshing];
        // 执行原来的Block
        onLoadingFinish(body);
      };
      [self setValue:MiddleBlock forKeyPath:@"_onLoadingFinish"];
    }
    // 添加下拉刷新
    NSString *headerType = self.mjHeaderStyle[@"headerType"];
    if ([headerType isEqualToString:@"gif"]) {
      // gif类型
      scrollView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    }
    
    else if ([headerType isEqualToString:@"gifTop"]) {
      // gifTop类型
      scrollView.mj_header = [XYRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    }
    else{
      // 默认类型 normal
      scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    }
    [self settingMJHeaderStyle];
  }else {
    // 移除下拉刷新
   scrollView.mj_header = nil;
    if (self.onLoadingFinishOrigin) {
      // 加载完成的Block 还原回来
      [self setValue:self.onLoadingFinishOrigin forKeyPath:@"_onLoadingFinish"];
    }
  }
  
}

-(BOOL)enableMJRefresh{
  return [(NSNumber *)objc_getAssociatedObject(self, &XYMJEnableRefreshKey) boolValue];
}

static const char XYMJRefreshingKey = '\0';
-(void)setMjRefreshing:(BOOL)mjRefreshing{
  objc_setAssociatedObject(self, &XYMJRefreshingKey, @(mjRefreshing), OBJC_ASSOCIATION_RETAIN);
  UIScrollView *scrollView = [self getScrollView];
  if (scrollView.mj_header) {
    if (mjRefreshing == NO) {
      [scrollView.mj_header endRefreshing];
    }else{
      [scrollView.mj_header beginRefreshing];
    }
  }
}

-(BOOL)mjRefreshing{
   return [(NSNumber *)objc_getAssociatedObject(self, &XYMJRefreshingKey) boolValue];
}


static const char XYMJonRefreshKey = '\0';
-(void)setOnMJRefresh:(RCTBubblingEventBlock)onMJRefresh{
  objc_setAssociatedObject(self, &XYMJonRefreshKey, onMJRefresh, OBJC_ASSOCIATION_RETAIN);
}
-(RCTBubblingEventBlock)onMJRefresh{
  
  return objc_getAssociatedObject(self, &XYMJonRefreshKey);
}

static const char XYMJScrollViewHeaderStyleKey = '\0';
-(void)setMjHeaderStyle:(NSDictionary *)mjHeaderStyle{
  objc_setAssociatedObject(self, &XYMJScrollViewHeaderStyleKey, mjHeaderStyle, OBJC_ASSOCIATION_RETAIN);
  // 设置mj_header样式
  [self settingMJHeaderStyle];
}
-(NSDictionary *)mjHeaderStyle{
  NSDictionary * headerStyle = objc_getAssociatedObject(self, &XYMJScrollViewHeaderStyleKey);
  if (headerStyle == nil) {
    return @{
             @"headerType": @"normal"
             };
  }
  return headerStyle;
}

static const char XYMJOnLoadingFinishOriginKey = '\0';
-(void)setOnLoadingFinishOrigin:(RCTDirectEventBlock)onLoadingFinishOrigin{
  objc_setAssociatedObject(self, &XYMJOnLoadingFinishOriginKey, onLoadingFinishOrigin, OBJC_ASSOCIATION_RETAIN);
}
-(RCTDirectEventBlock)onLoadingFinishOrigin{
  return objc_getAssociatedObject(self, &XYMJOnLoadingFinishOriginKey);
}

@end

