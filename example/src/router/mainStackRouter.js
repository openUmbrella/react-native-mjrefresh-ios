import {createStackNavigator} from 'react-navigation-stack';

import HomeScreen from '../screen/homeScreen';
import ListDemoScreen from '../screen/listDemoScreen';
import WebViewScreen from '../screen/webViewScreen';
import TipsScreen from '../screen/tipsScreen';

export default createStackNavigator({
  Home: {
    screen: HomeScreen,
    navigationOptions: {
      title: '演示',
      // headerStyle: {
      //     backgroundColor: '#10f9fa'
      // }
    },
  },
  ListDemo: {
    screen: ListDemoScreen,
  },
  WebView: {
    screen: WebViewScreen,
  },
  Tips: {
    screen: TipsScreen,
    navigationOptions: {
      title: '欢迎使用Tips组件',
    },
  },
});
