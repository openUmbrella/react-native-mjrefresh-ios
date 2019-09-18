### 功能
1. MJRefresh在RN中的拓展
2. 为RN的ScrollView、FlatList、SectionList以及WebView等可滑动组件提供新属性来实现下拉刷新, 上拉加载更多
3. 提供在RN中实现自定义MJRefresh的header和footer属性

### 配置
#### 1.安装MJRefresh
如果项目使用pod来管理iOS第三方依赖库，则在Podfile文件中添加以下代码：
```bash
pod 'MJRefresh', '~> 3.1.15.7'
```
然后执行： **pod install**
如果是手动引入MJRefresh，只要将MJRefresh文件夹引入到项目中

#### 2.引入拓展文件
将本库中的 **ios/ReactNativeMJRefresh** 路径下的文件引入到iOS项目中。

通过以上两步即可完成配置，接下来即可在RN中愉快的使用MJRefresh了

### 在RN端的使用
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
```
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
在WebView组件中，需要通过**nativeConfig**属性来添加, **这一点比较特殊, 需要特别关注**
具体操作如下:
```
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
**特别说明：**
在WebView刷新网页时，如果不设置mjRefreshing、onMJRefresh属性。那么当网页加在完成后，下拉刷新也会结束。如果指定了onMJRefresh属性，那么下拉刷新的结束状态就要我们通过mjRefreshing来自己控制了。

WebView组件没有上拉加载更多功能

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
```
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
| gifImages | 指定各个状态下的动画图片 | Object | **Object.idle**开始下拉时的状态<br>**Object.pulling**下拉超过刷新阈值, 如果放手则触发刷新的状态<br>**Object.refreshing**正在刷新状态<br>**Object.willRefresh**将要刷新状态<br>**Object.noMoreData**没有更多数据状态(适用于上拉加载更多) | 1. 只有headerType为 gif 时有效<br>2.表示各个状态的属性值都为图片名数组<br>3. 图片名为在iOS项目Images.xcassets文件夹中添加的图片名<br>4.可以不指定状态属性值，如果不指定，这个状态下则无动画 |
|  |  |  |  |  |
|  |  |  |  |  |




```js

/**
 * 指定各个状态下的动画图片
 *  注意: 
 *      1. 只有headerType为 gif 时有效
 *      2. 返回一个对象, 对象的属性对应下拉刷新的状态, 值为组成动画的图片名数组
 *      3. 图片名为在iOS项目Images.xcassets文件夹中添加的图片名
 */
gifImages: {
    /**
     * 开始下拉时的状态,
     * 注意:
     *      1. 可以不指定. 如果不指定, 这个状态下则无动画
     * 值为:
     *      图片名数组, 如: ['idle001', 'idle002', 'idle003', 'idle004', 'idle005', 'idle006']
     */
    idle: [], // this.state.idlelist
    /**
     * 下拉超过刷新阈值, 如果放手则触发刷新的状态
     * 注意:
     *      同上
     * 值为: 
     *      同上
     */
    pulling: [], // this.state.loadinglist
    /**
     * 正在刷新状态
     * 注意:
     *      同上
     * 值为: 
     *      同上
     */
    refreshing: [], // this.state.loadinglist
    /**
     * 将要刷新状态
     * 注意:
     *      同上
     * 值为: 
     *      同上
     */
    willRefresh: [],
    /**
     * 没有更多数据状态(适用于上拉加载更多)
     * 注意:
     *      同上
     * 值为: 
     *      同上
     */
    noMoreData: []
},
/**
 * 是否隐藏时间标签 默认为 false
 * 值为:
 *      true
 *      false
 */
hideTimeLabel: false,
/**
 * 菊花/箭头/图片 与 文字 的间距
 * 注意:
 *      1. 如果header类型是 gifTop 则默认值为0, 其他情况下默认值为20, 注意单位是:pt
 * 值为:
 *      数字
 */
labelImageGap: 20,
/**
 * 是否隐藏显示状态文字的标签
 * 值为:
 *      true
 *      false
 */
