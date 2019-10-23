### 功能
1. MJRefresh在RN中的拓展
2. 为RN的ScrollView、FlatList、SectionList等可滑动组件提供新属性来实现下拉刷新, 上拉加载更多
3. 一行代码为WebView组件提供刷新网页功能
4. 提供在RN中实现自定义MJRefresh的header和footer属性

### iOS配置
#### 1.安装MJRefresh
**推荐:** 如果项目使用pod来管理iOS第三方依赖库，则在Podfile文件中添加以下代码：
```bash
pod 'MJRefresh', '~> 3.1.15.7'
```
然后执行： **pod install**
如果是手动引入MJRefresh，将MJRefresh文件夹引入到项目中，[MJRefresh库地址](https://github.com/CoderMJLee/MJRefresh)

#### 2.引入拓展文件

安装库：
```
yarn add react-native-refresh-ios
```
或
```
npm install --save react-native-refresh-ios
```
或
直接download下载，找到对应文件引入到iOS项目中

通过npm或yarn安装的，需要在项目根目录下的**node_modules/react-native-mjrefresh-ios/ios**路径下根据需要将对应文件夹引入iOS项目中

在本库中的ios文件夹下有如下文件夹:
```
MJRefreshExtension          mjRefresh框架的拓展文件
RCTScrollView+MJRefresh     ScrollView,FlatList,SectionList等可滑动组件的拓展文件
RCTWebView+MJRefresh        WebView组件的拓展文件
RNCWebView+MJRefresh        react-native-webview中的WebView组件拓展文件
```
根据你需要拓展MJRefresh到对应组件，选择对应文件夹拖入到你的项目中。
注意：MJRefreshExtension文件夹必须拖入
**例如：**
1. 如果想让ScrollView，FlatList具备MJRefresh刷新能力，那么需要将**MJRefreshExtension**和**RCTScrollView+MJRefresh**文件夹引入到iOS项目中
2. 如果想让WebView具备MJRefresh下拉刷新能力，那么需要将**MJRefreshExtension**和**RCTWebView+MJRefresh**文件夹引入到iOS项目中
3. 如果想让ScrollView和WebView都具备MJRefresh下拉刷新能力， 则需要将**MJRefreshExtension**、**RCTScrollView+MJRefresh**、**RCTWebView+MJRefresh**或**RNCWebView+MJRefresh**文件夹引入到iOS项目中


* * *
**特别说明：**

由于iOS13以后，苹果已经不允许再使用UIWebView了，同时React Native团队也推荐我们使用社区提供的[react-native-webview](https://www.npmjs.com/package/react-native-webview)代替React-Native中的WebView。事实上， 在React-Native 0.60以后的版本已经将WebView组件给剥离出去了。

因此，在项目中如果使用了react-native-webview库，要使得其WebView具备MJRefresh下拉刷新能力，就需要将**RNCWebView+MJRefresh**文件夹引入到iOS项目中

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
是否显示刷新状态 如果为true，则为正在刷新状态，如果为false，则为初始的状态
4. **mjHeaderStyle**
设置下拉刷新头的样式, 后面会详细介绍

例如：
```jsx
<FlatList
    // 是否开启下拉刷新
    enableMJRefresh={true}
    // 指定刷新状态
    mjRefreshing={this.state.refreshing}
    // 拖拽刷新时，触发的回调
    onMJRefresh={this.loadDataList}
    // 设置header样式
    mjHeaderStyle={{
        // 指定属性
    }}
/>
```
使用方法与React Native提供的[RefreshControl](https://reactnative.cn/docs/refreshcontrol.html)组件的使用方法完全一致

##### 在WebView中的使用

###### 1. React Native提供的WebView

在WebView组件中，需要通过**nativeConfig**属性来添加, **这一点比较特殊, 需要特别关注**
具体操作如下:
```jsx
 <WebView
    source={{uri: 'https://www.baidu.com'}}
    nativeConfig={{
        props:{
                // 是否开启下拉刷新
                enableMJRefresh: true,
                // 指定刷新状态
                // mjRefreshing: this.state.refreshing,
                // 拖拽刷新时，触发的回调
                // onMJRefresh: this.reloadData,
                // 设置header样式
                // mjHeaderStyle: {
                //    // 指定属性
                // }
            }
    }}
 />
```
**如上，只需要一行代码即可实现网页的下拉刷新功能。**

同时，本库也提供像为ScrollView组件提供的属性一样提供**mjRefreshing**、**onMJRefresh**和**mjHeaderStyle**属性。


###### 2. react-native-webview提供的WebView

为WebView提供了与ScrollView一致的属性。
例如：
```jsx
import { WebView } from 'react-native-webview';

// ....

<WebView
    source={{uri: 'https://www.baidu.com'}}
    // 是否开启下拉刷新
    enableMJRefresh: true,
    // 指定刷新状态
    // mjRefreshing: this.state.refreshing,
    // 下拉刷新触发时，的回调
    // onMJRefresh: this.loadData,
    // mjHeaderStyle: {
    //    // 指定样式属性
    // }
/>

```

**特别说明：**

* * *

1. 在WebView刷新网页时，如果不设置mjRefreshing、onMJRefresh属性。那么当网页加载完成后，下拉刷新也会结束。如果指定了onMJRefresh属性，那么下拉刷新的结束状态就要开发者通过mjRefreshing自己控制了。
2. 当触发刷新时，WebView的**onLoad**、**onLoadEnd**也会被触发
3. WebView组件没有上拉加载更多功能

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
