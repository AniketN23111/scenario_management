import 'package:flutter/material.dart';
import 'package:scenario_management/route_names/route_names.dart';
import 'package:scenario_management/screens/home_screen/home_screen_connector.dart';
import 'package:scenario_management/screens/login_screen/login_screen_connector.dart';
import 'package:scenario_management/screens/register_screen/register_screen_connector.dart';
import 'package:scenario_management/screens/splash/splash_screen.dart';
import 'package:scenario_management/screens/test_case_details/edi_test_case/edit_test_case_connector.dart';
import 'package:scenario_management/screens/test_case_details/test_case_screen/test_case_connector.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:scenario_management/constants/hive_service.dart';
import 'package:scenario_management/models/user_model.dart';
import 'package:scenario_management/redux/app_state.dart';
import 'package:async_redux/async_redux.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scenario_management/theme/theme_manager.dart';

import 'Firebase/firebase_options.dart';
import 'models/test_cases.dart';

/// Declare Store
late Store<AppState> store;
final ThemeManager themeManager = ThemeManager();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Store
  var state = AppState.initState();
  store = Store<AppState>(initialState: state);

  /// Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Initialize Hive
  await Hive.initFlutter();

  /// Register the UserModelAdapter
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
  // Use the global themeManager instance

  @override
  void initState() {
    super.initState();

    // Listen for changes to theme and rebuild widget tree when it changes
    themeManager.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Remove the listener when disposed to avoid memory leaks
    themeManager.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: themeManager.getCurrentRoleTheme(),
        // Use the themeManager to get the current theme
        initialRoute: RoutesName.splashScreen,
        routes: {
          RoutesName.homePageScreen: (context) => const HomeScreenConnector(),
          RoutesName.loginScreen: (context) => const LoginScreenConnector(),
          RoutesName.splashScreen: (context) => const SplashScreen(),
          RoutesName.registerScreen: (context) =>
              const RegisterScreenConnector(),
          RoutesName.testCaseScreen: (context) =>
              const TestCaseScreenConnector(),
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
              return MaterialPageRoute(
                  builder: (context) => const TestCaseScreenConnector());
            case RoutesName.editTestCaseScreen:
              return settings.arguments != null
                  ? MaterialPageRoute(
                      builder: (context) => EditTestCaseScreenConnector(
                          testCase: settings.arguments as TestCase))
                  : MaterialPageRoute(
                      builder: (context) =>
                          const EditTestCaseScreenConnector());
            default:
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(
                    child: Text('Route not found!'),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
