import 'dart:async';
import 'dart:typed_data';

import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loaded.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loading.dart';

import '../../../constants/locator.dart';
import '../../../constants/response.dart';
import '../../../services/data_service.dart';
import '../../app_state.dart';

class UploadImageAction extends ReduxAction<AppState> {
  DataService dataService = locator();
  final Uint8List fileBytes;
  final String fileName;

  UploadImageAction(this.fileBytes, this.fileName);

  @override
  Future<AppState> reduce() async {
    Response responseApi = await dataService.uploadFile(fileBytes, fileName);
    return state.copy(response: responseApi);
  }

  @override
  void after() {
    dispatch(IsLoading());
    super.after();
  }

  @override
  void before() {
    dispatch(IsLoaded());
    super.before();
  }
}
