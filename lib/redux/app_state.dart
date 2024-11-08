

import '../models/user_model.dart';

///Global Store
class AppState {
  final bool loading;
  final UserModel userModel;

  AppState({required this.loading, required this.userModel});

  AppState copy({bool? loading, UserModel? userModel}) => AppState(
      loading: loading ?? this.loading, userModel: userModel ?? this.userModel);

  static AppState initState() =>
      AppState(loading: false, userModel: UserModel());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          loading == other.loading &&
          userModel == other.userModel;

  @override
  int get hashCode => loading.hashCode ^ userModel.hashCode;
}
