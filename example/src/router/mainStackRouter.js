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
            title: '演示',
            // headerStyle: {
            //     backgroundColor: '#10f9fa'
            // }
            
        }
    },
    ListDemo: {
        screen: ListDemoScreen
    },
    WebView: {
        screen: WebViewScreen
    }
});



