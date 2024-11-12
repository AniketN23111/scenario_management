import 'package:async_redux/async_redux.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scenario_management/route_names/route_names.dart';
import 'package:scenario_management/screens/home_screen/home_screen_connector.dart';
import 'package:scenario_management/screens/login_screen/login_screen_connector.dart';
import 'package:scenario_management/screens/register_screen/register_screen_connector.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:scenario_management/screens/splash/splash_screen.dart';
import 'package:scenario_management/screens/test_case_details/test_case.dart';
import 'package:scenario_management/screens/test_case_details/test_case_arguments.dart';

import 'Firebase/firebase_options.dart';

import 'constants/hive_service.dart';
import 'models/user_model.dart';
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

  ///Initialize Hive
  await Hive.initFlutter();

  ///Register the UserModelAdapter
  Hive.registerAdapter(UserModelAdapter());

  /// Initialize HiveService
  await HiveService().init();

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
        initialRoute: RoutesName.splashScreen,
        routes: {
          RoutesName.homePageScreen: (context) => const HomeScreenConnector(),
          RoutesName.loginScreen: (context) => const LoginScreenConnector(),
          RoutesName.splashScreen: (context) => const SplashScreen(),
          RoutesName.registerScreen: (context) =>
              const RegisterScreenConnector(),
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
            case RoutesName.splashScreen:
              return MaterialPageRoute(
                  builder: (context) => const SplashScreen());
            case RoutesName.testCaseScreen:
              return settings.arguments != null
                  ? MaterialPageRoute(
                      builder: (context) {
                        final args =
                            settings.arguments as TestCaseScreenArguments;
                        return TestCaseScreen(
                          scenario: args.scenario,
                          userModel: args.userModel,
                        );
                      },
                    )
                  : MaterialPageRoute(
                      builder: (context) => const TestCaseScreen());
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
