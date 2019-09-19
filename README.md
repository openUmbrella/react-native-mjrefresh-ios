### 功能
1. MJRefresh在RN中的拓展
2. 为RN的ScrollView、FlatList、SectionList以及WebView等可滑动组件提供新属性来实现下拉刷新, 上拉加载更多
3. 提供在RN中实现自定义MJRefresh的header和footer属性

### iOS配置
#### 1.安装MJRefresh
**推荐:** 如果项目使用pod来管理iOS第三方依赖库，则在Podfile文件中添加以下代码：
```bash
pod 'MJRefresh', '~> 3.1.15.7'
```
然后执行： **pod install**
如果是手动引入MJRefresh，将MJRefresh文件夹引入到项目中，[MJRefresh库地址](https://github.com/CoderMJLee/MJRefresh)

#### 2.引入拓展文件

##### 当RN版本 < 0.60 时
将本库中的 **ios/ReactNativeMJRefresh** 路径下的文件引入到iOS项目中。

##### 当RN版本 >= 0.60 时
将本库中的 **ios/ReactNativeMJRefresh60** 路径下的文件引入到iOS项目中。
**说明:**
1. RN在0.60版本之后将WebView组件剥离出去了, 社区推荐使用[react-native-webview](https://www.npmjs.com/package/react-native-webview)代替, 因此本库就针对于react-native-webview的WebView组件进行了MJRefresh拓展
2. 如果不需要在WebView中使用MJRefresh进行下拉刷新, 可以不引入文件夹中的以下文件:
```
RNCWebView+MJRfresh.h
RNCWebView+MJRfresh.m
RNCWebViewManager+MJRefresh.h
RNCWebViewManager+MJRefresh.m
```

* * *

通过以上两步即可完成配置，接下来即可在RN中愉快的使用MJRefresh了

### RN端的使用
#### 下拉刷新
##### 在ScrollView中的使用
这里指包含ScrollView、FlatList、SectionList等可以滑动组件的使用。在这些组件中新增了以下属性用于控制下拉刷新：
1. **enableMJRefresh**
 是否使用MJRefresh下拉刷新功能

2. **onMJRefresh**
下拉刷新时触发的回调

3. **mjRefreshing**
是否显示刷新状态 如果为true，则显示正在刷新状态，如果为false，则显示初始的状态
4. **mjHeaderStyle**
设置下拉刷新组件的样式, 后面会详细介绍

例如：
```jsx
<FlatList
    enableMJRefresh={true}
    mjRefreshing={this.state.refreshing}
    onMJRefresh={this.loadDataList}
    mjHeaderStyle={{
        // 设置属性
    }}
/>
```

##### 在WebView中的使用

###### 1. 当RN版本<0.60时
在WebView组件中，需要通过**nativeConfig**属性来添加, **这一点比较特殊, 需要特别关注**
具体操作如下:
```jsx
 <WebView
    nativeConfig={{
        props:{
                // 是否开启下拉刷新
                enableMJRefresh: true,
                // 决定是否开启刷新，是否结束刷新 如果为true，则显示正在刷新状态，如果为false，则显示默认的状态
                mjRefreshing: this.state.refreshing,
                // 下拉刷新触发时，的回调
                onMJRefresh: this.loadData,
                mjHeaderStyle: {
                    // 设置属性
                }
            }
    }}
 />
```

###### 2. 当RN版本>=0.60时
使用方式与ScrollView的使用方式一致。
例如：
```jsx
import {WebView} from 'react-native-webview';

// ....

<WebView
    style={{flex: 1, marginTop: 88}}
    source={{uri: 'https://www.baidu.com'}}
    // 是否开启下拉刷新
    enableMJRefresh: true,
    // 决定是否开启刷新，是否结束刷新 如果为true，则显示正在刷新状态，如果为false，则显示默认的状态
    mjRefreshing: this.state.refreshing,
    // 下拉刷新触发时，的回调
    onMJRefresh: this.loadData,
    mjHeaderStyle: {
        // 设置属性
    }
/>

```

**特别说明：**

* * *

1. 在WebView刷新网页时，如果不设置mjRefreshing、onMJRefresh属性。那么当网页加在完成后，下拉刷新也会结束。如果指定了onMJRefresh属性，那么下拉刷新的结束状态就要我们通过mjRefreshing来自己控制了。

2. WebView组件没有上拉加载更多功能

* * *


#### 上拉加载更多
与下拉刷新功能使用的组件范围相同。只要是可以滑动的组件，都可以使用。 通过以下属性来控制上拉加载更多：

1. **enableMJLoadMore**
是否使用MJRefresh上拉加载更多功能

2. **onMJLoadMore**
上拉加载更多时触发的回调

3. **mjLoadingMore**
是否开启上拉加载更多 如果为true，则显示正在加载更多状态，如果为false，则显示初始的状态

4. **mjLoadAll**
标识是否已经加载结束

5. **mjFooterStyle**
设置上拉加载更多组件的样式, 后面会详细介绍

例如：
```jsx
<FlatList
    enableMJLoadMore={this.state.enableLoadMore}
    mjLoadingMore={this.state.loadingMore}
    mjLoadAll={this.state.isLoadAll}
    onMJLoadMore={this.loadMoreData}
    mjFooterStyle={{
        // 设置属性
    }}

/>
```

### 自定义样式

针对于下拉刷新, 我们通过指定**mjHeaderStyle**来设置
针对于上拉加载更多, 我们通过指定**mjFooterStyle**来设置

#### mjHeaderStyle
mjHeaderStyle需要指定一个对象，通过这个对象来的属性来设置下拉刷新的样式， 以下是这个对象属性详细介绍


| 属性名 | 含义 | 值 | 说明 | 备注 |
| --- | --- | --- | --- | --- |
| headerType | 下拉刷新的样式类型，如果不设置改属性，默认为 normal样式 | normal<br>gif<br>gifTop | normal普通样式的下拉刷新。<br>gif带有动画的下拉刷新，动画在左边。<br>gifTop带有动画的下拉刷新，动画在顶部 | 1. 当指定值为 gif gifTop 时, 必须在iOS项目Images.xcassets文件夹下添加动画图片并且设置gifImages属性(下面有介绍) |
| indicatorType | 加载状态时的菊花样式 如果不指定该属性, 默认样式则为gray | white<br>whiteLarge<br>gray | white白色样式的小菊花<br>whiteLarge白色样式的大菊花<br>gray灰色样式的小菊花 | 只有headerType为 normal 时有效 |
| arrowImage | 拖拽状态下的指示图片名, 如果不指定, 默认使用箭头图片 | String | Images.xcassets文件夹下的图片名 | 1. 只有headerType为 normal 时有效<br>2. 改属性是指定放入在iOS项目中的Images.xcassets文件夹下面的图片名字, 因此必须在Images.xcassets文件中先添加图片 |
| gifImages | 指定各个状态下的动画图片 | Object | **Object.idle** 开始下拉时的状态图片数组<br>**Object.pulling** 下拉超过刷新阈值, 如果放手则触发刷新的状态图片数组<br>**Object.refreshing** 正在刷新状态图片数组<br>**Object.willRefresh** 将要刷新状态图片数组<br>**Object.noMoreData** 没有更多数据状态(适用于上拉加载更多)图片数组 | 1. 只有headerType为 gif 时有效<br>2.表示各个状态的属性值都为图片名数组<br>3. 图片名为在iOS项目Images.xcassets文件夹中添加的图片名<br>4.可以不指定状态属性值，如果不指定，这个状态下则无动画 |
| hideTimeLabel | 是否隐藏时间标签  | Boolean | 默认为 false |  |
| hideStateLabel | 是否隐藏显示状态文字的标签  | Boolean | 默认为 false |  |
| labelImageGap |  菊花/箭头/图片 与 文字 的间距 | Number | 如果header类型是 gifTop 则默认值为0, 其他情况下默认值为20 | 单位pt |
| stateLabelStyle | 显示状态文字的标签样式 | Object | **Object.fontSize** 字体大小<br>**Object.color** 字体颜色，可以使用十六进制色号 如: #1232fa, 也可以使用 rgb(255,2,34) 以及带不透明度的 rgba(255,22,2,0.5)，如果色号格式不正确,则返回黑色 | fontSize默认值14pt<br>color默认值#5A5A5A |
| timeLabelStyle | 显示上次刷新时间的标签样式 | 同上 | 同上 | 同上 |
| stateTitle | 状态标签在各个状态下显示的文字 | Object | **Object.idle** 开始下拉时的状态文字<br>**Object.pulling** 下拉超过刷新阈值, 如果放手则触发刷新的状态文字<br>**Object.refreshing** 正在刷新状态文字<br>**Object.willRefresh** 将要刷新状态文字<br>**Object.noMoreData** 没有更多数据状态(适用于上拉加载更多)文字 | 1.各个属性值类型为字符串 |
| ignoredInsetTop | 刷新组件距离scrollview的内容顶部的距离 | Number | 默认值为 0 |  |
| autoChangeAlpha | 在下拉的过程中,下拉刷新组件的不透明度逐渐由0变成1, 也就是随着下拉,下拉刷新组件会逐渐显现 | Boolean | 默认值为 false |  |

#### mjHeaderStyle
同理的，mjHeaderStyle需要指定一个对象，通过这个对象来的属性来设置上拉加载更多，以下是这个对象属性详细介绍

| 属性名 | 含义 | 值 | 说明 | 备注 |
| --- | --- | --- | --- | --- |
| footerType | 上拉加载更多组件的类型 | autoNormal<br>autoGif<br>backNormal<br>backGif<br> | **autoNormal** 上拉组件紧贴在ScrollView内容后面, 没有拖拽时显示是否放手刷新状态, 拖拽过程没有图片, 加载中的状态显示菊花<br>**autoGif** 上拉组件紧贴在ScrollView内容后面, 没有拖拽时显示是否放手刷新状态, 自定义加载中动画<br> **backNormal** 上拉组件隐藏在ScrollView组件的底部, 加载完成后会回弹出ScrollView组件以外 有拖拽时的状态提示, 有拖拽时的自定义图片, 有加载中的菊花<br>**backGif** 上拉组件隐藏在ScrollView组件的底部, 加载完成后会回弹出ScrollView组件以外 自定义各种状态下动画 |  |
| indicatorType | 加载状态时的菊花样式 | white<br>whiteLarge<br>gray<br> | **white** 白色样式的小菊花<br>**whiteLarge** 白色样式的大菊花<br>**gray** 灰色样式的小菊花 | 1. 只有footerType为 autoNormal backNormal 时有效<br>2. 如果不指定, 默认样式则为gray |
| arrowImage | 拖拽状态下的指示图片名 | String | Images.xcassets文件夹下的图片名 | 1. 只有footerType为 backNormal 时有效<br> 2. 该属性是指定放入在iOS项目中的Images.xcassets文件夹下面的图片名字, 因此必须在Images.xcassets文件中先添加图片<br>3. 如果不指定, 默认使用箭头图片 |
| gifImages | 指定各个状态下的动画图片 | Object | Object属性值与headerStyle的gifImages相同 | 1. 只有footerType为 autoGif backGif 类型才有效<br>2. 使用方法同headerType中的gifImages属性的使用方法一致, 具体详情请看之前描述 |
| labelImageGap |  菊花/箭头/图片 与 文字 的间距 | Number | 如果header类型是 gifTop 则默认值为0, 其他情况下默认值为20 | 单位pt |
| hideStateLabel | 是否隐藏显示状态文字的标签  | Boolean | 默认为 false |  |
| stateLabelStyle | 显示状态文字的标签样式 | Object | **Object.fontSize** 字体大小<br>**Object.color** 字体颜色，可以使用十六进制色号 如: #1232fa, 也可以使用 rgb(255,2,34) 以及带不透明度的 rgba(255,22,2,0.5)，如果色号格式不正确,则返回黑色 | fontSize默认值14pt<br>color默认值#5A5A5A |
| stateTitle | 状态标签在各个状态下显示的文字 | Object | 各个状态值与headerStyle的stateTitle相同 | 1.idle状态autoXX 类型下显示: 点击或上拉加载更多 backXX 类型下显示: 上拉可以加载更多<br>pulling状态，footerType为 backNormal backGif 时有效， 默认显示: 松开立即加载更多 |
| ignoredInsetBottom | 上拉加载组件距离ScrollView的内容底部距离 | Number | 只有footerType为 backNormal backGif 时才有效 | 默认为0 |
| autoChangeAlpha | 是否在上拉拖拽时, 上拉加载组件自动改变不透明度 | Boolean | 默认值 false |  |
