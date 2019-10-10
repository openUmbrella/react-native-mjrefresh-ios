import { 
    createAppContainer
} from 'react-navigation';
import AppStackNavigator from './src/router/mainStackRouter';


export default createAppContainer(AppStackNavigator);

// /**
//  * Sample React Native App
//  * https://github.com/facebook/react-native
//  *
//  * @format
//  * @flow
//  */
// 
// import React, {Component} from 'react';
// import {Platform, StyleSheet, Text, View, ScrollView} from 'react-native';

// const instructions = Platform.select({
//   ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
//   android:
//     'Double tap R on your keyboard to reload,\n' +
//     'Shake or press menu button for dev menu',
// });

// type Props = {};
// export default class App extends Component<Props> {
//   // 构造函数
//   constructor(props){
//     super(props);
//     this.state={
//       refreshing: false
//     };
    
//   }
//   render() {
//     return (
//       <ScrollView style={styles.sclview} contentContainerStyle={styles.container}
//         enableMJRefresh={true}
//         mjRefreshing={this.state.refreshing}
//         onMJRefresh={()=>{
//           console.log('啦啦啦啦');
//           this.setState({
//             refreshing: true
//           });
//           setTimeout(() => {
//             this.setState({
//               refreshing: false
//             });
//           }, 3000);
//         }}
//       >
//         <Text style={styles.welcome}>Welcome to React Native!</Text>
//         <Text style={styles.instructions}>To get started, edit App.js</Text>
//         <Text style={styles.instructions}>{instructions}</Text>
//       </ScrollView>
//     );
//   }
// }

// const styles = StyleSheet.create({
//   sclview: {
//     flex: 1,
//     marginTop: 44,
//   },
//   container: {
//     flex: 1,
//     justifyContent: 'center',
//     alignItems: 'center',
//     backgroundColor: '#F5FCFF',
//   },
//   welcome: {
//     fontSize: 20,
//     textAlign: 'center',
//     margin: 10,
//   },
//   instructions: {
//     textAlign: 'center',
//     color: '#333333',
//     marginBottom: 5,
//   },
// });