hideStateLabel: false,
/**
 * 显示状态文字的标签样式
 * 注意: 
 *      1. 返回一个对象, 对象只有两个属性: fontSize 和 color
 */
stateLabelStyle: {
    /**
     * 字体大小
     * 注意: 
     *      1. 默认值14, 单位pt
     */
    fontSize: 14, // 默认值 14
    /**
     * 颜色
     * 注意:
     *      1. 可以使用十六进制色号 如: #1232fa, 也可以使用 rgb(255,2,34) 以及带不透明度的 rgba(255,22,2,0.5), 
     *      2. 如果色号格式不正确,则返回黑色
     */
    color: 'rgba(255,0,255,0.9)'
},
/**
 * 显示上次刷新时间的标签样式
 * 注意: 
 *      1. 返回一个对象, 对象只有两个属性: fontSize 和 color
 */
timeLabelStyle: {
    /**
     * 同stateLabelStyle中的fontSize
     */
    fontSize: 14,
    /**
     * 同stateLabelStyle中的color
     */
    color: 'rgba(100,0,200,1)'
},
/**
 * 状态标签在各个状态下显示的文字
 */
stateTitle: {
    /**
     * 开始下拉时的状态
     * 注意:
     *      1. 可以不指定. 如果不指定, 则默认显示: 下拉可以刷新
     * 值为:
     *      字符串
     */
    idle: '敢不敢下拉试试',
    /**
     * 下拉超过刷新阈值, 如果放手则触发刷新的状态
     * 注意:
     *      1. 可以不指定. 如果不指定, 则默认显示: 松开立即刷新
     * 值为:
     *      字符串
     */
    pulling: 'you 放手, me 刷新',
    /**
     * 正在刷新状态
     * 注意:
     *      1. 可以不指定. 如果不指定, 则默认显示: 正在刷新数据中...
     * 值为:
     *      字符串
     */
    refreshing: '正在玩命加载中...',
    /**
     * 即将刷新状态
     * 注意:
     *      1. 可以不指定. 如果不指定, 则默认显示: ''
     * 值为:
     *      字符串
     */
    willRefresh: '即将刷新啦',
    /**
     * 没有更多数据状态(适用于上拉加载更多)
     * 注意:
     *      1. 可以不指定. 如果不指定, 则默认显示: '已经全部加载完毕'
     * 值为:
     *      字符串
     */
    noMoreData: '人生, 是有底线的' // 
},
/**
 * 刷新组件距离scrollview顶部的距离 默认值为 0
 */
ignoredInsetTop: 0,
/**
 * 在下拉的过程中,下拉刷新组件的不透明度逐渐由0变成1, 也就是随着下拉,下拉刷新组件会逐渐显现
 * 默认值为: false
 */
autoChangeAlpha: true
```

#### mjHeaderStyle
同理的，mjHeaderStyle需要指定一个对象，通过这个对象来的属性来设置上拉加载更多，以下是这个对象属性详细介绍
```js
/**
 * 上拉加载更多组件的类型
 * 值有:
 *      autoNormal      上拉组件紧贴在ScrollView内容后面, 没有拖拽时显示是否放手刷新状态, 拖拽过程没有图片, 加载中的状态显示菊花
 *      autoGif         上拉组件紧贴在ScrollView内容后面, 没有拖拽时显示是否放手刷新状态, 自定义加载中动画
 *      backNormal      上拉组件隐藏在ScrollView组件的底部, 加载完成后会回弹出ScrollView组件以外 有拖拽时的状态提示, 有拖拽时的自定义图片, 有加载中的菊花
 *      backGif         上拉组件隐藏在ScrollView组件的底部, 加载完成后会回弹出ScrollView组件以外 自定义各种状态下动画
 * 
 */
