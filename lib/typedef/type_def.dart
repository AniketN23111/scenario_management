
import 'package:scenario_management/models/scenario.dart';
import 'package:scenario_management/models/test_cases.dart';

///Type Def Function For the Sign In With Email and Password
typedef SignInWithEmailAndPasswordTypeDef = void Function (String email,String password);

///Type Def Function For the Register With Email and Password
typedef RegisterWithEmailAndDesignationTypeDef = void Function (String email,String password,String designation,String name);

///Type Def Function For the Add Test Case
typedef UpdateTestCaseTypeDef =void Function(String testCaseID,Scenario scenario,TestCase updatedTestCase);
