import 'package:async_redux/async_redux.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scenario_management/models/scenario.dart';
import 'package:scenario_management/models/test_cases.dart';
import 'package:scenario_management/route_names/route_names.dart';
import 'package:scenario_management/screens/home_screen/home_screen_connector.dart';
import 'package:scenario_management/screens/login_screen/login_screen_connector.dart';
import 'package:scenario_management/screens/register_screen/register_screen_connector.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:scenario_management/screens/splash/splash_screen.dart';
import 'package:scenario_management/screens/test_case_details/edi_test_case/edit_test_case_connector.dart';
import 'package:scenario_management/screens/test_case_details/test_case_screen/test_case_connector.dart';

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
          RoutesName.testCaseScreen: (context) =>
          const TestCaseScreenConnector(),
          /*RoutesName.editTestCaseScreen: (context) =>
          const EditTestCaseScreenConnector()*/
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
                  builder: (context) => TestCaseScreenConnector(
                      scenario:
                      settings.arguments as Scenario))
                  : MaterialPageRoute(
                  builder: (context) => const TestCaseScreenConnector());
            case RoutesName.editTestCaseScreen:
              return settings.arguments != null
                  ? MaterialPageRoute(
                  builder: (context) => EditTestCaseScreenConnector(
                      testCase:
                      settings.arguments as TestCase))
                  : MaterialPageRoute(
                  builder: (context) => const EditTestCaseScreenConnector());
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
