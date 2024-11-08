import 'package:hive/hive.dart';
import 'package:scenario_management/models/user_model.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User{
  @HiveField(0)
  final UserModel userModel;
  const User(this.userModel);
}
