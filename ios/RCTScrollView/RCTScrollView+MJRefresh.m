//
//  RCTScrollView+MJRefresh.m
//  ReactNativeMJRefresh
//
//  Created by jeff.Li on 2019/9/11.
//  Copyright © 2019 opu. All rights reserved.
//

#import "RCTScrollView+MJRefresh.h"
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




@interface RCTScrollView ()

@property (nonatomic, strong) NSDictionary *headerJSKey2OCMethod;

@property (nonatomic, strong) NSDictionary *footerJSKey2OCMethod;

@end



@implementation RCTScrollView (MJRefresh)

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

-(NSDictionary *)footerJSKey2OCMethod{
  return @{
           // 只有backNormal autoNormal类型才有
           @"indicatorType": @"settingMJFooterIndicatorType:",
           // 只有 backNormal类型才有
           @"arrowImage": @"settingMJFooterArrowImage:",
           // 只有 backGif autoGif 类型才有
           @"gifImages": @"settingMJFooterGifImages:",
           
           @"labelImageGap": @"settingMJFooterLabelLeftInset:",
           @"hideStateLabel" : @"settingMJFooterStateLabelVisible:",
           @"stateLabelStyle" : @"settingMJFooterStateLabelStyle:",
           @"stateTitle" : @"settingMJFooterStateLabelTitle:",
           @"ignoredInsetBottom" : @"settingMJFooterIgnoredScrollViewContentInsetBottom:",
           @"autoChangeAlpha" : @"settingMJFooterAutomaticallyChangeAlpha:",
           };
}


#pragma mark - 自定义header样式方法

