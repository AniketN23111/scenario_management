import 'package:async_redux/async_redux.dart';

import '../../app_state.dart';

///After Action Gets Complete
class IsLoaded extends ReduxAction<AppState> {
  @override
  AppState reduce() => state.copy(loading: false);
}
