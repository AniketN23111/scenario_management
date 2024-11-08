import 'package:async_redux/async_redux.dart';

import '../../app_state.dart';

///Before Action Gets Complete
class IsLoading extends ReduxAction<AppState> {
  @override
  AppState reduce() => state.copy(loading: true);
}