-(void)settingMJHeaderIndicatorType:(NSString *)type{
  // 只有normal类型才可以设置 菊花样式
  if([[self getMJHeader] isKindOfClass:[MJRefreshNormalHeader class]]){
    MJRefreshNormalHeader *mjheader = (MJRefreshNormalHeader *)[self getMJHeader];
    if (mjheader) {
      [self settingMJIndicatorType:type component:mjheader];
    }
  }
}
-(void)settingMJHeaderArrowImage:(NSString *)imageName{
   // 只有normal类型才可以设置 箭头图片
  if([[self getMJHeader] isKindOfClass:[MJRefreshNormalHeader class]]){
    MJRefreshNormalHeader *mjheader = (MJRefreshNormalHeader *)[self getMJHeader];
    if (mjheader) {
      [self settingMJArrowImage:imageName component:mjheader];
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
    [self settingMJGifImage:imageState component:mjHeader];
  }
}
-(void)settingMJHeaderLastUpdatedTimeLabelVisible: (NSNumber *) hide {
  MJRefreshStateHeader *mjHeader = (MJRefreshStateHeader *)[self getMJHeader];
  if (mjHeader) {
     mjHeader.lastUpdatedTimeLabel.hidden = hide.boolValue;
  }
 
}
-(void)settingMJHeaderLabelLeftInset: (NSNumber *)inset{
  MJRefreshStateHeader *mjHeader = (MJRefreshStateHeader *)[self getMJHeader];
  if (mjHeader) {
    mjHeader.labelLeftInset = inset.floatValue;
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
    UIColor *textcolor = [UIColor xy_colorWithColorString:color];
    label.textColor = textcolor;
  }
}

#pragma mark - 自定义footer样式方法

-(void)settingMJFooterIndicatorType:(NSString *)type{
  // 只有normal类型才可以设置 菊花样式 autoNormal backNormal
  MJRefreshFooter *footer = [self getMJFooter];
  if([footer isKindOfClass:[MJRefreshAutoNormalFooter class]] ||
     [footer isKindOfClass:[MJRefreshBackNormalFooter class]]){
    [self settingMJIndicatorType:type component:footer];
  }
}
-(void)settingMJFooterArrowImage:(NSString *)imagename{
  // 只有 backNormal 才可以设置
  MJRefreshFooter *footer = [self getMJFooter];
  if([footer isKindOfClass:[MJRefreshBackNormalFooter class]]){
    [self settingMJArrowImage:imagename component:footer];
  }
}
-(void)settingMJFooterGifImages: (NSDictionary *)images{
  // 只有backGif autoGif 设置有效
   MJRefreshFooter *footer = [self getMJFooter];
  if([footer isKindOfClass:[MJRefreshAutoGifFooter class]] ||
     [footer isKindOfClass:[MJRefreshBackGifFooter class]]){
    [self settingMJGifImage:images component:footer];
  }
  
}
-(void)settingMJFooterLabelLeftInset:(NSNumber *)value{
  MJRefreshFooter *footer = [self getMJFooter];
  // footer都有这个属性
  [footer setValue:value forKeyPath:@"labelLeftInset"];
}

-(void)settingMJFooterStateLabelVisible:(NSNumber *)hide{
  MJRefreshFooter *footer = [self getMJFooter];
  // footer都有这个属性
  [footer setValue:hide forKeyPath:@"stateLabel.hidden"];
}
-(void)settingMJFooterStateLabelStyle:(NSDictionary *)style{
  MJRefreshFooter *footer = [self getMJFooter];
  UILabel *stateLabel = [footer valueForKey:@"stateLabel"];
  if (stateLabel) {
    [self setLabelStyleWithLable:stateLabel styles:style];
  }
  
}
-(void)settingMJFooterStateLabelTitle:(NSDictionary *)stateTitle{
  MJRefreshFooter *footer = [self getMJFooter];
  NSArray *states = stateTitle.allKeys;
  if (footer) {
    for (NSString *state in states) {
      if (![stateTitle[state] isKindOfClass:[NSString class]]) {
        continue;
      }
      if ([state isEqualToString:@"idle"]) {
        if([footer isKindOfClass:[MJRefreshAutoStateFooter class]]){
          [(MJRefreshAutoStateFooter *)footer setTitle:stateTitle[state] forState:MJRefreshStateIdle];
        }else if ([footer isKindOfClass:[MJRefreshBackStateFooter class]]){
          [(MJRefreshBackStateFooter *)footer setTitle:stateTitle[state] forState:MJRefreshStateIdle];
        }
        
      }
      else if ([state isEqualToString:@"pulling"]) {
        if([footer isKindOfClass:[MJRefreshAutoStateFooter class]]){
          [(MJRefreshAutoStateFooter *)footer setTitle:stateTitle[state] forState:MJRefreshStatePulling];
        }else if ([footer isKindOfClass:[MJRefreshBackStateFooter class]]){
          [(MJRefreshBackStateFooter *)footer setTitle:stateTitle[state] forState:MJRefreshStatePulling];
        }
      }
      else if ([state isEqualToString:@"refreshing"]) {
        if([footer isKindOfClass:[MJRefreshAutoStateFooter class]]){
          [(MJRefreshAutoStateFooter *)footer setTitle:stateTitle[state] forState:MJRefreshStateRefreshing];
        }else if ([footer isKindOfClass:[MJRefreshBackStateFooter class]]){
          [(MJRefreshBackStateFooter *)footer setTitle:stateTitle[state] forState:MJRefreshStateRefreshing];
        }
      }
      else if ([state isEqualToString:@"willRefresh"]) {
        if([footer isKindOfClass:[MJRefreshAutoStateFooter class]]){
          [(MJRefreshAutoStateFooter *)footer setTitle:stateTitle[state] forState:MJRefreshStateWillRefresh];
        }else if ([footer isKindOfClass:[MJRefreshBackStateFooter class]]){
          [(MJRefreshBackStateFooter *)footer setTitle:stateTitle[state] forState:MJRefreshStateWillRefresh];
        }
      }
      else if ([state isEqualToString:@"noMoreData"]) {
        if([footer isKindOfClass:[MJRefreshAutoStateFooter class]]){
          [(MJRefreshAutoStateFooter *)footer setTitle:stateTitle[state] forState:MJRefreshStateNoMoreData];
        }else if ([footer isKindOfClass:[MJRefreshBackStateFooter class]]){
          [(MJRefreshBackStateFooter *)footer setTitle:stateTitle[state] forState:MJRefreshStateNoMoreData];
        }
      }
    }
  }
}
-(void)settingMJFooterIgnoredScrollViewContentInsetBottom: (NSNumber *)inset {
  MJRefreshFooter *footer = [self getMJFooter];
  footer.ignoredScrollViewContentInsetBottom = inset.floatValue;
}
-(void)settingMJFooterAutomaticallyChangeAlpha:(NSNumber *)hide{
  MJRefreshFooter *footer = [self getMJFooter];
  footer.automaticallyChangeAlpha = hide.boolValue;
}

#pragma mark - 自定义header/footer样式公共方法
-(void)settingMJIndicatorType:(NSString *)type component:(MJRefreshComponent *)component{
  if ([type isEqualToString:@"whiteLarge"]){
    [component setValue:@(UIActivityIndicatorViewStyleWhiteLarge) forKey:@"activityIndicatorViewStyle"];
  }
  else if ([type isEqualToString:@"white"]){
    [component setValue:@(UIActivityIndicatorViewStyleWhite) forKey:@"activityIndicatorViewStyle"];
  } else{
    // 默认是 灰色
    [component setValue:@(UIActivityIndicatorViewStyleGray) forKey:@"activityIndicatorViewStyle"];
  }
}
-(void)settingMJGifImage:(NSDictionary *)imageState component:(MJRefreshComponent *)component{
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
        if ([component isKindOfClass:[MJRefreshGifHeader class]]) {
          [(MJRefreshGifHeader *)component setImages:imagesArr forState:MJRefreshStateIdle];
        }else if ([component isKindOfClass:[MJRefreshAutoGifFooter class]]){
          [(MJRefreshAutoGifFooter *)component setImages:imagesArr forState:MJRefreshStateIdle];
        }else if ( [component isKindOfClass:[MJRefreshBackGifFooter class]]) {
          [(MJRefreshBackGifFooter *)component setImages:imagesArr forState:MJRefreshStateIdle];
        }
        // 为什么不实用performSelector:方法?
        // 因为要执行的setImages:forState:方法的state参数是一个基本数据类型
//        if ([component canPerformAction:@selector(setImages:forState:) withSender:self]) {
//          [component performSelector:@selector(setImages:forState:) withObject:imagesArr withObject:@(MJRefreshStateIdle)];
//        }
      }
      else if ([key isEqualToString:@"pulling"]){
        if ([component isKindOfClass:[MJRefreshGifHeader class]]) {
          [(MJRefreshGifHeader *)component setImages:imagesArr forState:MJRefreshStatePulling];
        }else if ([component isKindOfClass:[MJRefreshAutoGifFooter class]]){
          [(MJRefreshAutoGifFooter *)component setImages:imagesArr forState:MJRefreshStatePulling];
        }else if ( [component isKindOfClass:[MJRefreshBackGifFooter class]]) {
          [(MJRefreshBackGifFooter *)component setImages:imagesArr forState:MJRefreshStatePulling];
        }
      }
      else if ([key isEqualToString:@"refreshing"]){
        if ([component isKindOfClass:[MJRefreshGifHeader class]]) {
          [(MJRefreshGifHeader *)component setImages:imagesArr forState:MJRefreshStateRefreshing];
        }else if ([component isKindOfClass:[MJRefreshAutoGifFooter class]]){
          [(MJRefreshAutoGifFooter *)component setImages:imagesArr forState:MJRefreshStateRefreshing];
        }else if ( [component isKindOfClass:[MJRefreshBackGifFooter class]]) {
          [(MJRefreshBackGifFooter *)component setImages:imagesArr forState:MJRefreshStateRefreshing];
        }
      }
      else if ([key isEqualToString:@"willRefresh"]){
        if ([component isKindOfClass:[MJRefreshGifHeader class]]) {
          [(MJRefreshGifHeader *)component setImages:imagesArr forState:MJRefreshStateWillRefresh];
        }else if ([component isKindOfClass:[MJRefreshAutoGifFooter class]]){
          [(MJRefreshAutoGifFooter *)component setImages:imagesArr forState:MJRefreshStateWillRefresh];
        }else if ( [component isKindOfClass:[MJRefreshBackGifFooter class]]) {
          [(MJRefreshBackGifFooter *)component setImages:imagesArr forState:MJRefreshStateWillRefresh];
        }
      }
      else if ([key isEqualToString:@"noMoreData"]){
        if ([component isKindOfClass:[MJRefreshGifHeader class]]) {
          [(MJRefreshGifHeader *)component setImages:imagesArr forState:MJRefreshStateNoMoreData];
        }else if ([component isKindOfClass:[MJRefreshAutoGifFooter class]]){
          [(MJRefreshAutoGifFooter *)component setImages:imagesArr forState:MJRefreshStateNoMoreData];
        }else if ( [component isKindOfClass:[MJRefreshBackGifFooter class]]) {
          [(MJRefreshBackGifFooter *)component setImages:imagesArr forState:MJRefreshStateNoMoreData];
        }
      }
    } else {
      // 值类型不是数组
      RCTLogWarn(@"%@", [NSString stringWithFormat:@"the value of %@ is not array", key]);
    }
  }
}
-(void)settingMJArrowImage:(NSString *)imageName component:(MJRefreshComponent *)component{
  if (imageName.length == 0) {
    RCTLogWarn(@"%@", [NSString stringWithFormat:@"arrowImage can't be empty string"]);
    return;
  }
  UIImage *image = [UIImage imageNamed:imageName];
  if (image) {
    [component setValue:image forKeyPath:@"arrowView.image"];
  }else {
    RCTLogWarn(@"%@", [NSString stringWithFormat:@"%@ does not exist in Images.xcassets folder of iOS Project", imageName]);
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

-(void)settingMJFooterStyle{
  UIScrollView *scrollview = [self valueForKeyPath:@"_scrollView"];
  if (scrollview.mj_footer == nil || self.mjFooterStyle == nil) {
    return;
  }
  // NSLog(@"footer的样式:%@",self.mjFooterStyle);
  [self executeMethodWithDictionary:self.mjFooterStyle map:self.footerJSKey2OCMethod];
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
  UIScrollView *scrollView = [self valueForKeyPath:@"_scrollView"];
  if (scrollView) {
    return scrollView;
  }else{
    RCTLogError(@"%@", [NSString stringWithFormat:@"ohh, shit! can't get ScrollView"]);
    return nil;
  }
  
}
-(MJRefreshHeader *)getMJHeader{
  UIScrollView *scrollView = [self getScrollView];
  return scrollView.mj_header;
}
-(MJRefreshFooter *)getMJFooter{
  UIScrollView *scrollView = [self getScrollView];
  return scrollView.mj_footer;
}

#pragma mark - 刷新方法
-(void)refreshAction{
  // 执行刷新方法
  !self.onMJRefresh ?: self.onMJRefresh(@{});
  
}
-(void)loadMoreAction{
  
  !self.onMJLoadMore ?: self.onMJLoadMore(@{});
}


#pragma mark - 下拉刷新属性
static const char XYMJScrollViewEnableRefreshKey = '\0';
-(void)setEnableMJRefresh:(BOOL)enableMJRefresh{
  objc_setAssociatedObject(self, &XYMJScrollViewEnableRefreshKey,
                           @(enableMJRefresh), OBJC_ASSOCIATION_RETAIN);
  UIScrollView *scrollView = [self getScrollView];
  if (enableMJRefresh == YES) {
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
    // 设置样式
    [self settingMJHeaderStyle];
    
  }else {
    // 移除下拉刷新
    scrollView.mj_header = nil;
  }
  
}
-(BOOL)enableMJRefresh{
  return [(NSNumber *)objc_getAssociatedObject(self, &XYMJScrollViewEnableRefreshKey) boolValue];
}

static const char XYMJScrollViewRefreshingKey = '\0';
-(void)setMjRefreshing:(BOOL)mjRefreshing{
  objc_setAssociatedObject(self, &XYMJScrollViewRefreshingKey, @(mjRefreshing), OBJC_ASSOCIATION_RETAIN);
  UIScrollView *scrollView = [self getScrollView];
  if (scrollView.mj_header) {
    if (mjRefreshing == NO && scrollView.mj_header.refreshing == YES) {
      [scrollView.mj_header endRefreshing];
    }
    else if (mjRefreshing == YES && scrollView.mj_header.refreshing == NO){
      [scrollView.mj_header beginRefreshing];
    }
  }
}

-(BOOL)mjRefreshing{
  return [(NSNumber *)objc_getAssociatedObject(self, &XYMJScrollViewRefreshingKey) boolValue];
}


static const char XYMJScrollonRefreshKey = '\0';
-(void)setOnMJRefresh:(RCTBubblingEventBlock)onMJRefresh{
  objc_setAssociatedObject(self, &XYMJScrollonRefreshKey, onMJRefresh, OBJC_ASSOCIATION_RETAIN);
}
-(RCTBubblingEventBlock)onMJRefresh{
  
  return objc_getAssociatedObject(self, &XYMJScrollonRefreshKey);
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

#pragma mark - 上拉加载更多属性
static const char XYMJScrollViewEnableLoadMoreKey = '\0';
-(void)setEnableMJLoadMore:(BOOL)enableMJLoadMore{
  objc_setAssociatedObject(self, &XYMJScrollViewEnableLoadMoreKey,
                           @(enableMJLoadMore), OBJC_ASSOCIATION_RETAIN);
  UIScrollView *scrollView = [self getScrollView];
  if (enableMJLoadMore == YES) {
    // 添加上拉加载更多
    NSString *footerType = self.mjFooterStyle[@"footerType"];
    if ([footerType isEqualToString:@"backNormal"]) {
      scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    }
    else if ([footerType isEqualToString:@"backGif"]) {
      scrollView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    }
    else if ([footerType isEqualToString:@"autoGif"]) {
      scrollView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    }
    else {
      // 默认类型 autoNormal
      scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    }
    // 设置样式
    [self settingMJFooterStyle];
    
  }else {
    // 移除下拉刷新
    scrollView.mj_footer = nil;
  }
}
-(BOOL)enableMJLoadMore{
  return [(NSNumber *)objc_getAssociatedObject(self, &XYMJScrollViewEnableLoadMoreKey) boolValue];
}

static const char XYMJScrollViewLoadingMoreKey = '\0';
- (void)setMjLoadingMore:(BOOL)mjLoadingMore{
  objc_setAssociatedObject(self, &XYMJScrollViewLoadingMoreKey, @(mjLoadingMore), OBJC_ASSOCIATION_RETAIN);
  UIScrollView *scrollView = [self getScrollView];
  if (scrollView.mj_footer) {
    if (mjLoadingMore == NO) {
      [scrollView.mj_footer endRefreshing];
    }else{
      [scrollView.mj_footer beginRefreshing];
    }
  }
}
-(BOOL)mjLoadingMore{
  return [(NSNumber *)objc_getAssociatedObject(self, &XYMJScrollViewLoadingMoreKey) boolValue];
}

static const char XYMJScrollViewLoadAllKey = '\0';
-(void)setMjLoadAll:(BOOL)mjLoadAll{
  objc_setAssociatedObject(self, &XYMJScrollViewLoadAllKey, @(mjLoadAll), OBJC_ASSOCIATION_RETAIN);
  UIScrollView *scrollView = [self getScrollView];
  if(!scrollView) {
    
  }
  if (scrollView.mj_footer) {
    if (mjLoadAll == YES) {
      [scrollView.mj_footer endRefreshingWithNoMoreData];
    }else{
      [scrollView.mj_footer resetNoMoreData];
    }
  }
}
-(BOOL)mjLoadAll{
  return objc_getAssociatedObject(self, &XYMJScrollViewLoadAllKey);
}
static const char XYMJScrollViewFooterStyleKey = '\0';
-(void)setMjFooterStyle:(NSDictionary *)mjFooterStyle{
  objc_setAssociatedObject(self, &XYMJScrollViewFooterStyleKey, mjFooterStyle, OBJC_ASSOCIATION_RETAIN);
  [self settingMJFooterStyle];
}
-(NSDictionary *)mjFooterStyle{
  NSDictionary *footerStyle = objc_getAssociatedObject(self, &XYMJScrollViewFooterStyleKey);
  
  if (footerStyle == nil) {
    return @{
             @"footerType": @"autoNormal", // 值有: backNormal backGif autoNormal autoGif 默认值为autoNormal
             };
  }
  
  return footerStyle;
}

static const char XYMJScrollViewOnLoadMoreKey = '\0';
-(void)setOnMJLoadMore:(RCTBubblingEventBlock)onMJLoadMore{
  objc_setAssociatedObject(self, &XYMJScrollViewOnLoadMoreKey, onMJLoadMore, OBJC_ASSOCIATION_RETAIN);
}
-(RCTBubblingEventBlock)onMJLoadMore{
  return objc_getAssociatedObject(self, &XYMJScrollViewOnLoadMoreKey);
}

@end
