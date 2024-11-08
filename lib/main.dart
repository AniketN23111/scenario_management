import 'package:async_redux/async_redux.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scenario_management/route_names/route_names.dart';
import 'package:scenario_management/screens/home_screen/my_home_page_connector.dart';
import 'package:scenario_management/screens/login_screen/login_screen_connector.dart';
import 'package:scenario_management/screens/register_screen/register_screen_connector.dart';

import 'Firebase/firebase_options.dart';
import 'redux/app_state.dart';

///Declare Store
late Store<AppState> store;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ///Initialize Store
  var state = AppState.initState();
  store = Store<AppState>(initialState: state);
  ///Initialize Firebase In App
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: RoutesName.loginScreen,
        routes: {
          RoutesName.homePageScreen: (context) => const HomeScreenConnector(),
          RoutesName.loginScreen: (context) => const LoginScreenConnector(),
          RoutesName.registerScreen: (context) => const RegisterScreenConnector(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case RoutesName.homePageScreen:
              return MaterialPageRoute(
                  builder: (context) => const HomeScreenConnector());
             case RoutesName.registerScreen:
            return MaterialPageRoute(
                builder: (context) => const RegisterScreenConnector());
            case RoutesName.loginScreen:
              return MaterialPageRoute(
                  builder: (context) => const LoginScreenConnector());
          }
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text('Route not found!'),
              ),
            ),
          );
        },
      ));
}