footerType: 'backNormal',
/**
 * 加载状态时的菊花样式 如果不指定, 默认样式则为gray, 
 * 注意:
 *      1. 只有footerType为 autoNormal backNormal 时有效
 * 值有:
 *      white           白色样式的小菊花
 *      whiteLarge      白色样式的大菊花
 *      gray            灰色样式的小菊花 
 */
indicatorType: 'white',
/**
 * 拖拽状态下的指示图片名, 如果不指定, 默认使用箭头图片, 
 * 注意: 
 *      1. 只有footerType为 backNormal 时有效
 *      2. 改属性是指定放入在iOS项目中的Images.xcassets文件夹下面的图片名字, 因此必须在Images.xcassets文件中先添加图片
 * 值为:
 *      Images.xcassets文件夹下的图片名
 */
arrowImage: 'invite_code',
/**
 * 指定各个状态下的动画图片
 * 注意:
 *      1. 只有footerType为 autoGif backGif 类型才有效
 *      2. 使用方法同headerType中的gifImages属性的使用方法一致, 具体详情请看之前描述
 */
gifImages: {
    idle: [], // this.state.idlelist,
    pulling: [], // this.state.loadinglist,
    refreshing: [], //  this.state.loadinglist,
    willRefresh: [],
    noMoreData: []
},
/**
 * 菊花/箭头/图片 与 文字 的间距
 * 注意:
 *      1.默认值为20, 注意单位是:pt
 * 值为:
 *      数字
 */
labelImageGap: 20,
/**
 * 是否隐藏显示状态文字的标签 默认值为true
 * 值为:
 *      true
 *      false
 */
hideStateLabel: false,
/**
 * 显示状态文字的标签样式
 * 注意: 
 *      1. 返回一个对象, 对象只有两个属性: fontSize 和 color
 */
stateLabelStyle: {
    /**
     * 字体大小
     * 注意: 
     *      1. 默认值14, 单位pt
     */
    fontSize: 14,
    /**
     * 颜色
     * 注意:
     *      1. 可以使用十六进制色号 如: #1232fa, 也可以使用 rgb(255,2,34) 以及带不透明度的 rgba(255,22,2,0.5), 
     *      2. 如果色号格式不正确,则返回黑色
     */
    color: 'rgba(255,0,0,0.9)'
},
/**
 * 状态标签在各个状态下显示的文字
 */
stateTitle: {
    /**
     * 开始上拉时的状态
     * 注意:
     *      1. 可以不指定. 如果不指定, 则默认显示: autoXX 状态下显示: 点击或上拉加载更多 backXX 状态下显示: 上拉可以加载更多
     * 值为:
     *      字符串
     */
    idle: '上啦吧, 兄弟',
    /**
     * 下拉超过刷新阈值, 如果放手则触发刷新的状态
     * 注意:
     *      1. 这个状态之后footerType为 backNormal backGif 时有效
     *      2. 可以不指定. 如果不指定, 则默认显示: 松开立即加载更多
     * 值为:
     *      字符串
     */
    pulling: '别拉了, 我加载更多',
    /**
     * 正在刷新状态
     * 注意:
     *      1. 可以不指定. 如果不指定, 则默认显示: 正在加载更多数据...
     * 值为:
     *      字符串
     */
    refreshing: '加载中啊...',
    /**
     * 即将加载更多状态
     * 注意:
     *      1. 可以不指定. 如果不指定, 则默认显示: ''
     * 值为:
     *      字符串
     */
    willRefresh: '即将刷新啦',
    /**
     * 没有更多数据状态
     * 注意:
     *      1. 可以不指定. 如果不指定, 则默认显示: '已经全部加载完毕'
     * 值为:
     *      字符串
     */
    noMoreData: '人生, 是有底线的'

},
/**
 * 上拉加载组件距离ScrollView的内容的距离 默认为0
 * 注意:
 *      1. 只有footerType为 backNormal backGif 时才有效
 */
ignoredInsetBottom: 0,
/**
 * 是否在上拉拖拽时, 上拉加载组件自动改变不透明度 默认值 false
 */
autoChangeAlpha: false
```