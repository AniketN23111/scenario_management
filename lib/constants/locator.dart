import 'package:get_it/get_it.dart';
import '../services/data_service.dart';
import '../services/services.dart';


GetIt locator = GetIt.instance;
setupServiceLocator() {
  print('====================1');
  try {
    locator.registerLazySingleton<DataService>(() => Services());
  } catch (e) {
    print("=============================$e");
  }
}
