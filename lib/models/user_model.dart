import 'package:kgl_express/core/enums/user_role.dart';

class UserModel {
  final String uid;
  final String name;
  final String phoneNumber;
  final UserRole role;

  UserModel({
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.role,
  });
}