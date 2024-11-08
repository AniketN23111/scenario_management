
///Global Store
class AppState {
  final bool loading;
  AppState({required this.loading});

  AppState copy({bool? loading}) =>
      AppState(loading: loading ?? this.loading);

  static AppState initState() => AppState(loading: false);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState && loading == other.loading;

  @override
  int get hashCode => loading.hashCode ;
}
