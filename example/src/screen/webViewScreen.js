/**
 * WebViewScreen
 * 
 * opu
 * 19年10月9日
*/
import React, { Component } from 'react';
import { ScrollView, WebView, Text, StyleSheet, View } from 'react-native';

export default class WebViewDemoContainer extends Component {
    // 构造函数
    constructor(props) {
        super(props);
        this.state = {
            enableRefresh: true,
            refreshing: false
        };
    }
    componentDidMount() {
        let arr = [];
        let arr1 = [];
        for (let i = 1; i <= 8; i++) {
            arr.push(`wsfloading00${i}`);
        }
        for (let i = 1; i <= 6; i++) {
            arr1.push(`pulling00${i}`);
        }

        this.setState({
            loadinglist: arr,
            idlelist: arr1
        });
    }
    loadData = data => {
        console.log('传过来的参数:', data.nativeEvent);

        this.setState({
            refreshing: true
        });
        // 网络请求
        setTimeout(() => {
            this.setState({
                refreshing: false
            });
            console.log('请求结束:');
        }, 3000);
    };
    // 渲染组件
    render() {
        return (
            <View style={styles.container}>
                {/* RN提供的WebView */}
                <WebView
                    ref={'webview'}
                    source={{ uri: 'https://www.baidu.com' }}
                    javaScriptEnabled={true}
                    domStorageEnabled={true}
                    scalesPageToFit={false}
                    allowsInlineMediaPlayback={true}
                    dataDetectorTypes={'none'}
                    // 注意 指定值的特殊位置
                    nativeConfig={{
                        props: {
                            enableMJRefresh: true,
                            mjHeaderStyle: this.props.navigation.getParam('headerStyles')
                        }
                    }}
                />
            </View>
        );
    }
}
// 样式
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f5f9fa',
    },
   
});