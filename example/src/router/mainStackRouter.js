import {
    createStackNavigator
} from 'react-navigation';

import HomeScreen from '../screen/homeScreen';
import ListDemoScreen from '../screen/listDemoScreen';
import WebViewScreen from '../screen/webViewScreen';


export default stackContainer = createStackNavigator({
    Home: {
        screen: HomeScreen,
        navigationOptions: {
            title: '演示'
        }
    },
    ListDemo: {
        screen: ListDemoScreen
    },
    WebView: {
        screen: WebViewScreen
    }
});



